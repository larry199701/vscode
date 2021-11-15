


$rg = "test-1-rg"
New-AzResourceGroup -Name $rg -Location eastus -Force
#### 1. create scc-vnet ####
New-AzResourceGroupDeployment `
    -Name 'Network_Test' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\compute\3single-vd-dsc.json' `
    -TemplateParameterFile '.\json\compute\3single-vd-dsc.parameters.json' `
    -Verbose
    



<# 
####
#### Need to generate the above VM
####

#### create vm from image ####
New-AzResourceGroupDeployment `
    -Name 'create-vm-from-image' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\create-vm-from-image.json' `
    -TemplateParameterFile '.\json\create-vm-from-image.parameters.json' `
    -Verbose


#>

    


