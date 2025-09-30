variable "allowed_tags" {
  type = map(string)
  default = {
    env = "dev"
    owner = "team-a"
    provisioned_by = "terraform"
  }
}

variable "resource_group_name" {
  type = string
  default = "Project ALPHA Resource"
  description = "The name of the resource group in which to create resources."
}

variable "storage_acc_name" {
  type = string
  default = "VaidicTiwari StorageAccount @123.com"
  
}

variable "ports" {
  type = string
  default = "80,443,8080,3306"
}

variable allowed_environments {
  type = list(string)
  default = ["dev", "prod"]
}

variable "envs" {
  type = string
  # default = "dev"
  validation {
    condition = contains(["dev", "prod"], var.envs)
    error_message = "Environment must be one of 'dev', 'prod', or 'test'."
  }
}

variable "environments" {
  type = map(string)
  default = {
    dev = "Development"
    prod = "Production"
  }
}

variable "default_tags"{
  type = map(string)
  default = {
    company    = "TechCorp"
    managed_by = "terraform"
  }
}

variable "environment_tags"{
  type = map(string)
  default ={
    environment  = "production"
    cost_center = "cc-123"
  }
}

variable "vm_size" {
  type = string
  default = "Standard_B1s"
  description = "The size of the virtual machine."
  validation {
    condition = strcontains( lower(var.vm_size), "standard") && length(var.vm_size)>=2 && length(var.vm_size)<=20
    error_message = "VM size must contain 'Standard' and be between 2 and 20 characters long."
  }
}

variable "backup" {
  default = "daily_backup"
  type = string
  validation {
    condition = endswith(var.backup , "_backup")
    error_message = "Backup name must end with '_backup'."
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

variable "credentials" {
  type = string
  default = "xyz123"
  sensitive = true
}

variable "file_paths"{
  type = list(string)
  default = ["D:/docker/Terraform/9Functions/main.tf", "D:/docker/Terraform/9Functions/variables.tf"]
  validation {
    condition = alltrue([for path in var.file_paths : fileexists(path)])
    error_message = "One or more file paths do not exist."
  }
}

variable "user_locations"{
  type = list(string)
  default = ["East US", "West US", "Central US", "eastus"]
}

variable "default_locations"{
  type = list(string)
  default = ["northus"]
}

variable "costs" {
  type = list(number)
  default = [-50, 100, 75, 200]
}