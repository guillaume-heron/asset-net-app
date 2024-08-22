# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Create Application Insights
resource "azurerm_application_insights" "appi" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log.id
  application_type    = "web"

  tags = var.tags
}
