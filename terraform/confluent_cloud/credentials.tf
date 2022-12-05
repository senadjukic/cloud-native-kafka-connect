###########################################
############ Confluent Cloud ##############
###########################################

###########################################
################ API Keys #################
###########################################

resource "confluent_api_key" "cloud-connect-kafka-api-key" {
  display_name = "${confluent_service_account.cloud-connect-sa[0].display_name}-kafka-api-key"
  description  = "API Key for Kafka cluster ${confluent_kafka_cluster.standard.display_name} that is owned by '${confluent_service_account.cloud-connect-sa[0].display_name}' service account."
  owner {
    id          = confluent_service_account.cloud-connect-sa[0].id
    api_version = confluent_service_account.cloud-connect-sa[0].api_version
    kind        = confluent_service_account.cloud-connect-sa[0].kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.standard.id
    api_version = confluent_kafka_cluster.standard.api_version
    kind        = confluent_kafka_cluster.standard.kind

    environment {
      id = local.ccloud_env_id
    }
  }

  # The goal is to ensure that confluent_role_binding.client-namespace-topic-manage-rb is created before
  # confluent_api_key.${var.prefix}-${var.account_name}-sa-api-key is used to create instances of
  # confluent_kafka_topic resources.

  # 'depends_on' meta-argument is specified in confluent_api_key.${var.prefix}-${var.account_name}-sa-kafka-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_kafka_topic resources instead.
  depends_on = [
    confluent_role_binding.client-namespace-topic-manage-rb
  ]

  lifecycle {
    prevent_destroy = false
  }
}

# As API Keys for Confluent Cloud Schema Registry is not yet supported (as of December 4th., 2022)
# this section is commented out, until that capability is released later in the month of December 2022
# resource "confluent_api_key" "cloud-connect-sr-api-key" {
#   display_name = "${confluent_service_account.cloud-connect-sa[0].display_name}-sr-api-key"
#   description  = "API Key for schema registry ${local.ccloud_sr_name} that is owned by '${confluent_service_account.cloud-connect-sa[0].display_name}' service account."
#   owner {
#     id          = confluent_service_account.cloud-connect-sa[0].id
#     api_version = confluent_service_account.cloud-connect-sa[0].api_version
#     kind        = confluent_service_account.cloud-connect-sa[0].kind
#   }
# 
#   managed_resource {
#     id          = local.ccloud_sr_id 
#     api_version = local.ccloud_sr_api_version
#     kind        = local.ccloud_sr_kind
# 
#     environment {
#       id = local.ccloud_env_id
#     }
#   }
# 
#   lifecycle {
#     prevent_destroy = false
#   }
# }

# Workaround to create API Keys for Confluent Cloud Schema Registry, until natively supported in Confluent Cloud's terraform provider,
# as expected to be released later in the month of December 2022

# Create API Key for newly created Confluent Cloud Schema Registry using the confluent cli.
resource "null_resource" "cloud-cli-set-env" {
   provisioner "local-exec" {
   command     = "confluent environment use ${local.ccloud_env_id}" 
   interpreter = ["bash", "-c"]
  }
  depends_on = [local.ccloud_env_id]
}

resource "null_resource" "cloud-connect-sr-api-key" {
   provisioner "local-exec" {
   command     = "confluent api-key create --service-account ${confluent_service_account.cloud-connect-sa[0].id} --resource ${local.ccloud_sr_id} --description 'API Key for schema registry for environment ${local.ccloud_env_id} that is owned by ${confluent_service_account.cloud-connect-sa[0].display_name} service account.' -o json > ${path.root}/../config/${confluent_service_account.cloud-connect-sa[0].display_name}-${local.ccloud_sr_id}-sr-credentials.json"
   interpreter = ["bash", "-c"]
  }
  depends_on = [null_resource.cloud-cli-set-env, confluent_service_account.cloud-connect-sa, local.ccloud_sr_id]
}

# locals {
#  sr_credentials_file = jsondecode(file("${path.root}/../config/${confluent_service_account.cloud-connect-sa[0].display_name}-${local.ccloud_sr_id}-sr-credentials.json"))
#  sr_api_key          = local.sr_credentials_file.key 
#  sr_api_secret       = local.sr_credentials_file.secret
#}