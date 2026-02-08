# Common
  output "vnet_name" {
    description = "Nome da Virtual Network"
    value       = azurerm_virtual_network.vnet.name
  }

  output "vnet_id" {
    description = "ID da Virtual Network"
    value       = azurerm_virtual_network.vnet.id
  }

# AKS
  output "aks_ingress_private_ip" {
    description = "Endereço IP privado para uso do Frontend Configuration do Application Gateway do AKS. Precisa ser da mesma subnet do Application Gateway."
    value       = local.aks_ingress_private_ip
  }

  output "aks_node_subnet" {
    description = "Subnet do AKS"
    value = azurerm_subnet.aks_node_subnet
  }

  output "api_reports_private_dns_fqdn" {
    description = "FQDN do registro A do microsserviço de reports na zona DNS privada"
    value       = "${azurerm_private_dns_a_record.api_reports_dns_a.name}.${azurerm_private_dns_a_record.api_reports_dns_a.zone_name}"
  }

# Azure Functions
  output "azfunc_private_ip" {
    description = "Endereço IP privado para uso da aplicação hospedada no Azure Functions"
    value       = local.azfunc_private_ip
  }

  output "azfunc_private_dns_fqdn" {
    description = "FQDN do registro A do Azure Functions na zona DNS privada"
    value       = "${azurerm_private_dns_a_record.azfunc_dns_a.name}.${azurerm_private_dns_a_record.azfunc_dns_a.zone_name}"
  }

  output "azfunc_private_endpoint_subnet_id" {
    description = "ID da subnet de Private Endpoint do Azure Functions"
    value       = azurerm_subnet.azfunc_pe_subnet.id
  }

  output "azfunc_private_dns_zone_id" {
    description = "ID da zona DNS privada do Azure Functions"
    value       = azurerm_private_dns_zone.az_websites_private_dns.id
  }

# APIM
  output "apim_subnet" {
    description = "Subnet do APIM"
    value = azurerm_subnet.apim_subnet
  }

# Azure Service Bus
  output "sb_pe_subnet_id" {
    description = "ID da subnet de Private Endpoint do Service Bus"
    value       = azurerm_subnet.sb_pe_subnet.id
  }

  output "sb_private_dns_zone_id" {
    description = "ID da zona DNS privada do Service Bus"
    value       = azurerm_private_dns_zone.sb_private_dns.id 
  }

# Application Gateway
  output "appgw_subnet" {
    description = "Subnet do Application Gateway"
    value = azurerm_subnet.appgw_subnet
  }