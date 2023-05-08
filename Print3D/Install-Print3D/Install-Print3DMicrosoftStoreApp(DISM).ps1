$Print3d = DISM /Online /Get-ProvisionedAppxPackages | findstr "Microsoft.Print3D"

If (!$Print3D) {

    DISM.EXE /Online /Add-ProvisionedAppxPackage /PackagePath:"$($PSScriptRoot)\Microsoft.Print3D_3.3.791.0_neutral_~_8wekyb3d8bbwe.AppxBundle" /DependencyPackagePath:"$($PSScriptRoot)\Microsoft.VCLibs.140.00_14.0.30704.0_x64__8wekyb3d8bbwe.Appx" /SkipLicense

    Write-Host "The Print 3D Microsoft Store App has been Successfully Installed" -ForegroundColor Green

} Else {

    Write-Host "The Print 3D Microsoft Store App is already Installed" -ForegroundColor Yellow

}