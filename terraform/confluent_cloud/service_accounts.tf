###########################################
############ Confluent Cloud ##############
###########################################

###########################################
############ Service Account ##############
###########################################

resource "confluent_service_account" "cloud-connect-sa" {
  count        = var.create_ccloud_service_account ? 1 : 0
  display_name = "${var.prefix}-${var.account_name}-sa"
  description  = "Service Account for self-managed applications, such as Connect, with Confluent Cloud for ${var.project} demo"
}

###########################################
######## Dataplane Role Bindings ##########
###########################################

# Kafka topic access role bindings
resource "confluent_role_binding" "confluent-license-topic-manage-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${var.license_topic}"
}

resource "confluent_role_binding" "confluent-license-topic-read-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${var.license_topic}"
}

resource "confluent_role_binding" "confluent-license-topic-write-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${var.license_topic}"
}
resource "confluent_role_binding" "client-connect-topic-manage-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${var.connect_internal_topic_prefix}"
}

resource "confluent_role_binding" "client-connect-topic-read-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0    
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${var.connect_internal_topic_prefix}"
}

resource "confluent_role_binding" "client-connect-topic-write-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${var.connect_internal_topic_prefix}"
}

resource "confluent_role_binding" "client-namespace-topic-manage-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${var.namespace_topic_prefix}"
}

resource "confluent_role_binding" "client-namespace-topic-read-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${var.namespace_topic_prefix}"
}

resource "confluent_role_binding" "client-namespace-topic-write-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/topic=${var.namespace_topic_prefix}"
}


# Kafka consumer group role bindings
resource "confluent_role_binding" "confluent-license-group-manage-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/group=${var.license_group_prefix}"
}

resource "confluent_role_binding" "confluent-license-group-read-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/group=${var.license_group_prefix}"
}

resource "confluent_role_binding" "client-connect-group-manage-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/group=${var.connect_internal_group_prefix}"
}

resource "confluent_role_binding" "client-connect-group-read-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/group=${var.connect_internal_group_prefix}"
}

resource "confluent_role_binding" "client-namespace-group-manage-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperManage"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/group=${var.namespace_group_prefix}"
}

resource "confluent_role_binding" "client-namespace-group-read-rb" {
  count        = var.create_ccloud_rolebindings ? 1 : 0
  principal   = "User:${confluent_service_account.cloud-connect-sa[0].id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${confluent_kafka_cluster.standard.rbac_crn}/kafka=${confluent_kafka_cluster.standard.id}/group=${var.namespace_group_prefix}"
}
