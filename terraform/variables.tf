# Commn
  variable "subscription_id" {
    type        = string
    description = "Azure Subscription ID"
  }
  variable "resource_group_name" {
    type    = string
    default = "hackaton"
    description = "Nome do resource group"
  }

  # Assinatura Azure For Students não consegue criar determinados tipos de recursos em algumas regiões (Ex: PgSQl Flex Server não pode ser criado em East Us)
  # Existe uma Policy (listOfAllowedLocations) que define as regiões permitidas para criação de recursos na assinatura Azure For Students
  variable "location" {
    type        = string
    description = "Localização do recurso"
  }
  variable "aws_location" {
    type        = string
    description = "AWS Region"
  }
  variable "aws_credentials" {
    type        = string
    description = "AWS Credentials"
    sensitive   = true
  }
  variable "dns_prefix" {
    type = string
    description = "Prefixo DNS. Deve ser único globalmente."
    default = "videocore"
    
    validation {
      condition     = length(var.dns_prefix) >= 1 && length(var.dns_prefix) <= 54
      error_message = "O 'dns_prefix' deve ter entre 1 e 54 caracteres."
    }
  }

# VNET
  variable "vnet_prefix" {
    description = "Prefixo de endereço da rede"
    type        = list(string)
    default     = ["10.0.0.0/16"]
  }

  variable "vnet_aks_service_subnet_prefix" {
    description = "Prefixo de endereço da subrede de serviços do AKS"
    type        = list(string)
    default     = ["10.0.1.0/24"]
  }

  variable "vnet_aks_node_subnet_prefix" {
    description = "Prefixo de endereço da subrede de nós do AKS"
    type        = list(string)
    default     = ["10.0.2.0/24"]
  }

  variable "vnet_apim_subnet_prefix" {
    description = "Prefixo de endereço da subrede do APIM"
    type        = list(string)
    default     = ["10.0.3.0/24"]
  }

  variable "vnet_azfunc_pe_subnet_prefix" {
    description = "Prefixo de endereço da subrede de Private Endpoint do Azure Functions"
    type        = list(string)
    default     = ["10.0.4.0/24"]
  }

  variable "vnet_sb_subnet_prefix" {
    description = "Prefixo de endereço da subrede do Service Bus"
    type        = list(string)
    default     = ["10.0.5.0/24"]
  }

  variable "vnet_appgw_subnet_prefix" {
    description = "Prefixo de endereço da subrede do Application Gateway"
    type        = list(string)
    default     = ["10.0.6.0/24"]
  }

# AKV

  variable "akv_sku_name" {
    type        = string
    description = "SKU do Azure Key Vault"
    default     = "standard"
  }
  variable "akv_soft_delete_retention_days" {
    type        = number
    description = "Número de dias para retenção de soft delete no Azure Key Vault"
    default     = 7
  }

# AKV Secrets
  variable "server_mail_username" {
    type        = string
    description = "Username do servidor de e-mail SMTP"
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

  variable "server_mail_from" {
    type        = string
    description = "Endereço de e-mail do remetente para o servidor SMTP"
  }

  variable "server_mail_port" {
    type        = string
    description = "Porta do servidor de e-mail SMTP"
  }

# AKS

  variable "aks_enable_keda" {
    type        = bool
    description = "Habilita ou desabilita o KEDA no AKS"
    default     = true
  }
  variable "aks_network_plugin" {
    type        = string
    description = "Plugin de rede para o AKS" 
    default     = "azure"
  }
  variable "aks_network_plugin_mode" {
    type        = string
    description = "Modo do plugin de rede para o AKS. Somente aplicável se o plugin de rede for 'azure'" 
    default     = "overlay"
  }
  variable "aks_outbound_type" {
    type        = string
    description = "Tipo de saída de rede para o AKS" 
    default     = "loadBalancer"
  }
  variable "aks_auto_scaling_enabled" {
    type        = bool
    description = "Habilita ou desabilita o auto scaling no pool de nós do AKS"
    default     = true
    
  }
  # Existe Quota máxima de VCPU ao utilizar uma assinatura do Azure For Students
  variable "aks_max_count" {
    type        = number
    description = "Número máximo de nós para auto scaling no pool de nós do AKS"
    default     = 2
  }
  variable "aks_min_count" {
    type        = number
    description = "Número mínimo de nós para auto scaling no pool de nós do AKS"
    default     = 1
  }
  # Desejado: ao menos duas zonas de disponibilidade
  # Limitação Azure For Students: The zone(s) '2' for resource 'dftnodepool' is not supported. The supported zones for location 'eastus' are '3'"
  variable "aks_availability_zones" {
    type        = list(string)
    description = "Zonas de disponibilidade para o pool de nós do AKS"
    default = [ "3" ]
  }
  variable "vm_size" {
    type    = string
    default = "Standard_D2s_v3"
    description = "Tamanho da VM para os nós do AKS"
  }
  variable "identity_type" {
    type = string
    default = "SystemAssigned"
    description = "Tipo de identidade do AKS."
  }
  variable "kubernetes_version" {
    type    = string
    default = "1.32.5"
    description = "Versão do Kubernetes a ser usada no AKS"
  }
  variable "node_pool_name" {
    type        = string
    default     = "dftnodepool"
    description = "Nome do pool de nós padrão do AKS"
    
    validation {
      condition     = length(var.node_pool_name) >= 1 && length(var.node_pool_name) <= 12
      error_message = "O 'node_pool_name' deve ter entre 1 e 12 caracteres."
    }
  }
  variable "node_pool_temp_name" {
    type        = string
    default     = "tmpnodepool"
    description = "Nome temporário do pool de nós do AKS para rotação"
    
    validation {
      condition     = length(var.node_pool_temp_name) >= 1 && length(var.node_pool_temp_name) <= 12
      error_message = "O 'node_pool_temp_name' deve ter entre 1 e 12 caracteres."
    }
  }

  variable "aks_namespaces" {
    description = "Lista de namespaces Kubernetes a serem criados no AKS"
    type        = list(string)
    default = [
      "worker",
      "reports",
      "notification",
      "monitor"
    ]
  }

# Application Gateway
  variable "aks_app_gateway_tier" {
    description = "Tier do Application Gateway para o AKS"
    type        = string
    default     = "Standard_v2"
  }

  variable "aks_appgw_min_capacity" {
    type        = number
    description = "A capacidade mínima para o dimensionamento automático do Application Gateway para AKS."
    default = 2
  }

  variable "aks_appgw_max_capacity" {
    type        = number
    description = "A capacidade máxima para o dimensionamento automático do Application Gateway para AKS."
    default = 4
  }

# Blob Storage
  variable "video_container_name" {
    description = "Nome do container para armazenamento dos vídeos"
    type        = string
    default     = "video"
  }
  variable "image_container_name" {
    description = "Nome do container para armazenamento das imagens capturadas do vídeo"
    type        = string
    default     = "image"
  }
  variable "account_tier" {
    description = "Nivel da conta de armazenamento"
    type        = string
    default     = "Standard"
  }
  variable "account_replication_type" {
    description = "Tipo de replicação da conta de armazenamento"
    type        = string
    default     = "ZRS"
  }

# ACR
  variable "acr_sku" {
    description = "SKU do ACR"
    type        = string
    default     = "Premium"
  }
  variable "acr_admin_enabled" {
    description = "Habilita usuário admin"
    type        = bool
    default     = true
  }
  variable "acr_zone_redundancy_enabled" {
    description = "Habilita zone redundancy"
    type        = bool
    default     = true
  }

# APIM

  variable "apim_zones" {
    description = "Zonas de disponibilidade para o API Management"
    type        = list(string)
    default     = [ "2", "3" ]
  }

  variable "apim_publisher_name" {
    description = "Nome do publicador do API Management"
    type        = string
    default     = "VideoCore"
  }

  variable "apim_publisher_email" {
    description = "Email do publicador do API Management"
    type        = string
    default     = "RM364745@fiap.com.br"
  }

  variable "apim_sku_name" {
    description = "SKU do API Management"
    type        = string
    default     = "Premium"
  }

  variable "apim_apacity" {
    description = "Capacidade do API Management"
    type        = number
    default     = 2
  }

  variable "apim_max_capacity" {
    description = "Capacidade máxima do API Management"
    type        = number
    default     = 4
  }

  variable "apim_product_id" {
    description = "ID do produto do API Management"
    type        = string
    default     = "videocoreapi_start"
  }

  variable "apim_product_display_name" {
    description = "Nome exibido do produto do API Management"
    type        = string
    default     = "VideoCore API Start"
  }

  variable "apim_product_description" {
    description = "Descrição do produto do API Management"
    type        = string
    default     = "Produto de API para o VideoCore"
  }

  variable "apim_subscription_display_name" {
    description = "Nome exibido da assinatura do API Management"
    type        = string
    default     = "VideoCore API Subscription"
  }

  variable "apim_subscription_state" {
    description = "Estado da assinatura do API Management"
    type        = string
    default     = "active"
  }

# Azure Function
  variable "azfunc_sa_account_tier" {
    description = "O nível da conta de armazenamento."
    type        = string
    default     = "Standard"
  }

  variable "azfunc_sa_account_replication_type" {
    description = "O tipo de replicação da conta de armazenamento."
    type        = string
    default     = "LRS"
  }

  variable "az_func_sku_name" {
    description = "O nome do SKU do plano de serviço."
    type        = string
    default     = "P0v3"
  }

  variable "az_func_os_type" {
    description = "O tipo de sistema operacional do plano de serviço."
    type        = string
    default     = "Linux"
  }

  variable "azfunc_enable_always_on" {
    description = "Habilita o recurso Always On na Function App"
    type        = bool
    default     = true
  }

  variable "azfunc_instance_memory_in_mb" {
    description = "A quantidade de memória (em MB) alocada para cada instância."
    type        = number
    default     = 512
  }

  variable "az_premium_plan_auto_scale_enabled" {
    description = "Habilita o auto scale para o plano premium"
    type        = bool
    default     = true
  }

  variable "az_maximum_elastic_worker_count" {
    description = "Número máximo de workers elásticos para o plano de serviço"
    type        = number
    default     = 5
  }

  variable "az_minimum_elastic_worker_count" {
    description = "Número mínimo de workers elásticos para o plano de serviço"
    type        = number
    default     = 2
  }

  variable "az_worker_count" {
    description = "Número de workers para o plano de serviço"
    type        = number
    default     = 1
  }

  variable "az_zone_balancing_enabled" {
    description = "Habilita o balanceamento de zona para o plano de serviço"
    type        = bool
    default     = true
  }

# Cognito

  variable "callback_urls" {
    type        = list(string)
    description = "Lista de URLs de callback para o cliente do User Pool."
    default = [ "https://httpbin.org/get" ]
    
    validation {
      condition     = length(var.callback_urls) > 0
      error_message = "A lista 'callback_urls' não pode estar vazia."
    }
  }


# Azure Service Bus
  variable "sb_sku" {
    description = "SKU do Azure Service Bus Namespace"
    type = string
    default = "Premium"
  }
  variable "sb_capacity" {
    description = "Capacidade do Azure Service Bus Namespace"
    type        = number
    default     = 2
  }
  variable "sb_max_capacity" {
    description = "Capacidade máxima do Azure Service Bus Namespace"
    type        = number
    default     = 4
  }
  variable "sb_partitions" {
    description = "Número de partições para o Azure Service Bus Namespace Premium"
    type        = number
    default     = 2
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

    default = {
      "process.queue" = {
        DeadLetteringOnMessageExpiration    = false
        DefaultMessageTimeToLive            = "PT1H"
        DuplicateDetectionHistoryTimeWindow = "PT20S"
        LockDuration                        = "PT1M"
        MaxDeliveryCount                    = 1
        RequiresDuplicateDetection          = false
        RequiresSession                     = false
        PartitioningEnabled                 = true
      }
      "process.error.queue" = {
        DeadLetteringOnMessageExpiration    = false
        DefaultMessageTimeToLive            = "PT1H"
        DuplicateDetectionHistoryTimeWindow = "PT20S"
        LockDuration                        = "PT1M"
        MaxDeliveryCount                    = 1
        RequiresDuplicateDetection          = false
        RequiresSession                     = false
        PartitioningEnabled                 = true
      }
    }
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

    default = {
      "process.status.topic" = {
        Properties = {
          DefaultMessageTimeToLive            = "PT1H"
          DuplicateDetectionHistoryTimeWindow = "PT20S"
          RequiresDuplicateDetection          = false
          PartitioningEnabled                 = true
        }
      }
    }
  }

  variable "sb_subscriptions" {
    description = "Assinaturas dos tópicos do Azure Service Bus"
    type = map(object({
      topic_name = string
      properties = object({
        DeadLetteringOnMessageExpiration = bool
        DefaultMessageTimeToLive         = string
        LockDuration                     = string
        MaxDeliveryCount                 = number
        RequiresSession                  = bool
      })
    }))

    default = {
      "reports.process.status.topic.subscription" = {
        topic_name = "process.status.topic"
        properties = {
          DeadLetteringOnMessageExpiration = false
          DefaultMessageTimeToLive         = "PT1H"
          LockDuration                     = "PT1M"
          MaxDeliveryCount                 = 1
          RequiresSession                  = false
        }
      }

      "notification.process.status.topic.subscription" = {
        topic_name = "process.status.topic"
        properties = {
          DeadLetteringOnMessageExpiration = false
          DefaultMessageTimeToLive         = "PT1H"
          LockDuration                     = "PT1M"
          MaxDeliveryCount                 = 1
          RequiresSession                  = false
        }
      }
    }
  }

# Helm

  variable "newrelic_otel_collector_chart_name" {
    description = "Nome do Helm chart do New Relic OpenTelemetry Collector."
    type        = string
    default     = "nr-k8s-otel-collector"
  }

  variable "newrelic_otel_collector_repository" {
    description = "Repositório Helm oficial do New Relic que contém o chart nr-k8s-otel-collector."
    type        = string
    default     = "https://helm-charts.newrelic.com"
  }

  variable "newrelic_otel_collector_chart_version" {
    description = "Versão do Helm chart nr-k8s-otel-collector a ser utilizada."
    type        = string
    default     = "0.10.2"
  }

  variable "newrelic_cluster_name" {
    description = "Nome do cluster Kubernetes que será reportado ao New Relic."
    type        = string
    default     = "Video Core AKS Cluster"
  }

  variable "newrelic_license_key" {
    description = "License key de ingestão do New Relic utilizada pelo OpenTelemetry Collector."
    type        = string
    sensitive   = true
  }

  variable "newrelic_low_data_mode" {
    description = "Habilita o modo de baixo volume de dados (low data mode) para reduzir custos de ingestão."
    type        = bool
    default     = true
  }

  variable "newrelic_important_metrics_only" {
    description = "Coleta apenas métricas consideradas importantes pelo New Relic."
    type        = bool
    default     = true
  }

# Event Grid
  # https://learn.microsoft.com/en-us/azure/event-grid/event-schema-blob-storage?tabs=cloud-event-schema#example-events
  variable "event_delivery_schema" {
    description = "Esquema de entrega dos eventos do Event Grid"
    type        = string
    default     = "CloudEventSchemaV1_0"
  }

  variable "event_max_retry_attempts" {
    description = "Número máximo de tentativas de reenvio para eventos que falharem na entrega"
    type        = number
    default     = 30

  }

  variable "event_ttl" {
    description = "Tempo de vida dos eventos em minutos para eventos que falharem na entrega"
    type        = number
    default     = 1440
  }

# Public IP
  variable "aks_ingress_allocation_method" {
    type    = string
    default = "Static"
    description = "Método de alocação do IP público"
  }
  variable "aks_ingress_sku" {
    type    = string
    default = "Standard"
    description = "SKU do IP público"
  }
  # https://github.com/hashicorp/terraform-provider-azurerm/issues/16470
  variable "aks_ingress_public_ip_zones" {
    description = "Zonas de disponibilidade para o IP público do Ingress do AKS"
    type        = list(string)
    default     = [ "1", "2", "3" ]
  }