# Restaura las entradas de arranque quitadas el 25/07/2026
# Ejecutar: click derecho -> Ejecutar con PowerShell

Set-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'utweb' -Value "`"C:\Users\frans\AppData\Roaming\uTorrent Web\utweb.exe`" /MINIMIZED"
Set-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'RobloxPlayerBeta' -Value "`"C:\Users\frans\AppData\Local\Roblox\Versions\version-a246b41d05114581\RobloxPlayerBeta.exe`" --launch-to-tray"
Set-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'MicrosoftEdgeAutoLaunch_C88690A44566C89A4284E392C3296312' -Value "`"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe`" --no-startup-window --win-session-start"
Set-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'EpicGamesLauncher' -Value "`"C:\Program Files\Epic Games\Launcher\Portal\Binaries\Win64\EpicGamesLauncher.exe`" -silent -launchcontext=boot"
Set-ItemProperty 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run' -Name 'EADM' -Value "`"C:\Program Files\Electronic Arts\EA Desktop\EA Desktop\EALauncher.exe`" -silentOs"
Write-Host 'Entradas restauradas.' -ForegroundColor Green
Read-Host 'Enter para cerrar'
