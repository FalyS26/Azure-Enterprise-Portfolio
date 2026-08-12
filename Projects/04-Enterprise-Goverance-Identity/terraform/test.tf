resource "azurerm_storage_account" "policy_test_allowed" {
  name                     = "stgovtestallowed001"
  resource_group_name      = azurerm_resource_group.dev.name
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment_dev
  }
}