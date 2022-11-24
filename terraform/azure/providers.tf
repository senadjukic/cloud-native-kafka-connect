###########################################
################# Azure ###################
###########################################
# Configure the Azure provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.32"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  features {}
}

