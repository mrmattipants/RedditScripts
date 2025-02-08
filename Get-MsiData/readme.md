<h1>Get-MsiData.ps1</h1><br />

<b><ins>Importing Function - Method 1</ins></b>:<br />

<code>CD "C:\Path\To\Directory"</code><br /><br />
<code>. .\Get-MSIMetaData.ps1</code><br />

<b><ins>Importing Function - Method 2</ins></b>:<br />

<code>Import-Module -Name "C:\Path\To\Directory\Get-MSIMetaData.ps1"</code><br />

<b><ins>Usage</ins></b>:<br />

<code>$ProgramName = "ConnectWise"</code><br /><br />
<code>Get-ChildItem -Path "C:\Windows\Installer\\*.msi" | Get-FileMetaData | Where-Object {$_.Authors -like "\*$($ProgramName)\*" -or $_.comments -like "\*$($ProgramName)\*" -or $_.participants -like "\*$($ProgramName)\*" -or $_.subject -like "\*$($ProgramName)\*" -or $_.Title -like "\*$($ProgramName)\*"}</code><br />

<b><ins>Output</ins></b>:<br />

<img src="https://i.imgur.com/RIPf5NX.png"><br />
