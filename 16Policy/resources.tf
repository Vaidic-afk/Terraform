resource "azurerm_resource_group" "rg" {
  name = "vaidic-rg"
  location = "canadacentral"
}

resource "azurerm_storage_account" "sa" {
  name = "vaidicsa"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_replication_type = "LRS"
  account_tier = "Standard"
}