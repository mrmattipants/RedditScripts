
Import Script/Function into PowerShell:

```
Import-Module -name "C:\Path\To\Script\Log-ProjectEvent.ps1"
```

Function Usage Example:

```
$ProjectLog = "$([System.Environment]::GetFolderPath('Desktop'))\Project-Event-Log_$(([DateTime]::today).ToString("yyyyddMM")).json"
$ProjectName = "Project 01"
$ProjectStart = "$([DateTime]::now)"
$ProjectEnd = "$(([DateTime]::now).addSeconds(300))"
$ProjectState = "Running"

Log-ProjectEvent -JsonFilePath $ProjectLog -ProjectName $ProjectName -StartTime $ProjectStart -EndTime $ProjectEnd -CurrentState $ProjectState
```

Output Example (JSON File Contents) - First Entry:

```
{
  "Entries": [
    {
      "ProjectName": "Project 01",
      "StartTime": "12/11/2025 12:40:55",
      "EndTime": "12/11/2025 12:45:55",
      "ElapsedTime": "00:05:00",
      "CurrentState": "Running"
    }
  ]
}
``` 

Output Example (JSON File Contents) - Multiple Entries:

```
{
  "Entries": [
    {
      "ProjectName": "Project 01",
      "StartTime": "12/11/2025 12:40:55",
      "EndTime": "12/11/2025 12:45:55",
      "ElapsedTime": "00:05:00",
      "CurrentState": "Running"
    },
    {
      "ProjectName": "Project 01",
      "StartTime": "12/11/2025 12:51:38",
      "EndTime": "12/11/2025 12:56:38",
      "ElapsedTime": "00:05:00",
      "CurrentState": "Running"
    }
  ]
}
```
