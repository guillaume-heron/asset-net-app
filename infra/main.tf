terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.113"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  resource_group_name = "rg-${var.app_name}-${var.env}-${var.app_location}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.app_location
}
