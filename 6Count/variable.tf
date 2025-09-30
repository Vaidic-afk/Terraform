variable "storage_account_name" {
  description = "The name of the storage account."
  type        = list(string)
  default = ["vaidicsa11", "vaidicsa12", "vaidicsa13", "vaidicsa14"]
}

variable "allowed_tags" {
    description = "The environment for the resources."
    type        = map(string)
    default     = {
        environment = "dev"
        owner       = "vaidic"
        provisioned_by = "terraform"
    }
}

variable "location" {    
  type = set(string)
  description = "location of resources"
  default = [ "East US", "West Europe", "Central India", "Southeast Asia" ]
}