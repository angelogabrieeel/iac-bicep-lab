using './main.bicep'

param resourceGroupName = 'rg-angelo-dev'
param resourceLocationName = 'brazilsouth'
param tagsResourceGroup = {
 ambiente: 'Desenvolvimento'
 projeto: 'Angelo'  
}

param appServicePlanKind = 'linux'
param appServicePlanLocation = 'brazilsouth'
param appServicePlanName = 'asp-angelo-dev'
param appServicePlanSkuName = 'B2'
param appServicePlanTags = {
  ambiente: 'Desenvolvimento'
  projeto: 'Angelo'
}

param nameApplicationInsights = 'appi-angelo-dev'
param applicationLocation = 'brazilsouth'
param tagsApplicationInsights = {
  ambiente: 'Desenvolvimento'
  projeto: 'Angelo'
}

param logAnalyticsWorkspaceName = 'log-angelo-dev'
param logAnalyticsWorkspaceRetentionInDays = 30
param tagsApplicationWorkspace = {
  ambiente: 'Desenvolvimento'
  projeto: 'Angelo'
}

param appIntegrationSubnetName = 'snet-app-angelo-integration'
param privateEndpointSubnetName = 'snet-private-angelo-link'
param virtualNetworkAddressPrefix = '10.140.3.0/26'
param virtualNetworkDnsServers = [
  '10.30.0.57'
  '10.30.1.233'
]
param virtualNetworkName = 'vnet-angelo-dev'
param virtualNetworkSubnets = [
  {
    name: privateEndpointSubnetName
    addressPrefix: '10.140.3.0/27'
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
    networkSecurityGroupName: ''
    delegations: []
    serviceEndpoints: []
  }
  {
    name: appIntegrationSubnetName
    addressPrefix: '10.140.3.32/27'
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
    networkSecurityGroupName: ''
    delegations: [
      {
        name: 'delegation-serverfarms'
        properties: {
          serviceName: 'Microsoft.Web/serverfarms'
        }
      }
    ]
    serviceEndpoints: []
  }
]

param virtualNetworkLocation = 'brazilsouth'
param virtualNetworkTags = {
  ambiente: 'Desenvolvimento'
  projeto: 'Angelo'
}

param frontendAppAppSettings = {
}
param frontendAppClientAffinityEnabled = false
param frontendAppIpSecurityRestrictions = [
  {
    action: 'Allow'
    name: 'AllowApiManagementService'
    priority: 10
    ipAddress: '191.232.214.183/32'
  }
]
param frontendAppKind = 'app,linux'
param frontendAppLinuxFxVersion = 'PHP|8.2'
param frontendAppName = 'app-angelo-fea-dev'
param frontendAppPrivateEndpointName = 'pep-app-angelo-fea-dev'
param frontendAppPrivateEndpointPrivateDnsZoneId = '/subscriptions/8905d5a4-3edb-4079-a3d9-4ce684d5c19e/resourcegroups/rg-secops-shared-dns-prd/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net'
param frontendAppPublicNetworkAccess = 'Disabled'
param frontendAppReserved = true
param frontendAppTags = {
  ambiente : 'Desenvolvimento'
  projeto : 'Angelo'
}

