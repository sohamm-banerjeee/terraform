variable "location" {
  description = "The location to create the resources in."
  type        = string
  default     = "eastus"
}

variable "instance_name" {
  description = "The name of this managed Grafana instance."
  type        = string
  default     = "grafana-for-aks"
}
