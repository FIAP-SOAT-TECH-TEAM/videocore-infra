resource "azurerm_eventgrid_system_topic" "storage_topic" {
  name                   = "${var.dns_prefix}-stg-topic"
  resource_group_name    = var.resource_group_name
  location               = var.location
  source_resource_id     = var.storage_account_id
  topic_type             = "Microsoft.Storage.StorageAccounts"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "eventgrid_to_servicebus" {
  scope                = var.sb_process_queue_id
  role_definition_name = "Azure Service Bus Data Sender"
  principal_id         = azurerm_eventgrid_system_topic.storage_topic.identity[0].principal_id
}

resource "azurerm_eventgrid_system_topic_event_subscription" "video_blob_created" {
  name                = "${var.dns_prefix}-video-blob-created-subscription"
  system_topic        = azurerm_eventgrid_system_topic.storage_topic.name
  resource_group_name = var.resource_group_name

  included_event_types = [
    "Microsoft.Storage.BlobCreated"
  ]
  subject_filter {
    subject_begins_with = "/blobServices/default/containers/${var.video_container_name}/blobs/"
  }

  event_delivery_schema = var.event_delivery_schema
  service_bus_queue_endpoint_id = var.sb_process_queue_id

  retry_policy {
    max_delivery_attempts = var.event_max_retry_attempts
    event_time_to_live    = var.event_ttl
  }
}