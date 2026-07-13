terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-eastus-001"
    storage_account_name = "sttfstatefaly001"
    container_name       = "tfstate"
    key                  = "landing-zone.tfstate"
    use_azuread_auth     = true
  }
}