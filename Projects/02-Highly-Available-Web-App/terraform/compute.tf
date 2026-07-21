resource "azurerm_availability_set" "web" {
  name                = "availset-web-001"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  managed = true

  platform_fault_domain_count  = 2
  platform_update_domain_count = 5

  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Tier        = "Web"
  }
}
resource "azurerm_network_interface" "web01" {
  name                = "nic-web-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig-web-01"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Tier        = "Web"
  }
}

resource "azurerm_network_interface" "web02" {
  name                = "nic-web-02"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig-web-02"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Tier        = "Web"
  }
}
resource "azurerm_windows_virtual_machine" "web01" {
  name                = "vm-web-01"
  computer_name       = "WEB01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.web_vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.web01.id
  ]

  availability_set_id = azurerm_availability_set.web.id

  provision_vm_agent       = true
  enable_automatic_updates = true

  os_disk {
    name                 = "osdisk-vm-web-01"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Tier        = "Web"
    Server      = "Web01"
  }
}
resource "azurerm_windows_virtual_machine" "web02" {
  name                = "vm-web-02"
  computer_name       = "WEB02"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = var.web_vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.web02.id
  ]

  availability_set_id = azurerm_availability_set.web.id

  provision_vm_agent       = true
  enable_automatic_updates = true

  os_disk {
    name                 = "osdisk-vm-web-02"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Tier        = "Web"
    Server      = "Web02"
  }
}
resource "azurerm_virtual_machine_extension" "iis_web01" {
  name                 = "install-iis-web01"
  virtual_machine_id   = azurerm_windows_virtual_machine.web01.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = "powershell.exe -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name Web-Server -IncludeManagementTools; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '<html><body><h1>Project 2 - Web Server 01</h1><p>Served from VM-WEB-01</p></body></html>'; exit 0\""
  })

  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Tier        = "Web"
    Server      = "Web01"
  }
}

resource "azurerm_virtual_machine_extension" "iis_web02" {
  name                 = "install-iis-web02"
  virtual_machine_id   = azurerm_windows_virtual_machine.web02.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    commandToExecute = "powershell.exe -ExecutionPolicy Unrestricted -Command \"Install-WindowsFeature -Name Web-Server -IncludeManagementTools; Set-Content -Path 'C:\\inetpub\\wwwroot\\index.html' -Value '<html><body><h1>Project 2 - Web Server 02</h1><p>Served from VM-WEB-02</p></body></html>'; exit 0\""
  })

  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Tier        = "Web"
    Server      = "Web02"
  }
}