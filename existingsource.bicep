resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing= {
  name: 'terraformstatefilend'
}
output blobendpoint string = storageaccount.properties.primaryEndpoints.blob
