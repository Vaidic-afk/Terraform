resource "azurerm_resource_group" "rg" {
  name     = "vaidic-rg"
  location = "Central India"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vaidic-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "sn" {
    depends_on = [ azurerm_virtual_network.vnet ]
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "vaidic-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vaidic-machine"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "vaidict"
  admin_password = "Vaidic@12"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  disable_password_authentication = "false"

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("./.ssh.pub")
#   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 40
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_mssql_server" "sql-srvr" {
  name                         = "vt-sql-server-07865"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "vaidict"
  administrator_login_password = "Vaidic@1234"
}

resource "azurerm_mssql_database" "sql-db" {
    depends_on = [ azurerm_mssql_server.sql-srvr ]
  name         = "vaidic-db"
  server_id    = azurerm_mssql_server.sql-srvr.id
#   collation    = "SQL_Latin1_General_CP1_CI_AS"
#   license_type = "LicenseIncluded"
#   max_size_gb  = 2
#   sku_name     = "S0"
#   enclave_type = "VBS"

#   tags = {
#     foo = "bar"
#   }

  # prevent the possibility of accidental data loss
#   lifecycle {
#     prevent_destroy = true
#   }
}

resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  name = "vaidic-firewall"
  server_id = azurerm_mssql_server.sql-srvr.id
  start_ip_address = "10.0.2.1"  # Replace with your public IP
  end_ip_address   = "10.0.2.254"  # Replace with your public IP"
}