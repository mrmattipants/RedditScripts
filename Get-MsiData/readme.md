<h1>Get-MsiData.ps1</h1><br />

<b><ins>Importing Function - Method 1</ins></b>:<br />

<code>CD "C:\Path\To\Directory"</code><br /><br />
<code>. .\Get-MsiData.ps1</code><br />

<b><ins>Importing Function - Method 2</ins></b>:<br />

<code>Import-Module -Name "C:\Path\To\Directory\Get-MsiData.ps1"</code><br />

<b><ins>Get-MsiFileMetaData Function - Usage</ins></b>:<br />

<code>$ProgramName = "Esko ArtiosCAD Viewer"</code><br /><br />
<code>$MsiFileInfo = Get-ChildItem -Path "C:\Windows\Installer\\*.msi" | Get-MsiFileMetaData | Where-Object {$_.Authors -like "\*$($ProgramName)\*" -or $_.comments -like "\*$($ProgramName)\*" -or $_.participants -like "\*$($ProgramName)\*" -or $_.subject -like "\*$($ProgramName)\*" -or $_.Title -like "\*$($ProgramName)\*"}</code><br /><br />
<code>$MsiFileInfo</code><br /><br />

<b><ins>Get-MsiProductName Function - Usage</ins></b>:<br />

<code>$ProductName = Get-Item -Path $MsiFileInfo.Path | Get-MsiProductName</code><br /><br />
<code>Write-host "Product Name: $($ProductName)"</code><br /><br />

<b><ins>Get-MsiProductVersion Function - Usage</ins></b>:<br />

<code>$ProductVersion = Get-Item -Path $MsiFileInfo.Path | Get-MsiProductVersion</code><br /><br />
<code>Write-host "Product Version: $($ProductVersion)"</code><br /><br />

<b><ins>Example</ins></b>:<br />

<img src="https://i.imgur.com/wgRNOjM.png"><br />
