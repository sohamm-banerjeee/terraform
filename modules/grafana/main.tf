
data "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
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
