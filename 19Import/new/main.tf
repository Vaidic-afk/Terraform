resource "azurerm_resource_group" "res-0" {
  location = "eastus"
  name     = "test-rg"
}
resource "azurerm_virtual_network" "res-1" {
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  name                = "test-vnet"
  resource_group_name = "test-rg"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_subnet" "res-2" {
  address_prefixes     = ["10.0.0.0/24"]
  name                 = "default"
  resource_group_name  = "test-rg"
  virtual_network_name = "test-vnet"
  depends_on = [
    azurerm_virtual_network.res-1
  ]
}
resource "azurerm_service_plan" "res-3" {
  location            = "canadacentral"
  name                = "ASP-testrg-b562"
  os_type             = "Linux"
  resource_group_name = "test-rg"
  sku_name            = "B1"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_linux_web_app" "res-4" {
  ftp_publish_basic_authentication_enabled       = false
  https_only                                     = true
  location                                       = "canadacentral"
  name                                           = "test-app-1623"
  public_network_access_enabled                  = false
  resource_group_name                            = "test-rg"
  service_plan_id                                = azurerm_service_plan.res-3.id
  webdeploy_publish_basic_authentication_enabled = false
  site_config {
    always_on                         = false
    ftps_state                        = "FtpsOnly"
    # ip_restriction_default_action     = ""
    # scm_ip_restriction_default_action = ""
  }
}
resource "azurerm_app_service_custom_hostname_binding" "res-8" {
  app_service_name    = "test-app-1623"
  hostname            = "test-app-1623-gbc9cgg6bafuercm.canadacentral-01.azurewebsites.net"
  resource_group_name = "test-rg"
  depends_on = [
    azurerm_linux_web_app.res-4
  ]
}
