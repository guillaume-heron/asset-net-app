# Create the dedicated Resource Group for Azure Container Registry
resource "azurerm_resource_group" "rg" {
  name     = "rg-registry-shared-${var.location_short}"
  location = var.location
}

# Create an Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "acrhubshared${var.location_short}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}
