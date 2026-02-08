output "storage_container_name" {
  description = "Nome do container para armazenamento dos vídeos"
  value       = azurerm_storage_container.video.name
}

output "storage_container_name" {
  description = "Nome do container para armazenamento das imagens capturadas do vídeo"
  value       = azurerm_storage_container.image.name
}

output "storage_account_connection_string" {
  description = "Connection string primária da conta de armazenamento"
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}