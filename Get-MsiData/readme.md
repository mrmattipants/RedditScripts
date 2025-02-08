<h1>Get-MsiData.ps1</h1><br />

After Installing a Program via MSI or EXE (that Extracts an MSI Package), a Copy of that MSI File will be stored in a Hidden Directory (**C:\Windows\Installer**), for later. When the associated Program is Uninstalled later, it will be this MSI File Copy that will be used to perform the Uninstallation & Cleanup. This is why it is extremely important that you do NOT delete the Files/Subfolders that exist in this particular Directory. However, you can utilize these MSI Files Uninstall the associated Program and/or to perform various tasks (i.e. as a Detection Method for Scripts, Intune/SCCM, etc.).<br />

As you can see in the Screenshot below, this MSI File Copy will typiclly have a Generic Name consisting of Hexidecimal Characters, which can make it difficult to find unless you have certain columns visible (i.e. Authors, Comments, Participants, Subject, Title, etc.) in the Explorer Window.<br /><br />

<img src="https://i.imgur.com/StGujBB.png">

To get around the aforementioned obstacles, I wrote this Script, which contains Three Functions.<br />

- <b>Get-MsiFileMetaData</b><br />
     Can be used to Find the Correct MSI File, using the Program Name or just part of it.<br />
- <b>Get-MsiProductName</b><br />
     Pulls the Program Product Name from the internal MSI Database within the MSI File.<br />
- <b>Get-MsiProductVersion</b><br />
     Pulls the Product Version Number from the internal MSI Database within the MSI File.<br />

<b><ins>Importing Functions - Method 1</ins></b>:<br />

<code>CD "C:\Path\To\Directory"</code><br /><br />
<code>. .\Get-MsiData.ps1</code><br />

<b><ins>Importing Functions - Method 2</ins></b>:<br />

<code>Import-Module -Name "C:\Path\To\Directory\Get-MsiData.ps1"</code><br />

<b><ins>Using the "Get-MsiFileMetaData" Function</ins></b>:<br />

<code>$ProgramName = "Esko ArtiosCAD Viewer"</code><br /><br />
<code>$MsiFileInfo = Get-ChildItem -Path "C:\Windows\Installer\\*.msi" | Get-MsiFileMetaData | Where-Object {$_.Authors -like "\*$($ProgramName)\*" -or $_.comments -like "\*$($ProgramName)\*" -or $_.participants -like "\*$($ProgramName)\*" -or $_.subject -like "\*$($ProgramName)\*" -or $_.Title -like "\*$($ProgramName)\*"}</code><br /><br />
<code>$MsiFileInfo</code><br />

<b><ins>Using the "Get-MsiProductName" Function</ins></b>:<br />

<code>$ProductName = Get-Item -Path $MsiFileInfo.Path | Get-MsiProductName</code><br /><br />
<code>Write-host "Product Name: $($ProductName)"</code><br />

<b><ins>Using the "Get-MsiProductVersion" Function</ins></b>:<br />

<code>$ProductVersion = Get-Item -Path $MsiFileInfo.Path | Get-MsiProductVersion</code><br /><br />
<code>Write-host "Product Version: $($ProductVersion)"</code><br />

<b><ins>Example</ins></b>:<br />

<img src="https://i.imgur.com/wgRNOjM.png"><br /><br />

<b><ins>Opening the MSI Database & Viewing the Tables/Properties in ORCA</ins></b>:<br />

To Open/View the MSI Database, you can Download & Install the **ORCA** Program, through the following Link.<br />
<a href="https://www.technipages.com/downloads/OrcaMSI.zip">https://www.technipages.com/downloads/OrcaMSI.zip</a><br />

The "**ProductName**" and "**ProductVersion**" Properties (along with many others) can be found under the "**Property**" Table.<br />

* *<b>NOTE</b>: You can only have one instance of the MSI Database Open, at one time. If you try to run the "Get-MsiProductName" and/or "Get-MsiProductVersion" PowerShell Functions, while the MSI Database is Open in Orca, PowerShell will display an Error, until you Close the Orca Instance.* *<br /><br />

**Orca > "Property" Table > "ProductName" Property:**<br />
<img src="https://i.imgur.com/TWphmc3.png"><br />

**Orca > "Property" Table > "ProductVersion" Property:**<br />
<img src="https://i.imgur.com/1JKe0rz.png"><br />

As always, if anyone has any questions or runs into any issues, please feel free to reach out to me, via my Reddit Account.<br />
<a href="https://www.reddit.com/user/mrmattipants/">https://www.reddit.com/user/mrmattipants/</a><br />
