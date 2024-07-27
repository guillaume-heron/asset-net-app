terraform {
  backend "azurerm" {
    resource_group_name     = var.shared_rg_name
    storage_account_name    = "st${var.app_name}tfstates"
    container_name          = "tfstates"
    key                     = var.terraform_states_container_key
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