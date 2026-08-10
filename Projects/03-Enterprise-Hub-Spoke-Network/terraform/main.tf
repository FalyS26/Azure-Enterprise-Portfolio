resource "azurerm_resource_group" "hub" {
  name     = var.hub_resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Role        = "Hub"
  }
}

resource "azurerm_resource_group" "app" {
  name     = var.app_resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Role        = "Application Spoke"
  }
}

resource "azurerm_resource_group" "internal" {
  name     = var.internal_resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "Enterprise Hub-Spoke Network"
    Role        = "Internal Spoke"
  }
}