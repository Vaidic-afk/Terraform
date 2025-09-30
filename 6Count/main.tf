# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.41.0"
    }
  }
  required_version = "~>1.13.0"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "hello-world-rg"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_storage_account" "example" {
    # depends_on = [ azurerm_resource_group.example ] # explicit dependency
  count = length(var.storage_account_name) # count can only be used with list or number
  name                = var.storage_account_name[count.index]
  resource_group_name = azurerm_resource_group.example.name # implicit dependency
#   for_each = var.location for_each can only be used with map or set of strings
#   location = each.value for_each and count cannot be used together
  location            = azurerm_resource_group.example.location
  account_tier        = "Standard"
  account_replication_type = "GRS"

  tags ={
    environment = var.allowed_tags["environment"]
    owner       = var.allowed_tags["owner"]
    provisioned_by = var.allowed_tags["provisioned_by"]
  }
}