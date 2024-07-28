locals {
  resource_group_name = "rg-${var.app_name}-${var.env}-${var.app_location}"
  environment         = "${var.env}"
}