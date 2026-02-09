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

variable "storage_account_id" {
  type        = string
  description = "ID da conta de armazenamento"
}

variable "sb_process_queue_id" {
  type        = string
  description = "ID da fila de processamento dos vídeos no Service Bus, para onde os eventos serão enviados"
}

variable "video_container_name" {
  description = "Nome do container para armazenamento dos vídeos"
  type        = string
}

variable "event_delivery_schema" {
  description = "Esquema de entrega dos eventos do Event Grid"
  type        = string
}

variable "event_max_retry_attempts" {
  description = "Número máximo de tentativas de reenvio para eventos que falharem na entrega"
  type        = number
}

variable "event_ttl" {
  description = "Tempo de vida dos eventos em minutos para eventos que falharem na entrega"
  type        = number
}