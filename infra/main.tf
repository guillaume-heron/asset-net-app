# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.app_location
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "asp-netasset-${local.environment}-${azurerm_resource_group.rg.location}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

# Create the web app
resource "azurerm_linux_web_app" "webapp" {
  name                  = "app-netasset-${local.environment}-${azurerm_resource_group.rg.location}"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true

  site_config { 
    minimum_tls_version = "1.2"

    application_stack {
      dotnet_version = 8.0
    }
  }
}