# Login to Azure Account
Connect-AzAccount

# Select Subscription
$subscriptionId = "sub-id"
Select-AzSubscription -SubscriptionId $subscriptionId

# Define Variables
$resourceGroupName = "resource-group"
$storageAccountName = "storage-account"

# Get Storage Account Usage Metrics
$metrics = Get-AzMetric -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName" `
-MetricName "UsedCapacity" -TimeGrain "P1D" -StartTime (Get-Date).AddDays(-7) -EndTime (Get-Date)

# Display Metrics
$metrics.Data | Select-Object TimeStamp, Total | Format-Table -AutoSize
