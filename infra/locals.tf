locals {
  resource_group_name_acr     = "rg-registry-shared-${var.app_location}"
  container_registry_name     = "acrhubshared${var.app_location}"
  resource_group_name         = "rg-${var.app_name}-${var.env}-${var.app_location}"
  environment                 = var.env
  user_assigned_identity_name = "uai-acr-${var.app_name}-${var.env}-${var.app_location}"
}