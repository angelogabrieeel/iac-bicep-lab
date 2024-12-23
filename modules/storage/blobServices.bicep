param changeFeedEnabled bool
param containerDeleteRetentionPolicyDays int
param containerDeleteRetentionPolicyEnabled bool
param cors object
param deleteRetentionPolicyAllowPermanentDelete bool
param deleteRetentionPolicyDays int
param deleteRetentionPolicyEnabled bool
param isVersioningEnabled bool
param restorePolicyEnabled bool
param storageAccountName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
    name: storageAccountName
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
    parent: storageAccount
    name: 'default'
    properties: {
        changeFeed: {
            enabled: changeFeedEnabled
        }
        restorePolicy: {
            enabled: restorePolicyEnabled
        }
        containerDeleteRetentionPolicy: {
            enabled: containerDeleteRetentionPolicyEnabled
            days: containerDeleteRetentionPolicyDays
        }
        deleteRetentionPolicy: {
            allowPermanentDelete: deleteRetentionPolicyAllowPermanentDelete
            enabled: deleteRetentionPolicyEnabled
            days: deleteRetentionPolicyDays
        }
        isVersioningEnabled: isVersioningEnabled
        cors: cors
    }
}
