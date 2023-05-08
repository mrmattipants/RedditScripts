$Print3d = DISM /Online /Get-ProvisionedAppxPackages | findstr "Microsoft.Print3D"

If ($Print3d) {
    
    $Print3dPackage = $Print3d[1].split(":")[1].replace(" ", "")

    Dism /Online /Remove-ProvisionedAppxPackage /PackageName:$Print3dPackage

    Write-Host "The Print 3D Microsoft Store App has been Removed from this System" -ForegroundColor Green

} Else {

    Write-Host "The Print 3D Microsoft Store App is not Installed on this System" -ForegroundColor Yellow

}