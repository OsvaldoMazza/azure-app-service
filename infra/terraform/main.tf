terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.base_name}-rg"
  location = var.location
}

# Application Insights
resource "azurerm_application_insights" "insights" {
  name                = "${var.base_name}-app-insights"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"
}

# Determine SKU tier based on SKU name (same logic as Bicep)
locals {
  plan_tier = (
    var.plan_sku_name == "F1" ? "Free" :
    var.plan_sku_name == "B1" ? "Basic" :
    var.plan_sku_name == "S1" ? "Standard" :
    var.plan_sku_name
  )
}

# App Service Plan (Linux)
resource "azurerm_service_plan" "app_plan" {
  name                = "${var.base_name}-app-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = var.plan_sku_name
}

# App Service
resource "azurerm_linux_web_app" "app_service" {
  name                = "${var.base_name}-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    app_command_line = "gunicorn --worker-class uvicorn.workers.UvicornWorker --timeout 600 --access-logfile \"-\" --error-logfile \"-\" main:app"
  }

  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
  }

  # Path to the ZIP file containing the application code
  zip_deploy_file = "${path.module}/src.zip"
}