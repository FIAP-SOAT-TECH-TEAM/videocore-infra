# Common
    variable "dns_prefix" {
    type        = string
    description = "Prefixo DNS"
    }

    variable "resource_group_name" {
    type        = string
    description = "Nome do Resource Group"
    }

variable "frontdoor_sku" {
  type        = string
  description = "SKU do Front Door"
}

variable "static_website_hostname" {
  type        = string
  description = "Hostname do Static Website do Blob Storage (ex: mystorage.z13.web.core.windows.net)"
}