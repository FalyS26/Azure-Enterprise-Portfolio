resource "azurerm_network_interface" "app_test" {
  name                = "nic-vm-app-test-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.app.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app_application.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "internal_test" {
  name                = "nic-vm-internal-test-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.internal.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "app_test" {
  name                = "vm-app-test-001"
  resource_group_name = azurerm_resource_group.app.name
  location            = var.location
  size                = "Standard_D2as_v7"

  admin_username                  = "azureadmin"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.app_test.id
  ]

  admin_ssh_key {
    username   = "azureadmin"
    public_key = file("~/.ssh/id_rsa.pub")
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
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Role        = "App Test VM"
  }
}

resource "azurerm_linux_virtual_machine" "internal_test" {
  name                = "vm-internal-test-001"
  resource_group_name = azurerm_resource_group.internal.name
  location            = var.location
  size                = "Standard_D2as_v7"

  admin_username                  = "azureadmin"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.internal_test.id
  ]

  admin_ssh_key {
    username   = "azureadmin"
    public_key = file("~/.ssh/id_rsa.pub")
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

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
    echo "Project 3 - Internal Spoke reached through Azure Firewall" > /var/www/html/index.html
    systemctl enable nginx
    systemctl restart nginx
  EOF
  )

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Role        = "Internal Test VM"
  }
}