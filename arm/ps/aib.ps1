
#--------------------------------------------------------------------------------------------------------------------------------------------------
# Prerequests setup for AIB(Azure Image Builder): run as Administrator
#   1. Register
#   2. Setup variables
#   3. Permissions, create user identity and role for AIB
#   4. Create the Shared Image Gallery  
#--------------------------------------------------------------------------------------------------------------------------------------------------
# Set-AzContext -SubscriptionId 00000000-0000-0000-0000-000000000000
# Get-AzContext

# PreReqs 1 Register

# 1.0. Register for Azure Image Builder Feature and Providers
Register-AzProviderFeature -ProviderNamespace Microsoft.VirtualMachineImages -FeatureName VirtualMachineTemplatePreview
Get-AzProviderFeature -ProviderNamespace Microsoft.VirtualMachineImages -FeatureName VirtualMachineTemplatePreview

# 1.1. Register for Azure Providers
Get-AzResourceProvider -ProviderNamespace Microsoft.Compute, Microsoft.KeyVault, Microsoft.Storage, Microsoft.VirtualMachineImages |
Where-Object RegistrationState -ne Registered |
Register-AzResourceProvider

# PreReqs 2. Setup variables

$imageResourceGroup = 'myAIB-rg'
$location = 'eastus'
New-AzResourceGroup -Name $imageResourceGroup -Location $location
$location = (Get-AzResourceGroup -Name $imageResourceGroup).Location
$subscriptionID = (Get-AzContext).Subscription.Id
$imageName = 'aibCustomImgWin10'
$imageTemplateName = 'imageTemplateWin10Multi'
$runOutputName = 'win10Client'

# PreReqs 3 Permissions, create user identity and role for AIB

# 3.1 Create User Identity
# 3.1.1 Unique identityName
[int]$timeInt = $(Get-Date -UFormat '%s')
$imageRoleDefName = "Azure Image Builder Image Def $timeInt"
$identityName = "myIdentity$timeInt"

# 3.1.2 Install PS modules to support AzUserAssignedIdentity and Az AIB
'Az.ImageBuilder', 'Az.ManagedServiceIdentity' | ForEach-Object { Install-Module -Name $_ }

# 3.1.3 Create Identity
New-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName
$identityNamePrincipalId = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).PrincipalId
$identityNameResourceId = (Get-AzUserAssignedIdentity -ResourceGroupName $imageResourceGroup -Name $identityName).Id

# 3.2 Assign permissions for identity to distribute images
# 3.2.1 Create a new Role:
$myRoleImageCreationUrl = 'https://raw.githubusercontent.com/danielsollondon/azvmimagebuilder/master/solutions/12_Creating_AIB_Security_Roles/aibRoleImageCreation.json'
$myRoleImageCreationPath = ".\myRoleImageCreation.json"
Invoke-WebRequest -Uri $myRoleImageCreationUrl -OutFile $myRoleImageCreationPath -UseBasicParsing
$Content = Get-Content -Path $myRoleImageCreationPath -Raw
$Content = $Content -replace '<subscriptionID>', $subscriptionID
$Content = $Content -replace '<rgName>', $imageResourceGroup
$Content = $Content -replace 'Azure Image Builder Service Image Creation Role', $imageRoleDefName
$Content | Out-File -FilePath $myRoleImageCreationPath -Force

New-AzRoleDefinition -InputFile $myRoleImageCreationPath

Start-Sleep -Seconds 180

# 3.2.2 Grant the Role Definition to the Image Builder Service Principle and verify
New-AzRoleAssignment `
    -ObjectId $identityNamePrincipalId `
    -RoleDefinitionName $imageRoleDefName `
    -Scope "/subscriptions/$subscriptionID/resourceGroups/$imageResourceGroup"

Get-AzRoleAssignment -ObjectId $identityNamePrincipalId | Select-Object DisplayName, RoleDefinitionName

# PreReqs 4 Create the Shared Image Gallery

$sigGalleryName = "myaibsig01"
$imageDefName = "mywin10wvd"
New-AzGallery `
    -GalleryName $sigGalleryName `
    -ResourceGroupName $imageResourceGroup `
    -Location $Location

New-AzGalleryImageDefinition `
    -GalleryName $sigGalleryName `
    -ResourceGroupName $imageResourceGroup `
    -Location $location `
    -Name $imageDefName `
    -OsState Generalized `
    -OsType Windows `
    -Publisher 'myCo' `
    -Offer 'Windows' `
    -Sku '10wvd' 

#--------------------------------------------------------------------------------------------------------------------------------------------------
# Configure the Image Template
#--------------------------------------------------------------------------------------------------------------------------------------------------

# 1. Download the Win10MultiTemplate.json Template file and Update
# 1.1. Download
$Win10Url = "https://raw.githubusercontent.com/tsrob50/AIB/main/Win10MultiTemplate.json"
$Win10FileName = "Win10MultiTemplate.json"
$templateFilePath = ".\Template\$Win10FileName"
if ((test-path .\Template) -eq $false) {
    new-item -ItemType Directory -name 'Template'
} 
if ((test-path .\Template\$Win10FileName) -eq $true) {
    $confirmation = Read-Host "Are you Sure You Want to Replace the Template?:"
    if ($confirmation -eq 'y' -or $confirmation -eq 'yes' -or $confirmation -eq 'Yes') {
        Invoke-WebRequest -Uri $Win10Url -OutFile ".\Template\$Win10FileName" -UseBasicParsing
    }
} `
    else {
    Invoke-WebRequest -Uri $Win10Url -OutFile ".\Template\$Win10FileName" -UseBasicParsing
}

# 1.2. Update the Template 
((Get-Content -path $templateFilePath -Raw) -replace '<subscriptionID>', $subscriptionID) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<rgName>', $imageResourceGroup) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<region>', $location) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<runOutputName>', $runOutputName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<imageName>', $imageName) | Set-Content -Path $templateFilePath
((Get-Content -path $templateFilePath -Raw) -replace '<imgBuilderId>', $identityNameResourceId) | Set-Content -Path $templateFilePath

# 2. Submit the Template
New-AzResourceGroupDeployment -ResourceGroupName $imageResourceGroup -TemplateFile $templateFilePath `
    -api-version "2019-05-01-preview" -imageTemplateName $imageTemplateName -svclocation $location

# 4. Verify the template
Get-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup |
Select-Object -Property Name, LastRunStatusRunState, LastRunStatusMessage, ProvisioningState, ProvisioningErrorMessage

#--------------------------------------------------------------------------------------------------------------------------------------------------
# Build the Image
#--------------------------------------------------------------------------------------------------------------------------------------------------
Start-AzImageBuilderTemplate -ResourceGroupName $imageResourceGroup -Name $imageTemplateName

#--------------------------------------------------------------------------------------------------------------------------------------------------
# Create a VM from the Image
#--------------------------------------------------------------------------------------------------------------------------------------------------

$Cred = Get-Credential 
$ArtifactId = (Get-AzImageBuilderRunOutput -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup).ArtifactId
New-AzVM -ResourceGroupName $imageResourceGroup -Image $ArtifactId -Name myWinVM01 -Credential $Cred -size Standard_D2_v2

#--------------------------------------------------------------------------------------------------------------------------------------------------
# Remove the template deployment
#--------------------------------------------------------------------------------------------------------------------------------------------------

remove-AzImageBuilderTemplate -ImageTemplateName $imageTemplateName -ResourceGroupName $imageResourceGroup


















# Find the publisher, offer and Sku
# To use for the deployment template to identify 
# source marketplace images
# https://www.ciraltos.com/find-skus-images-available-azure-rm/
Get-AzVMImagePublisher -Location $location | where-object { $_.PublisherName -like "*win*" } | ft PublisherName, Location
$pubName = 'MicrosoftWindowsDesktop'
Get-AzVMImageOffer -Location $location -PublisherName $pubName | ft Offer, PublisherName, Location
# Set Offer to 'office-365' for images with O365 
# $offerName = 'office-365'
$offerName = 'Windows-10'
Get-AzVMImageSku -Location $location -PublisherName $pubName -Offer $offerName | ft Skus, Offer, PublisherName, Location
$skuName = '20h1-evd'
Get-AzVMImage -Location $location -PublisherName $pubName -Skus $skuName -Offer $offerName
$version = '19041.572.2010091946'
Get-AzVMImage -Location $location -PublisherName $pubName -Offer $offerName -Skus $skuName -Version $version


