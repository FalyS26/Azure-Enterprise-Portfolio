resource "azurerm_network_security_group" "management" {
  name                = "nsg-management-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub.name

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Tier        = "Management"
  }
}

resource "azurerm_network_security_group" "web" {
  name                = "nsg-web-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Tier        = "Web"
  }
}

resource "azurerm_network_security_group" "application" {
  name                = "nsg-application-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Tier        = "Application"
  }
}

resource "azurerm_network_security_group" "internal" {
  name                = "nsg-internal-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.internal.name

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Tier        = "Internal"
  }
}
resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.hub_management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.app_web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_subnet_network_security_group_association" "application" {
  subnet_id                 = azurerm_subnet.app_application.id
  network_security_group_id = azurerm_network_security_group.application.id
}

resource "azurerm_subnet_network_security_group_association" "internal" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.internal.id
}
resource "azurerm_network_security_rule" "internal_allow_http_from_app" {
  name                        = "Allow-App-To-Internal-HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "10.20.0.0/16"
  destination_address_prefix  = "10.30.0.0/16"
  resource_group_name         = azurerm_resource_group.internal.name
  network_security_group_name = azurerm_network_security_group.internal.name
}