# Define variables
$ResourceGroupName = "Azuredevops"
$StorageAccountName = "tfstate$((Get-Random -Maximum 10000))$((Get-Random -maximum 10000))"
$ContainerName = "tfstate"

# Create storage account
az storage account create --resource-group $ResourceGroupName --name $StorageAccountName --sku Standard_LRS --encryption-services blob

# Get storage account key
$AccountKey = (az storage account keys list --resource-group $ResourceGroupName --account-name $StorageAccountName --query "[0].value" -o tsv)
$env:ARM_ACCESS_KEY = $AccountKey  # Export environment variable

# Create blob container
az storage container create --name $ContainerName --account-name $StorageAccountName --account-key $AccountKey

# Output values
Write-Output "RESOURCE_GROUP_NAME=$ResourceGroupName"
Write-Output "STORAGE_ACCOUNT_NAME=$StorageAccountName"
Write-Output "CONTAINER_NAME=$ContainerName"
Write-Output "ACCOUNT_KEY=$AccountKey"