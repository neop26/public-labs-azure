## Get key data
$publicKeyPath = "azvm_key.pub"
$sshKey = Get-Content $publicKeyPath
$secureSSHKey = ConvertTo-SecureString $sshKey -AsPlainText -Force

$privateKeyPath = "azvm_key" # Optional if you want to connect to the VM after deployment

## Deploy to Azure
$resourceGroupName = "test-rg"
$resourceGroupLocation = "australiaeast"
$userName = "asamuel"
New-AzResourceGroup -Name $resourceGroupName -Location $resourceGroupLocation
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile ./main.bicep -adminUsername $userName -adminPasswordOrKey $secureSSHKey
$hostName = (Get-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName).outputs.hostname.value

## Adding slight delay
Start-Sleep 5

## Connect to the vm
ssh -i $privateKeyPath $userName@$hostName