resource "azurerm_public_ip" "aks-ingress-ip" {
  name                = "${var.dns_prefix}-aks-ingress-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.aks_ingress_allocation_method
  sku                 = var.aks_ingress_sku
  zones               = var.aks_ingress_public_ip_zones
}