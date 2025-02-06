<h1>LogOffOnIdle.ps1</h1><br />
<br />

<h2>EVENT LOGS</h2>

The Script will Generate "<b>Application</b>" Event Logs, when a User is Logged-Out<br />
(containing the Date, TIme and Idle Time)<br />
<center><img src="https://i.imgur.com/uZlZYft.png"></center><br />

<h2>GPO CONFIGURATION</h2>

<center><img src="https://i.imgur.com/oIhHVER.png"></center><br />

<b>1.)</b> Under the "<b>User Configuration > Policies > Windows Setting</b>" Select the  "<b>Logon Script</b>" Option.<br />
<center><img src="https://i.imgur.com/AEKlZOk.png"></center><br />

<b>2.)</b> Click on the "<b>Show Files</b>" Button, at the bottom of the "<b>Logon Properties</b>" Window<br />
<center><img src="https://i.imgur.com/WYXjkqN.png"></center><br />

<b>3.)</b> Copy Both the "<b>LogoffOnIdle.ps1</b>" and "<b>RunHidden.exe</b>" Files to the User Logon Scripts Folder<br />
<center><img src="https://i.imgur.com/FLsmJuQ.png"></center><br />

<b>4.)</b> Return to the "<b>Logon Properties</b>" and Click on the "<b>Add</b>" Button<br />
<center><img src="https://i.imgur.com/WokUZ8V.png"></center><br />

<b>5.)</b> When the "<b>Edit Script</b>" Dialog Opens, Type "<b>RunHidden.exe</b>" into the "<b>Script Name</b>" Field<br />
Then Type "<b>LogoffOnIdle.ps1</b>" into the "<b>Script Parameters</b>" Text Field<br />
<center><img src="https://i.imgur.com/N5303F5.png"></center><br />

<b>NOTE</b>: If you plan on Linking the GPO to an OU that contains Computers/Servers,<br />
You may want to consider including a Merge Loopback Policy, as well.<br />
<center><img src="https://i.imgur.com/xRH2PNp.png"></center><br />
