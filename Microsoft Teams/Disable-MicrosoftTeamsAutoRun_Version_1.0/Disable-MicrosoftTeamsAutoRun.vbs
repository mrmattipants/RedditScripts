Dim WshShell, strCurDir
Set WshShell = CreateObject("WScript.Shell")
strCurDir    = WshShell.CurrentDirectory
WshShell.Run Chr(34) & strCurDir & "\Disable-MicrosoftTeamsAutoRun.bat" & Chr(34),0,True
Set WshShell = Nothing