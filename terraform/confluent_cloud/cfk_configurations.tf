###########################################
############ Confluent Cloud ##############
###########################################

###########################################
######## Confluent 4 K8s Configs ##########
###########################################

# This terraform script sets a set of Confluent Cloud related parameters
# in Confluent for Kubernetes resource definition template files, so they 
# can be used directly with Confluent for Kubermetes to deploy the resoures

# Generate the Confluent Cloud credentials as K8s secret files to be used by CfK artefacts
locals{
  cfk_kafka_credentials =  templatefile("${path.root}/../../${var.cfk_config_dir}/ccloud-credentials.tftpl",{
        kafka_api_key    = confluent_api_key.cloud-connect-kafka-api-key.id, 
        kafka_api_secret = confluent_api_key.cloud-connect-kafka-api-key.secret
      }   
    )
}

resource "local_sensitive_file" "cfk_credentials_kafka_secret_file" {
    content         = local.cfk_kafka_credentials
    filename        = "${path.root}/../../${var.cfk_config_dir}/ccloud-credentials.txt"
    file_permission = "0644"
}


# Generate the Confluent 4 K8s CRD file for Kafka Connect by merging Terraform template file with Confluent Cloud resource attributes. 
locals{
  cfk_kafka_connect =  templatefile("${path.root}/../../${var.cfk_config_dir}/kafka-connect-yaml.tftpl",{
        ccloud_kafka_bootstrap_url    = trimprefix(confluent_kafka_cluster.standard.bootstrap_endpoint,"SASL_SSL://"), 
        ccloud_sr_url                 = local.ccloud_sr_rest_endpoint
      }   
    )
}

resource "local_file" "cfk_crd_kafka_connect_file" {
    content         = local.cfk_kafka_connect
    filename        = "${path.root}/../../${var.cfk_config_dir}/kafka-connect.yaml"
    file_permission = "0644"
}


# Generate the Confluent 4 K8s CRD file for Kafka Topic by merging Terraform template file with Confluent Cloud resource attributes. 
locals{
  cfk_kafka_topic =  templatefile("${path.root}/../../${var.cfk_config_dir}/create-topic-yaml.tftpl",{
        ccloud_kafka_rest_url    = confluent_kafka_cluster.standard.rest_endpoint, 
        ccloud_kafka_cluster_id  = confluent_kafka_cluster.standard.id
      }   
    )
}

resource "local_file" "cfk_crd_kafka_topic_file" {
    content         = local.cfk_kafka_topic
    filename        = "${path.root}/../../${var.cfk_config_dir}/create-topic.yaml"
    file_permission = "0644"
}
