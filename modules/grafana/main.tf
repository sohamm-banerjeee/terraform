
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
