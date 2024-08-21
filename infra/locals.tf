locals {
  environment                 = var.env
  resource_group_name         = "rg-${var.app_name}-${var.env}-${var.app_location_short}"
  keyvault_name               = "kv-${var.app_name}-${var.env}-${var.app_location_short}"
  user_assigned_identity_name = "uai-acr-${var.app_name}-${var.env}-${var.app_location_short}"
  app_service_plan_name       = "asp-${var.app_name}-${var.env}-${var.app_location_short}"
  web_app_name                = "app-${var.app_name}-${var.env}-${var.app_location_short}"
}