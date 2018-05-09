resource "azurerm_resource_group" "rg_static" {
  name     = "${var.resource_group_name}-${terraform.workspace}"
  location = "${var.location}"
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
  resource_group_name = "${azurerm_resource_group.rg_static.name}"
  loadbalancer_id     = "${azurerm_lb.static.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "static" {
  resource_group_name = "${azurerm_resource_group.rg_static.name}"
  loadbalancer_id     = "${azurerm_lb.static.id}"
  name                = "lbprobe"
  protocol            = "Http"
  port                = 9000
  request_path        = "/"
  interval_in_seconds = 120
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "static" {
  resource_group_name            = "${azurerm_resource_group.rg_static.name}"
  loadbalancer_id                = "${azurerm_lb.static.id}"
  probe_id                       = "${azurerm_lb_probe.static.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.static.id}"
  name                           = "lbrule"
  protocol                       = "Tcp"
  frontend_port                  = 9000
  backend_port                   = 9000
  idle_timeout_in_minutes        = 15
  frontend_ip_configuration_name = "loadBalancerFrontEnd"
}

resource "azurerm_lb_probe" "static2" {
  resource_group_name = "${azurerm_resource_group.rg_static.name}"
  loadbalancer_id     = "${azurerm_lb.static.id}"
  name                = "lbprobe2"
  protocol            = "Http"
  port                = 8081
  request_path        = "/"
  interval_in_seconds = 120
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "static2" {
  resource_group_name            = "${azurerm_resource_group.rg_static.name}"
  loadbalancer_id                = "${azurerm_lb.static.id}"
  probe_id                       = "${azurerm_lb_probe.static2.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.static.id}"
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
  name                  = "data"
  resource_group_name   = "${azurerm_resource_group.rg_static.name}"
  storage_account_name  = "${azurerm_storage_account.static.name}"
}

resource "azurerm_storage_share" "static_archive" {
  name                  = "archive"
  resource_group_name   = "${azurerm_resource_group.rg_static.name}"
  storage_account_name  = "${azurerm_storage_account.static.name}"
}
