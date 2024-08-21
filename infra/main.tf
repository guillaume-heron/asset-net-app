data "azurerm_client_config" "current" {}

module "container_registry" {
  source = "./modules/container_registry"

  location       = var.app_location
  location_short = var.app_location_short
}

# Create the Resource Group
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.app_location

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

module "application_insights" {
  source = "./modules/application_insights"

  app_name            = var.app_name
  environment         = local.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  location_short      = var.app_location_short
}

# Create the Keyvault that will be accessible from our Web App
resource "azurerm_key_vault" "keyvault" {
  name                        = local.keyvault_name
  resource_group_name         = azurerm_resource_group.main.name
  location                    = azurerm_resource_group.main.location
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  tags = {
    Environment = local.environment
  }
}

# Set keyvault secret for app insights connection string
resource "azurerm_key_vault_secret" "app_insights_conn_string" {
  name         = "APPLICATIONINSIGHTS-CONNECTION-STRING"
  value        = module.application_insights.connection_string
  key_vault_id = azurerm_key_vault.keyvault.id
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
    APPLICATIONINSIGHTS_CONNECTION_STRING      = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.app_insights_conn_string.versionless_id})"
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
  }

  tags = {
    Environment = local.environment
  }
}

# Create a role assignments
resource "azurerm_role_assignment" "acrpull" {
  scope                = module.container_registry.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}

resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id
}

resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
