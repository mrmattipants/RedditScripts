
# Check if Teams is Running
$TeamsProcess = (Get-Process -Name "Teams" -ErrorAction SilentlyContinue)

# Kill Teams Process, if Running
If ($TeamsProcess) {
    
    $TeamsProcess | Stop-Process

}

if ($TeamsProcess.HasExited -or !$TeamsProcess) {

    (Get-Content $env:LOCALAPPDATA\Microsoft\Teams\setup.json -ea SilentlyContinue).replace('"noAutoStart":false', '"noAutoStart":true') | Set-Content $env:LOCALAPPDATA\Microsoft\Teams\setup.json

    (Get-Content $ENV:APPDATA\Microsoft\Teams\desktop-config.json -ea SilentlyContinue).replace('"openAtLogin":true', '"openAtLogin":false') | Set-Content $ENV:APPDATA\Microsoft\Teams\desktop-config.json

    (Get-Content $ENV:APPDATA\Microsoft\Teams\storage.json -ea SilentlyContinue).replace('"openAtLogin":true', '"openAtLogin":false') | Set-Content $ENV:APPDATA\Microsoft\Teams\storage.json

    $TeamsAutoRun = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -ea SilentlyContinue)."com.squirrel.Teams.Teams"
    
    if ($TeamsAutoRun) {
        
        Remove-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name "com.squirrel.Teams.Teams" -Force -Confirm:$false
    
    }

    Start-Process "$($env:LOCALAPPDATA)\Microsoft\Teams\Update.exe" -ArgumentList "--processStart `"Teams.exe`"" -NoNewWindow -PassThru

}


