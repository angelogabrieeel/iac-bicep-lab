param kind string = 'linux'
param location string
param name string
param reserved bool = true
param skuName string
param tags object

resource serverfarm 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    reserved: reserved
  }
}

output id string = serverfarm.id
