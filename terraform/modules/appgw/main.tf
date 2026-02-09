resource "azurerm_application_gateway" "aks_appgw" {
   name                = "${var.dns_prefix}-aks-appgw"
   resource_group_name = var.resource_group_name
   location            = var.location
  #  zones               = var.aks_app_gateway_zones

  #  autoscale_configuration {
  #    min_capacity = var.aks_appgw_min_capacity
  #    max_capacity = var.aks_appgw_max_capacity
  #  }

   sku {
     name     = var.aks_app_gateway_tier
     tier     = var.aks_app_gateway_tier
     capacity = 1
   }

   gateway_ip_configuration {
     name      = "appGatewayIpConfig"
     subnet_id = var.appgw_subnet_id
   }

   frontend_port {
     name = local.frontend_private_port_name
     port = 80
   }

   frontend_ip_configuration {
     name                           = local.frontend_private_ip_configuration_name
     private_ip_address             = var.aks_appgw_private_ip
     subnet_id                      = var.appgw_subnet_id
     private_ip_address_allocation  = "Static"
   }
   
   frontend_ip_configuration {
     name                 = local.frontend_public_ip_configuration_name
     public_ip_address_id = var.aks_appgw_public_ip_id
   }

   backend_address_pool {
     name = local.backend_address_pool_name
   }

   backend_http_settings {
     name                  = local.http_setting_name
     cookie_based_affinity = "Disabled"
     port                  = 80
     protocol              = "Http"
     request_timeout       = 1
   }

   http_listener {
     name                           = local.listener_name
     frontend_ip_configuration_name = local.frontend_private_ip_configuration_name
     frontend_port_name             = local.frontend_private_port_name
     protocol                       = "Http"
   }

   request_routing_rule {
     name                       = local.request_routing_rule_name
     priority                   = 1
     rule_type                  = "Basic"
     http_listener_name         = local.listener_name
     backend_address_pool_name  = local.backend_address_pool_name
     backend_http_settings_name = local.http_setting_name
   }

   # Since this sample is creating an Application Gateway 
   # that is later managed by an Ingress Controller, there is no need 
   # to create a backend address pool (BEP). However, the BEP is still 
   # required by the resource. Therefore, "lifecycle:ignore_changes" is 
   # used to prevent TF from managing the gateway.
   # https://docs.azure.cn/en-us/aks/create-k8s-cluster-with-aks-application-gateway-ingress#implement-the-terraform-code
   lifecycle {
     ignore_changes = [
       tags,
       backend_address_pool,
       backend_http_settings,
       http_listener,
       probe,
       request_routing_rule,
       url_path_map
     ]
   }
 }