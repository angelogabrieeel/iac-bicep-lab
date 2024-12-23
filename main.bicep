targetScope = 'subscription'

param resourceGroupName string
param resourceLocationName string
param tagsResourceGroup object

resource resourceGroup1 'Microsoft.Resources/resourceGroups@2024-07-01' = {
  name: resourceGroupName
  location: resourceLocationName
  tags: tagsResourceGroup
}

param appServicePlanKind string
param appServicePlanLocation string
param appServicePlanName string
param appServicePlanSkuName string
param appServicePlanTags object

module appServicePlan1 'modules/web/serverfarms.bicep' = {
  scope: resourceGroup1
  name: '${deployment().name}-serverFarmDev'
  params: {
    name: appServicePlanName
    location: appServicePlanLocation
    skuName: appServicePlanSkuName
    kind: appServicePlanKind
    tags: appServicePlanTags
  }
}

param applicationLocation string
param tagsApplicationInsights object
param nameApplicationInsights string

module applicationInsightsAngelo 'modules/monitoring/applicationInsights.bicep' = {
scope: resourceGroup1
name: '${deployment().name}-appi'
params: {
  location: applicationLocation
  logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.id
  name: nameApplicationInsights
  tags: tagsApplicationInsights 
}
}

param logAnalyticsWorkspaceName string
param logAnalyticsWorkspaceRetentionInDays int
param tagsApplicationWorkspace object
 
module logAnalyticsWorkspace 'modules/management/logAnalytics.bicep' = {
  scope: resourceGroup1
  name: '${deployment().name}-log'
  params: {
    location: applicationLocation
    name: logAnalyticsWorkspaceName
    retentionInDays: logAnalyticsWorkspaceRetentionInDays
    tags: tagsApplicationWorkspace
  }
}

param appIntegrationSubnetName string
param privateEndpointSubnetName string
param virtualNetworkAddressPrefix string
param virtualNetworkDnsServers array
param virtualNetworkName string
param virtualNetworkSubnets array
param virtualNetworkLocation string
param virtualNetworkTags object

module virtualNetworkAngelo 'modules/networking/virtualNetwork.bicep' = {
  scope: resourceGroup1
  name: '${deployment().name}-vnet'
  params: {
    addressPrefix: virtualNetworkAddressPrefix
    dnsServers: virtualNetworkDnsServers
    location: virtualNetworkLocation
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.id
    name: virtualNetworkName
    subnets: virtualNetworkSubnets
    tags: virtualNetworkTags
  }
}

param frontendAppAppSettings object
param frontendAppClientAffinityEnabled bool
param frontendAppIpSecurityRestrictions array
param frontendAppKind string
param frontendAppLinuxFxVersion string
param frontendAppName string
param frontendAppPrivateEndpointName string
param frontendAppPrivateEndpointPrivateDnsZoneId string
param frontendAppPublicNetworkAccess string
param frontendAppReserved bool
param frontendAppTags object

module webApp1 'modules/web/sites.bicep' = {
  scope: resourceGroup1
  name: '${deployment().name}-fea-app'
  params: {
    appSettings: frontendAppAppSettings
    applicationInsightsName: applicationInsightsAngelo.outputs.name
    clientAffinityEnabled: frontendAppClientAffinityEnabled
    ipSecurityRestrictions: frontendAppIpSecurityRestrictions
    kind: frontendAppKind
    linuxFxVersion: frontendAppLinuxFxVersion
    location: applicationLocation
    logAnalyticsWorkspaceId: logAnalyticsWorkspace.outputs.id
    appName: frontendAppName
    privateEndpointGroupId: 'sites'
    privateEndpointName: frontendAppPrivateEndpointName
    privateEndpointPrivateDnsZoneId: frontendAppPrivateEndpointPrivateDnsZoneId
    privateEndpointSubnetId: '${virtualNetworkAngelo.outputs.id}/subnets/${privateEndpointSubnetName}'
    privateEndpointVirtualNetworkId: virtualNetworkAngelo.outputs.id
    publicNetworkAcess: frontendAppPublicNetworkAccess
    reserved: frontendAppReserved
    serverFarmId: appServicePlan1.outputs.id
    tags: frontendAppTags
    virtualNetworkSubnetId: '${virtualNetworkAngelo.outputs.id}/subnets/${appIntegrationSubnetName}'
  }
}




