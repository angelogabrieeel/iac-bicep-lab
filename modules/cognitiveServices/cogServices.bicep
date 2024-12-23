param cognitiveServicesName string
param cognitiveServicesLocation string
param location string
param tags object
param customSubDomainName string
param networkAcls object
param kind string
param publicNetworkAccess string
param skuName string
param dynamicThrottlingEnabled bool = false //Autoscale do Document intelligence

resource cognitiveServices 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: cognitiveServicesName
  location: cognitiveServicesLocation
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    customSubDomainName: customSubDomainName
    networkAcls: networkAcls == {} ? null : networkAcls
    publicNetworkAccess: publicNetworkAccess
    dynamicThrottlingEnabled: dynamicThrottlingEnabled //Autoscale do Document intelligence
  }
}

param privateEndpointName string
param privateEndpointGroupId string
param privateEndpointPrivateDnsZoneId string
param privateEndpointSubnetId string
param privateEndpointVirtualNetworkId string

module privateEndpoint '../networking/privateEndpoint.bicep' = {
  name: '${deployment().name}-privateEnd'
  params: {
    groupId: privateEndpointGroupId
    location: location
    name: privateEndpointName
    privateDnsZoneId: privateEndpointPrivateDnsZoneId
    resourceId: cognitiveServices.id
    subnetId: privateEndpointSubnetId
    tags: tags
    virtualNetworkId: privateEndpointVirtualNetworkId
  }
}

output name string = cognitiveServices.name
output identityPrincipalId string = cognitiveServices.identity.principalId
