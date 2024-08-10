locals {
  resource_group_name         = "rg-${var.app_name}-${var.env}-${var.app_location}"
  environment                 = var.env
  container_registry_name     = "acr${var.app_name}${var.env}${var.app_location}"
  user_assigned_identity_name = "uai-acr-${var.app_name}-${var.env}-${var.app_location}"
}