output "acr_login_server" {
  description = "URL do login server do ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  description = "Usuário admin do ACR"
  value       = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  description = "Senha admin do ACR"
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "acr_name" {
  description = "Nome do Azure Container Registry"
  value       = azurerm_container_registry.acr.name
}

output "acr_resource_group" {
  description = "Resource Group do ACR"
  value       = azurerm_container_registry.acr.resource_group_name
}

output "acr_id" {
  description = "ID do Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}