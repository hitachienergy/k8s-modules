locals {
  prefix  = split("-", "${azurerm_resource_group.rg.name}")[0]
}
