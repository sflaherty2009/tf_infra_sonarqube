terraform {
  backend "azurerm" {
    storage_account_name = "terraformlock"
    container_name       = "environments"
    resource_group_name  = "dvo_terraform"
    key                  = "sonarqube/static/terraform.tfstate"
    access_key           = "tPLgDxuAjzeFu32JO5DwD6eh53+TrKyQ+fgohBmvFlH12WzU9PaDM64oNAtQYxk5Pd/m78J0yhPgOC5cja+tVA=="
  }
}

provider "azurerm" {
  subscription_id = "${lookup(var.subscription_ids,terraform.workspace)}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

variable "subscription_ids" {
  type        = "map"
  description = "Map of Subscription IDs for provisioning resources in Azure. Map each workspace to a subscription ID."
}

variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription to know your Tenant ID"
}

variable "location" {
  description = "The default Azure region for the resource provisioning"
}

variable "resource_group_name" {
  description = "Resource group name that will contain various resources. A hyphen and the workspace name will be appended."
}

variable "vnets" {
  type        = "map"
  description = "Map of virtual networks. Map each workspace to a vnet."
}

variable "private_ips" {
  type        = "map"
  description = "Map of private IP addresses to be used for the static load balancer. Map each workspace to an IP address."
}
