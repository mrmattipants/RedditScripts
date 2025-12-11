Function Log-ProjectEvent {
      [CmdletBinding()]
      Param (
           [String]$JsonFilePath,
           [String]$ProjectName,
           [String]$CurrentState,
           [DateTime]$StartTime,
           [DateTime]$EndTime
     )

    If ($StartTime -and $EndTime) {
       $ElapseTimeTicks = $EndTime.Ticks - $StartTime.Ticks
       $ElapseTimeSpan = New-Object TimeSpan($ElapseTimeTicks)

       $ElapsedTime = $ElapseTimeSpan.ToString("hh\:mm\:ss")

   }

   if (-not (Test-Path $JsonFilePath)) {
        $ProjectData  = [PSCustomObject]@{
            Entries = @(
                @{
                    ProjectName = $ProjectName
                    StartTime = "$($StartTime)"
                    EndTime = "$($EndTime)"
                    ElapsedTime = "$($ElapsedTime)"
                    CurrentState = $CurrentState
                }
            )
        }
 
        $ProjectJson = $ProjectData | ConvertTo-Json

        $ProjectJson | Set-Content -Path $JsonFilePath

        Return $ProjectJson

    } Else {

        $ProjectData  = [PSCustomObject]@{
            ProjectName = $ProjectName
            StartTime = "$($StartTime)"
            EndTime = "$($EndTime)"
            ElapsedTime = "$($ElapsedTime)"
            CurrentState = $CurrentState
        }

        $JsonFileData = Get-Content -Path $JsonFilePath -Raw | ConvertFrom-Json

        $JsonFileData.Entries += $ProjectData

        $JsonFileData | ConvertTo-Json | Set-Content -Path $JsonFilePath 

    }

}
For testing purposes, I simply use the Current Date/Time for the $StartTime and Add 5 Minutes (300 Seconds) to it, for the $EndTime.
$ProjectLog = "$([System.Environment]::GetFolderPath('Desktop'))\Project-Event-Log_$(([DateTime]::today).ToString("yyyyddMM")).json"
$ProjectName = "Project 01"
$ProjectStart = "$([DateTime]::now)"
$ProjectEnd = "$(([DateTime]::now).addSeconds(300))"
$ProjectState = "Running"

Log-ProjectEvent -JsonFilePath $ProjectLog -ProjectName $ProjectName -StartTime $ProjectStart -EndTime $ProjectEnd -CurrentState $ProjectState
The JSON File Contents will appear as follows.
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
