# Spike S2 de (133): dos personas en la MISMA PC, cada una con su mando, con black-seamless-coop.
# Lo corre Fran, DESPUES de S1 (la primera vez el juego compila; dos copias compilando a la vez se pisarian).
#
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\PROBAR-COOP-PC.ps1"
#   ... -Control     # S2a: sin el puente; lo que trae el coop tal cual (solo la ventana con el foco lee mandos)
#   ... -Cruzar      # control del puente: mando 1 a la copia 2 y mando 2 a la copia 1
#   ... -Xbox        # los botones de Xbox tal cual (por defecto, los de PS2 que Fran usaba: R1 dispara, L1 apunta...)
#   ... -Mudo        # la copia 2 sin sonido (por defecto suenan las dos: cada uno escucha su arma)
#   ... -DosMonitores # con un monitor enchufado a la notebook: la copia 1 ocupa la pantalla de la notebook y la 2
#                       el monitor, cada una entera (si hay un solo monitor, vuelve a lado a lado)
#   ... -ArribaAbajo  # (138) pantalla partida arriba/abajo (la 1 arriba, la 2 abajo), como en consola: para la tele
#
# Que hace: abre dos copias en ventana, una al lado de la otra (la 1 es la anfitriona, la 2 se une sola), y el puente
# que le da a cada copia SU mando aunque la ventana este atras. Con el puente no hay teclado ni mouse en el juego:
# todo con los mandos. Para terminar: cerrar las dos ventanas.

#   ... -Carpeta <dir> -Etiqueta <nombre>  # (135c) otra carpeta del juego (la de prueba de un parche: PROBAR-PARCHE-COOP.ps1)

param([switch]$Control, [switch]$Cruzar, [switch]$Xbox, [switch]$Mudo, [switch]$DosMonitores, [switch]$ArribaAbajo, [string]$Carpeta, [string]$Etiqueta)

. (Join-Path $PSScriptRoot 'plataforma-comun.ps1')
if ($Carpeta) { $Script:Juego = $Carpeta; $Script:Exe = Join-Path $Carpeta 'BLACK.exe'; $Script:Toml = Join-Path $Carpeta 'black.toml'; $Script:Calidad = Join-Path $Carpeta 'calidad.toml' }
if (-not (Test-Instalacion)) { exit 1 }
if (-not $Carpeta -and -not (Test-Path -LiteralPath (Join-Path $Juego 'logs\black.log'))) {
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

# La calidad de esta maquina (PREPARAR-BLACK.ps1); el render se fija abajo, segun el alto de cada ventana.
Set-Calidad

# Donde va cada ventana: partida en la pantalla principal (lado a lado o arriba/abajo), o una por monitor.
$pantallas = Get-Monitores
$b1 = $pantallas[0].Bounds
if ($DosMonitores -and $pantallas.Count -lt 2) {
    Write-Host "Veo un solo monitor: van lado a lado. Enchufa el monitor y volve a correrlo para tener una ventana por pantalla." -ForegroundColor Yellow
    $DosMonitores = $false
}
if ($DosMonitores) {
    $b2 = $pantallas[1].Bounds
    $lugares = @(@($b1.X, $b1.Y, $b1.Width, $b1.Height), @($b2.X, $b2.Y, $b2.Width, $b2.Height))
    $alto = $b1.Height
    Set-Toml @{ display_mode = 'windowed'; width = $b1.Width; height = $b1.Height; fps_counter = $true; pause_on_focus_loss = $false }
} elseif ($ArribaAbajo) {
    # (138) la pantalla ENTERA: las ventanas van sin borde y encima de la barra de tareas (abajo, al acomodarlas)
    $mitad = [int]($b1.Height / 2)
    $lugares = @(@($b1.X, $b1.Y, $b1.Width, $mitad), @($b1.X, ($b1.Y + $mitad), $b1.Width, ($b1.Height - $mitad)))
    $alto = $mitad
    Set-Toml @{ display_mode = 'windowed'; width = $b1.Width; height = $mitad; fps_counter = $true; pause_on_focus_loss = $false }
} else {
    $mitad = [int]($b1.Width / 2)
    $lugares = @(@($b1.X, $b1.Y, $mitad, $b1.Height), @(($b1.X + $mitad), $b1.Y, ($b1.Width - $mitad), $b1.Height))
    $alto = $b1.Height
    Set-Toml @{ display_mode = 'windowed'; width = $mitad; height = $b1.Height; fps_counter = $true; pause_on_focus_loss = $false }
}
# (138) El render es un % del lado de la ventana (port: render_percent, 20..200, escala ancho y alto). Cada copia apunta
# a 3840x1080 = 4 147 200 pixeles internos: las dos juntas son UN cuadro 4K, que en la notebook (RTX 4060 Laptop) dio
# 60 fps las dos (medido arriba/abajo en 1080p: 1920x540 al 200 %). Lado a lado en 1080p (960x1080) tambien da 200 %
# (1920x2160, los mismos pixeles); en una tele 4K, 100 %. Con dos monitores, 100 % (sin medir mas que eso).
$ancho = $lugares[0][2]
$render = [int][Math]::Min(200, [Math]::Max(100, 5 * [Math]::Round(20 * [Math]::Sqrt(4147200 / ($ancho * $alto)))))
if ($DosMonitores) { $render = 100 }
# Lado a lado el juego no baja de 4:3: en 960x1080 dibuja 960x720 con franjas negras (medido (138)), y al 200 % la
# anfitriona cayo a 34 fps con la placa al 100 %. Al 150 % lo visible ya son 1080 lineas.
if (-not $ArribaAbajo -and -not $DosMonitores) { $render = [Math]::Min($render, 150) }
Set-Toml @{ render_percent = $render }
# (138) Partida en una pantalla = la tele: tope de 60 cuadros. Con la tele en "Duplicar" el juego tomaba los 144 Hz de la
# notebook y corria a 144 (medido) con la placa al 86 % para una tele que muestra 60. El juego original iba a 30.
if (-not $DosMonitores) { Set-Toml @{ fps_cap = 60 } }
# (138) Y MSAA 2x en vez de 4x: al 150-200 % la imagen ya esta sobremuestreada, y el fuego y el humo (lo que hace pegar
# bajones, Fran) cuestan por pixel y por muestra. SMAA sigue prendido.
if (-not $DosMonitores) { Set-Toml @{ msaa = 2 } }
Write-Host ("Render: {0} % de cada ventana ({1}x{2} -> {3}x{4} internos)." -f $render, $ancho, $alto, [int]($ancho * $render / 100), [int]($alto * $render / 100)) -ForegroundColor Cyan
$nombre = if ($Etiqueta) { $Etiqueta } elseif ($Control) { 's2a-control' } elseif ($Cruzar) { 's2b-cruzado' } else { 's2b' }
$corrida = New-CarpetaCorrida $nombre
$inicio = Get-Date

$a1 = @('--instance', '1', '--coop', 'host')
# (133) con --mute J2 no escuchaba su propia arma: la copia 1 la toca como un disparo de lejos. Por defecto suenan las dos.
$a2 = @('--instance', '2', '--coop', 'join', '--join', '127.0.0.1')
if ($Mudo) { $a2 += '--mute' }
if (-not $Control) { $a1 += @('--coop-control', '45501'); $a2 += @('--coop-control', '45502') }
Write-Host "S2: abriendo la copia 1 (anfitriona)..." -ForegroundColor Cyan
$p1 = Start-Process -FilePath $Exe -ArgumentList $a1 -WorkingDirectory $Juego -PassThru
Start-Sleep -Seconds 10
Write-Host "S2: abriendo la copia 2 (se une a la 1)..." -ForegroundColor Cyan
$p2 = Start-Process -FilePath $Exe -ArgumentList $a2 -WorkingDirectory $Juego -PassThru

# Cada ventana a su lugar: la 1 a la izquierda (o la notebook), la 2 a la derecha (o el monitor).
# (138) Partidas en una pantalla: sin borde ni barra de titulo (WS_CAPTION | WS_THICKFRAME fuera) y siempre encima
# (HWND_TOPMOST), asi tapan la barra de tareas y entre las dos ocupan la pantalla entera. Con dos monitores, como antes.
if (-not ('Win138' -as [type])) {
    Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public static class Win138 { [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr a, int x, int y, int cx, int cy, uint f); [DllImport("user32.dll")] public static extern bool SetProcessDPIAware(); [DllImport("user32.dll")] public static extern int GetWindowLong(IntPtr h, int i); [DllImport("user32.dll")] public static extern int SetWindowLong(IntPtr h, int i, int v); [DllImport("user32.dll")] public static extern IntPtr FindWindow(string c, string t); [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n); }'
}
# La barra de tareas es «siempre encima» y gana igual (medido (138)): se esconde mientras juegan y vuelve al cerrar.
# Si una corrida anterior murio sin devolverla, este mismo lanzador la devuelve al abrir (y al cerrar).
$barra = [Win138]::FindWindow('Shell_TrayWnd', $null)
[Win138]::ShowWindow($barra, 5) | Out-Null
[Win138]::SetProcessDPIAware() | Out-Null
$procs = @($p1, $p2)
for ($k = 0; $k -lt 2; $k++) {
    $pr = $procs[$k]; $l = $lugares[$k]
    for ($i = 0; $i -lt 30 -and $pr.MainWindowHandle -eq 0; $i++) { Start-Sleep -Milliseconds 500; $pr.Refresh() }
    if ($pr.MainWindowHandle -eq 0) { continue }
    $h = $pr.MainWindowHandle
    if ($DosMonitores) {
        [Win138]::SetWindowPos($h, [IntPtr]::Zero, $l[0], $l[1], $l[2], $l[3], 0x0044) | Out-Null
    } else {
        $estilo = [Win138]::GetWindowLong($h, -16)
        [Win138]::SetWindowLong($h, -16, ($estilo -band (-bnot 0x00C40000))) | Out-Null
        [Win138]::SetWindowPos($h, [IntPtr](-1), $l[0], $l[1], $l[2], $l[3], 0x0060) | Out-Null   # FRAMECHANGED|SHOWWINDOW
    }
}
if (-not $DosMonitores) { [Win138]::ShowWindow($barra, 0) | Out-Null }

$pp = $null
if (-not $Control) {
    $args_p = @("`"$puente`"") + $(if ($Cruzar) { @('--cruzar') } else { @() }) + $(if ($Xbox) { @('--xbox') } else { @() })
    $pp = Start-Process -FilePath 'python' -ArgumentList $args_p -NoNewWindow -PassThru
    $dondes = if ($ArribaAbajo) { 'arriba', 'abajo' } else { 'izquierda', 'derecha' }
    Write-Host "Puente de mandos andando: mando 1 -> ventana $($dondes[0]), mando 2 -> ventana $($dondes[1])$(if ($Cruzar) { ' (CRUZADO)' })." -ForegroundColor Green
}
Write-Host "Jueguen. La copia 1 elige la mision; la 2 la sigue sola. Para terminar, cierren las dos ventanas." -ForegroundColor Green

$n = 0
while (-not ($p1.HasExited -and $p2.HasExited)) {
    Start-Sleep -Seconds 30
    $n++
    try { Save-Captura (Join-Path $corrida ("foto-{0:D2}.png" -f $n)) } catch { }
    if (-not $Control) { python $puente --estado 2>&1 | Out-File -Append -Encoding utf8 (Join-Path $corrida 'estado.txt') }
}
[Win138]::ShowWindow($barra, 5) | Out-Null
if ($pp -and -not $pp.HasExited) { Stop-Process -Id $pp.Id -ErrorAction SilentlyContinue }
Save-Registros $corrida $inicio
Copy-Item -Path (Join-Path $Black 'volcados\puente\*.log') -Destination $corrida -ErrorAction SilentlyContinue
$min = [math]::Round(((Get-Date) - $inicio).TotalMinutes, 1)
$etiqueta = if ($Control) { 'S2a' } else { 'S2b' }
"{0}`t{1}`tsalidas={2},{3}`tminutos={4}`tfotos={5}" -f (Get-Date -Format s), $etiqueta, $p1.ExitCode, $p2.ExitCode, $min, $n |
    Out-File -Append -Encoding utf8 (Join-Path $Volcados 'corridas.txt')
Write-Host ("S2 listo: {0} min, {1} fotos. Avisale a Claude." -f $min, $n) -ForegroundColor Green
