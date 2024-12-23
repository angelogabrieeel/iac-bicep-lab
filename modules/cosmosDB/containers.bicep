param cosmosDbAccountName string
param sqlDatabaseName string
param sqlDbContainerName string
param containerThroughputName string
//param tags object

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-09-15' existing = {
  name: cosmosDbAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-09-15' existing = {
  parent: cosmosDbAccount
  name: sqlDatabaseName
}

resource sqlDbContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-09-15' = {
  parent: sqlDatabase
  name: sqlDbContainerName
  properties: {
    resource: {
      id: 'documents'
      indexingPolicy: {
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      partitionKey: {
        paths: [
          '/iddocs'
        ]
        kind: 'Hash'
        version: 2
      }
    }
  }
}
