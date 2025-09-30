variable "allowed_locations" {
    description = "List of allowed locations for resources."
    type        = list(string)
    default     = ["East US", "West US", "Central US", "North Europe", "West Europe"]
}

variable "location" {
    description = "The location where resources will be created."
    type        = string
    default     = "West Europe"
    validation {
        condition     = contains(var.allowed_locations, var.location)
        error_message = "The specified location is not in the list of allowed locations."
    }
}

variable "env" {
    description = "The environment for the resources (e.g., dev, prod)."
    type        = string
    default     = "dev"
}

output "splat" {
    value = local.nsg_rules[*] # splat is less flexible than for but easier to read
}

output "demo" {
    value = [for count in local.nsg_rules : count.priority] # for is more flexible than splat but more complex to read
}