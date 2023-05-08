$Print3D = Get-AppxPackage -Name Microsoft.Print3D -AllUsers

If ($Print3D) {

        Remove-AppxPackage -Package $Print3D.PackageFullName -AllUsers -Confirm:$False
        
        Write-Host "The Print 3D Microsoft Store App has been Removed from this System" -ForegroundColor Green

} Else {
    
    Write-Host "The Print 3D Microsoft Store App is not Installed on this System" -ForegroundColor Yellow

}