resource "azurerm_network_interface" "sonarqube" {
  name                = "${local.sonarqube_computer_name}-nic"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                                    = "${local.sonarqube_computer_name}-ipconf"
    subnet_id                               = "${local.vm_subnet_id}"
    private_ip_address_allocation           = "static"
    private_ip_address                      = "${local.sonarqube_private_ip}"
    # load_balancer_backend_address_pools_ids = ["${data.terraform_remote_state.static.backendAddressPoolId}"]
  }
}

resource "azurerm_virtual_machine" "sonarqube" {
  name                  = "${local.sonarqube_computer_name}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.sonarqube.id}"]
  vm_size               = "${local.sonarqube_vm_size}"

  delete_os_disk_on_termination    = false
  delete_data_disks_on_termination = false

  provisioner "local-exec" {
    when    = "destroy"
    command = "knife node delete ${local.sonarqube_computer_name}-${azurerm_resource_group.rg.name} -y; knife client delete ${local.sonarqube_computer_name}-${azurerm_resource_group.rg.name} -y"
  }

  storage_image_reference {
    publisher = "${var.lin_image_publisher}"
    offer     = "${var.lin_image_offer}"
    sku       = "${var.lin_image_sku}"
    version   = "${var.lin_image_version}"
  }

  storage_os_disk {
    name          = "osdisk"
    vhd_uri       = "${azurerm_storage_account.sonarqube.primary_blob_endpoint}${azurerm_storage_container.sonarqube.name}/${local.sonarqube_computer_name}/osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "datadisk-0"
    vhd_uri       = "${azurerm_storage_account.sonarqube.primary_blob_endpoint}${azurerm_storage_container.sonarqube.name}/${local.sonarqube_computer_name}/datadisk-0.vhd"
    disk_size_gb  = "979"
    create_option = "Empty"
    lun           = 0
  }

  os_profile {
    computer_name  = "${local.sonarqube_computer_name}"
    admin_username = "${local.admin_user}"
    admin_password = "${local.admin_password}"
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.sonarqube.primary_blob_endpoint}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

module "sonarqube_backup_vm" {
  source                          = "git::https://bitbucket.org/module_backup_vm.git"

  recovery_vault_rg               = "${lookup(var.sonarqube_recovery_vault_rg,terraform.workspace)}"
  recovery_vault_name             = "${lookup(var.sonarqube_recovery_vault_name,terraform.workspace)}"
  virtual_machines_resource_group = "${azurerm_resource_group.rg.name}"
  virtual_machines_list           = "${azurerm_virtual_machine.sonarqube.name}"
  backup_policy                   = "DailyBackupPolicy"

  depends_on                      = [
    "${azurerm_virtual_machine.sonarqube.id}"
  ]
}

resource "azurerm_virtual_machine_extension" "sonarqube" {
  name                       = "ChefClient"
  virtual_machine_id       = "${azurerm_virtual_machine.sonarqube.id}"
  publisher                  = "Chef.Bootstrap.WindowsAzure"
  type                       = "LinuxChefClient"
  type_handler_version       = "1210.12"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
  {
    "client_rb": "ssl_verify_mode :verify_none",
    "bootstrap_options": {
      "chef_node_name": "${azurerm_virtual_machine.sonarqube.name}-${azurerm_resource_group.rg.name}",
      "chef_server_url": "${var.chef_server_url}",
      "environment": "${lookup(var.chef_environment,terraform.workspace)}",
      "validation_client_name": "${var.chef_user_name}"
    },
    "custom_json_attr": {
      "dvo_user": {
        "ALM_environment": "${lower(terraform.workspace)}",
        "ALM_service": "sonarqube",
        "use": "linux sonarqube postgresql",
        "java": {
          "install": "jre",
          "version": "8"
        },
        "saName": "${data.terraform_remote_state.static.saName}",
        "saKey": "${data.terraform_remote_state.static.saKey}",
        "shareName1": "${data.terraform_remote_state.static.share1}",
        "shareName2": "${data.terraform_remote_state.static.share2}"
      },
      "dvo": {
        "IdM": {
          "admin_groups": "AZG-DevOps-admins",
          "user_groups": "AZG-DevOps-users"
        },
        "cloud_service_provider": {
          "name": "azure"
        }
      }
    },
    "runlist": "${var.sonarqube_chef_runlist}"
  }
  SETTINGS

  protected_settings = <<SETTINGS
  {
    "validation_key": "${file("${path.module}/secrets/validation.pem")}",
    "secret": "${file("${path.module}/secrets/sonarqube_secret")}"
  }
  SETTINGS
}
