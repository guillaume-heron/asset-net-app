locals {
  environment                 = var.env
  resource_group_name         = "rg-${var.app_name}-${var.env}-${var.app_location}"
  user_assigned_identity_name = "uai-acr-${var.app_name}-${var.env}-${var.app_location}"
  app_service_plan_name       = "asp-${var.app_name}-${var.env}-${var.app_location}"
  web_app_name                = "app-${var.app_name}-${var.env}-${var.app_location}"
}