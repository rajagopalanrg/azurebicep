param location string = 'eastus'
param computerName string = 'windowsvm'
param adminUsername string = 'azureuser'
param adminPassword string
resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing= {
  name: 'terraformstatefilend'
}
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' existing= {
  name: 'name'
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'name'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'name'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: 'subnet.id'
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
          id: 'id'
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
