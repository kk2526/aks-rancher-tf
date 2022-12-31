provider "rancher2" {
  api_url    = var.rancher_url
  token_key  = var.rancher_token_key
}

data rancher2_cloud_credential "aks_import_creds" {
   name = "techserv-creds"

}
# For imported AKS clusters, don't add any other aks_config_v2 field
resource "rancher2_cluster" "aks_cluster" {
  name = lower("${var.aks_name}")
  description = "Terraform AKS cluster"
  aks_config_v2 {
    cloud_credential_id = data.rancher2_cloud_credential.aks_import_creds.id
    resource_group = "${var.aks_name}-RG"
    resource_location = var.location
    imported = true
  }
}