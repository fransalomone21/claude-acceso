# Deshace PREPARAR-ACCESO-PC.ps1 en la PC: desinstala OpenSSH, saca la regla del firewall, la llave y el DefaultShell.
# Se corre en la PC como administrador, o desde la notebook: ACCESO-PC.ps1 -Quitar (corta la conexion al terminar).

$ErrorActionPreference = 'Continue'
Stop-Service sshd -ErrorAction SilentlyContinue
Remove-NetFirewallRule -Name 'SSH-por-cable' -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -ErrorAction SilentlyContinue
Remove-Item "$env:ProgramData\ssh\administrators_authorized_keys" -Force -ErrorAction SilentlyContinue
Get-ChildItem 'C:\Users\*\.ssh\authorized_keys' -ErrorAction SilentlyContinue | Where-Object {
    (Get-Content $_.FullName -Raw) -match 'notebook-a-pc-por-cable' } | Remove-Item -Force

$claves = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*', 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
Get-ItemProperty $claves -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like 'OpenSSH*' -and $_.PSChildName -like '{*}' } |
    ForEach-Object { Start-Process msiexec.exe -ArgumentList "/x $($_.PSChildName) /qn /norestart" -Wait }

if (Get-Service sshd -ErrorAction SilentlyContinue) { Write-Host "QUEDO sshd instalado: revisar a mano" -ForegroundColor Red; exit 1 }
Write-Host "LISTO: la PC ya no acepta entradas por SSH." -ForegroundColor Green
