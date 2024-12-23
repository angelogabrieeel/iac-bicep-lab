param name string
param location string
param tags object
param skuName string
param replicaCount int
param partitionCount int
param hostingMode string
param publicNetworkAccess string
param ipRules array
param disableLocalAuth bool

resource search 'Microsoft.Search/searchServices@2022-09-01' = {
    name: name
    location: location
    tags: tags
    sku: {
        name: skuName
    }
    properties: {
        replicaCount: replicaCount
        partitionCount: partitionCount
        hostingMode: hostingMode
        publicNetworkAccess: publicNetworkAccess
        networkRuleSet: {
            ipRules: ipRules
        }
        encryptionWithCmk: {
            enforcement: 'Unspecified'
        }
        disableLocalAuth: disableLocalAuth
        authOptions: {
            apiKeyOnly: {}
        }
    }
}
