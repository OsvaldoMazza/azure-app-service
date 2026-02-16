param location string = resourceGroup().location
param appServiceName string = 'fastapi-app-service'
param sku string = 'B1'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: '${appServiceName}-plan'
  location: location
  sku: {
    name: sku
    tier: 'Basic'
  }
  properties: {}
}

resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.9'
    }
  }
}

output appServiceUrl string = appService.properties.defaultHostName