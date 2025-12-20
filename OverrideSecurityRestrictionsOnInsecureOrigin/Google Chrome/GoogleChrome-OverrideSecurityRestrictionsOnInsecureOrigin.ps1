$Urls = @(
'https://[*.]calltrackingmetrics.com/*',
'http://[*.]calltrackingmetrics.com/*',
'https://tenant.sharepoint.com/*',
'https://mytenant.sharepoint.com/*'
)

$GooglePolicyReg = "REGISTRY::HKEY_LOCAL_MACHINE\Software\Policies\Google\Chrome\OverrideSecurityRestrictionsOnInsecureOrigin"

If (-NOT (Test-Path $GooglePolicyReg -ErrorAction SilentlyContinue)) {
    New-Item $GooglePolicyReg -Force
}

$RegItemCount = (Get-Item $GooglePolicyReg).property.count
if ($RegItemCount -ge 1) {
    $RegKeyCount = (Get-Item $GooglePolicyReg).property | Select-Object -Last 1

    Foreach ($Url in $Urls) {
        [string]$RegKeyCount = [int]$RegKeyCount + 1

        New-ItemProperty -Path $GooglePolicyReg -Name $RegKeyCount -PropertyType String -Value $Url -Force

    }

} Else {

    $RegKeyCount = 0

    Foreach ($Url in $Urls) {
        [string]$RegKeyCount = [int]$RegKeyCount + 1

        New-ItemProperty -Path $GooglePolicyReg -Name $RegKeyCount -PropertyType String -Value $Url -Force

    }

}