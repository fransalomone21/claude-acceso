# Servidor casero de The Last of Us (PS3) Factions en la PC: backend (comradesean/tlou-factions-server) + RPCN.
# Uso (en la PC, como administrador la primera vez):
#   servidor-tlou.ps1 -Instalar     tarea "TLOU-servidor" a pedido (sin disparador, invisible) + reglas de firewall
#   servidor-tlou.ps1 -Arrancar     arranca lo que no este corriendo (lo usa la tarea y el lanzador del juego)
#   servidor-tlou.ps1 -Parar        para los dos
#   servidor-tlou.ps1 -Estado       que puertos escuchan (sale 0 si estan los 7, 1 si no)
#   servidor-tlou.ps1 -Desinstalar  saca tarea y firewall (la carpeta C:\Games\tlou-factions queda; se borra a mano)
param([switch]$Instalar, [switch]$Arrancar, [switch]$Parar, [switch]$Estado, [switch]$Desinstalar)
$base = 'C:\Games\tlou-factions'
$srv = Join-Path $base 'servidor\server'
$rpcn = Join-Path $base 'rpcn'
$logs = Join-Path $base 'logs'
$py = 'C:\Users\Fran\AppData\Local\Programs\Python\Python312\python.exe'
$tcp = 80, 7312, 7313, 7314, 7320, 31313
$regla = 'TLOU Factions (juegos-casa)'
$tarea = 'TLOU-servidor'

function Get-Escuchando {
  $t = Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object LocalPort -in $tcp | Select-Object -ExpandProperty LocalPort -Unique
  $u = Get-NetUDPEndpoint -ErrorAction SilentlyContinue | Where-Object LocalPort -eq 3657 | Select-Object -ExpandProperty LocalPort -Unique
  @($t) + @($u) | Where-Object { $_ } | Sort-Object -Unique
}

if ($Instalar) {
  Remove-NetFirewallRule -DisplayName $regla -ErrorAction SilentlyContinue
  New-NetFirewallRule -DisplayName $regla -Direction Inbound -Protocol TCP -LocalPort $tcp -Action Allow -Profile Private -RemoteAddress 10.147.20.0/24, 192.168.1.0/24 | Out-Null
  New-NetFirewallRule -DisplayName $regla -Direction Inbound -Protocol UDP -LocalPort 3657 -Action Allow -Profile Private -RemoteAddress 10.147.20.0/24, 192.168.1.0/24 | Out-Null
  $accion = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -Arrancar"
  $quien = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType S4U -RunLevel Limited
  $ajustes = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 0 -AllowStartIfOnBatteries
  Register-ScheduledTask -TaskName $tarea -Action $accion -Principal $quien -Settings $ajustes -Force | Out-Null
  "instalado: tarea $tarea (a pedido) y firewall '$regla'"
  exit 0
}
if ($Desinstalar) {
  & $PSCommandPath -Parar | Out-Null
  Unregister-ScheduledTask -TaskName $tarea -Confirm:$false -ErrorAction SilentlyContinue
  Remove-NetFirewallRule -DisplayName $regla -ErrorAction SilentlyContinue
  "desinstalado: tarea y firewall"
  exit 0
}
if ($Parar) {
  Get-CimInstance Win32_Process | Where-Object { ($_.Name -eq 'rpcn.exe') -or ($_.Name -eq 'python.exe' -and $_.CommandLine -match 'tlou-factions') } |
    ForEach-Object { Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue; "parado $($_.Name) $($_.ProcessId)" }
  exit 0
}
if ($Arrancar) {
  New-Item -ItemType Directory -Force $logs | Out-Null
  $ya = Get-Escuchando
  if (-not ($ya -contains 31313)) {
    Start-Process -FilePath (Join-Path $rpcn 'rpcn.exe') -WorkingDirectory $rpcn -WindowStyle Hidden `
      -RedirectStandardOutput (Join-Path $logs 'rpcn.out.log') -RedirectStandardError (Join-Path $logs 'rpcn.err.log')
  }
  if (-not ($ya -contains 7320)) {
    Start-Process -FilePath $py -ArgumentList "`"$srv\run_all.py`"" -WorkingDirectory $srv -WindowStyle Hidden `
      -RedirectStandardOutput (Join-Path $logs 'backend.out.log') -RedirectStandardError (Join-Path $logs 'backend.err.log')
  }
  $fin = (Get-Date).AddSeconds(20)
  while ((Get-Date) -lt $fin -and (Get-Escuchando).Count -lt 7) { Start-Sleep -Milliseconds 500 }
}
$e = @(Get-Escuchando)
"escuchando: $($e -join ', ') ($($e.Count) de 7)"
if ($e.Count -lt 7) { exit 1 }
exit 0
