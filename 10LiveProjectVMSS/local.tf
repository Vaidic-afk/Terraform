locals {
    nsg_rules = {
        "allow_inbound_lb" = {
            name                       = "Allow_LB_To_VMSS"
            priority                   = 100
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "AzureLoadBalancer"
            destination_address_prefix = "*"
        }
        "deny_all_inbound" = {
            name                       = "Deny_All_Other_Inbound"
            priority                   = 200
            direction                  = "Inbound"
            access                     = "Deny"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
        }
        "allow_ssh" = {
            name                       = "allow-ssh"
            priority                   = 102
            direction                  = "Inbound"
            access                     = "Allow"
            protocol                   = "Tcp"
            source_port_range          = "*"
            destination_port_range     = "22"
            source_address_prefix      = "*"
            destination_address_prefix = "*"
        }
    }

    autoscaling_rules = {
        scale_out = {
            metric_name        = "Percentage CPU"
            metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id
            time_grain         = "PT1M"
            statistic          = "Average"
            time_window        = "PT5M"
            time_aggregation   = "Average"
            operator           = "GreaterThan"
            threshold          = 80

            scale_action = {
                direction      = "Increase"
                type           = "ChangeCount"
                value          = "1"
                cooldown       = "PT5M"
            }
        }
        scale_in = {
            metric_name        = "Percentage CPU"
            metric_resource_id = azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id
            time_grain         = "PT1M"
            statistic          = "Average"
            time_window        = "PT5M"
            time_aggregation   = "Average"
            operator           = "LessThan"
            threshold          = 10

            scale_action = {
                direction      = "Decrease"
                type           = "ChangeCount"
                value          = "1"
                cooldown       = "PT5M"
            }
        }
    }

    vm_size = var.vm_size[var.env_selected]
}