variable "allowed_locations" {
  default = ["eastus", "westus"]
}

variable "allowed_VM_sizes" {
  default = ["Standard_B2s", "Standard_B2ms"]
}

variable "mandatory_tags" {
  default = ["project", "department"]
}