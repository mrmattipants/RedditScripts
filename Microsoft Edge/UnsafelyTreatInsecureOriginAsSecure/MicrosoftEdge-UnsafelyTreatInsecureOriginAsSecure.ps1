$Urls = Get-Content -Path "$($PSScriptRoot)\Urls.txt"

$MsEdgePolicyReg = "REGISTRY::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Edge\UnsafelyTreatInsecureOriginAsSecure"

If (-NOT (Test-Path $MsEdgePolicyReg -ErrorAction SilentlyContinue)) {
    New-Item $MsEdgePolicyReg -Force
}

$RegItemCount = (Get-Item $MsEdgePolicyReg).property.count
if ($RegItemCount -ge 1) {
    $RegKeyCount = (Get-Item $MsEdgePolicyReg).property | Select-Object -Last 1

    Foreach ($Url in $Urls) {
        [string]$RegKeyCount = [int]$RegKeyCount + 1
        New-ItemProperty -Path $MsEdgePolicyReg -Name $RegKeyCount -PropertyType String -Value $Url -Force
    }

} Else {

    $RegKeyCount = 0

    Foreach ($Url in $Urls) {
        [string]$RegKeyCount = [int]$RegKeyCount + 1

        New-ItemProperty -Path $MsEdgePolicyReg -Name $RegKeyCount -PropertyType String -Value $Url -Force

    }

}