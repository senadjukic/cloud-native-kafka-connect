###########################################
################# Azure ###################
###########################################
# Configure the required providers for Azure, Kubernetes and Helm

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

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7.1"
    }
  }

  required_version = ">= 1.3.0"
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

# Configure the Helm provider to be used with kubectl based Authentication,
# as we are using this Terraform script for demos from the developer's local machine.

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}