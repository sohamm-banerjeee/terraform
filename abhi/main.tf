provider "azurerm" {
  features {}
}

resource "random_id" "ran_id" {
  byte_length = 8
}


resource "azurerm_resource_group" "grafana" {
  name     = "rg-${random_id.ran_id.hex}"
  location = var.location
}


resource "azurerm_dashboard_grafana" "grafana" {
  name                              = var.instance_name
  resource_group_name               = azurerm_resource_group.grafana.name
  location                          = azurerm_resource_group.grafana.location
  sku                               = "Standard"
  api_key_enabled                   = false
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = true
  zone_redundancy_enabled           = false

  identity {
    type = "SystemAssigned"
  }

  tags = {
    key = "soham"
  }
}


resource "azurerm_monitor_log_analytics_workspace" "grafana" {
  name                = "grafana-law"
  location            = azurerm_resource_group.grafana.location
  resource_group_name = azurerm_resource_group.grafana.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


resource "azurerm_monitor_diagnostic_setting" "grafana" {
  name               = "grafana-diagnostics"
  target_resource_id = azurerm_dashboard_grafana.grafana.id

  log_analytics_destination {
    workspace_id = azurerm_monitor_log_analytics_workspace.grafana.id
  }
  
    metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}