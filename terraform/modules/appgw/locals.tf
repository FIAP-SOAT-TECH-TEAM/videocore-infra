locals {
   backend_address_pool_name              = "${var.dns_prefix}-beap"
   frontend_private_port_name             = "${var.dns_prefix}-private-port"
   frontend_private_ip_configuration_name = "${var.dns_prefix}-private-config"
   http_setting_name                      = "${var.dns_prefix}-be-htst"
   listener_name                          = "${var.dns_prefix}-httplstn"
   request_routing_rule_name              = "${var.dns_prefix}-rqrt"
}