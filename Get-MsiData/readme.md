<h1>Get-MsiData.ps1</h1><br />

After Installing a Program via MSI or EXE (that Extracts an MSI Package), a Copy of that MSI File will be stored in a Hidden Directory (C:\Windows\Installer), for later. When the associated Program is Uninstalled later, it will be this MSI File Copy that will be used to perform the Uninstallation & Cleanup. This is why it is extremely important that you do not delete the Files/Directories that exist in this particular folder.<br />

As you can see in the Screenshot below, this MSI File Copy will typiclly have a Generic Name consisting of Hexidecimal Characters, which can make it difficult to find unless you have certain columns visible (i.e. Authors, Comments, Participants, Subject, Title, etc.) in the Explorer Window.<br /><br />

<img src="https://i.imgur.com/StGujBB.png">

To get around the aforementioned obstacles, I wrote this Script, which contains Three Functions.<br /><br />

- <b>Get-MsiFileMetaData</b><br />
     Can be used to Find the Correct MSI File, using the Program Name or just part of it.<br />
- <b>Get-MsiProductName</b><br />
     Pulls the Program Product Name from the internal MSI Database within the MSI File.<br />
- <b>Get-MsiProductVersion</b><br />
     Pulls the Product Version Number from the internal MSI Database within the MSI File.<br />

<b><ins>Importing Function - Method 1</ins></b>:<br />

<code>CD "C:\Path\To\Directory"</code><br /><br />
<code>. .\Get-MsiData.ps1</code><br />

<b><ins>Importing Function - Method 2</ins></b>:<br />

<code>Import-Module -Name "C:\Path\To\Directory\Get-MsiData.ps1"</code><br />

<b><ins>Get-MsiFileMetaData Function - Usage</ins></b>:<br />

<code>$ProgramName = "Esko ArtiosCAD Viewer"</code><br /><br />
<code>$MsiFileInfo = Get-ChildItem -Path "C:\Windows\Installer\\*.msi" | Get-MsiFileMetaData | Where-Object {$_.Authors -like "\*$($ProgramName)\*" -or $_.comments -like "\*$($ProgramName)\*" -or $_.participants -like "\*$($ProgramName)\*" -or $_.subject -like "\*$($ProgramName)\*" -or $_.Title -like "\*$($ProgramName)\*"}</code><br /><br />
<code>$MsiFileInfo</code><br />

<b><ins>Get-MsiProductName Function - Usage</ins></b>:<br />

<code>$ProductName = Get-Item -Path $MsiFileInfo.Path | Get-MsiProductName</code><br /><br />
<code>Write-host "Product Name: $($ProductName)"</code><br />

<b><ins>Get-MsiProductVersion Function - Usage</ins></b>:<br />

<code>$ProductVersion = Get-Item -Path $MsiFileInfo.Path | Get-MsiProductVersion</code><br /><br />
<code>Write-host "Product Version: $($ProductVersion)"</code><br />

<b><ins>Example</ins></b>:<br />

<img src="https://i.imgur.com/wgRNOjM.png"><br />
