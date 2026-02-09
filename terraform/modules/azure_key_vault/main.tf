resource "azurerm_key_vault" "akv" {
  name                          = "${var.dns_prefix}-akv"
  location                      = var.location
  sku_name                      = var.akv_sku_name
  resource_group_name           = var.resource_group_name
  enabled_for_disk_encryption   = true
  tenant_id                     = var.tenant_id
  soft_delete_retention_days    = var.akv_soft_delete_retention_days
  # Apenas para fins de atividade
  # Evitar o erro: Public network access is disabled and request is not from a trusted service nor via an approved private link, na hora de criar secrets via terraform
  # public_network_access_enabled = false

  # Apenas para fins de atividade
  purge_protection_enabled    = false

  enable_rbac_authorization   = true
}

resource "azurerm_key_vault_secret" "server_mail_username" {
  name         = "server-mail-username"
  value        = var.server_mail_username
  key_vault_id = azurerm_key_vault.akv.id

  tags = {
    microservice = "any"
    resource  = "smtp_server"
  }

}

resource "azurerm_key_vault_secret" "aws_credentials" {
  name         = "aws-credentials"
  value        = local.formatted_aws_credentials
  key_vault_id = azurerm_key_vault.akv.id

  tags = {
    microservice = "any"
    resource  = "any_aws_service"
  }

}

resource "azurerm_key_vault_secret" "server_mail_password" {
  name         = "server-mail-password"
  value        = var.server_mail_password
  key_vault_id = azurerm_key_vault.akv.id

  tags = {
    microservice = "any"
    resource  = "smtp_server"
  }

}

resource "azurerm_key_vault_secret" "server_mail_host" {
  name         = "server-mail-host"
  value        = var.server_mail_host
  key_vault_id = azurerm_key_vault.akv.id

  tags = {
    microservice = "any"
    resource  = "smtp_server"
  }

}

resource "azurerm_key_vault_secret" "server_mail_port" {
  name         = "server-mail-port"
  value        = var.server_mail_port
  key_vault_id = azurerm_key_vault.akv.id

  tags = {
    microservice = "any"
    resource  = "smtp_server"
  }

}

resource "azurerm_key_vault_secret" "server_mail_from" {
  name         = "server-mail-from"
  value        = var.server_mail_from
  key_vault_id = azurerm_key_vault.akv.id

  tags = {
    microservice = "any"
    resource  = "smtp_server"
  }

}