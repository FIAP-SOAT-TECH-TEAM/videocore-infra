locals {
  aks_dns_service_ip  = cidrhost(var.aks_service_subnet_prefix, -2)
  agic_identity_object_id = azurerm_kubernetes_cluster.aks.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
  secrets_store_csi_identity_object_id = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
  secrets_store_csi_identity_client_id = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].client_id
}