resource "azurerm_resource_group" "main" {
  name     = "rg-azure-portfolio-dev-eastus-001"
  location = "East US"

  tags = {
    Environment = "Dev"
    Project     = "Azure Enterprise Portfolio"
    Owner       = "Faly Sanchez"
  }
}
resource "azurerm_virtual_network" "main" {
  name                = "vnet-azure-portfolio-dev-eastus-001"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = "Dev"
    Project     = "Azure Enterprise Portfolio"
    Owner       = "Faly Sanchez"
  }
}
resource "azurerm_subnet" "management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet" "web" {
  name                 = "snet-web"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_subnet" "application" {
  name                 = "snet-application"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]
}
resource "azurerm_network_security_group" "management" {
  name                = "nsg-management"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name                       = "Allow-VNet-Management"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Dev"
    Project     = "Azure Enterprise Portfolio"
    Owner       = "Faly Sanchez"
  }
}
resource "azurerm_network_security_group" "web" {
  name                = "nsg-web"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_security_group" "application" {
  name                = "nsg-application"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name                       = "Allow-Web-To-App"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "10.0.2.0/24"
    destination_address_prefix = "10.0.3.0/24"
  }
}
resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_subnet_network_security_group_association" "application" {
  subnet_id                 = azurerm_subnet.application.id
  network_security_group_id = azurerm_network_security_group.application.id
}
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.4.0/26"]
}
resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion-azure-portfolio-dev-eastus-001"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Dev"
    Project     = "Azure Enterprise Portfolio"
    Owner       = "Faly Sanchez"
  }
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-azure-portfolio-dev-eastus-001"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = {
    Environment = "Dev"
    Project     = "Azure Enterprise Portfolio"
    Owner       = "Faly Sanchez"
  }
}