# Common
  output "resource_group_name" {
    value = module.resource_group.name
  }

  output "location" {
    value = var.location
  }

  output "aws_location" {
    value = var.aws_location
  }

  output "dns_prefix" {
    value = var.dns_prefix
  }
  output "tenant_id" {
    value      = data.azurerm_client_config.current.tenant_id
  }

# VNET

  output "vnet_name" {
    description = "Nome da Virtual Network"
    value       = module.vnet.vnet_name
  }

  output "vnet_id" {
    description = "ID da Virtual Network"
    value       = module.vnet.vnet_id
  }

  output "api_reports_private_dns_fqdn" {
    description = "FQDN do registro A do microsserviço de reports na zona DNS privada"
    value       = module.vnet.api_reports_private_dns_fqdn
  }

  output "vnet_aks_node_subnet_prefix" {
    description = "Prefixo de endereço da subrede de nós do AKS"
    value       = var.vnet_aks_node_subnet_prefix
  }

# AKV
  
  output "akv_id" {
    description = "ID do Azure Key Vault"
    value       = module.akv.akv_id
  }
  output "akv_name" {
    description = "Nome do Azure Key Vault"
    value       = module.akv.akv_name
  }

# AKS
  
  output "aks_name" {
    value = module.aks.aks_name
  }

  output "aks_resource_group" {
    description = "Resource Group onde o cluster AKS reside"
    value       = module.aks.aks_resource_group
  }

  output "aks_secret_identity_client_id" {
    description = "Client ID da identidade gerenciada do tipo UserAssigned criada para o Azure Key Vault Secrets Provider."
    value       = module.aks.aks_secret_identity_client_id 
  }

  output "aks_worker_namespace_name" {
    description = "Nome do namespace Kubernetes para o microsserviço de worker"
    value       = var.aks_namespaces[0]
  }

  output "aks_reports_namespace_name" {
    description = "Nome do namespace Kubernetes para o microsserviço de reports"
    value       = var.aks_namespaces[1]
  }

  output "aks_notification_namespace_name" {
    description = "Nome do namespace Kubernetes para o microsserviço de notification"
    value       = var.aks_namespaces[2]
  }

  output "aks_monitor_namespace_name" {
    description = "Nome do namespace Kubernetes para serviços de observabilidade"
    value       = var.aks_namespaces[3]
  }

# ACR

  output "acr_name" {
    description = "Nome do Azure Container Registry"
    value       = module.acr.acr_name
  }

  output "acr_resource_group" {
    description = "Resource Group do ACR"
    value       = module.acr.acr_resource_group
  }

# APIM

  output "apim_gateway_url" {
    description = "URL do gateway do API Management"
    value       = module.apim.apim_gateway_url
  }

  output "apim_resource_group" {
    description = "Resource Group do API Management"
    value       = module.apim.apim_resource_group
  }

  output "apim_name" {
    description = "Nome do API Management"
    value       = module.apim.apim_name
  }

  output "apim_videocore_start_productid" {
    description = "ID do produto do API Management"
    value       = module.apim.apim_videocore_start_productid
  }

  output "apim_videocore_start_subscriptionid" {
    description = "ID da assinatura do API Management"
    value       = module.apim.apim_videocore_start_subscriptionid
    sensitive   = true
  }

  output "apim_videocore_start_subscription_key" {
    description = "Chave de subscrição do API Management"
    value       = module.apim.apim_videocore_start_subscription_key
    sensitive   = true
  }

# Cognito

  output "cognito_code_login_url" {
    description = "URL de login do Cognito User Pool (usando o fluxo de authorization code)"
    value       = module.cognito.cognito_code_login_url
  }

  output "cognito_code_get_token_url" {
    description = "URL para obtenção do token do Cognito User Pool (usando o fluxo de authorization code)"
    value       = module.cognito.cognito_code_get_token_url
  }

  output "cognito_implicit_login_url" {
    description = "URL de login do Cognito User Pool (usando o fluxo implícito)"
    value       = module.cognito.cognito_implicit_login_url
  }

# Azure Function
  output "azfunc_name" {
    description = "O nome da Azure Function App"
    value       = module.azfunc.azfunc_name
  }

  output "azfunc_private_dns_fqdn" {
    description = "FQDN do registro A do Azure Functions na zona DNS privada"
    value       = module.vnet.azfunc_private_dns_fqdn
  }