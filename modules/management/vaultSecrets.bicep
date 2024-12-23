param contentType string
param keyVaultName string
param name string
@secure()
param value string

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
    name: keyVaultName
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-04-01-preview' = {
    parent: keyVault
    name: name
    properties: {
        attributes: {
            enabled: true
        }
        contentType: contentType
        value: value
    }
}
