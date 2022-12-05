###########################################
############ Confluent Cloud ##############
###########################################

###########################################
## Azure Container Infrastructure Configs #
###########################################

# This terraform script sets a set of Confluent Cloud related parameters
# in Azure Container Infrastructure resource configuration template files, so they 
# can be used to deploy the resoures for ACI.

# Generate the Confluent Cloud credentials as K8s secret files to be used by CfK artefacts
locals{
  aci_ccloud_env =  templatefile("${path.root}/../../${var.aci_config_dir}/set_ccloud_env.tftpl",{
        kafka_api_key                 = confluent_api_key.cloud-connect-kafka-api-key.id, 
        kafka_api_secret              = confluent_api_key.cloud-connect-kafka-api-key.secret,
        ccloud_kafka_bootstrap_url    = trimprefix(confluent_kafka_cluster.standard.bootstrap_endpoint,"SASL_SSL://"), 
        ccloud_sr_url                 = local.ccloud_sr_rest_endpoint
#        ccloud_sr_api_key             = local.sr_api_key 
#        ccloud_sr_api_secret          = local.sr_api_secret 
      }   
    )
}

resource "local_file" "aci_ccloud_env_script" {
    content         = local.aci_ccloud_env
    filename        = "${path.root}/../../${var.aci_config_dir}/set_ccloud_env.sh"
    file_permission = "0755"
}