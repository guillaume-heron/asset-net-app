module "container_registry" {
  source = "./modules/container_registry"

  location                = var.app_location
  container_registry_name = local.container_registry_name
  resource_group_name     = local.resource_group_registry_name
}

# Create the Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.app_location

  tags = {
    Environment = local.environment
  }
}

module "application_insights" {
  source = "./modules/application_insights"

  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  log_analytics_workspace_name = local.log_analytics_workspace_name
  application_insights_name    = local.application_insights_name

  tags = {
    Environment = local.environment
  }
}

# Create the Keyvault that will be accessible from our Web App
module "key_vault" {
  source = "./modules/key_vault"

  key_vault_name      = local.key_vault_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  kv_secrets = {
    "APPLICATIONINSIGHTS-CONNECTION-STRING" = module.application_insights.connection_string
  }

  tags = {
    Environment = local.environment
  }
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = local.app_service_plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "F1"

  tags = {
    Environment = local.environment
  }
}

# Create a User Assigned Identity
resource "azurerm_user_assigned_identity" "uai" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  name                = local.user_assigned_identity_name

  tags = {
    Environment = local.environment
  }
}

# Create the Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = local.web_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true

  site_config {
    minimum_tls_version = "1.2"
    always_on           = false

    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.uai.client_id

    application_stack {
      docker_image_name   = "${var.app_name}-${local.environment}:latest"
      docker_registry_url = "https://${module.container_registry.name}.azurecr.io"
    }
  }

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
  }

  app_settings = {
    WEBSITES_PORT                              = "8080"
    APPLICATIONINSIGHTS_CONNECTION_STRING      = "@Microsoft.KeyVault(SecretUri=${module.key_vault.key_vault_secrets["APPLICATIONINSIGHTS-CONNECTION-STRING"]})"
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }

  tags = {
    Environment = local.environment
  }

  depends_on = [
    module.key_vault,
    module.container_registry,
    azurerm_user_assigned_identity.uai,
    azurerm_service_plan.appserviceplan
  ]
}

# Create a role assignments
resource "azurerm_role_assignment" "acrpull" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id

  depends_on = [
    module.container_registry,
    azurerm_user_assigned_identity.uai
  ]
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id

  depends_on = [
    module.key_vault,
    azurerm_linux_web_app.webapp
  ]
}
