param cognitiveServicesName string
param cogDeploymentsName string
param cogDeploymentsSkuCapacity int
param cogDeploymentsModelFormat string
param cogDeploymentsModelName string
param cogDeploymentsModelVersion string



resource cognitiveServices 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: cognitiveServicesName
}


resource cogDeployments 'Microsoft.CognitiveServices/accounts/deployments@2023-05-01' = {
  parent: cognitiveServices
  name: cogDeploymentsName
  sku: {
    name: 'Standard'
    capacity: cogDeploymentsSkuCapacity
  }
  properties: {
    model: {
      format: cogDeploymentsModelFormat
      name: cogDeploymentsModelName
      version: cogDeploymentsModelVersion
    }
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
    raiPolicyName: 'Microsoft.Default'
  }
}
