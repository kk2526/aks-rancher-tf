variable subscription_id{
    type = string
    default = "16976247-7432-4fef-9c5b-6419a913aa8a"
}

variable "service_principal_name"{
  type = string
  description = "Name of SP to use to create AKS"
}

variable "key_vault_name" {
  type = string
  description = "Key Vault name to gather client id and secret"
}

variable "key_vault_rg" {
  type = string
  description = "resource group for Key Vault"
}

variable "aks_name" {
  type = string
  description = "AKS Name"
}

variable "rancher_url"{
  type = string
  description = "Rancher URL to register"
}

variable "location" {
  type        = string
  description = "The Azure location to edeploy the AKS cluster in. Valid Values: centralus, eastus"
}

variable "client_id"{
  type = string
}

variable "client_secret"{
  type = string
}

variable "rancher_token_key"{
  type = string
  description = "rancher token"
}