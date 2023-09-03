
# Kill Teams Process, if Running
$TeamsProcess = (Get-Process -Name "Teams" -ErrorAction SilentlyContinue)
If ($TeamsProcess) {
    $TeamsProcess | Stop-Process
}

# Confirm Teams Process has Exited, before Continuing
if ($TeamsProcess.HasExited -or !$TeamsProcess) {

    # Update setup.json File, by Setting "noAutoStart" to "True"
    (Get-Content $env:LOCALAPPDATA\Microsoft\Teams\setup.json -ea SilentlyContinue).replace('"noAutoStart":false', '"noAutoStart":true') | Set-Content $env:LOCALAPPDATA\Microsoft\Teams\setup.json

    # Update desktop-config.json File, by Setting "openAtLogin" to "False"
    (Get-Content $ENV:APPDATA\Microsoft\Teams\desktop-config.json -ea SilentlyContinue).replace('"openAtLogin":true', '"openAtLogin":false') | Set-Content $ENV:APPDATA\Microsoft\Teams\desktop-config.json

    # Update storage.json File, by Setting "openAtLogin" to "False"
    (Get-Content $ENV:APPDATA\Microsoft\Teams\storage.json -ea SilentlyContinue).replace('"openAtLogin":true', '"openAtLogin":false') | Set-Content $ENV:APPDATA\Microsoft\Teams\storage.json

    # Remove Teams AutoRun Registry Key, if it Exists
    $TeamsAutoRun = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -ea SilentlyContinue)."com.squirrel.Teams.Teams"
    if ($TeamsAutoRun) {
        Remove-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name "com.squirrel.Teams.Teams" -Force -Confirm:$false
    }

    # Re-Launch Teams Application
    Start-Process "$($env:LOCALAPPDATA)\Microsoft\Teams\Update.exe" -ArgumentList "--processStart `"Teams.exe`"" -NoNewWindow -PassThru

}
