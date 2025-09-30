variable "environment" {
    type        = string
    description = "Environment type"
    default     = "dev"
}

variable "disk_size" {
    type = number
    description = "size of disk in gb"
    default = 40
}

variable "disable_password" {
    type = bool
    default = false  
}

variable "locations" {
  type = list(string)
  default = ["West Europe", "North Europe", "East US", "West US"]
}

variable "allowed_tags" {
    type = map(string)
    default = {
        "env"  = "dev"
        "managed_by" = "terraform"
        "team" = "devops"
    }
}

variable "network_config" {
    type = tuple([ string, string, number ])
    description = "values for vnet address, subnet address and subnet mask"
    default = [ "10.0.0.0/16", "10.0.2.0", 24 ]
}

# variable set is same as list, the only difference is that in set the order of values does not matter and duplicates are not allowed

variable "vm_config" {
    type = object({
      size = list(string)
      publisher = string
      offer = string
      sku = string
      version = string
    })
    description = "values for vm configuration"
    default = {
      size = ["Standard_B1s", "Standard_B2s"]
      publisher = "Canonical"
      offer = "0001-com-ubuntu-server-jammy"
      sku = "22_04-lts"
      version = "latest"
    }
}

variable "delete_os_disk" {
  type = bool
  default = true
}

variable "delete_data_disk" {
  type = bool
  default = true
}