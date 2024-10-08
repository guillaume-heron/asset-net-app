variable "resource_group_name" {
  description = "The name of the main resource group, where all resources will be created"
}

variable "location" {
  description = "The region where all the resources will be deployed"
}

variable "log_analytics_workspace_name" {
  description = "The name of the log analytics workspace resource."
}

variable "application_insights_name" {
  description = "The name of the app insights resource."
}

variable "tags" {
  type = map(string)
  default = {}
  description = "The list of tags to be set for the resource and the associated sub ressources"
}