# Common
  variable "dns_prefix" {
    type = string
    description = "Prefixo DNS. Deve ser único globalmente."
    
    validation {
      condition     = length(var.dns_prefix) >= 1 && length(var.dns_prefix) <= 54
      error_message = "O 'dns_prefix' deve ter entre 1 e 54 caracteres."
    }
  }

  variable "aws_location" {
    type    = string
    description = "AWS Region"
  }

# AKV
  variable "akv_id" {
    type        = string
    description = "ID do Azure Key Vault"
  }

# COGNITO
  variable "callback_urls" {
    type        = list(string)
    description = "Lista de URLs de callback para o cliente do User Pool."
    
    validation {
      condition     = length(var.callback_urls) > 0
      error_message = "A lista 'callback_urls' não pode estar vazia."
    }
  }