# Common
    variable "dns_prefix" {
      type        = string
      description = "Prefixo DNS"
    }

    variable "resource_group_name" {
      type    = string
      description = "Nome do resource group"
    }

variable "cloudfront_price_class" {
  type        = string
  description = "Price Class do CloudFront (ex: PriceClass_100, PriceClass_200, PriceClass_All)"
}

variable "static_website_hostname" {
  type        = string
  description = "Hostname do Static Website do Blob Storage (ex: mystorage.z13.web.core.windows.net)"
}

variable "storage_account_name" {
  type = string
  description = "Nome da Storage Account do Azure Blob Storage que será a origem do CloudFront"
}