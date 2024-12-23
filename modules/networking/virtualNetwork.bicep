param addressPrefix string
param dnsServers array
param location string
param logAnalyticsWorkspaceId string
param name string
param subnets array
param tags object

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' = {
    name: name
    location: location
    tags: tags
    properties: {
        addressSpace: {
            addressPrefixes: [
                addressPrefix
            ]
        }
        subnets: [for item in subnets: {
            name: item.name
            properties: {
                addressPrefix: item.addressPrefix
                privateEndpointNetworkPolicies: item.privateEndpointNetworkPolicies
                privateLinkServiceNetworkPolicies: item.privateLinkServiceNetworkPolicies
                networkSecurityGroup: length(item.networkSecurityGroupName) > 0 ? json('{"id": "${resourceId('Microsoft.Network/networkSecurityGroups', item.networkSecurityGroupName)}"}') : null
                delegations: item.delegations
                serviceEndpoints: item.serviceEndpoints
            }
        }]
        dhcpOptions: {
            dnsServers: dnsServers
        }
    }
}



resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
    name: 'default'
    scope: virtualNetwork
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

output id string = virtualNetwork.id
output name string = virtualNetwork.name
