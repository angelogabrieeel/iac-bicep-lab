param applicationInsightsName string
param currentAppSettings object
param appSettings object
param appName string

resource webApp 'Microsoft.Web/sites@2022-09-01' existing = {
    name: appName
}

resource siteConfig 'Microsoft.Web/sites/config@2022-09-01' = {
    parent: webApp
    name: 'appsettings'
    properties: union({
            APPINSIGHTS_INSTRUMENTATIONKEY: reference('microsoft.insights/components/${applicationInsightsName}', '2015-05-01').InstrumentationKey
            APPLICATIONINSIGHTS_CONNECTION_STRING: reference('microsoft.insights/components/${applicationInsightsName}', '2015-05-01').ConnectionString
            APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
            APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
            ApplicationInsightsAgent_EXTENSION_VERSION: '~2'
            DiagnosticServices_EXTENSION_VERSION: '~3'
            InstrumentationEngine_EXTENSION_VERSION: '~1'
            SnapshotDebugger_EXTENSION_VERSION: 'disabled'
            XDT_MicrosoftApplicationInsights_BaseExtensions: '~1'
            XDT_MicrosoftApplicationInsights_Mode: 'recommended'
            XDT_MicrosoftApplicationInsights_PreemptSdk: 'disabled'
            WEBSITE_ENABLE_SYNC_UPDATE_SITE: 'true'
            WEBSITE_RUN_FROM_PACKAGE: '1'
        }, currentAppSettings, appSettings)
}
