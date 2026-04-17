
terraform {
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "ramyadevopstfstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "rg-devops-dev"
  location = var.location

  tags = {
    environment = "dev"
    project     = "azure-devsecops-platform"
    owner       = "ramya-tejaswini"
  }
}

module "networking" {
  source              = "../../modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = "dev"
}

module "acr" {
  source              = "../../modules/acr"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = "dev"
}

module "keyvault" {
  source              = "../../modules/keyvault"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = "dev"
}

module "monitoring" {
  source              = "../../modules/monitoring"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = "dev"
}

module "aks" {
  source              = "../../modules/aks"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = "dev"
  subnet_id           = module.networking.aks_subnet_id
  acr_id              = module.acr.acr_id
  log_analytics_id    = module.monitoring.log_analytics_id
}
