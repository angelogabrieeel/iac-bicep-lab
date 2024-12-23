param name string
param storageAccountName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
    name: storageAccountName
}

resource storageAccountBlobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' existing = {
    parent: storageAccount
    name: 'default'
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
    parent: storageAccountBlobService
    name: name
    properties: {
        defaultEncryptionScope: '$account-encryption-key'
        denyEncryptionScopeOverride: false
        publicAccess: 'None'
    }
}
