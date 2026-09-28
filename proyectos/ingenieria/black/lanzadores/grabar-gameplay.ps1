# grabar-gameplay.ps1 -- graba unos segundos de pantalla y los deja listos para que Claude los MIRE.
#
# Claude no ve video: ve imagenes. Por eso, ademas del .mp4, deja:
#   hojas\hoja_NN.png   hojas de contacto: 12 cuadros por imagen (2 por segundo), en orden, con la hora
#   cuadros\c_NNN.png   cuadros sueltos (4 por segundo), para mirar de cerca un momento
# en proyectos\ingenieria\black\volcados\video\<fecha-hora>\ (volcados\ no va a git).
#
# Graba con ffmpeg (ya instalado: winget Gyan.FFmpeg). Primero con ddagrab (Desktop Duplication: agarra bien
# la ventana del emulador a pantalla completa) y, si falla, con gdigrab.
#
#   .\grabar-gameplay.ps1                 # 60 s, empieza ya
#   .\grabar-gameplay.ps1 -Segundos 60 -Espera 5   # espera 5 s (para volver al juego) y graba 60 (el acceso)
# Atajo mientras se juega: Ctrl+Alt+G (lo agrega agachado-hold.ahk). Pita al empezar y al terminar.
#
# Sin acentos a proposito: la consola de Windows lee cp1252.

[CmdletBinding()]
param(
    [int]$Segundos = 60,
    [int]$Espera = 0,
    [int]$Fps = 30
)
$ErrorActionPreference = 'Stop'
$raiz = Resolve-Path (Join-Path $PSScriptRoot '..')
$ff = (Get-Command ffmpeg -ErrorAction SilentlyContinue).Source
if (-not $ff) { Write-Output 'No encuentro ffmpeg. Instalalo con:  winget install Gyan.FFmpeg'; exit 1 }

$dir = Join-Path $raiz ('volcados\video\' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Force -Path (Join-Path $dir 'hojas'), (Join-Path $dir 'cuadros') | Out-Null
$mp4 = Join-Path $dir 'gameplay.mp4'
$log = Join-Path $dir 'ffmpeg.log'

# PowerShell 5.1: con 'Stop', redirigir el stderr de un programa nativo lo convierte en error y corta el
# script aunque ffmpeg haya andado. Desde aca se mide por $LASTEXITCODE y por el archivo.
$ErrorActionPreference = 'Continue'
if ($Espera -gt 0) { Start-Sleep -Seconds $Espera }
[console]::beep(880, 150)

# 0) los botones de cada puerto, por PINE, en paralelo (herramientas\registro_mandos.py, bitacora (93y)).
#    Sin PINE no frena nada: deja mandos.txt diciendo por que y el video se graba igual.
$py = (Get-Command python -ErrorAction SilentlyContinue).Source
$reg = $null
if ($py) {
    $reg = Start-Process -FilePath $py -WindowStyle Hidden -PassThru -ArgumentList @(
        "`"$(Join-Path $raiz 'herramientas\registro_mandos.py')`"", 'grabar', "`"$dir`"", '--segundos', ($Segundos + 1))
}
# 0b) (96) el SONIDO: lo que sale por la salida por defecto de Windows (WASAPI loopback, pyaudiowpatch) a
#     audio.wav, en paralelo; al final se junta con el video en gameplay_audio.mp4. Sin el, el video sale igual.
$wav = Join-Path $dir 'audio.wav'
$aud = $null
if ($py) {
    $aud = Start-Process -FilePath $py -WindowStyle Hidden -PassThru -ArgumentList @(
        "`"$(Join-Path $raiz 'herramientas\grabar_audio.py')`"", "`"$wav`"", $Segundos)
}
function Marcar-Inicio { [string]([DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds() / 1000.0) |
    Set-Content -LiteralPath (Join-Path $dir 'inicio_video.txt') -Encoding ASCII }

# 1) grabar: ddagrab y, si no anda, gdigrab
$vf = 'hwdownload,format=bgra,scale=1280:-2,format=yuv420p'
Marcar-Inicio
& $ff -y -hide_banner -loglevel error -f lavfi -i "ddagrab=framerate=$($Fps)" -t $Segundos -vf $vf `
    -c:v libx264 -preset veryfast -crf 23 $mp4 2> $log
$ok = ($LASTEXITCODE -eq 0) -and (Test-Path -LiteralPath $mp4) -and ((Get-Item -LiteralPath $mp4).Length -gt 100KB)
$metodo = 'ddagrab'
if (-not $ok) {
    $metodo = 'gdigrab'
    Marcar-Inicio
    & $ff -y -hide_banner -loglevel error -f gdigrab -framerate $Fps -i desktop -t $Segundos `
        -vf 'scale=1280:-2,format=yuv420p' -c:v libx264 -preset veryfast -crf 23 $mp4 2>> $log
    $ok = ($LASTEXITCODE -eq 0) -and (Test-Path -LiteralPath $mp4)
}
[console]::beep(660, 150); [console]::beep(440, 250)
if (-not $ok) { Write-Output "No se pudo grabar. Mira $log"; exit 1 }
if ($aud) {
    $aud.WaitForExit(20000) | Out-Null
    if (Test-Path -LiteralPath $wav) {
        & $ff -y -hide_banner -loglevel error -i $mp4 -i $wav -c:v copy -c:a aac -shortest `
            (Join-Path $dir 'gameplay_audio.mp4') 2>> $log
    }
}

# 2) lo que mira Claude: hojas de 12 cuadros (2 por segundo, con la hora del video) y cuadros sueltos (4 por segundo)
# fontfile explicito: sin el, ffmpeg de winget no encuentra Fontconfig y las hojas salian sin la hora.
# La hora va abajo al centro: arriba tapa la vida (izq.) y la municion (der.).
$hora = "drawtext=fontfile='C\:/Windows/Fonts/arial.ttf':text='%{pts\:hms}':x=(w-tw)/2:y=h-th-8:fontsize=24:fontcolor=yellow:box=1:boxcolor=black@0.6"
& $ff -y -hide_banner -loglevel error -i $mp4 -vf "fps=2,scale=480:-2,$hora,tile=4x3" `
    (Join-Path $dir 'hojas\hoja_%02d.png') 2>> $log
if ($LASTEXITCODE -ne 0) {   # sin fuente para drawtext: las mismas hojas, sin la hora
    & $ff -y -hide_banner -loglevel error -i $mp4 -vf 'fps=2,scale=480:-2,tile=4x3' `
        (Join-Path $dir 'hojas\hoja_%02d.png') 2>> $log
}
& $ff -y -hide_banner -loglevel error -i $mp4 -vf 'fps=4,scale=960:-2' (Join-Path $dir 'cuadros\c_%03d.png') 2>> $log

# 3) los botones estampados debajo de cada mitad: hojas_mandos\ (12 cuadros a 4 por segundo) y eventos.txt
if ($reg) {
    if (-not $reg.WaitForExit(15000)) { $reg.Kill() }
    & $py (Join-Path $raiz 'herramientas\registro_mandos.py') anotar $dir 2>> $log | Out-Null
}
$mandos = if (Test-Path -LiteralPath (Join-Path $dir 'mandos.txt')) {
    (Get-Content -LiteralPath (Join-Path $dir 'mandos.txt') -TotalCount 1) } else { 'sin registro (no hay python)' }

$nh = (Get-ChildItem -LiteralPath (Join-Path $dir 'hojas') -Filter *.png).Count
$nc = (Get-ChildItem -LiteralPath (Join-Path $dir 'cuadros') -Filter *.png).Count
@(
    "grabado: $(Get-Date -Format s)  ($metodo, $Segundos s a $Fps cuadros/s)",
    "video:   gameplay.mp4",
    "hojas:   $nh (12 cuadros cada una, 2 por segundo)  <- lo primero que mira Claude",
    "cuadros: $nc (4 por segundo)",
    "mandos:  $mandos  -> hojas_mandos\ y eventos.txt (lo que recibio el juego en cada puerto)"
) | Set-Content -LiteralPath (Join-Path $dir 'LEEME.txt') -Encoding ASCII
Write-Output "Listo: $dir  ($nh hojas, $nc cuadros, $metodo)"
