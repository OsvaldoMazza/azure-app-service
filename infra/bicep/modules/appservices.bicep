@description('Base name for the resources')
param baseName string

@description('Location for the resources')
param location string = resourceGroup().location

@description('Insights instrumentation key to link with the App Service')
param appInsightsInstrumentationKey string

@description('App Service plan SKU (F1 for Free, B1 Basic, S1 Standard, etc.)')
param planSkuName string = 'B1'

// Derive tier from SKU if not explicitly mapped (simple heuristic)
var planTier = planSkuName == 'F1' ? 'Free' : planSkuName == 'B1' ? 'Basic' : planSkuName == 'S1' ? 'Standard' : planSkuName

// App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: '${baseName}-app-plan'
  location: location
  kind: 'linux'
  sku: {
    name: planSkuName
    tier: planTier
  }
  properties: {
    // For Linux plans (even Free) we need reserved=true
    reserved: true
  }
}

// App Service
resource appService 'Microsoft.Web/sites@2023-01-01' = {
  name: '${baseName}-app'
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.12'
      appCommandLine: 'gunicorn --worker-class uvicorn.workers.UvicornWorker --timeout 600 --access-logfile "-" --error-logfile "-" main:app'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsightsInstrumentationKey
        }
        {
          name: 'SCM_DO_BUILD_DURING_DEPLOYMENT'
          value: 'true' // Install dependencies during deployment
        }
        {
          name: 'PORT'
          value: '8000' // Or the port you prefer
        }
      ]
    }
  }
}

output appServiceName string = appService.name
output appServiceUrl string = appService.properties.defaultHostName
