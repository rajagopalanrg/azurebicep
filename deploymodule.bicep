module vnetModule 'vnetmodule.bicep' = {
  name: 'deployVnet'
  params:{
    vnetAddressPrefix: [
      '10.5.0.0/16'
    ]
    subnets: [
      {
        name: 'api'
        subnetPrefix: '10.5.0.0/24'
      }
      {
        name: 'worker'
        subnetPrefix: '10.5.1.0/24'
      }
    ]
    location: 'eastus'
    networkName: 'vnet-from-module'
  }
}
