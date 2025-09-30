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
    features {}
}

resource "azurerm_resource_group" "example" {
  name     = (var.env == "dev" ? "dev-rg" : "${var.env}-rg")
  location = var.location
}

resource "azurerm_network_security_group" "example" {
    name                = "${var.env}-nsg"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name

    dynamic "security_rule" {
        for_each = local.nsg_rules
        content {
            name                       = security_rule.key
            priority                   = security_rule.value.priority
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = security_rule.value.destination_port_range
            source_address_prefix      = "*"
            destination_address_prefix = "*"
            description                = security_rule.value.description
        }
    }
}

