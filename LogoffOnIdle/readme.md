<h1>LogOffOnIdle.ps1</h1><br />
<br />

<h2>EVENT LOGS</h2>

The Script will create "Application" Event Logs, when a User is Logged-Out<br />
(containing the Date, TIme and Idle Time)<br />
<center><img src="https://i.imgur.com/uZlZYft.png"></center><br />

<h2>GPO CONFIGURATION</h2>

<center><img src="https://i.imgur.com/oIhHVER.png"></center><br />

<b>Under the "User Configuration > Policies > Windows Setting" Select the  "Logon Script" Option</b><br />
<center><img src="https://i.imgur.com/AEKlZOk.png"></center><br />

<b>Click on the "Show Files" Button, at the bottom of the "Logon Properties" Window</b><br />
<center><img src="https://i.imgur.com/WYXjkqN.png"></center><br />

<b>Copy Both the "LogoffOnIdle.ps1" and "RunHidde.exe" Files to the User Logon Scripts Folder</b><br />
<center><img src="https://i.imgur.com/FLsmJuQ.png"></center><br />

<b>Return to the "Logon Properties" and Click on the "Add" Button</b><br />
<center><img src="https://i.imgur.com/wwhWjdQ.png"></center><br />

<b>When the "Edit Script" Dialog Opens, Type "RunHidden.exe" into the "Script Name" Field</b><br />
<b>Then Type "LogoffOnIdle.ps1" into the "Script Parameters" Text Field</b><br />
<center><img src="https://i.imgur.com/N5303F5.png"></center><br />
<b>If you plan on Linking the GPO to an OU that contains Computers/Servers,</b><br />
<b>You may want to include a Merge Loopback Policy</b><br />
<center><img src="https://i.imgur.com/xRH2PNp.png"></center><br />
