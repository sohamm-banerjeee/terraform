
data "azurerm_resource_group" "rg" {
  name     = var.resource_group
}

resource "azurerm_dashboard_grafana" "grafana" {
  name                              = var.instance_name
  resource_group_name               = data.azurerm_resource_group.rg.name
  location                          = var.location
  sku                               = "Standard"
  api_key_enabled                   = false
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = true
  zone_redundancy_enabled           = false

  identity {
    type = "SystemAssigned"
  }
  
}


resource "azurerm_log_analytics_workspace" "aks_law" {
  name                = "terraform-aks-law"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


data "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "soham-aks"
  resource_group_name = "terraform-aks-rg"
}

resource "azurerm_monitor_diagnostic_setting" "grafana" {
  name               = "grafana-diagnostics"
  target_resource_id = data.azurerm_kubernetes_cluster.aks_cluster.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_law.id
  
   enabled_log {
    category = "kube-audit-admin"

    retention_policy {
      enabled = true
      days = 10
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days = 10
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

data "azuread_user" "user" {
  user_principal_name = var.grafana_user
}

resource "azurerm_role_assignment" "grafana_admin1" {
  scope                = azurerm_dashboard_grafana.grafana.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azuread_user.user.object_id
}
