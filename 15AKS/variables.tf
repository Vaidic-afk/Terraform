variable "rgname" {
  type        = string
  description = "resource group name"
  default = "vaidic-rg"
}

variable "location" {
  type    = string
  default = "South India"
}

variable "service_principal_name" {
  type = string
  default = "vaidic-sp"
}

variable "keyvault_name" {
  type = string
  default = "vaidics-kv"
}

variable "SUB_ID" {
  type = string
  default = "881ea0d3-8a90-43e1-b9b1-5ee367b1ab0e"
}