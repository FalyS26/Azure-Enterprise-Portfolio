resource "azurerm_virtual_network" "hub" {
  name                = var.hub_vnet_name
  address_space       = var.hub_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Role        = "Hub"
  }
}

resource "azurerm_subnet" "hub_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.10.1.0/26"]
}

resource "azurerm_subnet" "hub_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.10.2.0/26"]
}

resource "azurerm_subnet" "hub_management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.10.3.0/24"]
}

resource "azurerm_virtual_network" "app" {
  name                = var.app_vnet_name
  address_space       = var.app_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Role        = "Application Spoke"
  }
}

resource "azurerm_subnet" "app_web" {
  name                 = "snet-web"
  resource_group_name  = azurerm_resource_group.app.name
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_subnet" "app_application" {
  name                 = "snet-application"
  resource_group_name  = azurerm_resource_group.app.name
  virtual_network_name = azurerm_virtual_network.app.name
  address_prefixes     = ["10.20.2.0/24"]
}

resource "azurerm_virtual_network" "internal" {
  name                = var.internal_vnet_name
  address_space       = var.internal_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.internal.name

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Role        = "Internal Spoke"
  }
}

resource "azurerm_subnet" "internal" {
  name                 = "snet-internal"
  resource_group_name  = azurerm_resource_group.internal.name
  virtual_network_name = azurerm_virtual_network.internal.name
  address_prefixes     = ["10.30.1.0/24"]
}