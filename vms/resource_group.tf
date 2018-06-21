resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}-${terraform.workspace}"
  location = "${var.location}"
}

resource "azurerm_management_lock" "sonarqube_lock" {
  name       = "DoNotDelete"
  scope      = "${azurerm_resource_group.rg.id}"
  lock_level = "CanNotDelete"
  notes      = "Implemented as part of DVO-3231"
}
