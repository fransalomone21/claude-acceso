# Deja ESTA maquina lista para jugar BLACK (la plataforma nueva, con el coop), en un solo comando. Sesion (133b).
# Se corre en cada computadora (la notebook y la PC); se puede repetir cuando quieras: no rompe nada.
#
#   git -C "$env:USERPROFILE\Desktop\claude-acceso" pull; powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\PREPARAR-BLACK.ps1"
#
# Que hace: 1) instala el coop y la ISO si faltan (el coop se baja de GitHub con su sha256; la ISO sale de
# C:\Games\BLACK\xbox\iso-redump\Black (USA).zip); 2) controla que el BLACK.exe sea el probado (las dos maquinas
# tienen que tener el mismo); 3) instala pygame para el puente de mandos; 4) elige la calidad grafica segun el
# monitor y la placa de video y la deja guardada; 5) mira la red y el firewall; 6) deja los accesos directos en
# Escritorio\Juegos\BLACK. Al final imprime un resumen.

. (Join-Path $PSScriptRoot 'plataforma-comun.ps1')
$ok = $true
Write-Host "== BLACK: preparando esta maquina ($env:COMPUTERNAME) ==" -ForegroundColor Cyan

# 1-2. instalacion y version
if (-not (Install-Plataforma)) { exit 1 }
Write-Host "[ok] juego y coop en $Juego" -ForegroundColor Green

# 3. el puente de mandos necesita pygame
python -c "import pygame" 2>$null
if ($LASTEXITCODE -ne 0) { python -m pip install pygame 2>&1 | Out-Null; python -c "import pygame" 2>$null }
if ($LASTEXITCODE -eq 0) { Write-Host "[ok] pygame (el puente de mandos)" -ForegroundColor Green }
else { Write-Host "[!!] falta Python o pygame: los mandos van a usar los botones de Xbox (sin puente)" -ForegroundColor Yellow; $ok = $false }

# 4. calidad grafica de esta maquina
$sug, $donde = Get-CalidadSugerida
Save-Calidad $sug
Set-Calidad
Set-Toml @{ display_mode = 'borderless'; fps_counter = $false }
Write-Host "[ok] graficos para $donde : render $($sug.render_percent)%, MSAA $($sug.msaa)x + SMAA, anisotropico 16x, distancia $($sug.draw_distance)x, GTAO, fps al maximo del monitor" -ForegroundColor Green

# 5. red y firewall (no se toca nada: se mira y se dice)
$ips = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } |
    ForEach-Object { "$($_.IPAddress) ($($_.InterfaceAlias))" }
Write-Host "[..] IP de esta maquina: $($ips -join ', ')"
$regla = Get-NetFirewallApplicationFilter -ErrorAction SilentlyContinue | Where-Object { $_.Program -like "$Juego*" }
if ($regla) { Write-Host "[ok] firewall: el juego ya esta permitido" -ForegroundColor Green }
else { Write-Host "[..] firewall: la primera vez que hostees, Windows pregunta: Permitir (redes privadas)" -ForegroundColor Yellow }

# 6. accesos directos
$dest = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Juegos\BLACK'
New-Item -ItemType Directory -Force $dest | Out-Null
$ps = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$w = New-Object -ComObject WScript.Shell
function Acceso([string]$nombre, [string]$script, [string]$extra, [string]$desc) {
    $a = $w.CreateShortcut((Join-Path $dest "$nombre.lnk"))
    $a.TargetPath = $ps
    $a.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$(Join-Path $PSScriptRoot $script)`" $extra".Trim()
    $a.WorkingDirectory = $PSScriptRoot
    $a.IconLocation = "$Exe,0"
    $a.Description = $desc
    $a.Save()
}
Acceso 'BLACK solo'                 'JUGAR-COOP-RED.ps1' '-Solo'       'BLACK de un jugador, con el mando en los botones de PS2'
Acceso 'BLACK coop - hostear'       'JUGAR-COOP-RED.ps1' '-Anfitrion'  'Coop por red: esta maquina hostea; muestra la IP para la otra'
Acceso 'BLACK coop - unirse'        'JUGAR-COOP-RED.ps1' '-Preguntar'  'Coop por red: pide la IP de la que hostea (recuerda la ultima)'
Acceso 'BLACK coop - misma maquina' 'PROBAR-COOP-PC.ps1' ''            'Dos copias en esta maquina, un mando cada una'
Acceso 'BLACK coop - dos pantallas' 'PROBAR-COOP-PC.ps1' '-DosMonitores' 'Dos copias en esta maquina, una por monitor'
Write-Host "[ok] accesos directos en $dest" -ForegroundColor Green

Write-Host ""
if ($ok) { Write-Host "LISTO para jugar." -ForegroundColor Green } else { Write-Host "LISTO, con un aviso arriba." -ForegroundColor Yellow }
"{0}`tPREPARAR`t{1}`t{2}" -f (Get-Date -Format s), $env:COMPUTERNAME, $donde | Out-File -Append -Encoding utf8 (Join-Path $Volcados 'corridas.txt')
