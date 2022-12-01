###########################################
############ Confluent Cloud ##############
###########################################

###########################################
####### Confluent Cloud Environment #######
###########################################

data "confluent_environment" "existing_env" {
  id = var.confluent_env_id
}

resource "confluent_environment" "new_env" {
  count        = var.create_ccloud_environment ? 1 : 0  
  display_name = var.confluent_environment_display_name
}

locals {
  ccloud_env_id = var.create_ccloud_environment ? confluent_environment.new_env[0].id : data.confluent_environment.existing_env.id
}

###########################################
######### Confluent Cloud Cluster #########
###########################################

resource "confluent_kafka_cluster" "standard" {
  display_name = "${var.prefix}-${var.project}-kafka-cluster"
  availability = var.confluent_availability
  cloud        = var.ccloud_service_provider
  region       = var.region
  standard {}

  environment {
    id = local.ccloud_env_id
  }
}
