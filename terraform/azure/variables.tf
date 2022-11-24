###########################################
################# Azure ###################
###########################################

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant id for azure account"
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription id in azure account to be used"
}
variable "region" {
  type        = string
  description = "The Azure Region where the Resource Group exists."
}

variable "zone" {
  type        = string
  description = "The availability zone in the Azure Region where the resources will be deployed."
}

variable "prefix" {
  type        = string
  description = "Prefix to be used for grouping resources."
}

variable "project" {
  type        = string
  description = "Project name for which the resources are deployed."
}

variable "tags" {
  type        = map(any)
  description = "Tags to add extra metadata to the resources."
  default = {
    Environment = "MeetTheSEDemo"
    Owner_Name  = "Perry Krol"
    Owner_Email = "perry@confluent.io"
  }
}

variable "instance_count" {
  type = map(string)
  default = {
    vms = 1
    lbs = 0
  }
}

variable "admin_username" {
  type        = string
  description = "Administrator user name for virtual machine"
}

variable "sku" {
  type        = map(string)
  description = "Ubuntu Linux OS version for virtual machine"
  default = {
    westeurope         = "18.04-LTS"
    germanywestcentral = "18.04-LTS"

  }
}

variable "k8s_core_node_type" {
  type        = string
  description = "Machine type to be used for core K8s nodes."
}

variable "gke_max_pods_per_node" {
  type        = number
  description = "Maximum pods per node on VPC Native GKE cluster. This is used to influence IP range size assigned per pod."
}

variable "create_aks" {
  type        = bool
  description = "Parameter that determines whether the AKS K8s cluster will be created or not."
}

variable "create_vms" {
  type        = bool
  description = "Parameter that determines whether the vms will be instantiated or not."
}


