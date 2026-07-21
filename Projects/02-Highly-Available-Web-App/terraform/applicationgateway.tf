locals {
  appgw_backend_pool_name      = "appgw-backend-pool"
  appgw_frontend_port_name     = "appgw-frontend-port"
  appgw_frontend_ip_name       = "appgw-frontend-ip"
  appgw_http_setting_name      = "appgw-http-settings"
  appgw_listener_name          = "appgw-http-listener"
  appgw_routing_rule_name      = "appgw-routing-rule"
  appgw_gateway_ip_config_name = "appgw-ip-configuration"
  appgw_probe_name             = "appgw-health-probe"
}
resource "azurerm_web_application_firewall_policy" "appgw" {
  name                = "wafpolicy-webapp-prod-eastus-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Component   = "Web Application Firewall"
  }
}

resource "azurerm_public_ip" "appgw" {
  name                = "pip-appgw-prod-eastus-001"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Component   = "Application Gateway"
  }
}
resource "azurerm_application_gateway" "main" {
  name                = "appgw-webapp-prod-eastus-001"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  firewall_policy_id = azurerm_web_application_firewall_policy.appgw.id

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = local.appgw_gateway_ip_config_name
    subnet_id = azurerm_subnet.appgateway.id
  }

  frontend_ip_configuration {
    name                 = local.appgw_frontend_ip_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  frontend_port {
    name = local.appgw_frontend_port_name
    port = 80
  }

  backend_address_pool {
    name = local.appgw_backend_pool_name

    ip_addresses = [
      azurerm_network_interface.web01.private_ip_address,
      azurerm_network_interface.web02.private_ip_address
    ]
  }

  probe {
    name                                      = local.appgw_probe_name
    protocol                                  = "Http"
    host                                      = "127.0.0.1"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = false

    match {
      status_code = ["200-399"]
    }
  }

  backend_http_settings {
    name                  = local.appgw_http_setting_name
    cookie_based_affinity = "Disabled"
    protocol              = "Http"
    port                  = 80
    request_timeout       = 30
    probe_name            = local.appgw_probe_name
  }

  http_listener {
    name                           = local.appgw_listener_name
    frontend_ip_configuration_name = local.appgw_frontend_ip_name
    frontend_port_name             = local.appgw_frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.appgw_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.appgw_listener_name
    backend_address_pool_name  = local.appgw_backend_pool_name
    backend_http_settings_name = local.appgw_http_setting_name
    priority                   = 100
  }


  tags = {
    Environment = var.environment
    Project     = "Highly Available Web App"
    Component   = "Application Gateway"
  }

  depends_on = [
    azurerm_virtual_machine_extension.iis_web01,
    azurerm_virtual_machine_extension.iis_web02
  ]
}