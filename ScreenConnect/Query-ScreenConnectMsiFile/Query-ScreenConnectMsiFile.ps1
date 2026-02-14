
Function Query-ScreenconnectProductName {
    param (
        [parameter(Mandatory=$true, ValueFromPipeline)] 
        [ValidateNotNullOrEmpty()] 
            [System.IO.FileInfo] $MSIPATH
    ) 
    if (!(Test-Path $MSIPATH.FullName)) { 
        throw "File '{0}' does not exist" -f $MSIPATH.FullName 
    } 
    try { 
        $WindowsInstaller = New-Object -com WindowsInstaller.Installer 
        $Database = $WindowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $Null, $WindowsInstaller, @($MSIPATH.FullName, 0)) 
        $NameQuery = "SELECT Value FROM Property WHERE Property = 'ProductName'"
        $View = $database.GetType().InvokeMember("OpenView", "InvokeMethod", $Null, $Database, ($NameQuery)) 
        $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null) | Out-Null
        $Record = $View.GetType().InvokeMember( "Fetch", "InvokeMethod", $Null, $View, $Null ) 
        $Version = $Record.GetType().InvokeMember( "StringData", "GetProperty", $Null, $Record, 1 ) 
        return $Version
    } catch { 
        throw "Failed to get MSI Product Name: {0}." -f $_
    }       
}

Function Query-ScreenConnectProductVersion {
    param (
        [parameter(Mandatory=$true, ValueFromPipeline)] 
        [ValidateNotNullOrEmpty()] 
            [System.IO.FileInfo] $MSIPATH
    ) 
    if (!(Test-Path $MSIPATH.FullName)) { 
        throw "File '{0}' does not exist" -f $MSIPATH.FullName 
    } 
    try { 
        $WindowsInstaller = New-Object -com WindowsInstaller.Installer 
        $Database = $WindowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $Null, $WindowsInstaller, @($MSIPATH.FullName, 0)) 
        $VersionQuery = "SELECT Value FROM Property WHERE Property = 'ProductVersion'"
        $View = $database.GetType().InvokeMember("OpenView", "InvokeMethod", $Null, $Database, ($VersionQuery)) 
        $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null) | Out-Null
        $Record = $View.GetType().InvokeMember( "Fetch", "InvokeMethod", $Null, $View, $Null ) 
        $Version = $Record.GetType().InvokeMember( "StringData", "GetProperty", $Null, $Record, 1 ) 
        return $Version
    } catch { 
        throw "Failed to get MSI Product Version: {0}." -f $_
    }       
}

Function Query-ScreenConnectLaunchParameters {
    param (
        [parameter(Mandatory=$true, ValueFromPipeline)] 
        [ValidateNotNullOrEmpty()] 
            [System.IO.FileInfo] $MSIPATH
    ) 
    if (!(Test-Path $MSIPATH.FullName)) { 
        throw "File '{0}' does not exist" -f $MSIPATH.FullName 
    } 
    try { 
        $WindowsInstaller = New-Object -com WindowsInstaller.Installer 
        $Database = $WindowsInstaller.GetType().InvokeMember("OpenDatabase", "InvokeMethod", $Null, $WindowsInstaller, @($MSIPATH.FullName, 0)) 
        $LaunchParamQuery = "SELECT Value FROM Property WHERE Property = 'SERVICE_CLIENT_LAUNCH_PARAMETERS'"
        $View = $database.GetType().InvokeMember("OpenView", "InvokeMethod", $Null, $Database, ($LaunchParamQuery)) 
        $View.GetType().InvokeMember("Execute", "InvokeMethod", $Null, $View, $Null) | Out-Null
        $Record = $View.GetType().InvokeMember( "Fetch", "InvokeMethod", $Null, $View, $Null ) 
        $Version = $Record.GetType().InvokeMember( "StringData", "GetProperty", $Null, $Record, 1 ) 
        return $Version
    } catch { 
        throw "Failed to get MSI Service Client Launch Parameters: {0}." -f $_
    }       
}

Function Query-ScreenConnectMsiFile {

    Add-Type -AssemblyName System.Windows.Forms

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = [Environment]::GetFolderPath('Desktop')
    $OpenFileDialog.Filter = "Windows Installer (*.msi)|*.msi"
    $OpenFileDialog.Title = "Select MSI File"

    $result = $OpenFileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {

        $selectedFile = $OpenFileDialog.FileName
        $MsiFile = Get-Item -Path $selectedFile
    
        $ProductName = $MsiFile | Query-ScreenconnectProductName
        $ProductVersion = $MsiFile | Query-ScreenconnectProductVersion
        $LaunchParameters = $MsiFile | Query-ScreenconnectLaunchParameters

        $ScreenConnectMsiData = [PSCustomObject]@{
            Identifier = $ProductName.split(" ",3)[2].replace("(","").replace(")","")
            ProductName = $ProductName
            Version = $ProductVersion
            LaunchParameters = $LaunchParameters
        }

        Return $ScreenConnectMsiData

    } 

}

Query-ScreenConnectMsiFile | Format-List