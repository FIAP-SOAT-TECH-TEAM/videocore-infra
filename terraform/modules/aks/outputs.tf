output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_resource_group" {
  description = "Resource Group onde o cluster AKS reside"
  value       = azurerm_kubernetes_cluster.aks.resource_group_name
}

output "aks_secret_identity_client_id" {
  description = "Client ID da identidade gerenciada do tipo UserAssigned criada para o Azure Key Vault Secrets Provider."
  value       = local.secrets_store_csi_identity_client_id
}

output "kube_config" {
  description = "Kube config do cluster AKS"
  value       = azurerm_kubernetes_cluster.aks.kube_config
}