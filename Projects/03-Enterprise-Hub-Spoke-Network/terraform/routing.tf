resource "azurerm_route_table" "app" {
  name                = "rt-app-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Component   = "App Routing"
  }
}
resource "azurerm_route" "app_to_internal" {
  name                = "route-to-internal-via-firewall"
  resource_group_name = azurerm_resource_group.app.name
  route_table_name    = azurerm_route_table.app.name

  address_prefix         = "10.30.0.0/16"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}
resource "azurerm_route_table" "internal" {
  name                = "rt-internal-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.internal.name

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Component   = "Internal Routing"
  }
}
resource "azurerm_route" "internal_to_app" {
  name                = "route-to-app-via-firewall"
  resource_group_name = azurerm_resource_group.internal.name
  route_table_name    = azurerm_route_table.internal.name

  address_prefix         = "10.20.0.0/16"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}
resource "azurerm_subnet_route_table_association" "app_web" {
  subnet_id      = azurerm_subnet.app_web.id
  route_table_id = azurerm_route_table.app.id
}

resource "azurerm_subnet_route_table_association" "app_application" {
  subnet_id      = azurerm_subnet.app_application.id
  route_table_id = azurerm_route_table.app.id
}
resource "azurerm_subnet_route_table_association" "internal" {
  subnet_id      = azurerm_subnet.internal.id
  route_table_id = azurerm_route_table.internal.id
}