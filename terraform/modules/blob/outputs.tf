output "storage_container_name" {
  description = "Nome do container"
  value       = azurerm_storage_container.images.name
}

output "storage_account_connection_string" {
  description = "Connection string primária da conta de armazenamento"
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true
}