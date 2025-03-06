@echo off

powershell.exe -ExecutionPolicy ByPass -File "%~dp0Uninstall-MsStoreAppxPackages.ps1"

PAUSE