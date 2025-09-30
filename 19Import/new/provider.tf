provider "azurerm" {
  features {
  }
  resource_provider_registrations = "none"
  subscription_id                 = "881ea0d3-8a90-43e1-b9b1-5ee367b1ab0e"
  environment                     = "public"
  use_msi                         = false
  use_cli                         = true
  use_oidc                        = false
}
