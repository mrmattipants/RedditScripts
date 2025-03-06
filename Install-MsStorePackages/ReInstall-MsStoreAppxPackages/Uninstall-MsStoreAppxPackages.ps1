$ErrorActionPreference = 'SilentlyContinue'

$FamilyPackageNames = $("Microsoft.Windows.Photos_8wekyb3d8bbwe","Microsoft.WindowsCalculator_8wekyb3d8bbwe")

$FamilyPackageNames | Foreach-Object {

    $PackageName = ($_ -Split "_")[0]

    $MsStoreAppxBundle = (Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq "$($PackageName)"})

    If ($MsStoreAppxBundle) {

        $MsStoreAppxBundle | Remove-AppxProvisionedPackage -Online
        
        Write-Host "The $($MsStoreAppxBundle.DisplayName) Microsoft Store Package has been Successfully Unprovisioned on this System" -ForegroundColor Green

    } Else {
    
        Write-Host "The $($MsStoreAppxBundle.DisplayName) Microsoft Store Package Package has Not been Provisioned on this System" -ForegroundColor Yellow

    }

    $MsStoreAppxAllUsers = Get-AppxPackage -Name "$($PackageName)" -AllUsers

    If ($MsStoreAppxAllUsers) {

        $MsStoreAppxAllUsers | Remove-AppxPackage -AllUsers
        
        Write-Host "The $($MsStoreAppxAllUsers.Name) Microsoft Store Package has been Successfully Removed for All Users" -ForegroundColor Green
            
    } Else {

        Write-Host "The $($MsStoreAppxAllUsers.Name) Microsoft Store Package is Not Installed for All Users" -ForegroundColor Yellow

    }

    $MsStoreAppxCurrentUser = Get-AppxPackage -Name "$($PackageName)"

    If ($MsStoreAppxCurrentUser) {

        $MsStoreAppxCurrentUser | Remove-AppxPackage
        
        Write-Host "The $($MsStoreAppxCurrentUser.Name) Microsoft Store Package has been Successfully Removed for this User" -ForegroundColor Green
            
    } Else {

        Write-Host "The $($MsStoreAppxCurrentUser.Name) Microsoft Store Package is Not Installed for this User" -ForegroundColor Yellow

    }

}