
$DomainUserKeys = (Get-ChildItem "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" | Where-Object {$_.Property -eq "Guid"}).Name 

ForEach ($UserKey in $DomainUserKeys) {
    
    $ProfileFolder = Get-ItemPropertyValue "Registry::$($UserKey)" -Name ProfileImagePath

    $ProfilePath = Test-Path $ProfileFolder

    If ($ProfilePath -eq $False) {

        Write-Host `n
        
        Remove-Item "Registry::$($UserKey)" -Recurse -Confirm:$False -Force -WhatIf
        
        Write-Host `n"Profile Folder `"$($ProfileFolder)`" Not Found." -ForegroundColor Red
        Write-Host "Registry Key `"$($UserKey)`" Removed."`n -ForegroundColor Red

    }

}