targetScope = 'subscription'

resource symbolicname 'Microsoft.Authorization/accessReviewScheduleDefinitions@2021-07-01-preview' = {
  name: 'lighthouse-approver'
  
  instances: [
    {
      properties: {
        backupReviewers: [
          {
            principalId: '5ec58b64-7dc4-4150-9870-4fa13beaf708'
          }
        ]
        endDateTime: 'string'
        reviewers: [
          {
            principalId: '5ec58b64-7dc4-4150-9870-4fa13beaf708'
          }
        ]
        startDateTime: '2022-01-18T00:00:00'
      }
    }
  ]
  reviewers: [
    {
      principalId: '5ec58b64-7dc4-4150-9870-4fa13beaf708'
    }
  ]
  settings: {
    autoApplyDecisionsEnabled: true
    defaultDecision: 'Recommendation'
    defaultDecisionEnabled: true
    instanceDurationInDays: 7
    justificationRequiredOnApproval: true
    mailNotificationsEnabled: true
    recommendationLookBackDuration: '90'
    recommendationsEnabled: true
    recurrence: {
      pattern: {
        interval: 7
        type: 'weekly'
      }
      range: {
        endDate: '2022-05-18T23:59:59'
        numberOfOccurrences: 1
        startDate: '2022-01-18T23:59:59'
        type: 'noEnd'
      }
    }
    reminderNotificationsEnabled: true
  }
}
