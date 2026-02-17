targetScope = 'subscription'

@description('Base Name')
param baseName string

@description('Region')
param location string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${baseName}-rg'
  location: location
}

module insightsModule './modules/insights.bicep' = {
  name: 'appInsightsModule'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    baseName: baseName
  }
}

module resourceModule './modules/appservices.bicep' = {
  name: 'appServiceModule'
  scope: resourceGroup(rg.name)
  params: {
    location: location
    baseName: baseName
    appInsightsInstrumentationKey: insightsModule.outputs.insightsInstrumentationKey
  }
}
