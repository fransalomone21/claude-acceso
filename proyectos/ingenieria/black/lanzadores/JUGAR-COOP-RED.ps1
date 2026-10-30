# Jugar BLACK en coop con DOS computadoras en la misma red (o por ZeroTier): cada uno en su maquina, su pantalla y su
# sonido. Es el coop de black-seamless-coop tal cual, por red: no hace falta el puente para separar los mandos.
# Sesion (133). Lo corren Fran y Agustin, uno en cada maquina:
#
#   en la que hostea (la notebook de Fran):
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\JUGAR-COOP-RED.ps1" -Anfitrion
#
#   en la otra (la PC), con la IP que muestra la anfitriona:
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\JUGAR-COOP-RED.ps1" -Unirse 192.168.1.3
#
#   ... -Teclado   # teclado y mouse (y el mando con los botones de Xbox); sin esto: el mando con los botones de PS2
#   ... -Xbox      # el mando con los botones de Xbox, por el puente
#
# Si falta la instalacion en esa maquina, la hace sola (el coop se baja de GitHub con su sha256; la ISO sale de
# C:\Games\BLACK\xbox\iso-redump\Black (USA).zip). Las dos maquinas tienen que tener el MISMO BLACK.exe: lo avisa.

#   ... -Preguntar # pide la IP (recuerda la ultima en ultima-ip.txt): lo usa el acceso "BLACK coop - unirse"
#   ... -Solo      # un jugador, sin coop (el acceso "BLACK solo")

param([switch]$Anfitrion, [string]$Unirse, [switch]$Preguntar, [switch]$Solo, [switch]$Teclado, [switch]$Xbox)

. (Join-Path $PSScriptRoot 'plataforma-comun.ps1')
$ultima = Join-Path $Juego 'ultima-ip.txt'
if ($Preguntar) {
    $previa = if (Test-Path -LiteralPath $ultima) { (Get-Content -LiteralPath $ultima -TotalCount 1).Trim() } else { '' }
    $resp = Read-Host "IP de la maquina que hostea$(if ($previa) { " (Enter = $previa)" })"
    $Unirse = if ($resp) { $resp.Trim() } else { $previa }
    if ($Unirse) { [IO.File]::WriteAllText($ultima, $Unirse) }
}
if (-not $Anfitrion -and -not $Unirse -and -not $Solo) {
    Write-Host "Decime el rol: -Anfitrion (una maquina), -Unirse <IP de la anfitriona> (la otra) o -Solo." -ForegroundColor Red
    exit 1
}
if (-not (Install-Plataforma)) { exit 1 }

$mon = (Get-Monitores)[0].Bounds
Set-Calidad
Set-Toml @{ display_mode = 'borderless'; width = $mon.Width; height = $mon.Height; pause_on_focus_loss = $false }

$red = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' } |
    ForEach-Object { "{0} ({1})" -f $_.IPAddress, $_.InterfaceAlias }
$args_j = @()
if ($Anfitrion) {
    $args_j += @('--coop', 'host')
    Write-Host "ANFITRIONA. Pasale a la otra maquina una de estas IP (la de la misma red; ZeroTier si estan lejos):" -ForegroundColor Green
    $red | ForEach-Object { Write-Host "    $_" }
    $publica = Get-NetConnectionProfile -ErrorAction SilentlyContinue | Where-Object { $_.NetworkCategory -eq 'Public' -and $_.InterfaceAlias -notlike 'ZeroTier*' }
    if ($publica) { Write-Host "AVISO: la red '$($publica.InterfaceAlias)' esta como Publica; si no conectan, cuando Windows pregunte, Permitir." -ForegroundColor Yellow }
} elseif ($Unirse) {
    $args_j += @('--coop', 'join', '--join', $Unirse)
    Write-Host "UNIRSE a $Unirse (puerto UDP 45410). Abri primero el juego en la anfitriona." -ForegroundColor Green
} else {
    Write-Host "UN JUGADOR." -ForegroundColor Green
}

$puente = Join-Path $Black 'herramientas\puente_mandos.py'
$pp = $null
if (-not $Teclado) {
    python -c "import pygame" 2>$null
    if ($LASTEXITCODE -ne 0) { python -m pip install pygame | Out-Null }
    $lista = python $puente --listar 2>&1 | Select-Object -First 1
    if ("$lista" -match '^0 mando') {
        Write-Host "No veo ningun mando prendido: lo abro con teclado y mouse." -ForegroundColor Yellow
        $Teclado = $true
    } else {
        $args_j += @('--coop-control', '45501')
    }
}

$rol = if ($Anfitrion) { 'anfitriona' } elseif ($Unirse) { 'unirse' } else { 'solo' }
$corrida = New-CarpetaCorrida "red-$rol"
$inicio = Get-Date
$p = Start-Process -FilePath $Exe -ArgumentList $args_j -WorkingDirectory $Juego -PassThru
if (-not $Teclado) {
    Start-Sleep -Seconds 3
    $ap = @("`"$puente`"") + $(if ($Xbox) { @('--xbox') } else { @() })
    $pp = Start-Process -FilePath 'python' -ArgumentList $ap -NoNewWindow -PassThru
    Write-Host "Mando con los botones de $(if ($Xbox) { 'Xbox' } else { 'PS2: R1 dispara, L1 apunta, R2 granada, L2 agacharse' }). Sin teclado ni mouse en el juego." -ForegroundColor Green
}
Write-Host "Para terminar, cerra el juego (la cruz o el menu)." -ForegroundColor Green
$n = 0
while (-not $p.HasExited) {
    Start-Sleep -Seconds 60
    if ($p.HasExited) { break }
    $n++
    try { Save-Captura (Join-Path $corrida ("foto-{0:D2}.png" -f $n)) } catch { }
}
if ($pp -and -not $pp.HasExited) { Stop-Process -Id $pp.Id -ErrorAction SilentlyContinue }
Save-Registros $corrida $inicio
"{0}`tRED-{1}`tsalida={2}`tminutos={3}" -f (Get-Date -Format s), $rol, $p.ExitCode, [math]::Round(((Get-Date) - $inicio).TotalMinutes, 1) |
    Out-File -Append -Encoding utf8 (Join-Path $Volcados 'corridas.txt')
Write-Host "Listo. Registro en $corrida" -ForegroundColor Green
