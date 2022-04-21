@description('The name of the Managed Cluster resource.')
param aksClusterName string = 'aks101cluster-vmss'

@description('The location of AKS resource.')
param location string = resourceGroup().location

@description('Optional DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string

@description('Disk size (in GiB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('The number of nodes for the cluster. 1 Node is enough for Dev/Test and minimum 3 nodes, is recommended for Production')
@minValue(1)
@maxValue(100)
param agentCount int = 3

@description('The size of the Virtual Machine.')
param agentVMSize string = 'Standard_D2s_v3'

@description('The type of operating system.')
@allowed([
  'Linux'
  'Windows'
])
param osType string = 'Linux'

@description('Enable OMS agent for AKS')
param enableOMS bool

@description('Resource Id of Log analytics workspace')
param omsWorkspaceId string

@description('subnet id')
param vnetSubnetID string

@description('azure or kubenet')
@allowed([
  'azure'
  'kubenet'
])
param networkPlugin string

@description('description')
@allowed([
  'azure'
  'calico'
])
param networkPolicy string

@description('IP CIDR for AKS')
param serviceCidr string

@description('IP address of DNS in AKS')
param dnsServiceIP string

@description('Docker bridge CIDR')
param dockerBridgeCidr string

@description('Resource ID of user managed identity')
param userAssignedIdentityID string

var omsAgent = {
  enabled: true
  config: {
    logAnalyticsWorkspaceResourceID: omsWorkspaceId
  }
}

resource aksClusterName_resource 'Microsoft.ContainerService/managedClusters@2022-01-02-preview' = {
  name: aksClusterName
  location: location
  tags: {
    displayname: 'AKS Cluster'
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentityID}': {}
    }
  }
  properties: {
    enableRBAC: true
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: osType
        type: 'VirtualMachineScaleSets'
        storageProfile: 'ManagedDisks'
        mode: 'System'
        maxPods: 110
        vnetSubnetID: vnetSubnetID
        enableNodePublicIP: false
      }
    ]
    networkProfile: {
      loadBalancerSku: 'standard'
      networkPlugin: networkPlugin
      networkPolicy: networkPolicy
      serviceCidr: serviceCidr
      dnsServiceIP: dnsServiceIP
      dockerBridgeCidr: dockerBridgeCidr
    }
    addonProfiles: {
      omsAgent: ((enableOMS == 'true') ? omsAgent : json('null'))
    }
  }
}

output controlPlaneFQDN string = aksClusterName_resource.properties.fqdn