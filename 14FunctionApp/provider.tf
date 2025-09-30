terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~>4.41.0"
    }
  }
  required_version = "~>1.13.0"
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {
  }
}