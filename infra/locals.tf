locals {
  # Main
  environment         = var.env
  resource_group_name = "rg-${var.app_name}-${var.env}-${var.app_location_short}"

  # Azure Container Registry
  resource_group_registry_name = "rg-registry-shared-${var.app_location_short}"
  container_registry_name      = "acrhubshared${var.app_location_short}"

  # Application Insights
  log_analytics_workspace_name = "log-${var.app_name}-${var.env}-${var.app_location_short}"
  application_insights_name    = "appi-${var.app_name}-${var.env}-${var.app_location_short}"

  # Key Vault
  key_vault_name = "kv-${var.app_name}-${var.env}-${var.app_location_short}"

  # Apps
  app_service_plan_name = "asp-${var.app_name}-${var.env}-${var.app_location_short}"
  web_app_name          = "app-${var.app_name}-${var.env}-${var.app_location_short}"

  # Others
  user_assigned_identity_name = "uai-acr-${var.app_name}-${var.env}-${var.app_location_short}"
}