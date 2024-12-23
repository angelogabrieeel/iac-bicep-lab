param location string = resourceGroup().location
param logAnalyticsWorkspaceId string
param name string
param tags object

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
    name: name
    location: location
    tags: tags
    kind: 'web'
    properties: {
        Application_Type: 'web'
        WorkspaceResourceId: logAnalyticsWorkspaceId
    }
}

output name string = applicationInsights.name
