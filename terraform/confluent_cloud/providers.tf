###########################################
############ Confluent Cloud ##############
###########################################

# Configure the Confluent Provider
terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.19.0"
    }
  }
  required_version = ">= 1.3.0"
}

# Configure the Confluent Cloud provider with credentials that can access the Confluent Cloud Data Plane API with 
# the appropriate Confluent Cloud Administration rights.
provider "confluent" {
  cloud_api_key    = var.confluent_cloud_admin_api_key    # optionally use CONFLUENT_CLOUD_API_KEY env var
  cloud_api_secret = var.confluent_cloud_admin_api_secret # optionally use CONFLUENT_CLOUD_API_SECRET env var
}