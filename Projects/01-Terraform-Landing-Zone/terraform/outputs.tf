output "resource_group_name" {
  description = "Name of the deployed Resource Group"
  value       = azurerm_resource_group.main.name
}
output "vnet_name" {
  description = "Name of the deployed Virtual Network"
  value       = azurerm_virtual_network.main.name
}
output "windows_vm_name" {
  description = "Name of the deployed Windows VM"
  value       = azurerm_windows_virtual_machine.main.name
}

output "linux_vm_name" {
  description = "Name of the deployed Linux VM"
  value       = azurerm_linux_virtual_machine.main.name
}

output "bastion_host_name" {
  description = "Name of the deployed Bastion host"
  value       = azurerm_bastion_host.main.name
}
output "windows_private_ip" {
  description = "Private IP of the Windows VM"
  value       = azurerm_network_interface.windows.private_ip_address
}

output "linux_private_ip" {
  description = "Private IP of the Linux VM"
  value       = azurerm_network_interface.linux.private_ip_address
}