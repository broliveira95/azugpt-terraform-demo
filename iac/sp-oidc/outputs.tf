output "application_name" {
  value = local.application_name
}

output "client_id" {
  value = azuread_application.application.client_id
}

output "sp_object_id" {
  value = azuread_service_principal.service_principal.object_id
}

output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}
