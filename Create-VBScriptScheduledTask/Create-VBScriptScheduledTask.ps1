$taskName = "Enable NIC in the BIOS"
$scriptPath = "C:\Windows\System32\BIOS.vbs `"Onboard Ethernet Controller`" Disabled"
$startTime = "07:30 AM"
$startDate = "05/15/2023"
$taskDescription = "This task will run the vbscript to enable the NIC in the BIOS"

# Create a new scheduled task object
$schedule = New-ScheduledTaskTrigger -Once -At $startTime
$action = New-ScheduledTaskAction -Execute 'C:\Windows\System32\cscript.exe' -Argument $scriptPath
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -RunOnlyIfNetworkAvailable
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
Register-ScheduledTask -TaskName $taskName -Trigger $schedule -Action $action -Settings $settings -Principal $principal -Description $taskDescription
