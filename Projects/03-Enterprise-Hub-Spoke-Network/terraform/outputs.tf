output "firewall_private_ip" {
  value = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}

output "app_test_vm_private_ip" {
  value = azurerm_network_interface.app_test.private_ip_address
}

output "internal_test_vm_private_ip" {
  value = azurerm_network_interface.internal_test.private_ip_address
}