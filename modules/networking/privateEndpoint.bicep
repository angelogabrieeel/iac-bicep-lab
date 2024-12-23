param groupId string
param location string
param name string
param privateDnsZoneId string
param resourceId string
param subnetId string
param tags object
param virtualNetworkId string

var privateDnsZoneSplitId = split(privateDnsZoneId, '/')
var virtualNetworkSplitId = split(virtualNetworkId, '/')

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
    name: name
    location: location
    tags: tags
    properties: {
        customNetworkInterfaceName: 'nic-${name}'
        subnet: {
            id: subnetId
        }
        privateLinkServiceConnections: [
            {
                name: name
                properties: {
                    privateLinkServiceId: resourceId
                    groupIds: [
                        groupId
                    ]
                }
            }
        ]
    }
}

module vnetLink 'privateDnsVirtualNetworkLink.bicep' = {
    name: '${deployment().name}-link'
    scope: resourceGroup(privateDnsZoneSplitId[2], privateDnsZoneSplitId[4])
    params: {
        privateDnsZoneName: last(privateDnsZoneSplitId)
        virtualNetworkId: virtualNetworkId
        virtualNetworkName: last(virtualNetworkSplitId)
    }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
    name: 'default'
    parent: privateEndpoint
    properties: {
        privateDnsZoneConfigs: [
            {
                name: '${privateEndpoint.name}-arecord'
                properties: {
                    privateDnsZoneId: privateDnsZoneId
                }
            }
        ]
    }
}

output name string = privateEndpoint.name
