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


data "azurerm_log_analytics_workspace" "aks_law" {
  name                = "terraform-aks-law"
  resource_group_name = "defaultresourcegroup-eus"
}


data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "soham-aks"
  resource_group_name = "terraform-aks-rg"
}

resource "azurerm_monitor_diagnostic_setting" "grafana" {
  name               = "grafana-diagnostics"
  target_resource_id = data.azurerm_kubernetes_cluster.aks_cluster.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.aks_law.id
  
   log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
	  days    = 2
      enabled = true
    }
  }
   metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      days    = 2
      enabled = true
    }
  }
}

data "azurerm_subscription" "current" {}

# Give Managed Grafana instances access to read monitoring data in current subscription.
resource "azurerm_role_assignment" "monitoring_reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.grafana.identity[0].principal_id
}

data "azurerm_client_config" "current" {}

# Give current client admin access to Managed Grafana instance.
resource "azurerm_role_assignment" "grafana_admin" {
  scope                = azurerm_dashboard_grafana.grafana.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}
