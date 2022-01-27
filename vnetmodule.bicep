param vnetAddressPrefix array
param subnets array
param location string
param networkName string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: networkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetAddressPrefix
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
      }
    }]
  }
}

output vnetResourceId string = virtualNetwork.id
output vnetName string = virtualNetwork.name
