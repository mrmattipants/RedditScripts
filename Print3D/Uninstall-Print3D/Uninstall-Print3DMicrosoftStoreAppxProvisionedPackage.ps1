$Print3d = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq "Microsoft.Print3D"}


If ($Print3d) {

    Remove-AppxProvisionedPackage -Online -PackageName $Print3d.PackageName

    Write-Host "The Print 3D Microsoft Store App Package has been Successfully Removed from this System" -ForegroundColor Green

} Else {

    Write-Host "The Print 3D Microsoft Store App Not Found on this System" -ForegroundColor Yellow

}