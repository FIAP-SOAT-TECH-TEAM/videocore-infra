# Common
  variable "dns_prefix" {
    type = string
    description = "Prefixo DNS para a conta de armazenamento. Deve ser único globalmente."
    
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

# ACR

  variable "acr_sku" {
    description = "SKU do ACR"
    type        = string
  }

  variable "acr_admin_enabled" {
    description = "Habilita usuário admin"
    type        = bool
  }

  variable "acr_zone_redundancy_enabled" {
    description = "Habilita zone redundancy"
    type        = bool
  }