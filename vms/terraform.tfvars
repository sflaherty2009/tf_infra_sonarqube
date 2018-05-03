tenant_id = "9dcd6c72-99eb-423d-b4d9-794d81eef415"

client_id = "d9a96123-f00d-45ff-be1c-5591347003b1"

client_secret = "4U89CIH/FpXV2b1vcQJTBvJI5myZOaKd7w3oA6tR20k="

location = "East US 2"

resource_group_name = "AZ-RG-SonarQube"

admin_user = "local_admin"

admin_password = "R0llW1th!t"

chef_server_url = "https://10.16.192.4/organizations/trek"

chef_environment = {
  "default" = "staging"
  "ss"      = "staging"
  "prod"    = "production"
}

chef_user_name = "trek-validator"

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
