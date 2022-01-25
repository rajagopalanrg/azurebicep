param location string = 'eastus'
param computerName string = 'windowsvm'
param adminUsername string = 'azureuser'

@secure()
param adminPassword string

param vnetName string = 'vnet-rg-eastus'

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing= {
  name: 'terraformstatefilend'
}
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

resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: computerName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    osProfile: {
      computerName: computerName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        name: 'winvmosdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
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
        storageUri:  storageaccount.properties.primaryEndpoints.blob
      }
    }
  }
}
