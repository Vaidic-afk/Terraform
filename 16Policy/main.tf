data "azurerm_subscription" "subs" {
  
}

resource "azurerm_policy_definition" "location" {
  name         = "allowed_locations"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed locations for the resources"

  policy_rule = jsonencode({
    if = {
        field = "location"
        notIn = [ for loc in var.allowed_locations : loc]
    },
    then = {
        effect = "deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "location_assign" {
  name = "allowed-locations"
  policy_definition_id = azurerm_policy_definition.location.id
  resource_group_id = azurerm_resource_group.rg.id
}

resource "azurerm_policy_definition" "tags" {
  name         = "mandatory_tags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Mandatory tags for the resources"

  policy_rule = jsonencode({
    if = {
        anyOf = [
            {
                field = "tags[${var.mandatory_tags[0]}]"
                exists = false
            },
            {
                field = "tags[${var.mandatory_tags[1]}]"
                exists = false
            }
        ]
    },
    then = {
        effect = "deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "tags_assign" {
  name = "mandatory-tags"
  policy_definition_id = azurerm_policy_definition.tags.id
  subscription_id = data.azurerm_subscription.subs.id
}

resource "azurerm_policy_definition" "vm_sizes" {
  name         = "allowed_VM_sizes"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed VM sizes for the resources"

  policy_rule = jsonencode({
    if = {
        field = "Microsoft.Compute/virtualMachines/sku.name"
        notIn = [ for vm in var.allowed_VM_sizes : vm]
    },
    then = {
        effect = "deny"
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "vm_size_assign" {
  name = "allowed-vms"
  policy_definition_id = azurerm_policy_definition.vm_sizes.id
  resource_group_id = azurerm_resource_group.rg.id
}