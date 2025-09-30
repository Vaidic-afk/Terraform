# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
# Configure the Microsoft Azure Provider
# Create a resource group
# Create a virtual network within the resource group
resource "azurerm_storage_account" "example" {
    # depends_on = [ azurerm_resource_group.example ] # explicit dependency
  name                = "vaidicsa14new"
  resource_group_name = azurerm_resource_group.example.name # implicit dependency
  location            = azurerm_resource_group.example.location
  account_tier        = "Standard"
  account_replication_type = local.common_tags.act

  tags ={
    environment = var.environment
    owner = local.common_tags.owner
  }
}