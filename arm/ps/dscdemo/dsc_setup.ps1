


# 1. create the iis_setup.zip file
Publish-AzVMDscConfiguration .\iis_setup.ps1 -OutputArchivePath '.\iis_setup.zip'

# 2. upload the .zip file to the Azure Storage Container:

$resourceGroupName = "dsc-rg"
$location = "eastus"
$storageAccountName = "dscsa790709"
$dscZipFilePath = '.\iis_setup.zip'
$storageContainerName = 'envsetupscripts'

# 2.1. Create Storage Account
New-AzResourceGroup -Name $resourceGroupName -Location $location
New-AzStorageAccount -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind StorageV2
$StorageAccount = Get-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroupName

# 2.2. Create, and store, new container
$StorageAccount | New-AzStorageContainer -Name $storageContainerName
$Container = $StorageAccount | Get-AzStorageContainer

# 2.3. Upload single file
$Container | Set-AzStorageBlobContent -File $dscZipFilePath