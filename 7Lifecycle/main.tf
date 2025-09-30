resource azurerm_resource_group "example" {
    name = "${var.environment}-rg"
    location = var.location
}

resource azurerm_storage_account "example" {
    lifecycle {
        # create_before_destroy = true
        # prevent_destroy = true
    #   ignore_changes = [ account_replication_type ]
        # replace_triggered_by = [ azurerm_resource_group.example.location ]
        precondition {
          condition = contains(var.allowed_locations, var.location)
          error_message = "The location of the resource group must be one of the allowed locations."
        }
    }
    count = length(var.storage_account_name)
    name = var.storage_account_name[count.index]
    resource_group_name = azurerm_resource_group.example.name
    location = azurerm_resource_group.example.location
    account_tier = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = var.allowed_tags["env"]
        owner = var.allowed_tags["owner"]
        provisioned_by = var.allowed_tags["provisioned_by"]
    }
}