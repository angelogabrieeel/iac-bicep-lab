param location string
param name string
param retentionInDays int
param tags object

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
    name: name
    location: location
    tags: tags
    properties: {
        sku: {
            name: 'PerGB2018'
        }
        retentionInDays: retentionInDays
    }
}

output id string = logAnalyticsWorkspace.id
