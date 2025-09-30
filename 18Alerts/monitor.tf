resource "azurerm_monitor_action_group" "mag" {
  name = "${var.prefix}-mag"
  resource_group_name = azurerm_resource_group.rg.name
  short_name = "new-mag"
  email_receiver {
    name          = "sendtoadmin"
    email_address = var.email
  }
}

resource "azurerm_monitor_metric_alert" "alert1" {
  name = "${var.prefix}-alert1"
  resource_group_name = azurerm_resource_group.rg.name
  scopes = [azurerm_linux_virtual_machine.vm.id]
  description = "Alert will be triggered when average load on VM is more than 60% for 5 minutes"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name = "Percentage CPU"
    aggregation = "Average"
    operator = "GreaterThan"
    threshold = 60
  }
  action {
    action_group_id = azurerm_monitor_action_group.mag.id
  }
}

resource "azurerm_monitor_metric_alert" "alert2" {
  name = "${var.prefix}-alert2"
  resource_group_name = azurerm_resource_group.rg.name
  scopes = [azurerm_linux_virtual_machine.vm.id]
  description = "Alert will be triggered when storage on VM is less than 20% for 5 minutes"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name = "Available Memory Bytes"
    aggregation = "Average"
    operator = "LessThan"
    threshold = 20
  }
  action {
    action_group_id = azurerm_monitor_action_group.mag.id
  }
}
