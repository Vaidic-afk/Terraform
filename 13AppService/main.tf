resource "azurerm_resource_group" "rg" {
  name = "${var.prefix}-rg"
  location = var.location
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.prefix}-app"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {}
}

resource "azurerm_app_service_source_control" "scm" {
  app_id   = azurerm_linux_web_app.app.id
  repo_url = "https://github.com/Vaidic-afk/awesome-terraform.git"
  branch   = "master"
}


resource "azurerm_linux_web_app_slot" "slot1" {
  name           = "${var.prefix}-slot"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {}
}

resource "azurerm_app_service_source_control_slot" "scm1" {
  slot_id   = azurerm_linux_web_app_slot.slot1.id
  repo_url = "https://github.com/Vaidic-afk/awesome-terraform.git"
  branch   = "appServiceSlot_Working_DO_NOT_MERGE"
}