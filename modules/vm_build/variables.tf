variable "environment" {
  type        = string
  description = "The environment you are deploying into (dev, qa, uat, prd)"
}

variable "name_prefix" {
  type        = string
  description = "The prefix to use in naming resources"
}

variable "product" {
  type        = string
  description = "The product name to use in naming resources (MMT)"
}

variable "location" {
  type        = string
  description = "The Azure location to edeploy the AKS cluster in. Valid Values: centralus, eastus"
}

variable "location_label" {
  type        = string
  description = "The friendly name for the location for use in resource names"
}

variable "elk_publisher" {
  type        = string
  description = "This is the Publisher of the ELK Marketplace image"
}


variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to add the NIC to"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The ID of log analytics workspace to attach to."
}


variable "log_analytics_workspace_shared_key" {
  type        = string
  description = "The primary key of the log analytics workspace to attach to."
}
