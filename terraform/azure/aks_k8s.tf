###########################################
################# Azure ###################
###########################################

###########################################
########### Generate SSH Keys #############
###########################################

resource "tls_private_key" "ssh_keypair_aks" {
  count     = var.create_aks ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "private_key_file_aks" {
    count           = var.create_aks ? 1 : 0
    content         = tls_private_key.ssh_keypair_aks[0].private_key_pem
    filename        = "${path.root}/../config/${var.prefix}-${var.project}-aks.pem"
    file_permission = "0400"
}

###########################################
######### Azure Kubernetes Service ########
###########################################

resource "azurerm_kubernetes_cluster" "aks_k8s" {
  count               = var.create_aks ? 1 : 0
  name                = "${var.prefix}-${var.project}-aks-cluster"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}"
  node_resource_group = "${var.prefix}-${var.project}-aks-node-rg"
  
  default_node_pool {
    name            = "${var.prefix}pool"
    node_count      = var.instance_count["k8s_nodes"]
    vm_size         = var.aks_node_vm_size
    max_pods        = var.aks_max_pods_per_node
    os_disk_size_gb = var.aks_disk_size
    os_sku          = var.aks_os_sku
    tags            = var.tags
  }

  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = tls_private_key.ssh_keypair_aks[0].public_key_openssh
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags             = var.tags
}

resource "time_sleep" "wait_for_aks_api" {
  depends_on = [azurerm_kubernetes_cluster.aks_k8s]
  create_duration = "30s"
}

# Update the local kubectl config
resource "null_resource" "configure_kubectl" {
  count = var.create_aks ? 1 : 0
  provisioner "local-exec" {
    command     = "az aks get-credentials --resource-group ${azurerm_resource_group.rg.name} --name ${azurerm_kubernetes_cluster.aks_k8s[0].name} --overwrite-existing"
    interpreter = ["bash", "-c"]
  }
  depends_on = [time_sleep.wait_for_aks_api]
}


# Configure an application specific Kubernetes namespace in our newly created AKS cluster
resource "kubernetes_namespace" "aks_ns" {
  count = var.create_aks ? 1 : 0
  metadata {
    name = var.aks_application_namespace
    annotations = {
      project     = var.project
      owner       = var.tags["Owner_Name"]
      email       = var.tags["Owner_Email"]
      environment = var.tags["Environment"]
    }
  }
  depends_on = [null_resource.configure_kubectl]
}

# Set newly created application namespace as default for Kubernetes context on local machine
resource "null_resource" "context_namespace" {
  count = var.create_aks ? 1 : 0
  provisioner "local-exec" {
   command     = "kubectl config set-context --current --namespace ${kubernetes_namespace.aks_ns[0].id}"
   interpreter = ["bash", "-c"]
  }
  depends_on = [kubernetes_namespace.aks_ns]
}
