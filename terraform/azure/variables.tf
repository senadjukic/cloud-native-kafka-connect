###########################################
################# Azure ###################
###########################################

# Azure tenant and subcription id required by terraform to ensure we create the resources in the right Azure environment.
variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant id for azure account"
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription id in azure account to be used"
}

#Generic naming elements for resource namespacing and grouping based on naming convention used throughout the scripts.
variable "prefix" {
  type        = string
  description = "Prefix to be used for grouping resources."
}

variable "project" {
  type        = string
  description = "Project name for which the resources are deployed."
}

# Optional tagging for cloud resources. Defined as a map of keys and values
# Replace with your own keys and values, or delete this if not needed.
variable "tags" {
  type        = map(any)
  description = "Tags to add extra metadata to the resources."
   default = {
    Environment = ""
    Owner_Name  = ""
    Owner_Email = ""
  }
}

# Infrastructure control
variable "create_networksg" {
  type        = bool
  description = "Parameter that determines whether the Network Security Group and Rules will be created or not."
}

variable "create_aks" {
  type        = bool
  description = "Parameter that determines whether the AKS K8s cluster will be created or not."
}

variable "deploy_cfk" {
  type        = bool
  description = "Parameter that determines whether the CFK Operator will deployed via Helm in the newly created AKS K8s cluster or not."
}

variable "instance_count" {
  type = map(string)
  default = {
    vms = 1 # If set to 0, no virtual machines and related resources will be created.
    lbs = 0
    k8s_nodes = 4
  }
}

#Infrastructure parameters, change them to meet your desired Azure setup 
variable "region" {
  type        = string
  description = "The Azure Region where the Resource Group exists."
  default = "germanywestcentral"
}

variable "zone" {
  type        = string
  description = "The availability zone in the Azure Region where the resources will be deployed."
}



#Variables to configure VM infrastructure. When vms is set to 0,it works as an enable

variable "admin_username" {
  type        = string
  description = "Administrator user name for virtual machine"
}

variable "vm_size" {
  type        = string
  description = "The SKU which should be used for this Virtual Machine"
  default = "Standard_DS3_v2"
}

variable "vm_disk_type" {
  type        = string
  description = "The Type of Storage Account which should back the Internal OS Disk"
  default     = "Premium_LRS"
}

variable "vm_disk_size" {
  type        = number
  description = "The size of the Internal OS Disk in GB"
  default     = 100
}

variable "vm_image_sku" {
  type        = map(string)
  description = "The SKU of the image used to create the virtual machines."
  default = {
    westeurope         = "18.04-LTS"
    germanywestcentral = "22.04-LTS"
    switzerlandnorth   = "22.04-LTS"
  }
}

## Azure Kubernetes Service configuration parameters

variable "aks_node_vm_size" {
  type        = string
  description = "The SKU which should be used for this AKS Node Pool"
  default     = "Standard_DS3_v2"
}

variable "aks_max_pods_per_node" {
  type        = number
  description = "Maximum pods per node in default node pool nodes on AKS cluster."
  default     = 110
}

variable "aks_os_sku" {
  type        = string
  description = "Specifies the OS SKU used by the agent pool. Possible values include: Ubuntu, CBLMariner, Mariner, Windows2019, Windows2022"
  default     = "Ubuntu"
}

variable "aks_disk_size" {
  type        = number
  description = "The size of the Internal OS Disk in GB"
  default     = 128
}

variable "aks_application_namespace" {
  type        = string
  description = "Specifies an application specific Kubernetes namespace in our newly created AKS cluster"
  default     = "confluent"
}