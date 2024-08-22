# Create the dedicated Resource Group for Azure Container Registry
resource "azurerm_resource_group" "rg_registry" {
  name     = var.resource_group_name
  location = var.location
}

# Create an Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg_registry.name
  location            = azurerm_resource_group.rg_registry.location
  sku                 = "Standard"
  admin_enabled       = false
}
