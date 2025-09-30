resource "azurerm_resource_group" "example" {
  name     = local.formatted_rg_name
  location = "West Europe"

  tags = local.combined_tags
}

locals {
  formatted_rg_name = lower(replace(var.resource_group_name, " ", "-"))
  combined_tags     = merge(var.default_tags, var.environment_tags)
  formatted_sa_name = lower(replace(replace(substr(var.storage_acc_name, 0, 24), " ", ""), "@", ""))
  all_ports = split(",", var.ports)
  nsg_rules = [for port in local.all_ports : {
    name = "port-${port}"
    port = port
    description = "Allow inbound traffic on port ${port}"
  }
    ]
  env = lookup(var.environments, var.envs, lower("dev"))
  dir_names = [for dir in var.file_paths : dirname(dir)]

  given_locations = toset(concat(var.user_locations, var.default_locations))
  positive_costs = [for cost in var.costs : abs(cost)]
  max_cost = max(local.positive_costs ...)

  current_time = timestamp()
  RESOURCE_NAME = formatdate("YYYYMMDD", local.current_time)
  Tags = formatdate("DD-MM-YYYY", local.current_time)

  config_content = sensitive(file("config.json"))
  json_content = file("myFile.md")
}

resource "azurerm_storage_account" "example" {
    # depends_on = [ azurerm_resource_group.example ] # explicit dependency
  name                = "${local.RESOURCE_NAME}-${local.formatted_sa_name}"
  resource_group_name = azurerm_resource_group.example.name # implicit dependency
  location            = azurerm_resource_group.example.location
  account_tier        = "Standard"
  account_replication_type = "GRS"

  tags ={
    environment = "testing"
    date_of_creation = local.Tags
  }
}

resource "azurerm_network_security_group" "example" {
    name                = "${local.formatted_rg_name}-nsg"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name

    dynamic "security_rule" {
        for_each = local.nsg_rules
        content {
            name                       = "rule-no-${security_rule.key + 1}"
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = security_rule.value.port
            source_address_prefix      = "*"
            destination_address_prefix = "*"
            description                = security_rule.value.description
        }
    }
}

output "combined-tags" {
    value = local.combined_tags
}

# output "nsg_rules" {
#     value = azurerm_network_security_group.example.security_rule
# }

output "env" {
  value = local.env
}

output "vm_size" {
    value = var.vm_size  
}

output "backup"{
    value = var.backup
}

output "credentials" {
  value     = var.credentials
  sensitive = true
}

output "dir_names" {
  value = local.dir_names
}

output "all_locations" {
  value = local.given_locations
}

output "monthly_costs" {
  value = local.positive_costs  
}

output "max_cost" {
  value = local.max_cost
}

# output "resource_name" {
#   value = local.RESOURCE_NAME
# }

# output "TAGS" {
#   value = local.Tags
# }

output "config" {
  value = yamldecode(local.config_content)
  sensitive = true
}

output "json_file" {
  value = jsonencode(local.json_content)
}