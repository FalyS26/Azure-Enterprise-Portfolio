resource "azurerm_role_assignment" "dev_contributor" {
  scope                = azurerm_resource_group.dev.id
  role_definition_name = "Contributor"
  principal_id         = var.developer_principal_id
}