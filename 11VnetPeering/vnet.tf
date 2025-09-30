resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}-rg"
    location = var.location
}

resource "azurerm_virtual_network" "vnet" {
    count = length(var.vnet_configs)
    name = var.vnet_configs[count.index].name
    address_space = var.vnet_configs[count.index].address_space
    resource_group_name = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
}

resource "azurerm_subnet" "subnet" {
    count = length(var.subnet_configs)
    name = var.subnet_configs[count.index].name
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet[count.index].name
    address_prefixes = [var.subnet_configs[count.index].address_prefix]
}

resource "azurerm_virtual_network_peering" "peer1" {
  name                      = "peer1to2"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = "vnet1"
  remote_virtual_network_id = azurerm_virtual_network.vnet[1].id
}

resource "azurerm_virtual_network_peering" "peer2" {
  name                      = "peer2to1"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = "vnet2"
  remote_virtual_network_id = azurerm_virtual_network.vnet[0].id
}