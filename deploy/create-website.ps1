Switch-AzureMode -Name AzureServiceManagement

# Authentication
# ======================================================================================

$azureAccount = Get-AzureAccount

if ($azureAccount) {    
    "AzureAccount found: $($azureAccount.Id)"
}
else {
    "AzureAccount not found, opening prompt..."
    $azureAccount = Add-AzureAccount

    If (-Not $azureAccount) {
        "AzureAccount prompt cancelled by user, shutting down..."
        Exit
    }

    "AzureAccount added: $($azureAccount.Id)" 
}

# Create Site
# ======================================================================================
$branchName = $(git symbolic-ref HEAD) -replace "refs/heads/", ""

If (-Not $branchName.StartsWith("feature/","CurrentCultureIgnoreCase")) {
    "Only feature branches can be automated, other branches should already have websites created"
    Exit
}


$urlSafeBranchName = $branchName -replace "feature/", "f/"
$urlSafeBranchName = $urlSafeBranchName -replace "/", "-"
$siteName = "jonoazuretest-$urlSafeBranchName"

"Getting GitHub credentials..."
$ghCredentials = Get-Credential -Message "GitHub login"

"Attempting to create site $siteName..."
New-AzureWebsite -Location "West Europe" -Name $siteName -GithubCredentials $ghCredentials -GithubRepository "jonoward/AzureTest"
"Site $siteName created"

# Hack to fix race condition where the line does not find a resource (assumed)
Start-Sleep -s 1

"Attempting to Change the SKU (pricing plan) and serverFarm (AppServicePlan)..."
Switch-AzureMode AzureResourceManager
$siteResource = Get-AzureResource -Name $siteName -ResourceGroupName DefaultResourceGroup -ResourceType Microsoft.Web/Sites -ApiVersion 2014-04-01

if (-Not $siteResource) {
    "Site resource not found, shutting down..."
    Exit
}

$siteResourceProperties = @{ "sku" = "Standard"; "serverFarm" = "DefaultAppServicePlan"; }
$siteResource = Set-AzureResource -Name $siteName -ResourceGroupName DefaultResourceGroup -ResourceType Microsoft.Web/Sites -ApiVersion 2014-04-01 -UsePatchSemantics -Force -PropertyObject $siteResourceProperties

if (-Not $siteResource) {
    "Site resource not updated, shutting down..."
    Exit
}