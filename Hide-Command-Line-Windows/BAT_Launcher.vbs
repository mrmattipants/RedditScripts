Dim WshShell, strCurDir
Set WshShell = CreateObject("WScript.Shell")
strCurDir    = WshShell.CurrentDirectory
CreateObject("Wscript.Shell").Run """" & strCurDir & "\BATCH_SCRIPT_FILE_NAME.bat" & """" ,0,True
Set WshShell = Nothing