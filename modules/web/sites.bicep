param appSettings object
param applicationInsightsName string
param clientAffinityEnabled bool
param ipSecurityRestrictions array = []
param ipSecurityRestrictionsDefaultAction string = 'Deny'
param scmIpSecurityRestrictions array = []
param scmIpSecurityRestrictionsUseMain bool = true
param kind string
param linuxFxVersion string = ''
param location string
param logAnalyticsWorkspaceId string
param appName string
param netFrameworkVersion string = ''
param publicNetworkAcess string = 'Disabled'
param reserved bool
param serverFarmId string
param tags object
param virtualNetworkSubnetId string


//resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = {
//  name: applicationInsightsName
//}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  tags: tags
  kind: kind
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    virtualNetworkSubnetId: virtualNetworkSubnetId
    publicNetworkAccess: publicNetworkAcess
    vnetRouteAllEnabled: true
    serverFarmId: serverFarmId
    reserved: reserved
    clientAffinityEnabled: clientAffinityEnabled
    httpsOnly: true
    siteConfig: {
      scmType: 'VSTSRM' //Propriedade especifica do projeto Analyzer
      linuxFxVersion: length(linuxFxVersion) > 0 ? linuxFxVersion : null
      httpLoggingEnabled: true
      detailedErrorLoggingEnabled: true
      logsDirectorySizeLimit: 35
      scmIpSecurityRestrictionsUseMain: scmIpSecurityRestrictionsUseMain
      scmIpSecurityRestrictionsDefaultAction: 'Deny'
      ipSecurityRestrictionsDefaultAction: ipSecurityRestrictionsDefaultAction
      ipSecurityRestrictions: ipSecurityRestrictions
      scmIpSecurityRestrictions: scmIpSecurityRestrictions
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      http20Enabled: true
      alwaysOn: true
      netFrameworkVersion: length(netFrameworkVersion) > 0 ? netFrameworkVersion : null
    }
  }
}

module functionAppConfig 'appsettings.bicep' = {
    name: '${appName}-config'
    params: {
        appName: appService.name
        applicationInsightsName: applicationInsightsName
        // Get the current appsettings
        currentAppSettings: list('Microsoft.Web/sites/${appName}/config/appsettings', '2022-03-01').properties
        // Acrescentar app Settings no arquivo de parametros
        appSettings: appSettings
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
    resourceId: appService.id
    subnetId: privateEndpointSubnetId
    tags: tags
    virtualNetworkId: privateEndpointVirtualNetworkId
  }
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'default'
  scope: appService
  properties: {
    workspaceId: logAnalyticsWorkspaceId
    logs: [
      {
        category: 'AppServiceHTTPLogs'
        enabled: true
      }
      {
        category: 'AppServiceConsoleLogs'
        enabled: true
      }
      {
        category: 'AppServiceAppLogs'
        enabled: true
      }
      {
        category: 'AppServiceAuditLogs'
        enabled: true
      }
      {
        category: 'AppServiceIPSecAuditLogs'
        enabled: true
      }
      {
        category: 'AppServicePlatformLogs'
        enabled: true
      }
    ]
  }
}
