# Spike S2 de (133): dos personas en la MISMA PC, cada una con su mando, con black-seamless-coop.
# Lo corre Fran, DESPUES de S1 (la primera vez el juego compila; dos copias compilando a la vez se pisarian).
#
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\PROBAR-COOP-PC.ps1"
#   ... -Control     # S2a: sin el puente; lo que trae el coop tal cual (solo la ventana con el foco lee mandos)
#   ... -Cruzar      # control del puente: mando 1 a la copia 2 y mando 2 a la copia 1
#
# Que hace: abre dos copias en ventana, una al lado de la otra (la 1 es la anfitriona, la 2 se une sola), y el puente
# que le da a cada copia SU mando aunque la ventana este atras. Con el puente no hay teclado ni mouse en el juego:
# todo con los mandos. Para terminar: cerrar las dos ventanas.

param([switch]$Control, [switch]$Cruzar)

. (Join-Path $PSScriptRoot 'plataforma-comun.ps1')
if (-not (Test-Instalacion)) { exit 1 }
if (-not (Test-Path -LiteralPath (Join-Path $Juego 'logs\black.log'))) {
    Write-Host "Primero S1 (PROBAR-PLATAFORMA-S1.ps1): la primera vez el juego compila, y dos copias a la vez se pisan." -ForegroundColor Red
    exit 1
}
$puente = Join-Path $Black 'herramientas\puente_mandos.py'
if (-not $Control) {
    python -c "import pygame" 2>$null
    if ($LASTEXITCODE -ne 0) { python -m pip install pygame | Out-Null }
    $lista = python $puente --listar 2>&1 | Select-Object -First 1
    if ("$lista" -notmatch '^[2-9] mando') {
        Write-Host "Hacen falta DOS mandos prendidos y conectados (ahora: $lista). Prendelos y volve a correr esto." -ForegroundColor Red
        exit 1
    }
}

Set-Toml @{ display_mode = 'windowed'; width = 960; height = 1080; fps_counter = $true; pause_on_focus_loss = $false }
$nombre = if ($Control) { 's2a-control' } elseif ($Cruzar) { 's2b-cruzado' } else { 's2b' }
$corrida = New-CarpetaCorrida $nombre
$inicio = Get-Date

$a1 = @('--instance', '1', '--coop', 'host')
$a2 = @('--instance', '2', '--coop', 'join', '--join', '127.0.0.1', '--mute')
if (-not $Control) { $a1 += @('--coop-control', '45501'); $a2 += @('--coop-control', '45502') }
Write-Host "S2: abriendo la copia 1 (anfitriona)..." -ForegroundColor Cyan
$p1 = Start-Process -FilePath $Exe -ArgumentList $a1 -WorkingDirectory $Juego -PassThru
Start-Sleep -Seconds 10
Write-Host "S2: abriendo la copia 2 (se une a la 1)..." -ForegroundColor Cyan
$p2 = Start-Process -FilePath $Exe -ArgumentList $a2 -WorkingDirectory $Juego -PassThru

# Las dos ventanas lado a lado: la 1 a la izquierda, la 2 a la derecha.
if (-not ('Win133' -as [type])) {
    Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public static class Win133 { [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr a, int x, int y, int cx, int cy, uint f); [DllImport("user32.dll")] public static extern bool SetProcessDPIAware(); }'
}
[Win133]::SetProcessDPIAware() | Out-Null
foreach ($par in @(@($p1, 0), @($p2, 960))) {
    for ($i = 0; $i -lt 30 -and $par[0].MainWindowHandle -eq 0; $i++) { Start-Sleep -Milliseconds 500; $par[0].Refresh() }
    if ($par[0].MainWindowHandle -ne 0) { [Win133]::SetWindowPos($par[0].MainWindowHandle, [IntPtr]::Zero, $par[1], 0, 960, 1080, 0x0044) | Out-Null }
}

$pp = $null
if (-not $Control) {
    $args_p = @("`"$puente`"") + $(if ($Cruzar) { @('--cruzar') } else { @() })
    $pp = Start-Process -FilePath 'python' -ArgumentList $args_p -NoNewWindow -PassThru
    Write-Host "Puente de mandos andando: mando 1 -> ventana izquierda, mando 2 -> ventana derecha$(if ($Cruzar) { ' (CRUZADO)' })." -ForegroundColor Green
}
Write-Host "Jueguen. La copia 1 elige la mision; la 2 la sigue sola. Para terminar, cierren las dos ventanas." -ForegroundColor Green

$n = 0
while (-not ($p1.HasExited -and $p2.HasExited)) {
    Start-Sleep -Seconds 30
    $n++
    try { Save-Captura (Join-Path $corrida ("foto-{0:D2}.png" -f $n)) } catch { }
    if (-not $Control) { python $puente --estado 2>&1 | Out-File -Append -Encoding utf8 (Join-Path $corrida 'estado.txt') }
}
if ($pp -and -not $pp.HasExited) { Stop-Process -Id $pp.Id -ErrorAction SilentlyContinue }
Save-Registros $corrida $inicio
Copy-Item -Path (Join-Path $Black 'volcados\puente\*.log') -Destination $corrida -ErrorAction SilentlyContinue
$min = [math]::Round(((Get-Date) - $inicio).TotalMinutes, 1)
$etiqueta = if ($Control) { 'S2a' } else { 'S2b' }
"{0}`t{1}`tsalidas={2},{3}`tminutos={4}`tfotos={5}" -f (Get-Date -Format s), $etiqueta, $p1.ExitCode, $p2.ExitCode, $min, $n |
    Out-File -Append -Encoding utf8 (Join-Path $Volcados 'corridas.txt')
Write-Host ("S2 listo: {0} min, {1} fotos. Avisale a Claude." -f $min, $n) -ForegroundColor Green
