locals {
  tags                = { Environment = upper(var.environment) }
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "${var.aks_prefix}-RG"
  location = var.location
  tags     = local.tags
  lifecycle { ignore_changes = [tags] }
}

  
resource "azurerm_kubernetes_cluster" "aks_rancher" {
  name                            = var.aks_prefix
  location                        = azurerm_resource_group.aks_rg.location
  resource_group_name             = azurerm_resource_group.aks_rg.name
  dns_prefix                      = "${var.product}-dns"
  kubernetes_version              = var.kubernetes_version
  node_resource_group             = "${var.aks_prefix}-NODES-RG"
  private_cluster_enabled         = true
  api_server_authorized_ip_ranges = []
  private_dns_zone_id             = "${var.location}.azmk8s.io"

  network_profile {
    network_plugin     = "kubenet"
    outbound_type      = "userDefinedRouting"
    service_cidr       = var.service_cidr
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
    pod_cidr           = var.pod_cidr
  }

  default_node_pool {
    name                = var.default_node_pool_name
    node_count          = var.default_node_pool_count
    vm_size             = var.default_node_pool_vm_size
    type                = var.default_node_pool_type
    max_pods            = var.default_node_pool_max_pods
    os_disk_size_gb     = var.default_node_pool_os_disk_size_gb
    enable_auto_scaling = false
    # min_count           = var.default_node_pool_min_count
    # max_count           = var.default_node_pool_max_count
    availability_zones  = var.availability_zones
    vnet_subnet_id      = var.aks_subnet_id
    node_labels         = {}
    node_taints         = []
    tags                = local.tags
  }
  
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control {
    enabled = true
  }

  addon_profile {

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }

  }

  tags = local.tags

}
