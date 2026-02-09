output "sb_connection_string" {
    description = "A connection strinf para o Service Bus Namespace"
    value       = azurerm_servicebus_namespace.sb_ns.default_primary_connection_string
}

output "sb_process_queue_id" {
  description = "ID da fila process.queue"
  value       = azurerm_servicebus_queue.sb_queues["process.queue"].id
}