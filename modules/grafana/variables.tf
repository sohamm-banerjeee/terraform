variable "location" {
  description = "The location to create the resources in."
  type        = string
}

variable "instance_name" {
  description = "The name of the managed Grafana instance."
  type        = string
}

variable "resource_group" {
  description = "The resource group name"
  type        = string
}

variable "grafana_user" {
  description = "The grafana user principle name"
  type        = string
}


