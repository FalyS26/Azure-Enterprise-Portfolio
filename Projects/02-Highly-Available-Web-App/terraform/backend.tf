terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-eastus-001"
    storage_account_name = "sttfstatefaly001"
    container_name       = "tfstate"
    key                  = "project-02-web-app.tfstate"
    use_azuread_auth     = true
  }
}
