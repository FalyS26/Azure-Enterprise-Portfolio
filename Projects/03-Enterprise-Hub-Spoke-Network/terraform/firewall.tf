resource "azurerm_public_ip" "firewall" {
  name                = "pip-azfw-hub-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Component   = "Azure Firewall"
  }
}
resource "azurerm_firewall_policy" "hub" {
  name                = "fwpolicy-hub-prod-eastus-001"
  resource_group_name = azurerm_resource_group.hub.name
  location            = var.location
  sku                 = "Standard"

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Component   = "Firewall Policy"
  }
}
resource "azurerm_firewall" "hub" {
  name                = "azfw-hub-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  firewall_policy_id = azurerm_firewall_policy.hub.id

  ip_configuration {
    name                 = "azfw-ipconfig"
    subnet_id            = azurerm_subnet.hub_firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Component   = "Azure Firewall"
  }
}