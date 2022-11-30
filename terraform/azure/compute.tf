###########################################
################# Azure ###################
###########################################

###########################################
############ Network Interface ############
###########################################

resource "azurerm_network_interface" "nic" {
  count               = var.instance_count["vms"] >= 1 ? var.instance_count["vms"] : 0
  name                = "${var.prefix}-${var.project}-server-${count.index}-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "${var.prefix}-${var.project}-server-${count.index}-nic-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip[count.index].id

  }

  tags = var.tags
}

###########################################
################# SSH Key #################
###########################################

resource "tls_private_key" "ssh_keypair" {
  count     = var.instance_count["vms"] >= 1 ? var.instance_count["vms"] : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

#output "tls_private_key" {
#  value     = tls_private_key.ssh_keypair.private_key_pem
#  sensitive = true
#}

resource "local_sensitive_file" "private_key_file" {
    count           = var.instance_count["vms"] >= 1 ? var.instance_count["vms"] : 0
    content         = tls_private_key.ssh_keypair[0].private_key_pem
    filename        = "${path.root}/../config/${var.prefix}-${var.project}-vm.pem"
    file_permission = "0400"
}

###########################################
############# Virtual Machine #############
###########################################

resource "azurerm_linux_virtual_machine" "vm" {
  count                           = var.instance_count["vms"] >= 1 ? var.instance_count["vms"] : 0
  name                            = "${var.prefix}-${var.project}-server-${count.index}-vm"
  location                        = var.region
  resource_group_name             = azurerm_resource_group.rg.name
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nic[count.index].id]
  size                            = var.vm_size
  tags                            = var.tags

  admin_ssh_key {
   username    = var.admin_username
   public_key  = tls_private_key.ssh_keypair[0].public_key_openssh
  }

  os_disk {
    name                 = "${var.prefix}-${var.project}-server-${count.index}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = var.vm_disk_type
    disk_size_gb         = 100
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = lookup(var.vm_image_sku, var.region)
    version   = "latest"
  }
}