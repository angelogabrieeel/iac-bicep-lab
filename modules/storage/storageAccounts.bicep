param accessTier string
param allowBlobPublicAccess bool
param formRecognizerPrincipalId string = ''
param kind string
param location string
param storageAccountLocation string
param minimumTlsVersion string
param name string
param privateEndpointGroupId string
param privateEndpointName string
param privateEndpointPrivateDnsZoneId string
param privateEndpointSubnetId string
param privateEndpointVirtualNetworkId string
param publicNetworkAccess string
param skuName string
param tags object

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: storageAccountLocation
  tags: tags
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    publicNetworkAccess: publicNetworkAccess
    minimumTlsVersion: minimumTlsVersion
    allowBlobPublicAccess: allowBlobPublicAccess
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    accessTier: accessTier
  }
}

module privateEndpoint '../networking/privateEndpoint.bicep' = {
  name: '${deployment().name}-pep'
  params: {
    groupId: privateEndpointGroupId
    location: location
    name: privateEndpointName
    privateDnsZoneId: privateEndpointPrivateDnsZoneId
    resourceId: storageAccount.id
    subnetId: privateEndpointSubnetId
    tags: tags
    virtualNetworkId: privateEndpointVirtualNetworkId
  }
}

@description('This is the built-in Blob Data Reader role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles')
resource blobDataReaderDefinition 'Microsoft.Authorization/roleDefinitions@2022-05-01-preview' existing = {
  name: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
  scope: subscription()
}

resource blobDataReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(formRecognizerPrincipalId)) {
  name: guid(storageAccount.name, formRecognizerPrincipalId)
  scope: storageAccount
  properties: {
    principalId: formRecognizerPrincipalId
    roleDefinitionId: blobDataReaderDefinition.id
    principalType: 'ServicePrincipal'
  }
}

output name string = storageAccount.name
