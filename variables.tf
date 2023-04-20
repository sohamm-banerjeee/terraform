variable "location" {
  description = "The location to create the resources in."
  type        = string
  default     = "eastus2"
}

variable "instance_name" {
  description = "The name of the managed Grafana instance."
  type        = string
  default     = "grafana-for-aks"
}

variable "resource_group" {
  description = "The resource group name"
  type        = string
  default     = "terraform-aks-rg"
}

variable "grafana_user" {
  description = "The grafana user principle name"
  type        = string
  default     = "grafanauser@sohamdvpsgmail.onmicrosoft.com"
}


