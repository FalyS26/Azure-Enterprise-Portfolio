resource "azurerm_virtual_network" "identity_test" {
  name                = "vnet-identity-test-dev-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev.name
  address_space       = ["10.40.0.0/16"]

  tags = {
    Environment = var.environment_dev
    Project     = "Enterprise Governance Identity"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet" "identity_test" {
  name                 = "snet-identity-test"
  resource_group_name  = azurerm_resource_group.dev.name
  virtual_network_name = azurerm_virtual_network.identity_test.name
  address_prefixes     = ["10.40.1.0/24"]
}

resource "azurerm_network_interface" "identity_test" {
  name                = "nic-identity-test-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.identity_test.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = var.environment_dev
    Project     = "Enterprise Governance Identity"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_linux_virtual_machine" "identity_test" {
  name                = "vm-identity-test-001"
  resource_group_name = azurerm_resource_group.dev.name
  location            = var.location
  size                = "Standard_D2as_v7"

  admin_username                  = "azureadmin"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.identity_test.id
  ]

  admin_ssh_key {
    username   = "azureadmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  identity {
    type = "UserAssigned"

    identity_ids = [
      azurerm_user_assigned_identity.app_identity.id
    ]
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = {
    Environment = var.environment_dev
    Project     = "Enterprise Governance Identity"
    ManagedBy   = "Terraform"
  }
}