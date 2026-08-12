resource "azurerm_policy_definition" "allowed_locations" {
  name         = "policy-allowed-locations-eastus"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allow resources only in East US"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "location"
          exists = "true"
        },
        {
          field     = "location"
          notEquals = "eastus"
        }
      ]
    }

    then = {
      effect = "deny"
    }
  })
}
resource "azurerm_resource_group_policy_assignment" "dev_allowed_locations" {
  name                 = "assign-dev-eastus-only"
  resource_group_id    = azurerm_resource_group.dev.id
  policy_definition_id = azurerm_policy_definition.allowed_locations.id
  display_name         = "Development resources must remain in East US"
}
resource "azurerm_policy_definition" "require_environment_tag" {
  name         = "policy-require-environment-tag"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require Environment tag"

  policy_rule = jsonencode({
    if = {
      field  = "tags['Environment']"
      exists = "false"
    }

    then = {
      effect = "deny"
    }
  })
}
resource "azurerm_resource_group_policy_assignment" "dev_require_environment_tag" {
  name                 = "assign-dev-require-environment-tag"
  resource_group_id    = azurerm_resource_group.dev.id
  policy_definition_id = azurerm_policy_definition.require_environment_tag.id
  display_name         = "Development resources require Environment tag"
}