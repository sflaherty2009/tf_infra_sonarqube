terraform {
  backend "azurerm" {
    storage_account_name = "terraformlock"
    container_name       = "environments"
    resource_group_name  = "dvo_terraform"
    key                  = "sonarqube/static/terraform.tfstate"
  }
}

terraform {
  required_providers {
      azurerm = {
        subscription_id = "${lookup(var.subscription_id,terraform.workspace)}"
      }
  }
}

variable "subscription_ids" {
  type        = "map"
  description = "Map of Subscription IDs for provisioning resources in Azure. Map each workspace to a subscription ID."
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
