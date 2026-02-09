# Common
  variable "dns_prefix" {
    type = string
    description = "Prefixo DNS para a conta de armazenamento. Deve ser único globalmente."
    
    validation {
      condition     = length(var.dns_prefix) >= 1 && length(var.dns_prefix) <= 54
      error_message = "O 'dns_prefix' deve ter entre 1 e 54 caracteres."
    }
  }

variable "newrelic_otel_collector_chart_name" {
  description = "Nome do Helm chart do New Relic OpenTelemetry Collector."
  type        = string
}

variable "newrelic_otel_collector_repository" {
  description = "Repositório Helm oficial do New Relic que contém o chart nr-k8s-otel-collector."
  type        = string
}

variable "newrelic_otel_collector_namespace" {
  description = "Namespace Kubernetes onde o Helm chart do New Relic OpenTelemetry Collector será instalado."
  type        = string
}

variable "newrelic_otel_collector_chart_version" {
  description = "Versão do Helm chart nr-k8s-otel-collector a ser utilizada."
  type        = string
}

variable "newrelic_cluster_name" {
  description = "Nome do cluster Kubernetes que será reportado ao New Relic."
  type        = string
}

variable "newrelic_license_key" {
  description = "License key de ingestão do New Relic utilizada pelo OpenTelemetry Collector."
  type        = string
}

variable "newrelic_low_data_mode" {
  description = "Habilita o modo de baixo volume de dados (low data mode) para reduzir custos de ingestão."
  type        = bool
}

variable "newrelic_important_metrics_only" {
  description = "Coleta apenas métricas consideradas importantes pelo New Relic."
  type        = bool
}