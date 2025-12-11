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
