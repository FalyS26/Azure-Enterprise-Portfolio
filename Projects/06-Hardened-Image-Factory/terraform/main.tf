resource "azurerm_resource_group" "image_factory" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "Production"
    Project     = "Hardened Image Factory"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_shared_image_gallery" "gallery" {
  name                = var.gallery_name
  resource_group_name = azurerm_resource_group.image_factory.name
  location            = azurerm_resource_group.image_factory.location

  tags = {
    Environment = "Production"
    Project     = "Hardened Image Factory"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_shared_image" "ubuntu_hardened" {
  name                = var.image_definition_name
  gallery_name        = azurerm_shared_image_gallery.gallery.name
  resource_group_name = azurerm_resource_group.image_factory.name
  location            = azurerm_resource_group.image_factory.location
  os_type             = "Linux"

  hyper_v_generation = "V2"

  identifier {
    publisher = "FalyEnterprise"
    offer     = "UbuntuHardened"
    sku       = "22_04"
  }
}