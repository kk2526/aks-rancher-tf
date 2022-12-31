variable "product" {
  type = string
}

variable "cluster_number" {
  type        = string
  default     = "01"
}

variable "name_prefix" {
  type = string
}

variable "kubernetes_version" {
  type        = string
  description = "The version of Kubernetes to run. If left blank, the most recent will be used."
}

variable "dns_service_ip" {
  type        = string
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Don't use the first IP address in your address range, such as .1. The first address in your subnet range is used for the kubernetes.default.svc.cluster.local address."
}

variable "docker_bridge_cidr" {
  type        = string
  description = "The Docker bridge network address represents the default docker0 bridge network address present in all Docker installations. While docker0 bridge is not used by AKS clusters or the pods themselves, you must set this address to continue to support scenarios such as docker build within the AKS cluster. It is required to select a CIDR for the Docker bridge network address because otherwise Docker will pick a subnet automatically which could conflict with other CIDRs. You must pick an address space that does not collide with the rest of the CIDRs on your networks, including the cluster's service CIDR and pod CIDR. Default of 172.17.0.1/16. You can reuse this range across different AKS clusters."
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "The VM Size for the Nodes. There are some limitations due to use of Availbility Zones."
}

variable "default_node_pool_count" {
  type        = string
  description = "The number of Node Pools to deploy"
}

variable "default_node_pool_min_count" {
  type        = string
  description = "The minimum number of nodes on a pool"
  default = "null"
}

variable "default_node_pool_max_count" {
  type        = string
  description = "The maximum number of nodes on a pool"
  default = "null"
}

variable "default_node_pool_os_disk_size_gb" {
  type        = string
  description = "The Size of the OS disk in GB for each node"
}

variable "default_node_pool_max_pods" {
  type        = string
  description = "The maximum number of pods PER Node"
}

variable "default_node_pool_name" {
  description = "The Name of the Node Pool"
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

# variable "global_subscription_id" {
#   type        = string
#   description = "ID of global subscritipion"

# }

variable "vnet_rg_name" {
  type        = string
  description = "The name of the resource group the spoke vnet is in"
}

variable "vnet_name" {
  type        = string
  description = "The name of the vnet the AKS cluster will be deployed into"
}


variable "aks_subnet_cidr" {
  type        = string
  description = "This range will be used to assign private IPs that can be used to connect directly to the containers in the cluster"
}

variable "rancher_url"{
  type = string
  description = "Rancher URL to register"
}

variable "key_vault_name" {
  type = string
  description = "Key Vault name to gather client id and secret"
}

variable "key_vault_rg" {
  type = string
  description = "resource group for Key Vault"
}

variable "service_principal_name"{
  type = string
  description = "Name of SP to use to create AKS"
}

# variable "client_id"{
#   type = string
# }

# variable "client_secret"{
#   type = string
# }

# variable "rancher_token_key"{
#   type = string
#   description = "rancher token"
# }

# variable "privatelink_dns_zone_rg" {
#   type        = string
#   description = "The shared HUB resource group containing all the privatelink DNS zones."
# }

