variable "resource_group_name" {
  description = "The name of the main resource group, where all resources will be created"
}

variable "app_name" {
  description = "The name of the app"
}

variable "environment" {
  description = "The environment used for all resources"
}

variable "location" {
  description = "The region where all the resources will be deployed"
}

variable "location_short" {
  description = "The short name of the region to write on the resource name."
}
