output "aks_appgw_id" {
    description = "O ID do Application Gateway para AKS"
    value       = azurerm_application_gateway.aks_appgw.id
}