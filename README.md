# README for SonarQube Terraform Configuration

## Overview
This Terraform configuration is designed for setting up a SonarQube environment in Azure. It manages the necessary resources for a robust and secure SonarQube deployment.

## Configuration Files

### `main.tf`
- Main configuration file for core resources.
- Includes resource group, Azure management lock, and load balancer.

### `outputs.tf`
- Defines outputs from the Terraform deployment.
- Includes storage account details and backend pool IDs.

### `terraform.tfvars`
- Sets default values for Terraform variables.
- Includes subscription IDs, private IPs, and virtual network settings.

### `variables.tf`
- Defines variables used across the Terraform setup.
- Includes Azure region and storage configurations.

### `resource_group.tf`
- Manages the Azure resource group and management lock for SonarQube.

### `sonarqube.tf`
- Configures network interfaces specific to SonarQube.

### `storage_account.tf`
- Sets up storage accounts and containers for SonarQube in Azure.

## Folders 
### `static`
- This Terraform module provisions the SonarQube static resources such as the load balancer and shared storage account.

### `vms`
- This Terraform module provisions the SonarQube virtual machines.

## Prerequisites
- Azure account with required permissions.
- Terraform installed and configured on your system.

## Usage
1. **Initialization**: Begin by initializing Terraform with `terraform init`.
2. **Configuration**: Update `variables.tf` and `terraform.tfvars` as per your requirements.
3. **Execution**: Deploy the infrastructure using `terraform apply`.

## Security and Maintenance
- Ensure secure management of Azure credentials and Terraform state files.
- Regularly update the Terraform scripts to align with Azure updates and SonarQube requirements.

For detailed configuration and customization, refer to the contents within each Terraform file.

## HOW-TO

* Azure credentials have been removed from the configuration files. Going forward you must log into the Azure CLI and/or add certain credentials to environment variables for Terraform to be able to access them.
* All secrets are now placed under the 'secrets' folder and are excluded from git. 
* The following files need to be added to the vms/secrets directory:
  * admin_credentials (username on first line, password on second.)
  * sonarqube_secret
  * validation.pem (Chef validation.pem)
* To see a list of current environments & the one you're currently working in:
  * `terraform workspace list`
* Select the environment to work from (environment_name reflects the list above)
  * `terraform workspace select environment_name`
* Make necessary changes to variables.tf
* Get or update remote modules if necessary
  * `terraform get --update`
* Run a plan and double check your changes
  * `terraform plan -var-file terraform.tfvars -out=tfplan`
* Apply your changes
  * `terraform apply tfplan`
