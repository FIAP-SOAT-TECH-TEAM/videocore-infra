# Common
  variable "dns_prefix" {
    type = string
    description = "Prefixo DNS. Deve ser único globalmente."
    
    validation {
      condition     = length(var.dns_prefix) >= 1 && length(var.dns_prefix) <= 54
      error_message = "O 'dns_prefix' deve ter entre 1 e 54 caracteres."
    }
  }
  variable "resource_group_name" {
    type = string
    description = "Nome do resource group"
    
    validation {
      condition = can(regex("^[a-zA-Z0-9]+$", var.resource_group_name))
      error_message = "O nome do resource group deve conter apenas letras e números."
    }
  }
  variable "location" {
    description = "Localização do recurso"
    type = string
  }

# Application Insights
  variable "app_insights_instrumentation_key" {
    description = "A chave de instrumentação do Application Insights"
    type        = string
  }

  variable "app_insights_connection_string" {
    description = "A connection string do Application Insights"
    type        = string
  }

# APIM

  variable "apim_zones" {
    description = "Zonas de disponibilidade para o API Management"
    type        = list(string)
  }

  variable "apim_subnet_id" {
    type = string
    description = "ID da sub-rede do APIM"
  }

  variable "apim_publisher_name" {
    description = "Nome do publicador do API Management"
    type        = string
  }

  variable "apim_publisher_email" {
    description = "Email do publicador do API Management"
    type        = string
  }

  variable "apim_sku_name" {
    description = "SKU do API Management"
    type        = string
  }

  variable "apim_capacity" {
    description = "Capacidade do API Management"
    type        = number
  }

  variable "apim_max_capacity" {
    description = "Capacidade máxima do API Management"
    type        = number
  }

  variable "apim_product_id" {
    description = "ID do produto do API Management"
    type        = string
  }

  variable "apim_product_display_name" {
    description = "Nome exibido do produto do API Management"
    type        = string
  }

  variable "apim_product_description" {
    description = "Descrição do produto do API Management"
    type        = string
  }

  variable "apim_subscription_display_name" {
    description = "Nome exibido da assinatura do API Management"
    type        = string
  }

  variable "apim_subscription_state" {
    description = "Estado da assinatura do API Management"
    type        = string
  }
