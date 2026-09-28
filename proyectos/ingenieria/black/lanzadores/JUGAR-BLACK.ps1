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
    # el coop en pantalla dividida (bloque del pnach de coop_mod.py). Sin -Coop el
    # bloque se APAGA, para que jugar solo no arme un jugador 2.
    #   teclado : J1 teclado+mouse, J2 el unico mando (SDL-0)
    #   2mandos : J1 mando SDL-0 (+teclado), J2 mando SDL-1
    [ValidateSet('', 'teclado', '2mandos')]
    [string]$Coop = '',
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

# --- coop: el bloque del pnach y a que mando va cada jugador -----------------
# configurar-controles.ps1 solo escribe [Pad1] (SDL-0 + teclado/mouse). Aca se
# ajusta despues: con un solo mando, SDL-0 sale de [Pad1] y pasa a [Pad2].
if ($Coop) {
    # el bloque instalado sale siempre de la fuente del repo (no cambia nada si ya coincide)
    & python (Join-Path $raiz 'herramientas\coop_mod.py') instalar
    if ($LASTEXITCODE -ne 0) { throw 'coop_mod.py instalar fallo' }
}
$accion = if ($Coop) { 'activar' } else { 'desactivar' }
& python (Join-Path $raiz 'herramientas\coop_mod.py') $accion
if ($LASTEXITCODE -ne 0) { throw "coop_mod.py $accion fallo" }

# --- saltear videos con Start (bitacora (93w)): en TODOS los accesos ------------
$sv = Join-Path $raiz 'herramientas\saltear_videos.py'
& python $sv instalar
if ($LASTEXITCODE -ne 0) { throw 'saltear_videos.py instalar fallo' }
& python $sv activar
if ($LASTEXITCODE -ne 0) { throw 'saltear_videos.py activar fallo' }

$ini = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PCSX2\inis\PCSX2.ini'
$lineas = [IO.File]::ReadAllLines($ini)
$seccion = ''
$out = foreach ($l in $lineas) {
    if ($l -match '^\[(.+)\]$') { $seccion = $Matches[1] }
    if ($Coop -eq 'teclado' -and $seccion -eq 'Pad1' -and $l -match '= SDL-0/') { continue }
    if ($seccion -eq 'Pad2') {
        if ($Coop -eq 'teclado') { $l = $l -replace '= SDL-1/', '= SDL-0/' }
        else                     { $l = $l -replace '= SDL-0/', '= SDL-1/' }
    }
    $l
}
[IO.File]::WriteAllLines($ini, [string[]]$out, (New-Object Text.UTF8Encoding($false)))

# --- la sensibilidad de mira: solo cuando se juega con MOUSE -------------------
# Los tres parches de docs/10-jugar.md (curva lineal, giro a 350 grados/seg, zona
# muerta a cero) existen para el mouse. Con dos mandos, Fran pidio la sensibilidad
# ORIGINAL (2026-09-28): se apagan. Son globales del juego: en -Coop teclado valen
# tambien para el mando de J2.
$mira = @('Mira lineal - exponente del stick a 1.0',
          'Mira sensible - velocidad de giro de 70 a 350 grados/seg',
          'Zona muerta del pad a cero')
$conMouse = ($Coop -ne '2mandos')
$aj = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PCSX2\gamesettings\SLUS-21376_5C891FF1.ini'
$ls = [Collections.Generic.List[string]]([IO.File]::ReadAllLines($aj) | Where-Object {
        $_.Trim() -notin ($mira | ForEach-Object { "Enable = $_" }) })
if ($conMouse) { $ls.InsertRange($ls.IndexOf('[Patches]') + 1, [string[]]($mira | ForEach-Object { "Enable = $_" })) }

# --- la pantalla ancha (bitacora (93t)/(93v)) --------------------------------
# El parche comunitario 'Widescreen 16:9' reescribe en cada cuadro la proporcion de la camara de escena y
# pisa la mitad que pone el coop entre las dos pasadas: la mitad de J2 parpadeaba comprimida. Con el coop
# lo APAGAMOS: el bloque COOP trae su propia pantalla ancha (las mismas lineas menos esas dos, que pone el
# stub). Solo, se PRENDE como siempre.
$ancho = 'Enable = Widescreen 16:9'
$ls = [Collections.Generic.List[string]]($ls | Where-Object { $_.Trim() -ne $ancho })
if (-not $Coop) { $ls.Insert($ls.IndexOf('[Patches]') + 1, $ancho) }
[IO.File]::WriteAllLines($aj, [string[]]$ls, (New-Object Text.UTF8Encoding($false)))
Write-Output "Sensibilidad de mira: $(if ($conMouse) {'la del mouse (parches prendidos)'} else {'ORIGINAL (parches apagados)'})."
Write-Output "Pantalla ancha: $(if ($Coop) {'la del coop (Widescreen 16:9 comunitario APAGADO)'} else {'Widescreen 16:9 comunitario'})."

if ($Coop) { Write-Output "COOP ($Coop): pantalla dividida, J2 con el mando $(if ($Coop -eq 'teclado') {'unico'} else {'2'})." }

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
