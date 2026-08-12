resource "azurerm_user_assigned_identity" "app_identity" {
  name                = "id-governance-app-prod-eastus-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.prod.name

  tags = {
    Environment = var.environment_prod
    Project     = "Enterprise Governance Identity"
    ManagedBy   = "Terraform"
  }
}