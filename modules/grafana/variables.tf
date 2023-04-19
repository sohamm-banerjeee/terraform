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