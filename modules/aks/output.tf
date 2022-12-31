output "aks_name" {
  value       = azurerm_kubernetes_cluster.aks_rancher.name
  description = "The name of the AKS Cluster."
}