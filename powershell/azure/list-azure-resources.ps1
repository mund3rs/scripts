# Login to Azure Account
Connect-AzAccount

# Select Subscription
$subscriptionId = "sub-id"
Select-AzSubscription -SubscriptionId $subscriptionId

# Get All Resources
$resources = Get-AzResource

# Display Resources
$resources | Select-Object ResourceGroupName, ResourceType, Location, Name | Format-Table -AutoSize
