resource "azurerm_management_lock" "prod_cannot_delete" {
  name       = "lock-prod-cannot-delete"
  scope      = azurerm_resource_group.prod.id
  lock_level = "CanNotDelete"
  notes      = "Protects production resources from accidental deletion."
}