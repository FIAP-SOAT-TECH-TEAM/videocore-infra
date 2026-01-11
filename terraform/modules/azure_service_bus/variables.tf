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

# AKV
  variable "akv_id" {
    type        = string
    description = "ID do Azure Key Vault"
  }

# Service Bus

  variable "sb_subnet_id" {
    description = "ID da subnet para regras de rede do Azure Service Bus"
    type        = string
  }
  variable "sb_private_dns_zone_id" {
    description = "ID da zona DNS privada para o Azure Service Bus"
    type        = string
  }
  variable "sb_sku" {
    description = "SKU do Azure Service Bus Namespace"
    type = string
  }
  variable "sb_capacity" {
    description = "Capacidade do Azure Service Bus Namespace"
    type        = number
  }
  variable "sb_max_capacity" {
    description = "Capacidade máxima do Azure Service Bus Namespace"
    type        = number
  }
  variable "sb_partitions" {
    description = "Número de partições para o Azure Service Bus Namespace Premium"
    type        = number
  }

  variable "sb_queues" {
    description = "Filas do Azure Service Bus"
    type = map(object({
      DeadLetteringOnMessageExpiration    = bool
      DefaultMessageTimeToLive            = string
      DuplicateDetectionHistoryTimeWindow = string
      LockDuration                        = string
      MaxDeliveryCount                    = number
      RequiresDuplicateDetection          = bool
      RequiresSession                     = bool
      PartitioningEnabled                 = bool
    }))
  }

  variable "sb_topics" { 
    description = "Tópicos do Azure Service Bus"
    type = map(object({
      Properties = object({
        DefaultMessageTimeToLive            = string
        DuplicateDetectionHistoryTimeWindow = string
        RequiresDuplicateDetection          = bool
        PartitioningEnabled                 = bool
      })
    }))
  }

  variable "sb_subscriptions" {
    description = "Assinaturas dos tópicos do Azure Service Bus"
    type = map(object({
      topic_name  = string
      properties  = object({
        DeadLetteringOnMessageExpiration = bool
        DefaultMessageTimeToLive         = string
        LockDuration                     = string
        MaxDeliveryCount                 = number
        RequiresSession                  = bool
      })
    }))
  }