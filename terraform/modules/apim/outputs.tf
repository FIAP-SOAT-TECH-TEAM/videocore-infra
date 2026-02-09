output "apim_gateway_url" {
  description = "URL do gateway do API Management"
  value       = azurerm_api_management.apim.gateway_url
}

output "apim_resource_group" {
  description = "Resource Group do API Management"
  value       = azurerm_api_management.apim.resource_group_name
}

output "apim_name" {
  description = "Nome do API Management"
  value       = azurerm_api_management.apim.name
}

output "apim_videocore_start_productid" {
  description = "ID do produto do API Management"
  value       = azurerm_api_management_product.videocoreapi_start_product.product_id
}

output "apim_videocore_start_subscriptionid" {
  description = "ID da assinatura do API Management"
  value       = azurerm_api_management_subscription.videocoreapi_start_subscription.id
}

output "apim_videocore_start_subscription_key" {
  description = "Chave de subscrição do API Management"
  value       = azurerm_api_management_subscription.videocoreapi_start_subscription.primary_key
  sensitive   = true
}