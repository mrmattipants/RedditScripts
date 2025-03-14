﻿$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'

function Download-AppxPackage {
[CmdletBinding()]
param (
  [string]$PackageFamilyName,
  [string]$Path
)
  process {
    $WebResponse = Invoke-WebRequest -Method 'POST' -Uri 'https://store.rg-adguard.net/api/GetFiles' -Body "type=PackageFamilyName&url=$($PackageFamilyName)&ring=Retail&lang=en-US" -ContentType 'application/x-www-form-urlencoded' -UseBasicParsing
    $LinksMatch = $WebResponse.Links | where {$_ -match '.*(_x64|_neutral).*.(\.appx|\.appxbundle|\.msixbundle).*'} | Select-String -Pattern '(?<=a href=").+(?=" r)'
    $DownloadLinks = @($LinksMatch.matches.Value)

    for ($i = 1; $i -le $DownloadLinks.Count; $i++) {
      $Filename = $LinksMatch[$i-1] -replace '.*?>([^<]*).*', '$1'
      Invoke-WebRequest -Uri $DownloadLinks[$i-1] -OutFile "$($Path)\$($Filename)"   
    }
  }
}

Remove-Item -Path "C:\Temp\AppXPackages" -Recurse -Force -Confirm:$False

# WindowsStore

If (!(Test-Path "C:\Temp\AppXPackages\WindowsStore\Dependencies")) {
    New-item -Path "C:\Temp\AppXPackages\WindowsStore\Dependencies" -ItemType Directory
}

Download-AppxPackage -PackageFamilyName Microsoft.WindowsStore_8wekyb3d8bbwe -Path C:\Temp\AppXPackages\WindowsStore

Get-Childitem "C:\Temp\AppXPackages\WindowsStore\*.appx" | Move-Item -Destination "C:\Temp\AppXPackages\WindowsStore\Dependencies"

Get-ChildItem "C:\Temp\AppXPackages\WindowsStore\Dependencies\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Get-ChildItem "C:\Temp\AppXPackages\WindowsStore\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Remove-Item -Path "C:\Temp\AppXPackages\WindowsStore" -Recurse -Force -Confirm:$False

# StorePurchaseApp

If (!(Test-Path "C:\Temp\AppXPackages\StorePurchaseApp\Dependencies")) {
    New-item -Path "C:\Temp\AppXPackages\StorePurchaseApp\Dependencies" -ItemType Directory
}

Download-AppxPackage -PackageFamilyName Microsoft.StorePurchaseApp_8wekyb3d8bbwe -Path C:\Temp\AppXPackages\StorePurchaseApp

Get-Childitem "C:\Temp\AppXPackages\StorePurchaseApp\*.appx" | Move-Item -Destination "C:\Temp\AppXPackages\StorePurchaseApp\Dependencies"

Get-ChildItem "C:\Temp\AppXPackages\StorePurchaseApp\Dependencies\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Get-ChildItem "C:\Temp\AppXPackages\StorePurchaseApp\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Remove-Item -Path "C:\Temp\AppXPackages\StorePurchaseApp" -Recurse -Force -Confirm:$False

# DesktopAppInstaller

If (!(Test-Path "C:\Temp\AppXPackages\DesktopAppInstaller\Dependencies")) {
    New-item -Path "C:\Temp\AppXPackages\DesktopAppInstaller\Dependencies" -ItemType Directory
}

Download-AppxPackage -PackageFamilyName Microsoft.DesktopAppInstaller_8wekyb3d8bbwe -Path C:\Temp\AppXPackages\DesktopAppInstaller

Get-Childitem "C:\Temp\AppXPackages\DesktopAppInstaller\*.appx" | Move-Item -Destination "C:\Temp\AppXPackages\DesktopAppInstaller\Dependencies"

Get-ChildItem "C:\Temp\AppXPackages\DesktopAppInstaller\Dependencies\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Get-ChildItem "C:\Temp\AppXPackages\DesktopAppInstaller\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Remove-Item -Path "C:\Temp\AppXPackages\DesktopAppInstaller" -Recurse -Force -Confirm:$False


# XboxIdentityProvider

If (!(Test-Path "C:\Temp\AppXPackages\XboxIdentityProvider\Dependencies")) {
    New-item -Path "C:\Temp\AppXPackages\XboxIdentityProvider\Dependencies" -ItemType Directory
}

Download-AppxPackage -PackageFamilyName Microsoft.XboxIdentityProvider_8wekyb3d8bbwe -Path C:\Temp\AppXPackages\XboxIdentityProvider

Get-Childitem "C:\Temp\AppXPackages\XboxIdentityProvider\*.appx" | Move-Item -Destination "C:\Temp\AppXPackages\XboxIdentityProvider\Dependencies"

Get-ChildItem "C:\Temp\AppXPackages\XboxIdentityProvider\Dependencies\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Get-ChildItem "C:\Temp\AppXPackages\XboxIdentityProvider\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Remove-Item -Path "C:\Temp\AppXPackages\XboxIdentityProvider" -Recurse -Force -Confirm:$False


# Windows.Photos

If (!(Test-Path "C:\Temp\AppXPackages\WindowsPhotos\Dependencies")) {
    New-item -Path "C:\Temp\AppXPackages\WindowsPhotos\Dependencies" -ItemType Directory
}

Download-AppxPackage -PackageFamilyName Microsoft.Windows.Photos_8wekyb3d8bbwe -Path C:\Temp\AppXPackages\WindowsPhotos

Get-Childitem "C:\Temp\AppXPackages\WindowsPhotos\*.appx" | Move-Item -Destination "C:\Temp\AppXPackages\WindowsPhotos\Dependencies"

Get-ChildItem "C:\Temp\AppXPackages\WindowsPhotos\Dependencies\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Get-ChildItem "C:\Temp\AppXPackages\WindowsPhotos\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Remove-Item -Path "C:\Temp\AppXPackages\WindowsPhotos" -Recurse -Force -Confirm:$False


# WindowsCalculator

If (!(Test-Path "C:\Temp\AppXPackages\WindowsCalculator\Dependencies")) {
    New-item -Path "C:\Temp\AppXPackages\WindowsCalculator\Dependencies" -ItemType Directory
}

Download-AppxPackage -PackageFamilyName Microsoft.WindowsCalculator_8wekyb3d8bbwe -Path C:\Temp\AppXPackages\WindowsCalculator

Get-Childitem "C:\Temp\AppXPackages\WindowsCalculator\*.appx" | Move-Item -Destination "C:\Temp\AppXPackages\WindowsCalculator\Dependencies"

Get-ChildItem "C:\Temp\AppXPackages\WindowsCalculator\Dependencies\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Get-ChildItem "C:\Temp\AppXPackages\WindowsCalculator\*" | Sort-Object FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_.FullName -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

Remove-Item -Path "C:\Temp\AppXPackages" -Recurse -Force -Confirm:$False
