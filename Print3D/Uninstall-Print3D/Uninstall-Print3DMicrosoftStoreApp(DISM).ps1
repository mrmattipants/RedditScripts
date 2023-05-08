$Print3d = DISM /Online /Get-ProvisionedAppxPackages | findstr "Microsoft.Print3D"

If ($Print3d) {
    
    $Print3dPackage = $Print3d[1].split(":")[1].replace(" ", "")

    Dism /Online /Remove-ProvisionedAppxPackage /PackageName:$Print3dPackage

}