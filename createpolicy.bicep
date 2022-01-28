targetScope = 'subscription'
param logAnalytics string = '656bbe38-7d46-4b54-b0a8-99f7abb06ccc'
resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'InstallLogAnalytics'
  properties: {
    displayName: 'Configure Log analytics to load balancers'
    policyType: 'Custom'
    mode: 'All'
    description: 'description'
    metadata: {
      version: '0.1.0'
      category: 'category'
      source: 'source'
    }
    parameters: {
      logAnalytics: {
        type: 'String'
        metadata: {
          displayName: 'Log analytics workspace'
          description: 'Log analytics workspace'
        }
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Network/loadBalancers'
          }
        ]
      }
      then: {
        effect: 'deployIfNotExists'
        details: {
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/749f88d5-cbae-40b8-bcfc-e573ddc772fa'
          ]
          type: 'Microsoft.Insights/diagnosticSettings'
          existenceCondition: {
            allOf: [
              {
                field: 'Microsoft.Insights/diagnosticSettings/logs.enabled'
                equals: 'True'
              }
              {
                field: 'Microsoft.Insights/diagnosticSettings/workspaceId'
                matchInsensitively: '[parameters(\'logAnalytics\')]'
              }
            ]
          }
          deployment: {
            properties: {
              mode: 'incremental'
              template: {
                '': 'schema'
                contentVersion: '1.0.0.0'
                parameters: {
                  logAnalytics: {
                    type: 'String'
                  }
                }
                variables: {}
                resources: [
                  {
                    name: 'loadbalancerDiagSettings'
                    type: 'Microsoft.Network/loadBalancers/providers/diagnosticSettings'
                    apiVersion: '2017-05-01-preview'
                    location: 'east us'
                    properties: {
                      workspaceId: '[parameters(\'logAnalytics\')]'
                      metrics: [
                        {
                          category: 'AllMetrics'
                          timeGrain: null
                          enabled: true
                          retentionPolicy: {
                            enabled: false
                            days: 0
                          }
                        }
                      ]
                      logs: [
                        {
                          category: 'LoadBalancerAlertEvent'
                          enabled: true
                        }
                        {
                          category:'LoadBalancerProbeHealthStatus'
                          enabled: true
                        }
                      ]
                    }
                  }
                ]
              }
              parameters: {
                logAnalytics: {
                   value: '[parameters(\'logAnalytics\')]'
                }
             }
            }
          }
        }
      }
    }
  }
}
resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: 'LB-logMonitoring'
  location: 'eastus'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Implement Log Analytics for Load Balancers'
    description: 'LB-logMonitoring'
    enforcementMode: 'Default'
    metadata: {
      source: 'source'
      version: '0.1.0'
    }
    policyDefinitionId: policyDefinition.id
    parameters: {
      logAnalytics: {
        value: logAnalytics
      }
    }
    nonComplianceMessages: [
      {
        message: 'Load Balancer is not associated with Log Analytics Workspace'
      }
    ]
  }
}


