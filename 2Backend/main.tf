# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.41.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "backend-state-rg"
      storage_account_name = "backend30681"
      container_name       = "tfstate"
      key                  = "test.terraform.tfstate"
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
  name                = "vaidicsa14new"
  resource_group_name = azurerm_resource_group.example.name # implicit dependency
  location            = azurerm_resource_group.example.location
  account_tier        = "Standard"
  account_replication_type = "GRS"

  tags ={
    environment = "testing"
  }
}