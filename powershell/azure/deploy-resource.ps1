# Login to Azure Account
Connect-AzAccount

# Select Subscription
$subscriptionId = "sub-id"
Select-AzSubscription -SubscriptionId $subscriptionId

# Define Variables
$resourceGroupName = "resource-group"
$location = "East US"
$templateFilePath = "path-to-arm-template.json"
$parametersFilePath = "path-to-parameters.json"

# Create Resource Group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Deploy ARM Template
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath
