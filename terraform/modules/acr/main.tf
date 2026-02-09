resource "azurerm_container_registry" "acr" {
  name                    = "${var.dns_prefix}acr"
  resource_group_name     = var.resource_group_name
  location                = var.location
  sku                     = var.acr_sku
  admin_enabled           = var.acr_admin_enabled

  zone_redundancy_enabled = var.acr_zone_redundancy_enabled
}