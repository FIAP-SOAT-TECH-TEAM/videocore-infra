output "frontdoor_url" {
  description = "URL pública do Azure Front Door"
  value       = "https://${azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name}"
}

output "frontdoor_profile_name" {
  description = "Nome do Profile utilizado no Front Door"
  value       = azurerm_cdn_frontdoor_profile.fd_profile.name
}

output "frontdoor_endpoint_name" {
  description = "Nome do Endpoint utilizado no Front Door"
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.name
}

output "frontdoor_endpoint_hostname" {
  description = "Hostname do Endpoint utilizado no Front Door"
  value       = azurerm_cdn_frontdoor_endpoint.fd_endpoint.host_name
}