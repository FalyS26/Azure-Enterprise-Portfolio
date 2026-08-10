resource "azurerm_firewall_policy_rule_collection_group" "hub" {
  name               = "rcg-hub-prod-eastus-001"
  firewall_policy_id = azurerm_firewall_policy.hub.id
  priority           = 100

  network_rule_collection {
    name     = "net-allow-app-to-internal"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-app-to-internal-https"
      protocols             = ["TCP"]
      source_addresses      = ["10.20.0.0/16"]
      destination_addresses = ["10.30.0.0/16"]
      destination_ports     = ["80", "443"]
    }
  }
}