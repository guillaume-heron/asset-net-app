variable "env" {
  description = "The environment tag used for all resources."
  default     = "dev"
}

variable "shared_rg_name" {
  description = "The resource group name for storing tfstate files."
  default     = "rg-netasset-shared-francecentral"
}

variable "terraform_states_container_key" {
  description = "The key for the storage account container storing tfstate files."
  default     = "netasset.dev.tfstate"
}

variable "app_name" {
  description = "The name of the app."
  default     = "netasset"
}

variable "app_location" {
  description = "The location of the app."
  default     = "francecentral"
}