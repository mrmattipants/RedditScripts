# How long before Logging User Off?
# Alternative Options:
# * -Seconds 10 ( = 10 Seconds)
# * -Minutes 10 ( = 10 Minutes)
# * -Hours 10 ( = 10 Hours)

$idle_timeout = New-TimeSpan -Minutes 10

#Function to Format ComputerName based on Domain/Workgroup Membership
function ComputerHostname
{ 
    If ($env:userdnsdomain -eq $null) 
    {
        $Hostname = "$env:computername"
    } Else {
        $Hostname = "$env:computername.$env:userdnsdomain"
    }
    Return $Hostname
}

#Function to Format ComputerName based on Domain/Workgroup Membership
function DomainUsername
{ 
    If ($env:userdnsdomain -eq $null) 
    {
        $Username = "$env:username"
    } Else {
        $Username = "$env:userdomain\$env:username"
    }
    Return $Username
}

#Function to Generate Timestamp from Current Date
function GenerateDateTimestamp 
{
    Return [DateTime]::Now.toString("M/d/yyyy")
}

#Function to Generate Timestamp from Current Date & Time
function GenerateTimeTimestamp 
{
    Return [DateTime]::Now.toString("h:mm:ss tt")
}

#Function to Generate Timestamp from Current Date & Time
function GenerateTimestamp 
{
    Return [DateTime]::Now.toString("M/d/yyyy h:mm:ss tt")
}

#Function to Build Info Event
function CreatePsInfoEvent ($EvtId,$EvtLog,$EvtSource,$EvtParam1,$EvtParam2,$EvtParam3)
{

    #Load the event source to the log if not already loaded.
    if ([System.Diagnostics.EventLog]::SourceExists($EvtSource) -eq $false) 
    {
        [System.Diagnostics.EventLog]::CreateEventSource($EvtSource, $EvtLog)
    }

    #Create Event Instance
    $Id = New-Object System.Diagnostics.EventInstance($EvtId,1); #INFORMATION EVENT
    
    #Create Event Log Entry
    $EvtObject = New-Object System.Diagnostics.EventLog;
    $EvtObject.Log = $EvtLog;
    $EvtObject.Source = $EvtSource;
    $EvtObject.WriteEvent($Id,@($EvtParam1,$EvtParam2,$EvtParam3))

}

#Define Event Log parameters
$EventSource = "PowerShell Script (LogoffOnIdle.ps1)"
$EventLog = "Application"

# Log User Sign On Event
$InfoEventId = 0
CreatePsInfoEvent $InfoEventId $EventLog $EventSource "INFO: User $(DomainUsername) Signed into $(ComputerHostname) at $(GenerateTimeTimestamp) on $(GenerateDateTimestamp)" "$(ComputerHostname)" "$(GenerateTimestamp)"

# C-Sharp Snippet to Check Usr Idle Time
Add-Type @'
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace PInvoke.Win32 {

    public static class UserInput {

        [DllImport("user32.dll", SetLastError=false)]
        private static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

        [StructLayout(LayoutKind.Sequential)]
        private struct LASTINPUTINFO {
            public uint cbSize;
            public int dwTime;
        }

        public static DateTime LastInput {
            get {
                DateTime bootTime = DateTime.UtcNow.AddMilliseconds(-Environment.TickCount);
                DateTime lastInput = bootTime.AddMilliseconds(LastInputTicks);
                return lastInput;
            }
        }

        public static TimeSpan IdleTime {
            get {
                return DateTime.UtcNow.Subtract(LastInput);
            }
        }

        public static int LastInputTicks {
            get {
                LASTINPUTINFO lii = new LASTINPUTINFO();
                lii.cbSize = (uint)Marshal.SizeOf(typeof(LASTINPUTINFO));
                GetLastInputInfo(ref lii);
                return lii.dwTime;
            }
        }
    }
}
'@

# Set LogOff Variable to 0 (FALSE)
$LogOff = 0;

do {
	# How Long has User been Idle?
	$idle_time = [PInvoke.Win32.UserInput]::IdleTime;


	# If User is NOT Logged Off, but Idle Time is longer than Allowed, Log User Off
	if (($LogOff -eq 0) -And ($idle_time -gt $idle_timeout)) {

        # Log User Sign Off Event
        $InfoEventId = 1
        CreatePsInfoEvent $InfoEventId $EventLog $EventSource "INFO: User $(DomainUsername) was Signed Out of $(ComputerHostname) at $(GenerateTimeTimestamp) on $(GenerateDateTimestamp), after being Idle for $($idle_time)" "$(ComputerHostname)" "$(GenerateTimestamp)"
		
        # Run Command to Log User Off
		Logoff

		# Set LogOff Variable to 1 (TRUE)
		$LogOff = 1;
	}

	# If User is Idle for Less than the Allowed Time, User is Logged On
	if ($idle_time -lt $idle_timeout) {
		$LogOff = 0;
	}

	# Sleep for 10 Seconds between Checks
    Start-Sleep -Seconds 10
}
while ($LogOff -eq 0)

EXIT 0