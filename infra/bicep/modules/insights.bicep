@description('Base name for the resources')
param baseName string

@description('Location for the resources')
param location string = resourceGroup().location

resource insights 'Microsoft.Insights/components@2020-02-02' = {
  name: '${baseName}-app-insights'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output insightsName string = insights.name
output insightsInstrumentationKey string = insights.properties.InstrumentationKey
