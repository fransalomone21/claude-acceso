# Revierte la mudanza y la limpieza del 25/07/2026

Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Autodesk Access Service" -Value '"C:\Program Files\Autodesk\AdODIS\V1\Setup\AdskAccessService.exe" --autoLaunch'
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Autodesk Access" -Value '"C:\Program Files\Autodesk\AdODIS\V1\Access\AdskAccessCore.exe" --minimizedUi --autoLaunch'

$ac = New-ScheduledTaskAction -Execute "C:\Users\frans\OneDrive\Desktop\Programas\ThrottleStop_9.7\ThrottleStop.exe" -WorkingDirectory "C:\Users\frans\OneDrive\Desktop\Programas\ThrottleStop_9.7"
$pr = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest
if (Test-Path "C:\Users\frans\OneDrive\Desktop\Programas\ThrottleStop_9.7.old") { Rename-Item "C:\Users\frans\OneDrive\Desktop\Programas\ThrottleStop_9.7.old" "ThrottleStop_9.7" }
Set-ScheduledTask -TaskName "throttle" -Action $ac -Principal $pr | Out-Null
Write-Host "Revertido. La carpeta C:\ThrottleStop sigue ahi, borrala a mano si queres." -ForegroundColor Green
Read-Host "Enter para cerrar"
