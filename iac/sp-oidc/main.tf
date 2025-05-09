# ============================================================================ #
# Remote backend
# ============================================================================ #
terraform {
  backend "azurerm" {}
}

# ============================================================================ #
# Providers
# ============================================================================ #
provider "azuread" {}

provider "azurerm" {
  features {}
  subscription_id = "a4ead089-9a25-48c7-a816-e3397ce5a520"
}

provider "github" {
  # Configuration options
  owner = local.github_organization_name
}

# ============================================================================ #
# Data Sources
# ============================================================================ #
data "azurerm_subscription" "current" {}

data "azuread_client_config" "current" {}

# ============================================================================ #
# Local Variables
# ============================================================================ #
locals {
  github_organization_name = "broliveira95"
  github_repository_name   = "azugpt-terraform-demo"
  application_name         = "sp-${local.github_repository_name}-${var.environment}"

  github_environment_variables = {
    ARM_SUBSCRIPTION_ID  = data.azurerm_subscription.current.subscription_id
    ARM_TENANT_ID        = data.azuread_client_config.current.tenant_id
    ARM_CLIENT_ID        = azuread_application.application.client_id
    ARM_APPLICATION_NAME = local.application_name
  }
}

# ============================================================================ #
# Resources
# ============================================================================ #
resource "azuread_application" "application" {
  display_name = local.application_name
}

resource "azuread_service_principal" "service_principal" {
  client_id = azuread_application.application.client_id
}

resource "azuread_application_federated_identity_credential" "federated_identity_environment" {
  application_id = "/applications/${azuread_application.application.object_id}"
  display_name   = "github-${local.github_organization_name}.${local.github_repository_name}-${var.environment}"
  description    = "GitHub federated identity credentials"
  subject        = "repo:${local.github_organization_name}/${local.github_repository_name}:environment:${var.environment}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
}

resource "azurerm_role_assignment" "rbac_contributor" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.service_principal.object_id
}

resource "azurerm_role_assignment" "rbac_blob_data_contributor" {
  scope                = data.azurerm_subscription.current.id // don't do this
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azuread_service_principal.service_principal.object_id
}

resource "github_repository_environment" "gh_env" {
  environment = var.environment
  repository  = local.github_repository_name
}

resource "github_actions_environment_variable" "gh_env_vars" {
  for_each      = local.github_environment_variables
  repository    = local.github_repository_name
  environment   = github_repository_environment.gh_env.environment
  variable_name = each.key
  value         = each.value
}
