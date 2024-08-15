# Create the resource group
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.app_location

  tags = {
    Environment = local.environment
  }
}

# Create an Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = local.container_registry_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false

  tags = {
    Environment = local.environment
  }
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "asp-${var.app_name}-${local.environment}-${azurerm_resource_group.rg.location}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"

  tags = {
    Environment = local.environment
  }
}

# Create the web app
resource "azurerm_linux_web_app" "webapp" {
  name                = "app-${var.app_name}-${local.environment}-${azurerm_resource_group.rg.location}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  https_only          = true

  site_config {
    minimum_tls_version = "1.2"
    always_on           = false

    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = azurerm_user_assigned_identity.uai.client_id

    application_stack {
      docker_image_name   = "${var.app_name}:latest"
      docker_registry_url = "https://${local.container_registry_name}.azurecr.io"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai.id]
  }

  tags = {
    Environment = local.environment
  }
}

# Create a User Assigned Identity for Container Registry
resource "azurerm_user_assigned_identity" "uai" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = local.user_assigned_identity_name

  tags = {
    Environment = local.environment
  }
}

# Create a role assignment
resource "azurerm_role_assignment" "ra" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.uai.principal_id
}