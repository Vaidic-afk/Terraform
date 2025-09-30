variable "environments" {
    type = list(string)
    default = ["dev", "stage", "prod"]
}

variable "location" {
    type = string
    default = "West Europe"
}

variable "env_selected" {
    type = string
    default = "dev"
}

variable "prefix" {
  type = string
  default = "dev"
}

variable "vnet_configs" {
  type = list(object({
    name          = string
    address_space = list(string)
  }))
  default = [
    { name = "vnet1", address_space = ["10.0.0.0/16"] },
    { name = "vnet2", address_space = ["10.1.0.0/16"] }
  ]
}

variable "subnet_configs" {
    type = list(object({
        name = string
        address_prefix = string
        # virtual_network_name = string
    }))
    default = [
        {name = "subnet1", address_prefix = "10.0.0.0/24"},
        {name = "subnet2", address_prefix = "10.1.0.0/24"}
    ]
}

variable "nic_configs" {
    type = list(object({
        name = string
        subnet_id = string
    }))
    default = [
        {name = "nic1", subnet_id = "subnet1"},
        {name = "nic2", subnet_id = "subnet2"}
    ]
}

variable "vm_configs" {
    type = list(object({
        name = string
        network_interface_ids = string
    }))
    default = [
        {name = "vm1", network_interface_ids = "nic1"},
        {name = "vm2", network_interface_ids = "nic2"}
    ]
}

variable "public_ip_configs" {
    type = list(object({
        name = string
        allocation_method = string
        sku = string
    }))
    default = [
        {name = "pip1", allocation_method = "Static", sku = "Standard"},
        {name = "pip2", allocation_method = "Static", sku = "Standard"}
    ]
}

variable "bastion_configs" {
    type = list(object({
        name = string
        virtual_network_name = string
        subnet_name = string
        public_ip_name = string
        vm_size = string
        admin_username = string
        admin_password = string
    }))
    default = [
        {name = "bastion1", virtual_network_name = "vnet1", subnet_name = "AzureBastionSubnet", public_ip_name = "bastionpip1", vm_size = "Standard_B1s", admin_username = "bastionadmin", admin_password = "Password1234!"},
        {name = "bastion2", virtual_network_name = "vnet2", subnet_name = "AzureBastionSubnet", public_ip_name = "bastionpip2", vm_size = "Standard_B1s", admin_username = "bastionadmin", admin_password = "Password1234!"}
    ]
  
}

variable "vnet_peering_configs" {
    type = list(object({
        name = string
    }))
    default = [
        {name = "peer1to2"},
        {name = "peer2to1"}
    ]
  
}