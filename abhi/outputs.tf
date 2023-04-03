output "instance_name" {
  description = "The name of the Managed Grafana instance."
  value       = azurerm_dashboard_grafana.grafana.name
}

output "instance_id" {
  description = "The ID of the Managed Grafana instance."
  value       = azurerm_dashboard_grafana.grafana.id
}

output "endpoint" {
  description = "The endpoint of the Managed Grafana instance."
  value       = azurerm_dashboard_grafana.grafana.endpoint
}

output "grafana_version" {
  description = "The version of Grafana running on the Managed Grafana instance"
  value       = azurerm_dashboard_grafana.grafana.grafana_version
}
