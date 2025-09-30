variable "keyvault_name" {
    type = string
    default = "vaidics-kv"
}

variable "location" {
    type = string
}
variable "resource_group_name" {
    type = string
}

variable "service_principal_name" {
    type = string
    default = "vaidic-sp"
}

variable "service_principal_object_id" {}
variable "service_principal_tenant_id" {}