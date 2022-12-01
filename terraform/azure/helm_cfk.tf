###########################################
######## Confluent for Kubernetes #########
###########################################

# Deploy the Confluent for Kubernetes operator 
resource "helm_release" "helm_cfk" {
  count      = var.deploy_cfk ? 1 : 0
  name       = "${var.prefix}-${var.project}-cfk-release"
  repository = "https://packages.confluent.io/helm"
  chart      = "confluent-for-kubernetes"
  version    = "2.5.0"
  namespace  = kubernetes_namespace.aks_ns[0].id
}
