output "locations" {
    value = [for i in azurerm_storage_account.example : i.location]
}