output "sb_process_queue_id" {
  description = "ID da fila process.queue"
  value       = azurerm_servicebus_queue.sb_queues["process.queue"].id
}

output "sb_process_queue_name" {
  description = "Nome da fila process.queue"
  value       = azurerm_servicebus_queue.sb_queues["process.queue"].name
}

output "sb_namespace_name" {
  description = "Nome do namespace do Service Bus"
  value       = azurerm_servicebus_namespace.sb_ns.name
}