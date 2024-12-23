param privateDnsZoneName string
param virtualNetworkId string
param virtualNetworkName string

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
    name: privateDnsZoneName
}

resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
    name: 'link-${virtualNetworkName}'
    parent: privateDnsZone
    location: 'global'
    properties: {
        registrationEnabled: false
        virtualNetwork: {
            id: virtualNetworkId
        }
    }
}
