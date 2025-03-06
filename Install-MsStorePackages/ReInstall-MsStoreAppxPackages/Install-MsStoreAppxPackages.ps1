$ErrorActionPreference = 'SilentlyContinue'

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


# Windows.Photos

If (!(Test-Path "C:\Temp\AppXPackages\WindowsPhotos\Dependencies")) {
    New-item -Path "C:\Temp\AppXPackages\WindowsPhotos\Dependencies" -ItemType Directory
}

Download-AppxPackage -PackageFamilyName Microsoft.Windows.Photos_8wekyb3d8bbwe -Path C:\Temp\AppXPackages\WindowsPhotos

Get-Childitem "C:\Temp\AppXPackages\WindowsPhotos\*.appx" | Move-Item -Destination "C:\Temp\AppXPackages\WindowsPhotos\Dependencies"

Get-ChildItem "C:\Temp\AppXPackages\WindowsPhotos\Dependencies\*" | Sort-Object FullName | Select-Object $_.FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_ -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

$AppPackage = (Get-ChildItem "C:\Temp\AppXPackages\WindowsPhotos\*" | Sort-Object FullName -Descending)[0]

Add-AppxProvisionedPackage -Online -PackagePath $AppPackage.FullName -SkipLicense
#Add-AppxPackage -Path $AppPackage.FullName -Confirm:$False


# WindowsCalculator

If (!(Test-Path "C:\Temp\AppXPackages\WindowsCalculator\Dependencies")) {
    New-item -Path "C:\Temp\AppXPackages\WindowsCalculator\Dependencies" -ItemType Directory
}

Download-AppxPackage -PackageFamilyName Microsoft.WindowsCalculator_8wekyb3d8bbwe -Path C:\Temp\AppXPackages\WindowsCalculator

Get-Childitem "C:\Temp\AppXPackages\WindowsCalculator\*.appx" | Move-Item -Destination "C:\Temp\AppXPackages\WindowsCalculator\Dependencies"

Get-ChildItem "C:\Temp\AppXPackages\WindowsCalculator\Dependencies\*" | Sort-Object FullName | Select-Object $_.FullName | ForEach-Object {

    Add-AppxProvisionedPackage -Online -PackagePath $_ -SkipLicense
    #Add-AppxPackage -Path "$($_.FullName)" -Confirm:$False

}

$AppPackage = (Get-ChildItem "C:\Temp\AppXPackages\WindowsCalculator\*" | Sort-Object FullName -Descending)[0]

Add-AppxProvisionedPackage -Online -PackagePath $AppPackage.FullName -SkipLicense
#Add-AppxPackage -Path $AppPackage.FullName -Confirm:$False

Remove-Item -Path "C:\Temp\AppXPackages" -Recurse -Force -Confirm:$False