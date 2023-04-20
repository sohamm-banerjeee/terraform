module "grafana" {
        source = "./modules/grafana"   
        location = var.location   
        instance_name = var.instance_name
        resource_group = var.resource_group
        grafana_user = var.grafana_user
}