resource "azurerm_servicebus_namespace" "sb_ns" {
  name                          = "${var.dns_prefix}-sb-namespace"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = "Standard"
  # sku                           = var.sb_sku
  # Funcionalidade de Endpoint Privado suportada apenas em namespaces Premium
  # https://github.com/Azure/azure-service-bus/issues/474
  # public_network_access_enabled = false
  capacity                      = 0
  # capacity                      = var.sb_capacity
  # premium_messaging_partitions  = var.sb_partitions

  # https://github.com/hashicorp/terraform-provider-azurerm/issues/27239#issuecomment-2420234755
  #zone_redundant     = true
}

# resource "azurerm_monitor_autoscale_setting" "servicebus_namespace_autoscale" {
#   name                = "${var.dns_prefix}-sb-autoscale"
#   enabled             = true
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   target_resource_id  = azurerm_servicebus_namespace.sb_ns.id

#   profile {
#     name = "CPU-based scaling"

#     capacity {
#       default = var.sb_capacity
#       minimum = var.sb_capacity
#       maximum = var.sb_max_capacity
#     }

#     # Scale Out
#     rule {
#       metric_trigger {
#         metric_name        = "NamespaceCpuUsage"
#         metric_namespace   = "microsoft.servicebus/namespaces"
#         metric_resource_id = azurerm_servicebus_namespace.sb_ns.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 60
#       }

#       scale_action {
#         direction = "Increase"
#         type      = "ServiceAllowedNextValue"
#         value     = "1"
#         cooldown  = "PT5M"
#       }
#     }

#     # Scale In
#     rule {
#       metric_trigger {
#         metric_name        = "NamespaceCpuUsage"
#         metric_namespace   = "microsoft.servicebus/namespaces"
#         metric_resource_id = azurerm_servicebus_namespace.sb_ns.id
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 60
#       }

#       scale_action {
#         direction = "Decrease"
#         type      = "ServiceAllowedNextValue"
#         value     = "1"
#         cooldown  = "PT5M"
#       }
#     }
#   }
# }

resource "azurerm_servicebus_queue" "sb_queues" {
  for_each                                  = var.sb_queues

  name                                      = each.key
  namespace_id                              = azurerm_servicebus_namespace.sb_ns.id

  dead_lettering_on_message_expiration      = each.value.DeadLetteringOnMessageExpiration
  default_message_ttl                       = each.value.DefaultMessageTimeToLive
  duplicate_detection_history_time_window   = each.value.DuplicateDetectionHistoryTimeWindow
  lock_duration                             = each.value.LockDuration
  max_delivery_count                        = each.value.MaxDeliveryCount
  requires_duplicate_detection              = each.value.RequiresDuplicateDetection
  requires_session                          = each.value.RequiresSession
  # partitioning_enabled                      = each.value.PartitioningEnabled
}

resource "azurerm_servicebus_topic" "sb_topics" {
  for_each = var.sb_topics

  name                                      = each.key
  namespace_id                              = azurerm_servicebus_namespace.sb_ns.id

  default_message_ttl                       = each.value.Properties.DefaultMessageTimeToLive
  duplicate_detection_history_time_window   = each.value.Properties.DuplicateDetectionHistoryTimeWindow
  requires_duplicate_detection              = each.value.Properties.RequiresDuplicateDetection
  #partitioning_enabled                      = each.value.Properties.PartitioningEnabled
}

resource "azurerm_servicebus_subscription" "sb_subscriptions" {
  for_each = var.sb_subscriptions

  name                                  = each.key
  topic_id                              = azurerm_servicebus_topic.sb_topics[each.value.topic_name].id

  dead_lettering_on_message_expiration  = each.value.properties.DeadLetteringOnMessageExpiration
  default_message_ttl                   = each.value.properties.DefaultMessageTimeToLive
  lock_duration                         = each.value.properties.LockDuration
  max_delivery_count                    = each.value.properties.MaxDeliveryCount
  requires_session                      = each.value.properties.RequiresSession
}

# resource "azurerm_private_endpoint" "sb_private_endpoint" {
#   name                = "${var.dns_prefix}-sb-pe"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.sb_subnet_id

#   private_service_connection {
#     name                           = "${var.dns_prefix}-sb-pe"
#     is_manual_connection           = false
#     private_connection_resource_id = azurerm_servicebus_namespace.sb_ns.id
#     subresource_names              = ["namespace"]
#   }

#   private_dns_zone_group {
#     name                 = "sb-dns-zone-group"
#     private_dns_zone_ids = [var.sb_private_dns_zone_id]
#   }
# }


resource "azurerm_key_vault_secret" "az_svc_bus_connection_string" {
  name         = "az-svc-bus-connection-string"
  value        = azurerm_servicebus_namespace.sb_ns.default_primary_connection_string
  key_vault_id = var.akv_id

  tags = {
    microservice = "any"
    resource  = "Azure Service Bus"
  }

}