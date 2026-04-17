
resource "azurerm_container_registry" "main" {
  name                = "acrdevops${var.environment}001"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = { environment = var.environment }
}
