output "akv_id" {
    description = "O ID do Azure Key Vault"
    value       = azurerm_key_vault.akv.id
}

output "akv_name" {
    description = "O nome do Azure Key Vault"
    value       = azurerm_key_vault.akv.name 
}