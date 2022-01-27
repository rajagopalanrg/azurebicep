param location string = 'eastus'
param adminUsername string = 'azureuser'
@secure()
param adminPassword string

param vnetName string = 'vnet-rg-eastus'
resource diagStorage 'Microsoft.Storage/storageAccounts@2021-02-01' existing= {
  name: 'terraformstatefilend'
}
var disks = [
  {
    diskSizeGB: 32
    lun:0
    createOption: 'Empty'
  }
  {
    diskSizeGB: 32
    lun:1
    createOption: 'Empty'
  }
]
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = [for i in range(0, 1): {
  name: 'storageaccountbicep${i}'
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}]

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: vnetName
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'config1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetwork.properties.subnets[0].id
          }
        }
      }
    ]
  }
}
resource ubuntuVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'ubuntuvm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    osProfile: {
      computerName: 'ubuntuvm'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '16.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: 'osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
      dataDisks: [for disk in disks: {
        diskSizeGB: disk.diskSizeGB
        createOption: disk.createOption
        lun: disk.lun
      }]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: diagStorage.properties.primaryEndpoints.blob
      }
    }
  }
}
output storageData array = [for i in range(0, 1): {
  id: storageaccount[i].id
  blobendpoint: storageaccount[i].properties.primaryEndpoints.blob
}]
