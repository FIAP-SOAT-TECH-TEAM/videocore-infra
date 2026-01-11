# Common
  variable "dns_prefix" {
    type = string
    description = "Prefixo DNS para o IP público. Deve ser único globalmente."
    
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

# Public IP
  variable "aks_ingress_allocation_method" {
    description = "Método de alocação do IP público"
    type = string
  }
  variable "aks_ingress_sku" {
    description = "SKU do IP público"
    type = string
  }
  variable "aks_ingress_public_ip_zones" {
    description = "Zonas de disponibilidade para o IP público do AKS Ingress"
    type        = list(string)
  }