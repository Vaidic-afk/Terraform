variable "prefix" {
  type = string
  default = "test"
}

variable "location" {
  type = string
  default = "eastus"
}

resource "azurerm_resource_group" "rg" {
  name = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sn" {
  name = "default"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_service_plan" "asp" {
  name = "ASP-testrg-b562"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name = "B1"
  os_type = "Linux"
}

resource "azurerm_linux_web_app" "app" {
  name = "test-app-1623"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  service_plan_id = azurerm_service_plan.asp.id
  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }
}