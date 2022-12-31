#### VARIABLES ####

locals {
  // mapping of location to friendly-name for use in resource names
  location_name_mapping = {
    "westus"    = "wsus",
    "centralus" = "ctus",
    "eastus2"   = "eus2"
  }
  location_label      = local.location_name_mapping[var.location]
  
  aks_prefix_name        = upper("aks-${var.environment}-${var.product}-${local.location_label}-${var.cluster_number}")

  tags = {
    Environment       = title(var.environment)
  }

}


#### RESOURCES ####

resource "azurerm_subnet" "aks-ecp-subnet" {
  name                                           = "${local.aks_prefix_name}-SUBNET"
  resource_group_name                            = var.vnet_rg_name
  virtual_network_name                           = var.vnet_name
  address_prefixes                               = [var.aks_subnet_cidr]
  enforce_private_link_service_network_policies  = true
  enforce_private_link_endpoint_network_policies = true
  service_endpoints                              = ["Microsoft.KeyVault"]

}

# resource "azurerm_resource_group" "log_analytics_rg" {
#   name     = "${var.product}-LOG-ANALYTICS-RG"
#   location = var.location
#   tags     = local.tags
#   lifecycle { ignore_changes = [tags] }
# }

data "azurerm_resource_group" "log_analytics_rg" {
  name     = "${var.product}-LOG-ANALYTICS-RG"
}


resource "azurerm_log_analytics_workspace" "ecp_log_analytics" {
  name                = "${local.aks_prefix_name}-LOG-ANALYTICS"
  location            = data.azurerm_resource_group.log_analytics_rg.location
  resource_group_name = data.azurerm_resource_group.log_analytics_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
  lifecycle { ignore_changes = [tags] }
}


### To get client_id of service principal
data "azuread_service_principal" "sp_id" {
  display_name = "Pipeline-techserv-dev-SP"
}

### Import Key Vault 
data "azurerm_key_vault" "techserv_kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

### Extract client_secret [sp]
data "azurerm_key_vault_secret" "sp_secret" {
  name         = "Pipeline-techserv-dev-SP" 
  key_vault_id = data.azurerm_key_vault.techserv_kv.id
}

### Rancher token to access rancherapi
data "azurerm_key_vault_secret" "rancher_token" {
  name         = "labrancher-token"
  key_vault_id = data.azurerm_key_vault.techserv_kv.id
}


module "aks" {
  source                            = "./modules/aks"
  aks_prefix                        = local.aks_prefix_name
  environment                       = var.environment
  product                           = var.product
  location                          = var.location
  location_label                    = local.location_label
  cluster_number                    = var.cluster_number
  aks_subnet_id                     = azurerm_subnet.aks-ecp-subnet.id
  kubernetes_version                = var.kubernetes_version
  default_node_pool_vm_size         = var.default_node_pool_vm_size
  default_node_pool_min_count       = var.default_node_pool_min_count
  default_node_pool_max_count       = var.default_node_pool_max_count
  default_node_pool_max_pods        = var.default_node_pool_max_pods
  default_node_pool_os_disk_size_gb = var.default_node_pool_os_disk_size_gb
  log_analytics_workspace_id        = azurerm_log_analytics_workspace.ecp_log_analytics.id
  default_node_pool_name            = var.default_node_pool_name
  default_node_pool_count           = var.default_node_pool_count
  client_id                         = data.azuread_service_principal.sp_id.application_id
  client_secret                     = data.azurerm_key_vault_secret.sp_secret.value
}

module "rancher2aks" {
  source          = "./modules/rancher_import"
  aks_name =  module.aks.aks_name
  key_vault_name = var.key_vault_name
  key_vault_rg = var.key_vault_rg
  service_principal_name = var.service_principal_name
  rancher_url = var.rancher_url
  location = var.location
  client_id = data.azuread_service_principal.sp_id.application_id
  client_secret = data.azurerm_key_vault_secret.sp_secret.value
  rancher_token_key = data.azurerm_key_vault_secret.rancher_token.value
}