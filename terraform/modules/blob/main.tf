resource "azurerm_storage_account" "this" {
  name                     = "${var.dns_prefix}stgaccount"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

resource "azurerm_storage_container" "video" {
  name                  = var.video_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "blob"
}

resource "azurerm_storage_container" "image" {
  name                  = var.image_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "blob"
}

resource "azurerm_key_vault_secret" "az_storage_connection_string" {
  name         = "az-storage-connection-string"
  value        = azurerm_storage_account.this.primary_connection_string
  key_vault_id = var.akv_id

  tags = {
    microservice = "any"
    resource  = "azureblobstorage"
  }

}

resource "azurerm_key_vault_secret" "az_storage_video_container_name" {
  name         = "az-storage-video-container-name"
  value        = azurerm_storage_container.video.name
  key_vault_id = var.akv_id

  tags = {
    microservice = "any"
    resource  = "azureblobstorage"
  }
}

resource "azurerm_key_vault_secret" "az_storage_image_container_name" {
  name         = "az-storage-image-container-name"
  value        = azurerm_storage_container.image.name
  key_vault_id = var.akv_id

  tags = {
    microservice = "any"
    resource  = "azureblobstorage"
  }
}