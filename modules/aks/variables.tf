variable "environment" {
  type        = string
  description = "The environment you are deploying into (dev, qa, uat, prd)"
}
variable "cluster_number" {
  type        = string
  default     = "01"
}
variable "product" {
  type        = string
  description = "The product name to use in naming resources (IMS)"
}

variable "location" {
  type        = string
  description = "The Azure location to edeploy the AKS cluster in. Valid Values: centralus, eastus"
}

variable "location_label" {
  type        = string
  description = "The friendly name for the location for use in resource names"
}



variable "aks_subnet_id" {
  type        = string
  description = "The Azure id of the AKS subnet"
}

variable "availability_zones" {
  type        = list(any)
  description = "Availability zones where cluster should be created default '[1,2,3]' "
  default     = [1, 2, 3]

}

variable "aks_prefix" {
  type        = string
  description = "Prefix to add to different resources"
}

variable "kubernetes_version" {
  type        = string
  description = "The version of Kubernetes to run. If left blank, the most recent will be used."
}

variable "default_node_pool_name" {
  description = "The Name of the Node Pool"
}

variable "default_node_pool_count" {
  type        = string
  description = "The number of Node Pools to deploy"
}

variable "default_node_pool_vm_size" {
  type        = string
  description = "The VM Size for the Nodes. There are some limitations due to use of Availbility Zones."
}

variable "default_node_pool_type" {
  type        = string
  description = "The type of service to use for the nodes: AvailabilitySet, VirtualMachineScaleSets"
  default     = "VirtualMachineScaleSets"
}

variable "default_node_pool_max_pods" {
  type        = string
  description = "The maximum number of pods PER Node"
}

variable "default_node_pool_min_count" {
  type        = string
  description = "The minimum number of nodes on a pool"
  default = null
}

variable "default_node_pool_max_count" {
  type        = string
  description = "The maximum number of nodes on a pool"
  default = null
}

variable "default_node_pool_os_disk_size_gb" {
  type        = string
  description = "The Size of the OS disk in GB for each node"
}

variable "service_cidr" {
  type        = string
  description = "This range should not be used by any network element on or connected to this virtual network. Service address CIDR must be smaller than /12. You can reuse this range across different AKS clusters."
  default     = "10.43.0.0/16"
}

variable "dns_service_ip" {
  type        = string
  description = "IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns). Don't use the first IP address in your address range, such as .1. The first address in your subnet range is used for the kubernetes.default.svc.cluster.local address."
  default     = "10.43.0.10"
}

variable "docker_bridge_cidr" {
  type        = string
  description = "The Docker bridge network address represents the default docker0 bridge network address present in all Docker installations. While docker0 bridge is not used by AKS clusters or the pods themselves, you must set this address to continue to support scenarios such as docker build within the AKS cluster. It is required to select a CIDR for the Docker bridge network address because otherwise Docker will pick a subnet automatically which could conflict with other CIDRs. You must pick an address space that does not collide with the rest of the CIDRs on your networks, including the cluster's service CIDR and pod CIDR. Default of 172.17.0.1/16. You can reuse this range across different AKS clusters."
  default     = "172.17.0.1/16"
}

variable "pod_cidr" {
  type        = string
  description = "This is the CIDR that will be assigned to individual pods"
  default     = "10.42.0.0/16"
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "client_id"{
  type = string
  description = "Name of SP to use to create AKS"
}

variable "client_secret"{
  type = string
  description = "Name of SP to use to create AKS"
}


# variable "service_principal_name"{
#   type = string
#   description = "Name of SP to use to create AKS"
# }

# variable "key_vault_name" {
#   type = string
#   description = "Key Vault name to gather client id and secret"
# }

# variable "key_vault_rg" {
#   type = string
#   description = "resource group for Key Vault"
# }


