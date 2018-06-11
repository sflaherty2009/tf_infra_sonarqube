# dvo_infra_sonarqube

Creates SonarQube infrastructure.

Uses workspaces: ss|prod

## HOW-TO

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
