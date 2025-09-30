# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.41.0"
    }
  }
  # backend "azurerm" {
  #     resource_group_name  = "backend-state-rg"
  #     storage_account_name = "backend30681"
  #     container_name       = "tfstate"
  #     key                  = "test.terraform.tfstate"
  # }
  required_version = "~>1.13.0"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

variable "prefix" {
  default = "tfvmex"
}

resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-rg"
  location = var.locations[2]
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = [element(var.network_config,0)]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "internal" {
    depends_on = [ azurerm_virtual_network.main ]
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["${element(var.network_config,1)}/${element(var.network_config,2)}"]
}

resource "azurerm_network_interface" "main" {
    # depends_on = [ azurerm_virtual_network.main ]
  name                = "${var.environment}-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.environment}-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_config.size[0]

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = var.delete_os_disk

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = var.delete_data_disk

  storage_image_reference {
    publisher = var.vm_config.publisher
    offer     = var.vm_config.offer
    sku       = var.vm_config.sku
    version   = var.vm_config.version
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = var.disk_size
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = var.disable_password
  }
  tags = {
    environment = var.allowed_tags["env"]
    managed_by = var.allowed_tags["managed_by"]
    team = var.allowed_tags["team"]
  }
}