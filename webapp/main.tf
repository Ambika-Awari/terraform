resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux" # "Windows", "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.web_service
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    # dotnet_framework_version = "v4.0" # deprecated
    always_on = false
    application_stack {
      dotnet_version = "6.0" # "v3.0", "v4.0", "5.0", "v6.0"
    }
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

}