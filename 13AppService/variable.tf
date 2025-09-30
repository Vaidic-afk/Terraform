variable "prefix" {
  type = string
  default = "vaidic"
}

variable "custom_tags" {
    type = map(string)
    default = {
      "environment" = "prod"
      "platform" = "terraform"
      "owner" = "vaidic"
    }
}

variable "location" {
  type = string
  default = "central india"
}