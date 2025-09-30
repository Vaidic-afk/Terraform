variable "env" {
  default = ["dev", "stage", "prod"]
  type = list(string)
  description = "Environment names"
}

variable "env_selected" {
  type = string
  default = "dev"
  description = "Selected environment"
}

variable "allowed_location" {
  type = list(string)
  default = ["East US", "West Europe", "Southeast Asia"]
  description = "Allowed Azure locations"
}

variable "location" {
  type = string
  default = "East US"
  description = "Azure location for resources"
  validation {
    condition = contains(var.allowed_location, var.location)
    error_message = "Please choose a valid Azure location."
  }
}

variable "vm_size" {
    type = map(string)
    default = {
        "dev" = "Standard_B1s"
        "stage" =  "Standard_B2s"
        "prod" = "Standard_B2ms"
    }
}