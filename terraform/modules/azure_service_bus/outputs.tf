output "sb_connection_string" {
    description = "A connection strinf para o Service Bus Namespace"
    value       = azurerm_servicebus_namespace.sb_ns.default_primary_connection_string
}