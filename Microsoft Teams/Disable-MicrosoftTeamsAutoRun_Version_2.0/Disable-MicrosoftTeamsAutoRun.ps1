
# Kill Teams Process, if Running
$TeamsProcess = (Get-Process -Name "Teams" -ErrorAction SilentlyContinue)
If ($TeamsProcess) {
    $TeamsProcess | Stop-Process
}

# Confirm Teams Process has Exited, before Continuing
if($TeamsProcess.HasExited -or !$TeamsProcess) {

    # Check All JSON Files in Teams AppData Directory for "openAtLogin" Key and Set to "False" (if Set to "True")
    $RoamingFilePath = "$($ENV:APPDATA)\Microsoft\Teams\*.json"
    $RoamingJsonFiles = Get-ChildItem -Path $RoamingFilePath -Force | Select *
    Foreach ($RoamingJsonFile in $RoamingJsonFiles) {
        (Get-Content -Path "$($RoamingJsonFile.FullName)" -ea SilentlyContinue).replace('"openAtLogin":true', '"openAtLogin":false') | Set-Content -Path "$($RoamingJsonFile.FullName)" -Force -Confirm:$false
    }

    # Check All JSON Files in Teams Local Directory for "noAutoStart" Key and Set to "True" (if Set to "False")
    $LocalFilePath = "$($env:LOCALAPPDATA)\Microsoft\Teams\*.json"
    $LocalJsonFiles = Get-ChildItem -Path $LocalFilePath -Force | Select *
    Foreach ($LocalJsonFile in $LocalJsonFiles) {
        (Get-Content -Path "$($LocalJsonFile.FullName)" -ea SilentlyContinue).replace('"noAutoStart":false', '"noAutoStart":true') | Set-Content -Path "$($LocalJsonFile.FullName)" -Force -Confirm:$false
    }

    # Remove Teams AutoRun Registry Key, if it Exists
    $TeamsAutoRun = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -ea SilentlyContinue)."com.squirrel.Teams.Teams"
    if ($TeamsAutoRun) {
        Remove-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Run -Name "com.squirrel.Teams.Teams" -Force -Confirm:$false
    }

    # Re-Launch Teams Application
    Start-Process "$($env:LOCALAPPDATA)\Microsoft\Teams\Update.exe" -ArgumentList "--processStart `"Teams.exe`"" -NoNewWindow -PassThru

}
