variable "allowed_tags" {
  type = map(string)
  default = {
    env = "dev"
    owner = "team-a"
    provisioned_by = "terraform"
  }
}

variable "location" {
  type = string
  default = "East US"
  description = "The Azure region where resources will be created."
  
}
variable "environment" {
  type = string
  default = "dev"
  description = "The environment for the resources (e.g., dev, prod, test)"
}

variable "allowed_locations" {
  type = list(string)
  default = ["West Europe", "North Europe", "East US", "West US"]
}

variable "storage_account_name" {
  type = list(string)
  default = ["helloworldsa11", "helloworldsa12"]
}