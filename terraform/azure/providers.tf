###########################################
################# Azure ###################
###########################################
# Configure the required providers for Azure

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.33"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 1.0.0"
}

# Configure the Microsoft Azure Provider to be used with CLI based Authentication,
# as we are using this Terraform script for demos from the developer's local machine.

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  features {}
}

# Configure the Kubernetes provider to be used with kubectl based Authentication,
# as we are using this Terraform script for demos from the developer's local machine.

provider "kubernetes" {
  config_path = "~/.kube/config"
}