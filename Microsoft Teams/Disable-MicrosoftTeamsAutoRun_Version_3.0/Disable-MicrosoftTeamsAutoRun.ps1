# !!! THIS SCRIPT NEEDS TO BE RUN IN USER SCOPE !!!

# Start Logging in Temp folder (env:TMP)
# -------------------------------------------------------
# System Scope: C:\Windows\Temp
#  User  Scope: C:\Users\%USERNAME%\AppData\Local\Temp   <---
# -------------------------------------------------------
Start-Transcript -Path "${env:TMP}\Teams_Autostart_Disable_$(Get-Date -Format yyyy-MM-dd_HH-mm-ss).log"

###################################
#            Variables            #
###################################

# Do not change, this variable is needed to determine if a file was changed
$fileChanged = $false

# Key and Value that need to be changed in Json files in AppData\Local
$LocalKey = "noAutoStart"
$LocalValue = $true

# Key and Value that need to be changed in Json files in AppData\Roaming
$RoamingKey = "openAtLogin"
$RoamingValue = $false

# Path to the Registry Key that needs to be deleted
$RegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$RegistryName = "com.squirrel.Teams.Teams"


###################################
#            FUNCTIONS            #
###################################

# Recursive Function to process json objects
Function Process-JsonObject([PSCustomObject]$jsonObj, [String]$keyToModify, [boolean]$newValue)
{
    # Loop over each Key-Value-Pair in the JSON Object
    # If the Key is the one specified, we change the Value, everything else stays the same
    ForEach ($property in $jsonObj.PSObject.Properties)
    {
        # We log every Object we touch, in case something crashes
        Write-Output "        Property: $($property.Name)"
        $value = $property.Value
        If ($value -is [boolean] -And $property.Name -eq $keyToModify -And $value -ne $newValue)
        {
            # only modify the boolean value if the key is the one we are searching for
            Write-Output "        Value: $value"
            $property.Value = $newValue
            Write-Output "        ---> New Value: $newValue"
            $global:fileChanged = $true
        }
        ElseIf ($value -eq $null -Or 
            $value -is [String] -Or 
            $value -is [char] -Or 
            $value -is [int] -Or 
            $value -is [long] -Or 
            $value -is [byte] -Or 
            $value -is [float] -Or 
            $value -is [double] -Or 
            $value -is [decimal] -Or 
            $value -is [boolean]
        )
        {
            # If Value is a simple data type, it should stay the same
            # But still, every Object should be logged
            Write-Output "        Value: $value"
            Write-Output "        ---> Value not changed"
        }
        ElseIf ($value -is [PSCustomObject])
        {
            # The value is a JSON Object which needs to be parsed itself
            Write-Output "        Value is an PSCustomObject, start processing it"
            Process-JsonObject $value $keyToModify $newValue
        }
        ElseIf ($value -is [Array])
        {
            # The Value is an Array, which again could contain compositive data type objects, so we need to parse it, too
            Write-Output "        Value is an Array, start processing it"
            Process-Array $value $keyToModify $newValue
        }
        Else 
        {
            # The value has an unexpected type
            Write-Output "        Value is of unexpected type! Abort!"
            Stop-Transcript
            Exit 1
        }
        Write-Output "        Finished Processing $($property.Name)"
    }
}


# Recursive Helper function to Process Arrays inside of the Json Objects
Function Process-Array([array]$array, [String]$keyToModify, [boolean]$newValue)
{
    # Loop over each Item in the Array
    ForEach ($item in $array)
    {
        # Items in the Array could also be compositive data types. We need to process those
        If ($item -is [PSCustomObject])
        {
            Write-Output "        Array contains PSCustomObject, start processing it"
            Process-JsonObject $item $keyToModify $newValue
        }
        ElseIf ($item -is [array])
        {
            Write-Output "        Array contains Array. Start processing it"
            Process-Array $item $keyToModify $newValue
            Write-Output "Finished processing Array"
        }
        ElseIf ($item -eq $null -Or 
            $item -is [String] -Or 
            $item -is [char] -Or 
            $item -is [int] -Or 
            $item -is [long] -Or 
            $item -is [byte] -Or 
            $item -is [float] -Or 
            $item -is [double] -Or 
            $item -is [decimal] -Or 
            $item -is [boolean]
        )
        {
            # If Item is of a simple data type, it just stays the same
            # Still, we log every Object we touch
            Write-Output "        Item: $item"
        }
        Else
        {
            # The Item has an unexpected data type
            Write-Output "        Item is of unexpected type! Abort!"
            Stop-Transcript
            Exit 1
        }
    }
}


# Function to process all JSON Files from a given Path
Function Process-Files([String]$JsonFilePath, [String]$keyToModify, [boolean]$newValue)
{
    Write-Output ""
    Write-Output "$($JsonFilePath)"
    Write-Output "-------------------------"
    $JsonFiles = Get-ChildItem -Path $(Join-Path ${JsonFilePath} "*.json") -Force | Select *
    
    ForEach ($JsonFile in $JsonFiles)
    {
        # For each file we want to know if changes were made
        $Global:fileChanged = $false
        
        Write-Output "    Processing '$($JsonFile.Name)'"
        Try
        {
            $JsonContent = Get-Content -Path "$($JsonFile.FullName)" -ErrorAction SilentlyContinue | ConvertFrom-Json
            Process-JsonObject $JsonContent $keyToModify $newValue
            
            If ($global:fileChanged)
            {
                Write-Output "    Data from file '$($JsonFile.Name)' was changed"
                Write-Output "    Save original file..."
                Try
                {
                    Copy-Item -Path "$($JsonFile.FullName)" -Destination "$($JsonFile.FullName)_orig_$(Get-Date -Format yyyyMMdd_HHmmss)"
                    Write-Output "    File saved!"
                }
                Catch
                {
                    Write-Output "    Could not save original config file! Abort!"
                    Stop-Transcript
                    Exit 1
                }
                
                # Convert back to JSON. Depth parameter is necessary, because default is 2. 100 is max
                $JsonString = $JsonContent | ConvertTo-Json -Depth 100
                Try
                {
                    Write-Output "    Write changed content to file..."
                    $JsonString | Set-Content -Path "$($JsonFile.FullName)" -Force -Confirm:$false
                }
                Catch
                {
                    Write-Output "    Could not write content back to file! Abort!"
                    Stop-Transcript
                    Exit 1
                }
            }
            Else
            {
                Write-Output "    No config changed in this file!"
            }
            Write-Output "    Finished processing file '$($JsonFile.Name)'"
        }
        Catch
        {
            Write-Output "    An Error occured while processing file '$($JsonFile.Name)'! Abort!"
            Stop-Transcript
            Exit 1
        }
        
        Write-Output ""
    }
}


###################################
#            Main Code            #
###################################

# Check if run in User Scope
If (${env:USERNAME} -eq "SYSTEM")
{
    Write-Output "Script is run from system scope. Abort!"
    Stop-Transcript
    exit 1
}
# The following is only executed if script runs in user scope


# Check if Teams is installed
Write-Output "Check if Teams is installed for current User"
$isInstalled = Test-Path "${env:LOCALAPPDATA}\Microsoft\Teams\Update.exe"


If ($isInstalled)
{
    Write-Output "Teams is installed. Check if running."
    
    
    # Kill Teams Process, if running
    $TeamsProcess = (Get-Process -Name "Teams" -ErrorAction SilentlyContinue)
    If ($TeamsProcess)
    {
        Write-Output "Teams is running. Try to stop process"
        Try
        {
            $TeamsProcess | Stop-Process
            Write-Output "Teams Process stopped."
        }
        Catch
        {
            Write-Output "Could not stop MS Teams Process! Abort!"
            Stop-Transcript
            Exit 1
        }
    }
    
    
    # Confirm Teams Process has Exited, before Continuing
    If ($TeamsProcess.HasExited -or !$TeamsProcess)
    {
        # Check All JSON Files in Teams AppData Directory for "openAtLogin" Key and Set to "False" (if Set to "True")
        Write-Output "Teams Process not running, start processing .json files in AppData Directory"
        Process-Files "${env:APPDATA}\Microsoft\Teams\" $RoamingKey $RoamingValue
        
        
        Write-Output ""
        
        
        # Check All JSON Files in Teams Local Directory for "noAutoStart" Key and Set to "True" (if Set to "False")
        Write-Output "Start processing .json files in Teams Local Directory"
        Process-Files "${env:LOCALAPPDATA}\Microsoft\Teams\" $LocalKey $LocalValue
        
        
        # Remove Teams AutoRun Registry Key, if it Exists
        Write-Output "Check if AutoRun Registry Value is present"
        $TeamsAutoRun = (Get-ItemProperty $RegistryPath -ea SilentlyContinue).$RegistryName
        If ($TeamsAutoRun)
        {
            Try
            {
                Write-Output "Registry Value is present, attempt to delete."
                Remove-ItemProperty $RegistryPath -Name $RegistryName -Force -Confirm:$false
                Write-Output "Deleted the following Registry Value: "
                Write-Output "    Path:  $($RegistryPath)"
                Write-Output "    Name:  $($RegistryName)"
                Write-Output "    Value: $($TeamsAutoRun)"
            }
            Catch
            {
                Write-Output "Could not delete Registry Value! Abort!"
                Stop-Transcript
                Exit 1
            }
        }
        Else
        {
            Write-Output "Registry Value not present."
        }
        
        
        # Re-Launch Teams Application
        Write-Output "Try to start Teams Process again."
        Try
        {
            Start-Process "${env:LOCALAPPDATA}\Microsoft\Teams\Update.exe" -ArgumentList "--processStart `"Teams.exe`"" -NoNewWindow -PassThru
            Write-Output "Restarted Teams Process"
        }
        Catch
        {
            # Do not Fail if Teams process does not start. Change was applied
            Write-Output "Could not restart Teams Process, but Config was applied"
        }
        Finally
        {
            # Change was applied, even if Teams did not restart. Exit Code is Zero
            Stop-Transcript
            Exit 0
        }
    }
    Else
    {
        Write-Output "Teams Process still running. Abort!"
        Stop-Transcript
        Exit 1
    }
}
Else
{
    Write-Output "Teams is not installed for current user. Nothing to do!"
    Stop-Transcript
    Exit 0
}
