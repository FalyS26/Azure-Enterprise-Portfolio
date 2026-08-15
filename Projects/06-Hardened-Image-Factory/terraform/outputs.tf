output "resource_group_name" {
  value = azurerm_resource_group.image_factory.name
}

output "gallery_name" {
  value = azurerm_shared_image_gallery.gallery.name
}

output "image_definition_name" {
  value = azurerm_shared_image.ubuntu_hardened.name
}