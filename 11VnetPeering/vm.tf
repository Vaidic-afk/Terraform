resource "azurerm_network_interface" "main1" {
  count = length(var.nic_configs)
  name                = "${var.prefix}-${var.nic_configs[count.index].name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testconfiguration${count.index}"
    subnet_id                     = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main1" {
    count = length(var.vm_configs)
  name                  = "${var.prefix}-${var.vm_configs[count.index].name}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.main1[count.index].id]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = 40
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

# resource "azurerm_public_ip" "pip" {
#     count = length(var.public_ip_configs)
#   name                = var.public_ip_configs[count.index].name
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

# resource "azurerm_bastion_host" "bh" {
#     count = length(var.bastion_configs)
#   name                = var.bastion_configs[count.index].name
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                 = "configuration${count.index}"
#     subnet_id            = azurerm_subnet.subnet[count.index].id
#     public_ip_address_id = azurerm_public_ip.pip[count.index].id
#   }
# }