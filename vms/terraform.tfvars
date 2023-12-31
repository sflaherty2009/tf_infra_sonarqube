location = "East US 2"

resource_group_name = "AZ-RG-SonarQube"

chef_server_url = "https://10.16.192.4/organizations/org"

chef_environment = {
  "default" = "staging"
  "ss"      = "staging"
  "prod"    = "production"
}

chef_user_name = "validator"

lin_image_publisher = "OpenLogic"

lin_image_offer = "CentOS"

lin_image_sku = "7.4"

lin_image_version = "7.4.20180118"

subscription_ids = {
  "default" = "9db13c96-62ad-4945-9579-74aeed296e48"
  "ss"      = "9db13c96-62ad-4945-9579-74aeed296e48"
  "prod"    = "9fbf7025-df40-4908-b7fb-a3a2144cee91"
}

vnets = {
  "default" = "AZ-VN-EastUS2-01"
  "ss"      = "AZ-VN-EastUS2-01"
  "prod"    = "AZ-VN-EastUS2-02"
}

sonarqube_chef_runlist = "cb_dvo_resolveDNS, cb_dvo_chefClient, cb_dvo_selinux, cb_dvo_addStorage, cb_dvo_adJoin, cb_dvo_sshd, cb_dvo_authorization, cb_dvo_prtg, cb_tbc_dockerHost, cb_dvo_localAccounts, cb_dvo_java, cb_dvo_logging, cb_dvo_sonarqube"

sonarqube_computer_names = {
  "default" = "azl-ss-sqb-01"
  "ss"      = "azl-ss-sqb-01"
  "prod"    = "azl-prd-sqb-01"
}

sonarqube_vm_sizes = {
  "default" = "Standard_DS1_v2"
  "ss"      = "Standard_DS2_v2"
  "prod"    = "Standard_DS2_v2"
}

sonarqube_private_ips = {
  "default" = "10.15.128.70"
  "ss"      = "10.15.128.70"
  "prod"    = "10.16.128.70"
}

sonarqube_recovery_vault_rg = {
  "default" = "AZ-RG-RV-Dev"
  "ss"      = "AZ-RG-RV-Dev"
  "prod"    = "AZ-RG-RV-Prd"
}

sonarqube_recovery_vault_name = {
  "default" = "AZ-RV-Dev"
  "ss"      = "AZ-RV-Dev"
  "prod"    = "AZ-RV-Prd"
}
