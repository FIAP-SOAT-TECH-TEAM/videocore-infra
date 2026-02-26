resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "${var.dns_prefix}-fd-profile"
  resource_group_name = var.resource_group_name
  sku_name            = var.frontdoor_sku
}

resource "azurerm_cdn_frontdoor_endpoint" "fd_endpoint" {
  name                     = "${var.dns_prefix}-fd-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

resource "azurerm_cdn_frontdoor_origin_group" "fd_origin_group" {
  name                     = "${var.dns_prefix}-fd-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  load_balancing {
    successful_samples_required = 3
  }

  health_probe {
    protocol            = "Https"
    request_type        = "GET"
    interval_in_seconds = 120
    path                = "/"
  }
}

resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  name                          = "${var.dns_prefix}-blob-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id

  certificate_name_check_enabled = true
  host_name          = var.static_website_hostname
  origin_host_header = var.static_website_hostname
  http_port          = 80
  https_port         = 443
  enabled            = true
}

resource "azurerm_cdn_frontdoor_route" "fd_route" {
  name                          = "${var.dns_prefix}-fd-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.fd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.fd_origin.id]

  supported_protocols = ["Http", "Https"]
  patterns_to_match   = ["/*"]
  forwarding_protocol = "HttpsOnly"
  https_redirect_enabled = true
}