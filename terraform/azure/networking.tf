###########################################
################# Azure ###################
###########################################

###########################################
############# Virtual Network #############
###########################################

resource "azurerm_virtual_network" "vnet_network" {
  name                = "${var.prefix}-${var.project}-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

###########################################
################# Subnets #################
###########################################

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-${var.project}-vnet-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_network.name
  address_prefixes     = ["10.10.68.0/24"]
}

###########################################
############### Public IPs ################
###########################################

resource "azurerm_public_ip" "publicip" {
  count               = var.instance_count["vms"] >= 1 ? var.instance_count["vms"] : 0
  name                = "${var.prefix}-${var.project}-server-${count.index}-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags                = var.tags
}

###########################################
############# Security Groups #############
###########################################

resource "azurerm_network_security_group" "nsg" {
  count               = var.create_networksg ? 1 : 0
  name                = "${var.prefix}-${var.project}-nsg"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "ssh_sr" {
  count                       = var.create_networksg ? 1 : 0
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}

resource "azurerm_network_security_rule" "c3_sr" {
  count                       = var.create_networksg ? 1 : 0
  name                        = "HTTP80"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}

resource "azurerm_network_security_rule" "ksqldb_sr" {
  count                       = var.create_networksg ? 1 : 0
  name                        = "HTTP8088"
  priority                    = 1003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8088"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}

resource "azurerm_network_security_rule" "connect_sr" {
  count                       = var.create_networksg ? 1 : 0
  name                        = "HTTP8083"
  priority                    = 1004
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8083"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}