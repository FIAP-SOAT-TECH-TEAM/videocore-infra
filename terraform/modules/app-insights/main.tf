resource "azurerm_application_insights" "app-insights" {
  name                = "${var.dns_prefix}-app-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
}