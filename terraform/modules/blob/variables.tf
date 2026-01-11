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

# AKV
  variable "akv_id" {
    type        = string
    description = "ID do Azure Key Vault"
  }

# Blob Storage
  variable "container_name" {
    description = "Nome do container"
    type        = string
  }
  variable "account_tier" {
    description = "Nivel da conta de armazenamento"
    type        = string
  }
  variable "account_replication_type" {
    description = "Tipo de replicação da conta de armazenamento"
    type        = string
  }