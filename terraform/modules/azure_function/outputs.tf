output "azfunc_name" {
  description = "O nome da Azure Function App"
  value       = azurerm_linux_function_app.azfunc.name
}