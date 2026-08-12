resource "azurerm_resource_group" "prod" {
  name     = var.prod_resource_group_name
  location = var.location

  tags = {
    Environment = var.environment_prod
    Project     = "Enterprise Governance Identity"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "dev" {
  name     = var.dev_resource_group_name
  location = var.location

  tags = {
    Environment = var.environment_dev
    Project     = "Enterprise Governance Identity"
    ManagedBy   = "Terraform"
  }
}