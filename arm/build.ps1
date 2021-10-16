

#$rg = "ddd"
$rg = "test-rg"
New-AzResourceGroup -Name $rg -Location eastus -Force


<#
#### 1. create scc-vnet ####
New-AzResourceGroupDeployment `
    -Name 'scc-inline-nested' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\scc0-inline-nested.json' `
    -TemplateParameterFile '.\json\scc0-inline-nested.parameters.json' `
    -Verbose
    #### 1. create scc-vnet ####
New-AzResourceGroupDeployment `
    -Name 'Vnet-and-All' `
    -ResourceGroupName $rg `
    -TemplateFile 'azuredeploy.json' `
    -Verbose
 

#>
<# 
#### 1. create scc-vnet ####
New-AzResourceGroupDeployment `
    -Name 'Winimage' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\sccsingle.json' `
    -TemplateParameterFile '.\json\sccsingle.parameters.json' `
    -Verbose
    
#### 2. create scc-nsg ####
New-AzResourceGroupDeployment `
    -Name 'scc-nsgName' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\scc2nsg.json' `
    -TemplateParameterFile '.\json\scc2nsg.parameters.json' `
    -Verbose


    

#### 3. create scc-pip ####
New-AzResourceGroupDeployment `
    -Name 'scc-pipName' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\scc3pip.json' `
    -TemplateParameterFile '.\json\scc3pip.parameters.json' `
    -Verbose

#### 4. create scc-nif ####
New-AzResourceGroupDeployment `
    -Name 'scc-nifName' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\scc4nif.json' `
    -TemplateParameterFile '.\json\scc4nif.parameters.json' `
    -Verbose


 #>
<# 
#### 5. create scc-lb ####
New-AzResourceGroupDeployment `
    -Name 'scc-lbName' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\scc5lb.json' `
    -TemplateParameterFile '.\json\scc5lb.parameters.json' `
    -Verbose
    
 #>

 
<# 
#### 6. create scc-resources ####
New-AzResourceGroupDeployment `
-Name 'scc-single-6-web' `
-ResourceGroupName $rg `
-TemplateFile 'json\scc6web.json' `
-TemplateParameterFile '.\json\scc6web.parameters.json' `
-Verbose

#>


####
#### Need to generate the above VM
####


#### 8. create Vnet/subnet ####
New-AzResourceGroupDeployment `
    -Name 'Vnet-subnet' `
    -ResourceGroupName $rg `
    -TemplateFile '.\json\1vnet.json' `
    -TemplateParameterFile '.\json\1vnet.parameters.json' `
    -Verbose

#### 7. create a scale set only ####
New-AzResourceGroupDeployment `
    -Name 'ScaleSet' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\20ssonly.json' `
    -TemplateParameterFile '.\json\20ssonly.parameters.json' `
    -Verbose



<# 


#### 8. create scc-ss ####
New-AzResourceGroupDeployment `
    -Name 'scc-midName' `
    -ResourceGroupName $rg `
    -TemplateFile '.\json\scc8mid.json' `
    -TemplateParameterFile '.\json\scc8mid.parameters.json' `
    -Verbose


#### 20. create scc-sa ####
New-AzResourceGroupDeployment `
    -Name 'scc-saName' `
    -ResourceGroupName $rg `
    -TemplateFile '.\json\scc20sa.json' `
    -TemplateParameterFile '.\json\scc20sa.parameters.json' `
    -Verbose
#>


<# 
#### create scc-resources ####
New-AzResourceGroupDeployment `
-Name 'scc-webprocess-james' `
-ResourceGroupName $rg `
-TemplateFile 'json\scctemplate-james.json' `
-TemplateParameterFile '.\json\scctemplate-james.parameters.json' `
-Verbose




#### create vm from image ####
New-AzResourceGroupDeployment `
    -Name 'create-vm-from-image' `
    -ResourceGroupName $rg `
    -TemplateFile 'json\create-vm-from-image.json' `
    -TemplateParameterFile '.\json\create-vm-from-image.parameters.json' `
    -Verbose


#>

    


