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

  variable "tenant_id" {
    type        = string
    description = "ID do locatário do Azure AD associado ao Key Vault"
  }
  variable "aws_location" {
    type        = string
    description = "AWS Region"
  }


# Azure Key Vault
  variable "akv_soft_delete_retention_days" {
    type        = number
    description = "Número de dias para retenção de exclusão suave no Azure Key Vault"

    validation {
      condition     = var.akv_soft_delete_retention_days >= 7 && var.akv_soft_delete_retention_days <= 90
      error_message = "O 'akv_soft_delete_retention_days' deve estar entre 7 e 90 dias."
    }
    
  }

  variable "akv_sku_name" {
    type = string
    description = "SKU do Azure Key Vault"
  }

# Secrets

  variable "aws_credentials" {
    type        = string
    description = "AWS Credentials"
    sensitive   = true
  }

  variable "server_mail_username" {
    type        = string
    description = "Username do servidor de e-mail SMTP"
  }

  variable "server_mail_from" {
    type        = string
    description = "Endereço de e-mail do remetente para o servidor SMTP"
  }

  variable "server_mail_password" {
    type        = string
    description = "Password do servidor de e-mail SMTP"
    sensitive   = true
  }

  variable "server_mail_host" {
    type        = string
    description = "Host do servidor de e-mail SMTP"
  }

  variable "server_mail_port" {
    type        = string
    description = "Porta do servidor de e-mail SMTP"
  }