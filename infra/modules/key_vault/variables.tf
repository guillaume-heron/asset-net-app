variable "key_vault_name" {
  description = "The name of the keyvault to be created"
}

variable "resource_group_name" {
  description = "The name of the main resource group, where all resources will be created"
}

variable "location" {
  description = "The region where all the resources will be deployed"
}

variable "kv_secrets" {
  type = map(string)
  default = {}
  description = "The list of secrets to be set on the keyvault"
}

variable "tags" {
  type = map(string)
  default = {}
  description = "The list of tags to be set for the resource and the associated sub ressources"
}