cc
resource "azurerm_network_interface" "nic" {
  count               = var.instance_count["vms"] >= 1 ? var.instance_count["vms"] : 0
  name                = "${var.prefix}-${var.project}-server-${count.index}-nic"
  location            = var.location
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
  algorithm = "RSA"
  rsa_bits  = 4096
}
output "tls_private_key" {
  value     = tls_private_key.ssh_keypair.private_key_pem
  sensitive = true
}

###########################################
############# Virtual Machine #############
###########################################

resource "azurerm_virtual_machine" "vm" {
  count                         = var.instance_count["vms"] >= 1 ? var.instance_count["vms"] : 0
  name                          = "${var.prefix}-${var.project}-server-${count.index}-vm"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  network_interface_ids         = [azurerm_network_interface.nic[count.index].id]
  vm_size                       = "Standard_DS3_v2"
  delete_os_disk_on_termination = true
  tags                          = var.tags

  storage_os_disk {
    name              = "${var.prefix}-${var.project}-server-${count.index}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = 100
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = lookup(var.sku, var.location)
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-${var.project}-vm-${count.index}"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.ssh_keypair.public_key_openssh
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
}