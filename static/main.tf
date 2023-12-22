resource "azurerm_resource_group" "rg_static" {
  name     = "${var.resource_group_name}-${terraform.workspace}"
  location = "${var.location}"
}

resource "azurerm_management_lock" "sonarqube_static_lock" {
  name       = "DoNotDelete"
  scope      = "${azurerm_resource_group.rg_static.id}"
  lock_level = "CanNotDelete"
  notes      = "Implemented as part of DVO-3231"
}

resource "azurerm_lb" "static" {
  name                = "AZ-LB-SonarQube-private"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg_static.name}"

  frontend_ip_configuration {
    name                          = "loadBalancerFrontEnd"
    private_ip_address_allocation = "static"
    private_ip_address            = "${lookup(var.private_ips,terraform.workspace)}"
    subnet_id                     = "/subscriptions/${lookup(var.subscription_ids,terraform.workspace)}/resourceGroups/AZ-RG-Network/providers/Microsoft.Network/virtualNetworks/${lookup(var.vnets, terraform.workspace)}/subnets/AZ-SN-front"
  }
}

resource "azurerm_lb_backend_address_pool" "static" {
  loadbalancer_id     = "${azurerm_lb.static.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "static" {
  loadbalancer_id     = "${azurerm_lb.static.id}"
  name                = "lbprobe"
  protocol            = "Http"
  port                = 9000
  request_path        = "/"
  interval_in_seconds = 120
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "static" {
  loadbalancer_id                = "${azurerm_lb.static.id}"
  probe_id                       = "${azurerm_lb_probe.static.id}"
  backend_address_pool_ids       = "${azurerm_lb_backend_address_pool.static.id}"
  name                           = "lbrule"
  protocol                       = "Tcp"
  frontend_port                  = 9000
  backend_port                   = 9000
  idle_timeout_in_minutes        = 15
  frontend_ip_configuration_name = "loadBalancerFrontEnd"
}

resource "azurerm_lb_probe" "static2" {
  loadbalancer_id     = "${azurerm_lb.static.id}"
  name                = "lbprobe2"
  protocol            = "Http"
  port                = 8081
  request_path        = "/"
  interval_in_seconds = 120
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "static2" {
  loadbalancer_id                = "${azurerm_lb.static.id}"
  probe_id                       = "${azurerm_lb_probe.static2.id}"
  backend_address_pool_ids        = "${azurerm_lb_backend_address_pool.static.id}"
  name                           = "lbrule2"
  protocol                       = "Tcp"
  frontend_port                  = 8081
  backend_port                   = 8081
  idle_timeout_in_minutes        = 15
  frontend_ip_configuration_name = "loadBalancerFrontEnd"
}

resource "azurerm_storage_account" "static" {
  name                     = "sqbstatics${terraform.workspace}"
  resource_group_name      = "${azurerm_resource_group.rg_static.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "static_data" {
  name                 = "data"
  quota                = 50
  storage_account_name = "${azurerm_storage_account.static.name}"
}

resource "azurerm_storage_share" "static_archive" {
  name                 = "archive"
  quota                = 50
  storage_account_name = "${azurerm_storage_account.static.name}"
}
