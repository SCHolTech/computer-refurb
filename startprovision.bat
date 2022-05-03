SET mypath=%~dp0
powershell.exe -ExecutionPolicy Bypass -File %mypath:~0,-1%\setup-stage002.ps1

