terraform {
  backend "azurerm" {
    storage_account_name = "terraformlock"
    container_name       = "environments"
    resource_group_name  = "dvo_terraform"
    key                  = "sonarqube/vms/terraform.tfstate"
  }
}

data "terraform_remote_state" "static" {
  backend   = "azurerm"
  workspace = "${terraform.workspace}"

  config {
    storage_account_name = "terraformlock"
    container_name       = "environments"
    resource_group_name  = "dvo_terraform"
    key                  = "sonarqube/static/terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "${lookup(var.subscription_ids,terraform.workspace)}"
}

locals {
  vm_subnet_id = "/subscriptions/${lookup(var.subscription_ids,terraform.workspace)}/resourceGroups/AZ-RG-Network/providers/Microsoft.Network/virtualNetworks/${lookup(var.vnets,terraform.workspace)}/subnets/AZ-SN-back"

  sonarqube_computer_name   = "${lookup(var.sonarqube_computer_names,terraform.workspace)}"
  sonarqube_vm_size         = "${lookup(var.sonarqube_vm_sizes,terraform.workspace)}"
  sonarqube_private_ip    = "${lookup(var.sonarqube_private_ips,terraform.workspace)}"

  admin_credentials = "${split("\n",file("${path.module}/secrets/admin_credentials"))}"
  admin_user = "${local.admin_credentials[0]}"
  admin_password = "${local.admin_credentials[1]}"
}

variable "subscription_ids" {
  type        = "map"
  description = "Map of Subscription IDs for provisioning resources in Azure. Map a subscription ID to each workspace."
}

variable "vnets" {
  type        = "map"
  description = "Map of virtual networks to use. Map a vnet to each workspace."
}

variable "location" {
  description = "The default Azure region for the resource provisioning."
}

variable "resource_group_name" {
  description = "Resource group name that will contain various resources."
}

variable "chef_server_url" {
  description = "Enter full chef url using private ip."
}

variable "chef_environment" {
  type        = "map"
  description = "Enter desired environment to be setup on chef server."
}

variable "chef_user_name" {
  description = "Enter username to be utilized with validation key."
}

variable "lin_image_publisher" {
  description = "Publisher name of the linux machine image."
}

variable "lin_image_offer" {
  description = "Offer name of the linux machine image."
}

variable "lin_image_sku" {
  description = "SKU of the linux machine image."
}

variable "lin_image_version" {
  description = "Image version desired for linux machines."
}

variable "sonarqube_computer_names" {
  type        = "map"
  description = "Map of desired names for the SonarQube node. Map a name to each workspace."
}

variable "sonarqube_vm_sizes" {
  type        = "map"
  description = "Map of desired sizes for the SonarQube node. Map a size to each workspace."
}

variable "sonarqube_chef_runlist" {
  description = "An ordered runlist to be sent to the chef server on provision for the SonarQube node."
}

variable "sonarqube_private_ips" {
  type        = "map"
  description = "Map of full static private IP addresses to use. Map an IP to each workspace."
}

variable "sonarqube_recovery_vault_rg" {
  type        = "map"
  description = "Map of resource groups. Map appropriate recovery vault RG to each environment."
}

variable "sonarqube_recovery_vault_name" {
  type        = "map"
  description = "Map of resource groups names. Map appropriate recovery vault name to each environment."
}
