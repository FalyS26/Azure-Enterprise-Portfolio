data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "prod" {
  name                = "kv-gov-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.prod.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  rbac_authorization_enabled = true

  tags = {
    Environment = var.environment_prod
    Project     = "Enterprise Governance Identity"
    ManagedBy   = "Terraform"
  }
}
resource "azurerm_role_assignment" "identity_secret_reader" {
  scope                = azurerm_key_vault.prod.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.app_identity.principal_id
}