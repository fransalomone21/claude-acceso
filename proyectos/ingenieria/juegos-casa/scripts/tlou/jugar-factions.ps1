# Abre The Last of Us (PS3) para jugar Facciones de a dos contra el servidor de la casa (L0-02, L1-04, L1-15).
# 1) se asegura de que el servidor de la PC este prendido (en la PC lo prende; en la note se lo pide por SSH),
# 2) compara el juego de esta maquina con la referencia (tamano + fecha contra el MD5 medido al instalar),
# 3) abre RPCS3 0.0.43 con la ISO. Lo que hace queda en C:\Games\tlou-factions\jugar.log.
$base = 'C:\Games\tlou-factions'
$iso = 'C:\Games\PS3-ISOs\Last of Us, The (USA) (En,Fr,Es,Pt).iso'
$rpcs3 = 'C:\Games\RPCS3\rpcs3.exe'
$pc = '10.147.20.3'
$log = Join-Path $base 'jugar.log'
function Write-Paso([string]$t) { $l = "{0:HH:mm:ss} {1}" -f (Get-Date), $t; Add-Content -LiteralPath $log $l; Write-Host $l }
function Test-Servidor { $c = New-Object Net.Sockets.TcpClient; try { $c.ConnectAsync($pc, 7320).Wait(2000) -and $c.Connected } catch { $false } finally { $c.Close() } }

Write-Paso "--- jugar Facciones en $env:COMPUTERNAME"
if (-not (Test-Servidor)) {
  Write-Paso 'servidor apagado: lo prendo'
  if ($env:COMPUTERNAME -eq 'PCFRAN') { Start-ScheduledTask -TaskName 'TLOU-servidor' }
  else { ssh -o ConnectTimeout=10 -i (Join-Path $env:USERPROFILE '.ssh\pc-cable') "Fran@$pc" 'schtasks /run /tn TLOU-servidor' | Out-Null }
  $fin = (Get-Date).AddSeconds(40)
  while (-not (Test-Servidor) -and (Get-Date) -lt $fin) { Start-Sleep -Milliseconds 700 }
}
if (-not (Test-Servidor)) { Write-Paso 'ROJO: el servidor de la PC no responde (la PC prendida y con ZeroTier?)'; Read-Host 'Enter para cerrar'; exit 1 }
Write-Paso 'servidor OK'

# L1-15: el MD5 entero tarda ~2 min; se mide al instalar (referencia.txt) y aca se compara que el archivo sea el mismo
$ref = Get-Content (Join-Path $base 'referencia.txt') -ErrorAction SilentlyContinue | ConvertFrom-StringData
$f = Get-Item -LiteralPath $iso -ErrorAction SilentlyContinue
if (-not $f -or -not $ref -or "$($f.Length)" -ne $ref.largo -or $f.LastWriteTimeUtc.ToString('o') -ne $ref.fecha) {
  Write-Paso "ROJO: el juego de esta maquina no es el de referencia (MD5 $($ref.md5)); correr instalar-juego-tlou.ps1"
  Read-Host 'Enter para cerrar'; exit 1
}
Write-Paso "juego OK (MD5 de referencia $($ref.md5))"
Start-Process -FilePath $rpcs3 -ArgumentList '--no-gui', "`"$iso`"" -WorkingDirectory (Split-Path $rpcs3)
Write-Paso 'RPCS3 abierto'
