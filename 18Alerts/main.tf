resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}-rg"
    location = "central India"
}

resource "azurerm_virtual_network" "vnet" {
  name = "${var.prefix}-vnet"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name = "${var.prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
  address_prefixes = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


# Public IP
resource "azurerm_public_ip" "vm_ip" {
  name                = "${var.prefix}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  name = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name = "${var.prefix}-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.nic.id]
  size = "Standard_B1s"
  admin_username = "vaidict"
  admin_password = "Vaidic@123"
  disable_password_authentication = "false"
  os_disk {
    caching = "ReadWrite"
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