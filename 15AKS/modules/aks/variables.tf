variable "location" {
  type = string
  # default = "South India"
}
 variable "resource_group_name" {
  type = string
  # default = "vaidic-rg-aks"
 }

variable "service_principal_name" {
  type = string
  # default = "881ea0d3-8a90-43e1-b9b1-5ee367b1ab0e"
}

# variable "kube_version" {
#   type = string
#   default = null
# }

# variable "ssh_public_key" {
#   default = "~/.ssh/id_rsa.pub"
# }

variable "client_id" {}
variable "client_secret" {
  type = string
  sensitive = true
}