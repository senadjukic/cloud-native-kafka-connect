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