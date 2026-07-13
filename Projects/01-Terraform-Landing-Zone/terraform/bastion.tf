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
    Project     = var.project_name
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
    Project     = var.project_name
    Owner       = "Faly Sanchez"
  }
}