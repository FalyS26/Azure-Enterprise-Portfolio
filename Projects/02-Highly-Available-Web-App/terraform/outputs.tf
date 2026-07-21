output "application_gateway_public_ip" {
  description = "Public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw.ip_address
}

output "application_gateway_url" {
  description = "Public HTTP URL for the web application"
  value       = "http://${azurerm_public_ip.appgw.ip_address}"
}