$Print3D = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq "Microsoft.Print3D"}

If (!$Print3D) {

        Add-AppxProvisionedPackage -Online -PackagePath "$($PSScriptRoot)\Microsoft.Print3D_3.3.791.0_neutral_~_8wekyb3d8bbwe.AppxBundle" -DependencyPackagePath "$($PSScriptRoot)\Microsoft.VCLibs.140.00_14.0.30704.0_x64__8wekyb3d8bbwe.Appx" -SkipLicense
        
        Write-Host "The Print 3D Microsoft Store App has been Installed to this System" -ForegroundColor Green

} Else {
    
    Write-Host "The Print 3D Microsoft Store App is already Installed on this System" -ForegroundColor Yellow

}