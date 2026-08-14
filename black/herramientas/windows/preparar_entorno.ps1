<#
.SYNOPSIS
    Deja una máquina Windows lista para el proyecto BLACK: Python, numpy,
    PINE activado y savestates sin comprimir en PCSX2, y confirma la
    identidad del juego contra kb/objetivo.json.

.DESCRIPTION
    Automatiza el checkpoint 0. Hace, en orden:
      1. Se re-lanza con permisos de administrador (UAC) si hace falta.
      2. Busca Python 3.11+ e instala numpy si falta.
      3. Corre la batería de pruebas del proyecto (no necesita PCSX2).
      4. Encuentra la instalación de PCSX2 (o usa la que le pases).
      5. Le prende PINE (slot 28011) y le apaga la compresión de
         savestates en su .ini — con backup antes de tocar nada.
      6. Si PCSX2 no estaba abierto, lo abre (y el ISO, si se lo pasás).
      7. Espera a que PINE conteste y corre pine.py info.
      8. Si el juego está cargado, confirma serial/CRC en kb/objetivo.json.
      9. Deja un log completo en black/volcados/.

    Nada de esto necesita en realidad permisos de administrador: los
    archivos que toca están todos dentro de tu carpeta de usuario. Se pide
    UAC de todas formas porque así se pidió, y de paso evita problemas si
    tu Python está instalado "para todos los usuarios" (bajo Program Files).

.PARAMETER Pcsx2Exe
    Ruta al ejecutable de PCSX2. Si no se pasa, se busca solo.

.PARAMETER IsoPath
    Ruta a la ISO de BLACK. Si se pasa y PCSX2 no estaba abierto, se lanza
    directo con esa ISO. Si no se pasa, abrís el juego vos a mano.

.PARAMETER EsperaSegundos
    Cuánto esperar a que PINE conteste después de abrir PCSX2. Por defecto 90.

.PARAMETER SinElevar
    No pedir UAC. Usalo si ya corrés la consola como administrador, o si
    preferís que no se re-lance el script.

.PARAMETER SinPatchIni
    No tocar el .ini de PCSX2. Sólo diagnostica y corre las pruebas.

.EXAMPLE
    .\preparar_entorno.ps1

.EXAMPLE
    .\preparar_entorno.ps1 -IsoPath "D:\Juegos\BLACK.iso"

.EXAMPLE
    .\preparar_entorno.ps1 -Pcsx2Exe "C:\PCSX2\pcsx2-qt.exe" -SinElevar
#>

[CmdletBinding()]
param(
    [string]$Pcsx2Exe,
    [string]$IsoPath,
    [int]$EsperaSegundos = 90,
    [switch]$SinElevar,
    [switch]$SinPatchIni
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# ============================================================================
# 0. Rutas del proyecto
# ============================================================================
# este script vive en black/herramientas/windows/
$RepoBlack = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

if (-not (Test-Path (Join-Path $RepoBlack 'CLAUDE.md'))) {
    Write-Host "No encuentro black/CLAUDE.md desde $RepoBlack." -ForegroundColor Red
    Write-Host "Este script tiene que vivir en black/herramientas/windows/. Si lo moviste, volvé a ponerlo ahí." -ForegroundColor Red
    exit 1
}

$CarpetaVolcados = Join-Path $RepoBlack 'volcados'
if (-not (Test-Path $CarpetaVolcados)) {
    New-Item -ItemType Directory -Path $CarpetaVolcados -Force | Out-Null
}
$marcaTiempo = Get-Date -Format 'yyyyMMdd-HHmmss'
$RutaLog = Join-Path $CarpetaVolcados "diagnostico-entorno-$marcaTiempo.txt"
Start-Transcript -Path $RutaLog -Append | Out-Null

function Titulo($texto) {
    Write-Host ''
    Write-Host "== $texto ==" -ForegroundColor Cyan
}

function Ok($texto) { Write-Host "  [ok] $texto" -ForegroundColor Green }
function Advertir($texto) { Write-Host "  [!] $texto" -ForegroundColor Yellow }
function Fallar($texto) {
    Write-Host "  [error] $texto" -ForegroundColor Red
    Stop-Transcript | Out-Null
    exit 1
}

# ============================================================================
# 1. UAC — re-lanzarse elevado si hace falta
# ============================================================================
Titulo 'Permisos'

$identidad = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identidad)
$esAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($esAdmin) {
    Ok 'ya corriendo como administrador'
}
elseif ($SinElevar) {
    Advertir 'sin -SinElevar se pediría UAC; seguimos sin admin porque lo pediste así'
}
else {
    Write-Host '  pidiendo UAC (va a aparecer el diálogo de Windows)...' -ForegroundColor Yellow
    $listaArgs = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"")
    foreach ($clave in $PSBoundParameters.Keys) {
        $valor = $PSBoundParameters[$clave]
        if ($valor -is [switch]) {
            if ($valor.IsPresent) { $listaArgs += "-$clave" }
        }
        else {
            $listaArgs += "-$clave"
            $listaArgs += "`"$valor`""
        }
    }
    Stop-Transcript | Out-Null
    try {
        Start-Process -FilePath 'powershell.exe' -ArgumentList $listaArgs -Verb RunAs -ErrorAction Stop
        # se relanzó con éxito: la instancia elevada sigue desde acá, esta se cierra
        exit 0
    }
    catch {
        # cancelaste el UAC, o falló la elevación: seguimos sin admin en vez de
        # morir, porque casi nada de esto necesita admin de verdad
        Start-Transcript -Path $RutaLog -Append | Out-Null
        Advertir 'cancelaste el UAC o falló la elevación. Sigo sin permisos de administrador.'
    }
}

# ============================================================================
# 2. Python 3.11+
# ============================================================================
Titulo 'Python'

function Buscar-Python {
    $candidatos = @(
        [pscustomobject]@{ Exe = 'python'; Pre = @() }
        [pscustomobject]@{ Exe = 'python3'; Pre = @() }
        [pscustomobject]@{ Exe = 'py'; Pre = @('-3.11') }
        [pscustomobject]@{ Exe = 'py'; Pre = @('-3') }
    )
    foreach ($c in $candidatos) {
        $cmd = Get-Command $c.Exe -ErrorAction SilentlyContinue
        if (-not $cmd) { continue }
        try {
            # Out-String junta toda la salida en un solo string: si -match
            # se aplicara sobre un array, $Matches puede quedar sin poblar
            # o arrastrar el match de una iteración anterior del loop.
            $salida = (& $c.Exe @($c.Pre) '--version' 2>&1 | Out-String)
        }
        catch { continue }
        if ($salida -match 'Python (\d+)\.(\d+)') {
            $mayor = [int]$Matches[1]
            $menor = [int]$Matches[2]
            if (($mayor -eq 3 -and $menor -ge 11) -or $mayor -gt 3) {
                return [pscustomobject]@{ Exe = $c.Exe; Pre = $c.Pre; Version = $salida.Trim() }
            }
        }
    }
    return $null
}

$py = Buscar-Python
if ($null -eq $py) {
    Fallar 'No encontré Python 3.11+ en el PATH (probé python, python3, py -3.11, py -3). Instalalo desde https://python.org/downloads/ marcando "Add python.exe to PATH", y volvé a correr este script.'
}
Ok "$($py.Version)  ($($py.Exe) $($py.Pre -join ' '))"

Titulo 'numpy'
try {
    & $py.Exe @($py.Pre) '-m' 'pip' 'install' '--user' '--quiet' '--disable-pip-version-check' 'numpy' 2>&1 |
        ForEach-Object { Write-Host "  $_" }
    Ok 'numpy instalado (o ya estaba)'
}
catch {
    Advertir "no pude instalar numpy: $_. Las herramientas igual funcionan, más lentas en escaneos completos."
}

# ============================================================================
# 3. Batería de pruebas del proyecto (no necesita PCSX2)
# ============================================================================
Titulo 'Pruebas del proyecto'
$rutaPruebas = Join-Path $RepoBlack 'pruebas\prueba_herramientas.py'
& $py.Exe @($py.Pre) $rutaPruebas
if ($LASTEXITCODE -ne 0) {
    Advertir 'las pruebas fallaron. Seguimos igual, pero revisá la salida de arriba antes de confiar en el resto.'
}
else {
    Ok 'todas las pruebas pasaron'
}

# ============================================================================
# 4. Encontrar PCSX2
# ============================================================================
Titulo 'Buscando PCSX2'

function Resolver-Atajo($rutaLnk) {
    try {
        $shell = New-Object -ComObject WScript.Shell
        $atajo = $shell.CreateShortcut($rutaLnk)
        return $atajo.TargetPath
    }
    catch { return $null }
}

function Buscar-Pcsx2 {
    # 1. atajos conocidos (escritorio, menú inicio)
    $carpetasAtajos = @(
        [Environment]::GetFolderPath('Desktop')
        [Environment]::GetFolderPath('CommonDesktopDirectory')
        (Join-Path ([Environment]::GetFolderPath('StartMenu')) 'Programs')
        (Join-Path ([Environment]::GetFolderPath('CommonStartMenu')) 'Programs')
    )
    foreach ($carpeta in $carpetasAtajos) {
        if (-not (Test-Path $carpeta)) { continue }
        $atajos = Get-ChildItem -Path $carpeta -Filter '*pcsx2*.lnk' -Recurse -ErrorAction SilentlyContinue
        foreach ($a in $atajos) {
            $destino = Resolver-Atajo $a.FullName
            if ($destino -and (Test-Path $destino) -and $destino -match '\.exe$') {
                return $destino
            }
        }
    }

    # 2. carpetas de instalación típicas
    $raices = @(
        $env:ProgramFiles
        ${env:ProgramFiles(x86)}
        (Join-Path $env:LOCALAPPDATA 'Programs')
        "$env:SystemDrive\PCSX2"
        "$env:SystemDrive\Games\PCSX2"
        (Join-Path $env:USERPROFILE 'PCSX2')
    ) | Where-Object { $_ -and (Test-Path $_) }

    foreach ($raiz in $raices) {
        $hallado = Get-ChildItem -Path $raiz -Filter '*pcsx2*.exe' -Recurse -Depth 3 -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -notmatch 'uninstall|setup' } |
            Select-Object -First 1
        if ($hallado) { return $hallado.FullName }
    }
    return $null
}

if (-not $Pcsx2Exe) {
    $Pcsx2Exe = Buscar-Pcsx2
}

if ($Pcsx2Exe -and (Test-Path $Pcsx2Exe)) {
    Ok "PCSX2 en: $Pcsx2Exe"
}
else {
    Advertir 'no encontré el ejecutable de PCSX2 solo. Pasalo con -Pcsx2Exe "C:\ruta\a\pcsx2.exe". Sigo sin poder abrirlo ni tocar su configuración automáticamente.'
    $Pcsx2Exe = $null
}

# ============================================================================
# 5. Ubicar y parchear PCSX2.ini
# ============================================================================
function Set-ValorIni {
    <#
        Edita (o inserta) UNA clave dentro de UNA sección de un archivo .ini
        estilo PCSX2, tocando sólo esa línea. No reordena ni toca el resto
        del archivo.
    #>
    param(
        [string[]]$Lineas,
        [string]$Seccion,
        [string]$Clave,
        [string]$Valor
    )
    $encabezado = "[$Seccion]"
    $idxSeccion = -1
    for ($i = 0; $i -lt $Lineas.Count; $i++) {
        if ($Lineas[$i].Trim() -eq $encabezado) { $idxSeccion = $i; break }
    }

    # PCSX2 escribe sus .ini como "Clave = Valor" (con espacios); mantenemos
    # el mismo estilo para que un diff del archivo se vea prolijo.
    if ($idxSeccion -eq -1) {
        # la sección no existe: se agrega entera al final
        $nuevas = $Lineas + @('', $encabezado, "$Clave = $Valor")
        return $nuevas
    }

    # buscar la clave dentro del bloque de esa sección
    $idxFinSeccion = $Lineas.Count
    for ($i = $idxSeccion + 1; $i -lt $Lineas.Count; $i++) {
        if ($Lineas[$i] -match '^\s*\[.+\]\s*$') { $idxFinSeccion = $i; break }
    }

    for ($i = $idxSeccion + 1; $i -lt $idxFinSeccion; $i++) {
        if ($Lineas[$i] -match "^\s*$([regex]::Escape($Clave))\s*=") {
            $Lineas[$i] = "$Clave = $Valor"
            return $Lineas
        }
    }

    # la sección existe pero la clave no: se inserta justo debajo del encabezado
    $antes = $Lineas[0..$idxSeccion]
    $despues = if ($idxSeccion + 1 -le $Lineas.Count - 1) { $Lineas[($idxSeccion + 1)..($Lineas.Count - 1)] } else { @() }
    return $antes + @("$Clave = $Valor") + $despues
}

Titulo 'Configuración de PCSX2 (PINE + savestates)'

if ($SinPatchIni) {
    Advertir '-SinPatchIni: no se toca el .ini'
}
else {
    $procesoActivo = Get-Process -Name '*pcsx2*' -ErrorAction SilentlyContinue
    if ($procesoActivo) {
        Advertir "PCSX2 ya está corriendo (PID $($procesoActivo[0].Id)). Si edito el .ini ahora, PCSX2 lo pisa con lo que tiene en memoria al cerrarse. Cerralo, corré este script de nuevo, y volvelo a abrir después — o cambiá los ajustes a mano en Settings > Advanced."
    }
    else {
        $rutaIniDocumentos = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'PCSX2\inis\PCSX2.ini'
        $rutaIni = $null

        if ($Pcsx2Exe) {
            $carpetaExe = Split-Path -Parent $Pcsx2Exe
            $esPortable = Test-Path (Join-Path $carpetaExe 'portable.txt')
            $rutaIniPortable = Join-Path $carpetaExe 'inis\PCSX2.ini'
            if ($esPortable -and (Test-Path $rutaIniPortable)) {
                $rutaIni = $rutaIniPortable
            }
        }
        if (-not $rutaIni -and (Test-Path $rutaIniDocumentos)) {
            $rutaIni = $rutaIniDocumentos
        }

        if (-not $rutaIni) {
            Advertir "no encontré PCSX2.ini (ni en Documentos ni junto al ejecutable). Si es la primera vez que corrés PCSX2, abrilo una vez, dejalo generar su configuración, cerralo, y volvé a correr este script."
        }
        else {
            Ok "ini encontrado: $rutaIni"
            try {
                $respaldo = "$rutaIni.respaldo-$marcaTiempo"
                Copy-Item -Path $rutaIni -Destination $respaldo -Force -ErrorAction Stop
                Ok "respaldo guardado en: $respaldo"

                $lineas = Get-Content -Path $rutaIni -ErrorAction Stop
                $lineas = Set-ValorIni -Lineas $lineas -Seccion 'EmuCore' -Clave 'EnablePINE' -Valor 'true'
                $lineas = Set-ValorIni -Lineas $lineas -Seccion 'EmuCore' -Clave 'PINESlot' -Valor '28011'
                $lineas = Set-ValorIni -Lineas $lineas -Seccion 'EmuCore' -Clave 'SavestateZstdCompression' -Valor 'false'
                Set-Content -Path $rutaIni -Value $lineas -Encoding UTF8 -ErrorAction Stop

                Ok 'EnablePINE = true, PINESlot = 28011, SavestateZstdCompression = false'
            }
            catch {
                Advertir "no pude editar el .ini ($_). Si quedó un archivo .respaldo-* al lado, el original está intacto ahí. Activá PINE y desactivá la compresión a mano en Settings > Advanced."
            }
        }
    }
}

# ============================================================================
# 6. Abrir PCSX2 si no estaba corriendo
# ============================================================================
Titulo 'PCSX2'

$yaCorria = [bool](Get-Process -Name '*pcsx2*' -ErrorAction SilentlyContinue)

if ($yaCorria) {
    Ok 'PCSX2 ya estaba abierto; lo dejo como está'
}
elseif ($Pcsx2Exe) {
    Write-Host "  abriendo PCSX2..."
    try {
        if ($IsoPath -and (Test-Path $IsoPath)) {
            Start-Process -FilePath $Pcsx2Exe -ArgumentList "`"$IsoPath`"" -ErrorAction Stop
            Ok "lanzado con: $IsoPath"
        }
        else {
            if ($IsoPath) {
                Advertir "la ISO '$IsoPath' no existe; abro PCSX2 sin cargar nada"
            }
            Start-Process -FilePath $Pcsx2Exe -ErrorAction Stop
            Ok 'lanzado sin ISO — cargá BLACK a mano cuando abra'
        }
    }
    catch {
        Advertir "no pude lanzar PCSX2 ($_). Abrilo vos a mano. Sigo esperando a que PINE conteste."
    }
}
else {
    Advertir 'no tengo la ruta de PCSX2: abrilo vos a mano. Sigo esperando a que PINE conteste.'
}

# ============================================================================
# 7. Esperar a PINE y correr pine.py info
# ============================================================================
Titulo "Esperando a PINE (hasta $EsperaSegundos s)"

$puertoListo = $false
$limite = (Get-Date).AddSeconds($EsperaSegundos)
while ((Get-Date) -lt $limite) {
    $prueba = Test-NetConnection -ComputerName '127.0.0.1' -Port 28011 -WarningAction SilentlyContinue -InformationLevel Quiet -ErrorAction SilentlyContinue
    if ($prueba) { $puertoListo = $true; break }
    Start-Sleep -Seconds 2
    Write-Host '.' -NoNewline
}
Write-Host ''

$comandoPine = "$($py.Exe) $($py.Pre -join ' ') herramientas\pine.py info".Trim() -replace '\s+', ' '

if (-not $puertoListo) {
    Advertir "PINE no contestó en $EsperaSegundos s. Puede que PCSX2 siga cargando, que PINE no haya quedado activado (revisá Settings > Advanced > PINE Settings a mano), o que necesite un juego cargado. Corré '$comandoPine' desde black\ cuando esté listo."
}
else {
    Ok 'PINE responde'
    Push-Location $RepoBlack
    & $py.Exe @($py.Pre) 'herramientas\pine.py' 'info'
    $huboJuego = $LASTEXITCODE -eq 0

    if ($huboJuego) {
        Titulo 'Confirmando identidad en kb/objetivo.json'
        & $py.Exe @($py.Pre) 'herramientas\fijar_objetivo.py'
    }
    else {
        $comandoFijar = "$($py.Exe) $($py.Pre -join ' ') herramientas\fijar_objetivo.py".Trim() -replace '\s+', ' '
        Advertir "pine.py info devolvió error. Si PCSX2 está en el menú (sin juego cargado), es normal: cargá BLACK y corré a mano desde black\: $comandoFijar"
    }
    Pop-Location
}

# ============================================================================
# Cierre
# ============================================================================
Titulo 'Listo'
Write-Host "  log completo en: $RutaLog"
Write-Host '  si kb/objetivo.json cambió, revisalo y hacé commit + push.'

Stop-Transcript | Out-Null
