output "app_insights_instrumentation_key" {
  description = "A chave de instrumentação do Application Insights"
  value = azurerm_application_insights.app-insights.instrumentation_key
}

output "app_insights_connection_string" {
  description = "A connection string do Application Insights"
  value = azurerm_application_insights.app-insights.connection_string
}