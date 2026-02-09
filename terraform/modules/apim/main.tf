resource "azurerm_api_management" "apim" {
  name                = "${var.dns_prefix}-apim"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = "Developer_1"
  # sku_name            = "${var.apim_sku_name}_${var.apim_capacity}"
  # zones               = var.apim_zones

  virtual_network_type = "External"

  virtual_network_configuration {
    subnet_id = var.apim_subnet_id
  }
}

resource "azurerm_api_management_logger" "app_insights_logger" {
  name                = "${var.dns_prefix}-apim-logger"
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  
  application_insights {
    instrumentation_key = var.app_insights_instrumentation_key
  }

  depends_on = [ azurerm_api_management.apim ]
}

# resource "azurerm_monitor_autoscale_setting" "apim_autoscale" {
#   name                = "${var.dns_prefix}-apim-autoscale"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   target_resource_id  = azurerm_api_management.apim.id
#   enabled             = true

#   profile {
#     name = "Request-based scaling"

#     capacity {
#       default = var.apim_capacity
#       minimum = var.apim_capacity
#       maximum = var.apim_max_capacity
#     }

#     # Scale Out
#     rule {
#       metric_trigger {
#         metric_name        = "Requests"
#         metric_resource_id = azurerm_api_management.apim.id
#         time_grain         = "PT1M"
#         statistic          = "Sum"
#         time_window        = "PT5M"
#         time_aggregation   = "Total"
#         operator           = "GreaterThan"
#         threshold          = 1000
#       }

#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT5M"
#       }
#     }

#     # Scale In
#     rule {
#       metric_trigger {
#         metric_name        = "Requests"
#         metric_resource_id = azurerm_api_management.apim.id
#         time_grain         = "PT1M"
#         statistic          = "Sum"
#         time_window        = "PT5M"
#         time_aggregation   = "Total"
#         operator           = "LessThan"
#         threshold          = 200
#       }

#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = "1"
#         cooldown  = "PT10M"
#       }
#     }
#   }
# }


resource "azurerm_api_management_product" "videocoreapi_start_product" {
  product_id            = var.apim_product_id
  api_management_name   = azurerm_api_management.apim.name
  resource_group_name   = var.resource_group_name

  display_name          = var.apim_product_display_name
  description           = var.apim_product_description
  subscription_required = true
  approval_required     = false
  published             = true
}

resource "azurerm_api_management_product_policy" "videocoreapi_start_product_policy" {
  api_management_name = azurerm_api_management.apim.name
  product_id          = azurerm_api_management_product.videocoreapi_start_product.product_id
  resource_group_name = var.resource_group_name

  xml_content = <<XML
  <policies>
    <inbound>
      <base />

      <!-- Rate limit (por assinatura) -->
      <rate-limit-by-key 
        calls="100" 
        renewal-period="60" 
        counter-key="@(context.Subscription?.Key)" />

      <!-- Cache de resposta -->
      <cache-lookup 
        vary-by-developer="false" 
        vary-by-developer-groups="false"
        caching-type="internal"
        downstream-caching-type="private"
        must-revalidate="true"
        allow-private-response-caching="true">
        
        <!-- Headers que fazem o cache variar -->
        <vary-by-header>Authorization</vary-by-header>

        <!-- Query parameters que fazem o cache variar -->
        <vary-by-query-parameter>id</vary-by-query-parameter>
        <vary-by-query-parameter>topic</vary-by-query-parameter>
      </cache-lookup>
    </inbound>

    <backend>
      <base />
    </backend>

    <outbound>
      <base />

      <!-- Armazena a resposta em cache -->
      <cache-store duration="60" />
    </outbound>

    <on-error>
      <base />
    </on-error>
  </policies>
  XML
}

resource "azurerm_api_management_subscription" "videocoreapi_start_subscription" {
  api_management_name  = azurerm_api_management.apim.name
  resource_group_name  = var.resource_group_name

  product_id           = azurerm_api_management_product.videocoreapi_start_product.id
  display_name         = var.apim_subscription_display_name
  state                = var.apim_subscription_state
}