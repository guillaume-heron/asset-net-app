variable "env" {
  description = "The environment tag used for all resources."
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "The name of the app."
  type        = string
  default     = "netasset"
}

variable "app_location" {
  description = "The location of the app."
  type        = string
  default     = "westeurope"
}