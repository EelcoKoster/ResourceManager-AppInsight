[cmdletbinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Environment,
    [string]$Changeset="latest"
)

function TestAzureWebSite([string]$resourceGroupName, [string]$resourceName) {
    Test-AzureResource  -ResourceGroupName $resourceGroupName -ResourceName $resourceName -ResourceType Microsoft.Web/sites
    $serviceStatus = if($?) {"OK"} else {"Unavailable"}
    Write-Host "ResourceGroup $resourceGroupName; service $resourceName  - status $serviceStatus"
}

#Determine the current location
$ScriptDir = Split-Path -parent $MyInvocation.MyCommand.Path
#the location where the creation templates can be found
$templatePath = $ScriptDir + "\templates"

$EnvironmentLower = $Environment.ToLower().Trim()
$Location = "West Europe"

$ContainerName = $ChangeSet.ToLower()
$DeployUrl = "http://bloblower.blob.core.windows.net/$($ContainerName)/"


#Go into Resoure Manager Mode
Switch-AzureMode -Name AzureResourceManager

#Create ResourceGroup         
$ResourceGroupName = "AppInsight-$Environment" 
New-AzureResourceGroup -Name $ResourceGroupName -Location $Location -Force
$DeploymentName = $ResourceGroupName + "-DeploymentWeb"

$hostingPlanName = "hostingplan" + $EnvironmentLower
$template = $templatePath + "\site.json"
$siteName = "appinsight-" + $EnvironmentLower

#Create Site with Application Insight
New-AzureResourceGroupDeployment -Name $DeploymentName `
-ResourceGroupName $ResourceGroupName -TemplateFile $template -siteName $siteName `
-hostingPlanName $hostingPlanName -siteLocation $Location `
-DeployPackageUri "$($DeployUrl)AppInsightTest.zip"

Write-Host "Ready"

# check deployed artefacts
TestAzureWebSite $ResourceGroupName $siteName                    