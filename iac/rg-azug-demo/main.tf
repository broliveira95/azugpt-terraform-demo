# ============================================================================ #
# Remote backend
# ============================================================================ #
terraform {
  backend "azurerm" {}
}

# ============================================================================ #
# Providers
# ============================================================================ #
provider "azurerm" {
  features {}
  subscription_id = "a4ead089-9a25-48c7-a816-e3397ce5a520"
}

# ============================================================================ #
# Data Sources
# ============================================================================ #
data "azurerm_client_config" "current" {}

# ============================================================================ #
# Local Variables
# ============================================================================ #
locals {
  environment_short = substr(var.environment, 0, 1)
}

# ============================================================================ #
# Resources
# ============================================================================ #
resource "azurerm_resource_group" "rg" {
  name     = "rg-azug-demo-${local.environment_short}"
  location = var.location
}

#tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "kv" {
  name                       = "kv-demo-azug-${local.environment_short}"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.kv_sku
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  enable_rbac_authorization  = true
}
