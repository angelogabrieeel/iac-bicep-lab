@description('Name of our Cosmos DB account')
@maxLength(44)
param cosmosDbAccountName string
param cosmosDbAccountLocation string
param location string
param kind string
param enableFreeTier bool
param defaultConsistencyLevel string
param maxStalenessPrefix int
param maxIntervalInSeconds int
param failoverPriority int
param databaseAccountOfferType string
param enableAutomaticFailover bool
param totalThroughputLimit int
param publicNetworkAccess string


resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-09-15' = {
  name: cosmosDbAccountName
  location: cosmosDbAccountLocation
  tags:{
    defaultExperience: 'Core (SQL)'
    Ambiente: 'openai' //TODO: Como usar parametros em array?
    'hidden-cosmos-mmspecial': ''
  }
  kind: kind
  identity:{
    type:'SystemAssigned'
  }
  properties: {
    backupPolicy: {
      type: 'Continuous'
      continuousModeProperties:{
        tier:'Continuous7Days'
      }
    }
    publicNetworkAccess: publicNetworkAccess
    enableFreeTier: enableFreeTier
    consistencyPolicy: {
      defaultConsistencyLevel: defaultConsistencyLevel
      maxStalenessPrefix: maxStalenessPrefix
      maxIntervalInSeconds: maxIntervalInSeconds
    }
    locations: [
      {
        locationName: cosmosDbAccountLocation
        failoverPriority: failoverPriority
      }
    ]
    databaseAccountOfferType: databaseAccountOfferType
    enableAutomaticFailover: enableAutomaticFailover
    //capabilities: []
    capacity:{
      totalThroughputLimit: totalThroughputLimit
    }
  }
}



param privateEndpointName string
param privateEndpointGroupId string
param privateEndpointPrivateDnsZoneId string
param privateEndpointSubnetId string
param privateEndpointVirtualNetworkId string


module privateEndpoint '../networking/privateEndpoint.bicep' = {
  name: '${deployment().name}-cosmos-privateEnd'
  params: {
    groupId: privateEndpointGroupId
    location: location
    name: privateEndpointName
    privateDnsZoneId: privateEndpointPrivateDnsZoneId
    resourceId: cosmosDbAccount.id
    subnetId: privateEndpointSubnetId
    tags: {
      Ambiente: 'openai'
    }
    virtualNetworkId: privateEndpointVirtualNetworkId
  }
}

//TODO: Confirmar local diagnosticSetting CosmosDB. Codigo abaixo deve estar no dbaccount, container ou sqldatabase
// resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
//   name: 'default'
//   scope: cosmosDbAccount
//   properties: {
//     workspaceId: logAnalyticsWorkspaceId
//     logs: [
//       {
//         category: 'allLogs'
//         enabled: true
//       }
//     ]
//   }
// }


output name string = cosmosDbAccount.name







