# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-${var.app_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = var.environment
  }
}

# Create Application Insights
resource "azurerm_application_insights" "appi" {
  name                = "appi-${var.app_name}-${var.environment}-${var.location}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log.id
  application_type    = "web"

  tags = {
    Environment = var.environment
  }
}
