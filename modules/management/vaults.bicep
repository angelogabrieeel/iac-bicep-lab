param accessPolicies array
param location string
param logAnalyticsWorkspaceId string
param name string
param privateEndpointGroupId string
param privateEndpointName string
param privateEndpointPrivateDnsZoneId string
param privateEndpointSubnetId string
param privateEndpointVirtualNetworkId string
param softDeleteRetentionInDays int
param publicNetworkAccess string
param tags object

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
    name: name
    location: location
    tags: tags
    properties: {
        sku: {
            family: 'A'
            name: 'standard'
        }
        tenantId: subscription().tenantId
        enabledForTemplateDeployment: true
        enablePurgeProtection: true
        enableRbacAuthorization: true
        enableSoftDelete: true
        softDeleteRetentionInDays: softDeleteRetentionInDays
        accessPolicies: accessPolicies
        publicNetworkAccess: publicNetworkAccess
        networkAcls: {
            bypass: 'AzureServices'
            defaultAction: 'Allow'
            ipRules: []
            virtualNetworkRules: []
        }
    }
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
    name: 'default'
    scope: keyVault
    properties: {
        workspaceId: logAnalyticsWorkspaceId
        logs: [
            {
                categoryGroup: 'allLogs'
                enabled: true
            }
        ]
    }
}

module privateEndpoint '../networking/privateEndpoint.bicep' = {
    name: '${deployment().name}-pep'
    params: {
        groupId: privateEndpointGroupId
        location: location
        name: privateEndpointName
        privateDnsZoneId: privateEndpointPrivateDnsZoneId
        resourceId: keyVault.id
        subnetId: privateEndpointSubnetId
        tags: tags
        virtualNetworkId: privateEndpointVirtualNetworkId
    }
}

output id string = keyVault.id
output name string = keyVault.name
