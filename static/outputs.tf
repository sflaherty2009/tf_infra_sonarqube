output "saName" {
  value = "${azurerm_storage_account.static.name}"
}

output "saKey" {
  value = "${azurerm_storage_account.static.primary_access_key}"
}

output "share1" {
  value = "${azurerm_storage_share.static_data.name}"
}

output "share2" {
  value = "${azurerm_storage_share.static_archive.name}"
}

output "backendAddressPoolId" {
  value = "${azurerm_lb_backend_address_pool.static.id}"
}
