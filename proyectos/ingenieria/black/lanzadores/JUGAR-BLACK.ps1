# JUGAR-BLACK.ps1 -- abrir BLACK y jugar, de una.
#
# Hace tres cosas antes de lanzar, en este orden, y ninguna es opcional:
#   1. si PCSX2 esta abierto, avisa y no toca nada (al salir pisa el ini)
#   2. deja el mapeo de teclado+mouse igual al del repo (configurar-controles.ps1)
#   3. levanta el .ahk de agachado-mantenido si AutoHotkey esta instalado
# y recien despues abre el emulador en pantalla completa con el ISO.
#
# Las rutas NO se escriben aca: salen de kb/ubicaciones.json, que es la fuente
# unica del proyecto. Si un ISO se movio, se corrige alla y esto sigue andando.
#
# Sin acentos a proposito: la consola de Windows lee cp1252.

[CmdletBinding()]
param(
    # 'original' (default), 'mod-armas', 'mod-7b', o una ruta completa a un .iso
    [string]$Iso = 'original',
    [switch]$SinAhk,
    [switch]$Ventana
)

$ErrorActionPreference = 'Stop'
$raiz = Resolve-Path (Join-Path $PSScriptRoot '..')

function Ruta-De([string]$clave) {
    $j = Get-Content -LiteralPath (Join-Path $raiz 'kb\ubicaciones.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    return $j.rutas.$clave.ruta
}

if (Get-Process -Name 'pcsx2-qt' -ErrorAction SilentlyContinue) {
    Write-Output 'PCSX2 ya esta abierto. Cerralo primero (si no, al salir pisa la configuracion).'
    Start-Sleep -Seconds 4
    exit 1
}

# --- que ISO ---------------------------------------------------------------
switch ($Iso) {
    'original'  { $rutaIso = Ruta-De 'iso_original' }
    'mod-armas' { $rutaIso = Ruta-De 'iso_mod_armas' }
    'mod-7b'    { $rutaIso = (Split-Path (Ruta-De 'iso_original')) + '\Black-mod-7b.iso' }
    default     { $rutaIso = $Iso }
}
if (-not (Test-Path -LiteralPath $rutaIso)) { throw "No existe el ISO: $rutaIso" }

$exe = Ruta-De 'pcsx2_exe_juego'
if (-not $exe -or -not (Test-Path -LiteralPath $exe)) {
    throw "Falta la clave pcsx2_exe_juego en kb/ubicaciones.json (el PCSX2 2.8.0 de Program Files)."
}

# --- controles -------------------------------------------------------------
$cfg = Join-Path $raiz 'herramientas\configurar-controles.ps1'
& $cfg -Verificar *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Output 'El mapeo de controles no coincide con el del repo: lo aplico.'
    & $cfg
}

# --- agachado mantenido ----------------------------------------------------
if (-not $SinAhk) {
    $ahkScript = Join-Path $PSScriptRoot 'agachado-hold.ahk'
    $ahkExe = @(
        "$env:ProgramFiles\AutoHotkey\v2\AutoHotkey64.exe",
        "$env:ProgramFiles\AutoHotkey\AutoHotkey.exe",
        "${env:ProgramFiles(x86)}\AutoHotkey\AutoHotkey.exe"
    ) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

    if ($ahkExe -and (Test-Path -LiteralPath $ahkScript)) {
        if (-not (Get-Process -Name 'AutoHotkey*' -ErrorAction SilentlyContinue)) {
            Start-Process -FilePath $ahkExe -ArgumentList "`"$ahkScript`""
            Write-Output 'Agachado-mantenido: activo (AutoHotkey).'
        }
    } else {
        Write-Output 'AutoHotkey no esta instalado: Shift agacha en modo TOGGLE (una tocada queda agachado).'
        Write-Output '  Para el agachado mantenido:  winget install AutoHotkey.AutoHotkey'
    }
}

# --- a jugar ---------------------------------------------------------------
$args = @()
if (-not $Ventana) { $args += '-fullscreen' }
$args += '-fastboot'
$args += "`"$rutaIso`""

Write-Output "Abriendo $(Split-Path $rutaIso -Leaf) ..."
Start-Process -FilePath $exe -ArgumentList $args -WorkingDirectory (Split-Path $exe)
