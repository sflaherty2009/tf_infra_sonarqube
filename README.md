# dvo_infra_sonarqube

Creates SonarQube infrastructure.

Uses workspaces: ss|prod

## HOW-TO

* Azure credentials have been removed from the configuration files. Going forward you must log into the Azure CLI and/or add certain credentials to environment variables for Terraform to be able to access them.
* All secrets are now placed under the 'secrets' folder and are excluded from git. When you clone this repo you'll need to pull them out of LastPass or get them from another DevOps team member.
* For more details on secrets and credentials in Terraform, see this Confluence page: <https://trekbikes.atlassian.net/wiki/spaces/DVO/pages/446922822/Terraform+-+Authentication+and+Secrets>
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
