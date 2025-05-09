terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
}
