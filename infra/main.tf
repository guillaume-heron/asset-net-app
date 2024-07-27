terraform {
  backend "azurerm" {
    resource_group_name     = "rg-${var.app_name}-shared-${var.app_location}"
    storage_account_name    = "st${var.app_name}tfstates"
    container_name          = "tfstates"
    key                     = "${var.app_name}.${var.env}.tfstate"
  }
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.113"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "rg-${var.app_name}-${var.env}-${var.app_location}"
  location = "${var.app_location}"
}