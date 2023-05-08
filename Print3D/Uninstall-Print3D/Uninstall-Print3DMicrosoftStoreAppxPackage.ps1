
If (Get-AppxPackage -Name Microsoft.Print3D -AllUsers) {

        Remove-AppxPackage -Package $Print3DMachine.PackageFullName -AllUsers -Confirm:$False
        
        Write-Host "The Print 3D Microsoft Store App has been Removed from this System" -ForegroundColor Green

} ElseIf (Get-AppxPackage -Name Microsoft.Print3D) {

    Remove-AppxPackage -Package $Print3DUser.PackageFullName -Confirm:$False

    Write-Host "The Print 3D Microsoft Store App has been Removed from this Account" -ForegroundColor Green

} Else {
    
    Write-Host "The Print 3D Microsoft Store App is not Installed on this Account or System" -ForegroundColor Yellow

}