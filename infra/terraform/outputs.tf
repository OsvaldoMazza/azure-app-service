output "resource_group_name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.rg.name
}

output "app_service_default_hostname" {
  description = "The default hostname of the App Service."
  value       = azurerm_linux_web_app.app_service.default_hostname
}