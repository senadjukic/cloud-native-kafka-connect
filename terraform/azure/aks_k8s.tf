###########################################
################# Azure ###################
###########################################

###########################################
######### Azure Kubernetes Service ########
###########################################


# Update the local kubectl config
resource "null_resource" "configure_kubectl" {
  count = var.create_aks ? 1 : 0
  provisioner "local-exec" {
    command     = "gcloud container clusters get-credentials ${google_container_cluster.mse_aks[0].name} --zone ${var.zone} --project ${var.gcp_project}"
    interpreter = ["bash", "-c"]
  }

  depends_on = [google_container_cluster.mse_aks]
}