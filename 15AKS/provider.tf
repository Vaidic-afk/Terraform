# Configure the Azure provider, you can have many
# if you use azurerm provider, it's source is hashicorp/azurerm
# short for registry.terraform.io/hashicorp/azurerm


terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.41.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "~> 3.5.0"
    }
     tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }
  }

  required_version = ">= 1.13.0"
}
# configures the provider

provider "azurerm" {
  resource_provider_registrations = "none"
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}
provider "azuread" {
  
}

provider "tls" {
  
}