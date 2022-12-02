###########################################
############ Confluent Cloud ##############
###########################################

#Generic naming elements for resource namespacing and grouping based on naming convention used throughout the scripts.
variable "prefix" {
  type        = string
  description = "Prefix to be used for grouping resources."
}

variable "project" {
  type        = string
  description = "Project name for which the resources are deployed."
}


# Confluent Cloud credentials (API Key and Secret) for a User- or Service account with at least EnvironmentAdmin role assigned 
# to be used by the Confluent terraform provider.
variable "confluent_cloud_admin_api_key" {
  type        = string
  description = "Confluent Cloud API Key credential for a User- or Service account with at least EnvironmentAdmin role assigned."
}

variable "confluent_cloud_admin_api_secret" {
  type        = string
  description = "Confluent Cloud API Secret credential for a User- or Service account with at least EnvironmentAdmin role assigned."
}


# Infrastructure control
variable "create_ccloud_environment" {
  type        = bool
  description = "Parameter that determines whether a new Confluent Cloud Environment will be created or not."
}

variable "create_ccloud_service_account" {
  type        = bool
  description = "Parameter that determines whether a new Service Account will be created or not."
}

variable "create_ccloud_rolebindings" {
  type        = bool
  description = "Parameter that determines whether data plane role bindings Confluent Cloud Environment will be created for the newly created Service Account or not."
}


## Confluent Cloud Environment configuration parameters
variable "confluent_env_id" {
  type        = string
  description = "Existing Confluent Cloud Environment id in which the Confluent Cloud Cluster will be deployed."
}

variable "confluent_environment_display_name" {
  type        = string
  description = "New Confluent Cloud Environment display name in which the Confluent Cloud Cluster will be deployed."
}


## Confluent Cloud Kafka Cluster configuration parameters
variable "confluent_availability" {
  type        = string
  description = "The availability zone configuration of the Confluent Cloud Kafka cluster."
  default     = "SINGLE_ZONE"
}

variable "ccloud_service_provider" {
  type        = string
  description = "The cloud service provider that runs the Confluent Cloud Kafka cluster. Valid values are AWS, AZURE, and GCP."
  default     = "AZURE"
}

variable "region" {
  type        = string
  description = "The CSP Region where the Confluent Cloud cluster will be deployed."
  default = "germanywestcentral"
}


## Confluent Cloud Service Account configuration paramters
variable "account_name" {
  type        = string
  description = "The name element used to configure the Service Account name, using the pattern {var.prefix}-{var.account_name}-sa."
  default     = "connect"
}


## Confluent Cloud Role Binding configuration paramters

variable "license_topic" {
  type        = string
  description = "The name of the license topic that is used by Commercial Confluent Cloud components"
  default     = "_confluent-command"
}

variable "connect_internal_topic_prefix" {
  type        = string
  description = "The topic name prefix used for the Kafka Connect internal topics."
  default     = "confluent.*"
}

variable "namespace_topic_prefix" {
  type           = string
  description    = "The topic name prefix used for application topics in the project namespace to which applications, such as connectors, write or read from."
}

variable "license_group_prefix" {
  type        = string
  description = "The consumer group name prefix to read from the license topic that is used by Commercial Confluent Cloud components"
  default     = "_confluent-command"
}

variable "connect_internal_group_prefix" {
  type        = string
  description = "The consumer group prefix used to read from Kafka Connect internal topics."
  default     = "confluent.*"
}

variable "namespace_group_prefix" {
  type           = string
  description    = "The consumer group prefix used to read from application topics in the project namespace."
}

