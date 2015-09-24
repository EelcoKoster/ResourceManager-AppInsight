[cmdletbinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Environment
)

#Determine the current location
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
$EnvironmentLower = $Environment.ToLower().Trim()
$Location = "West Europe"
$ResourceGroupName = "AppInsight-$Environment" 
$DeploymentName = $ResourceGroupName + "-DeploymentWeb"
$template = $ScriptDir + "\AppInsight.json"
$siteName = "appinsight-" + $EnvironmentLower

#Go into Resoure Manager Mode
Switch-AzureMode -Name AzureResourceManager

#Create ResourceGroup         
New-AzureResourceGroup -Name $ResourceGroupName -Location $Location -Force

#Create Site with Application Insight
New-AzureResourceGroupDeployment -Name $DeploymentName `
-ResourceGroupName $ResourceGroupName -TemplateFile $template -siteName $siteName `
-siteLocation $Location               
