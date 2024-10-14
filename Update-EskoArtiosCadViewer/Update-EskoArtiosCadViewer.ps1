
#App Registry Variables
$AppName = "Esko ArtiosCAD Viewer"
$RegPath = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall","HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall")

#Query Registry for Existing App Installation. If App is Found, Uninstall it.
$App = (Get-ChildItem -Path $RegPath -ErrorAction SilentlyContinue | Get-ItemProperty | Where-Object {$_.DisplayName -eq $AppName})

If ($App) {
    Try {
        $UninstallString = $App.UninstallString -split " "
        Start-Process -FilePath "$($UninstallString[0])" -ArgumentList "$($UninstallString[1]) /passive /norestart" -Wait
        Write-Host "Esko ArtiosCAD Viewer $($App.DisplayVersion) Uninstall Successful." -ForegroundColor Green
    } 
    Catch {
        Write-Host "Esko ArtiosCAD Viewer $($App.DisplayVersion) Uninstall Failed. Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

#App Download/Installer Variables
$InstallerUrl = "https://mysoftware.esko.com/public/downloads/Free/ArtCadViewer/Latest/Windows"
$OutputPath = "C:\DSS-SETUP\INSTALL\Artios Viewer"
$OutputFileName = "ArtiosViewer.exe"

#Check if Download Path Exists. If Path is NOT Found, Create it.
If (!$OutputPath) {
    Try {
        New-Item $OutputPath -ItemType Directory -Force -Confirm:$False
        Write-Host "Download Folder Path Creation Successful." -ForegroundColor Green
    }
    Catch {
        Write-Host "Download Folder Path Creation Failed. Error: $($_.Exception.Message)" -ForegroundColor Red
    }
} Else {
    Write-Host "Download Folder Path Confirmation Successful." -ForegroundColor Green
}

#Download Installation File to Download Path.
Try {
    Invoke-RestMethod -uri $InstallerUrl -Method GET -OutFile "$($OutputPath)\$($OutputFileName)"
    Write-Host "Esko ArtiosCAD Viewer Download Successful." -ForegroundColor Green
}
Catch {
    Write-Host "Esko ArtiosCAD Viewer Download Failed. Error: $($_.Exception.Message)" -ForegroundColor Red
}

#Execute App Installer File & Complate Installation
$FileVersion = (Get-Item "$($OutputPath)\$($OutputFileName)").VersionInfo.ProductVersion
Try {
    Start-Process -FilePath $OutputFileName -WorkingDirectory $OutputPath -ArgumentList "/s /v`"/passive /norestart`"" -Wait
    Write-Host "Esko ArtiosCAD Viewer $($FileVersion) Install Successful" -ForegroundColor Green
}
Catch {
    Write-Host "Esko ArtiosCAD Viewer $($FileVersion) Install Failed. Error: $($_.Exception.Message)" -ForegroundColor Red
}

EXIT 0