###########################################
################# Azure ###################
###########################################

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.project}-rg"
  location = var.region
  tags     = var.tags
}