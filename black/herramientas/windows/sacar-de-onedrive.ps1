<#
.SYNOPSIS
    Devuelve Escritorio / Documentos / Imagenes de OneDrive a C:\Users\<vos>.

.DESCRIPTION
    Windows 11 activa "Known Folder Move" solo y redirige las carpetas
    conocidas a OneDrive. Eso deja DOS carpetas Desktop y ya causo errores
    reales en este proyecto: se creaba algo en C:\Users\frans\Desktop que Fran
    no veia, porque su escritorio real era el de OneDrive.

    Y hay algo peor que la confusion: el data dir de PCSX2 vive en
    Documentos. Los savestates son ~32 MB sin comprimir escritos en
    background. OneDrive los lockea y escanea mientras PCSX2 los usa. Es el
    sospechoso principal de las dos muertes de PCSX2 del 2026-08-15.

    ESTE SCRIPT NO BORRA NADA. Copia con robocopy, verifica, y recien
    despues cambia el registro. Los archivos quedan en OneDrive hasta que
    vos los borres a mano, mirando.

.PARAMETER Aplicar
    Sin este switch corre en seco: dice todo lo que haria y no toca nada.
    Es el modo por defecto A PROPOSITO.

.PARAMETER Carpetas
    Cuales mover. Por defecto las tres. El proyecto necesita Documentos
    (por PCSX2); Escritorio es lo que pidio Fran.

.EXAMPLE
    .\sacar-de-onedrive.ps1
    .\sacar-de-onedrive.ps1 -Aplicar

.NOTES
    ANTES DE CORRERLO CON -Aplicar:
      1. Cerrar PCSX2, Ghidra, el explorador de archivos y cualquier editor
         que tenga abierto algo de esas carpetas.
      2. Cerrar esta sesion de Claude Code si su directorio de trabajo esta
         adentro de alguna de las carpetas que se mueven.
      3. Tener OneDrive DETENIDO (este script lo verifica y se niega si esta
         corriendo).

    DESPUES: cerrar sesion de Windows y volver a entrar. Explorer cachea las
    rutas de las carpetas conocidas; reiniciar explorer.exe no siempre alcanza.
#>
[CmdletBinding()]
param(
    [switch]$Aplicar,
    [ValidateSet('Desktop', 'Personal', 'My Pictures')]
    [string[]]$Carpetas = @('Desktop', 'Personal', 'My Pictures')
)

$ErrorActionPreference = 'Stop'

# nombre en el registro -> nombre de la carpeta en disco
$MAPA = @{
    'Desktop'     = 'Desktop'
    'Personal'    = 'Documents'
    'My Pictures' = 'Pictures'
}

$CLAVE  = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
$CLAVE2 = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'
$PERFIL = $env:USERPROFILE

function Escribir($texto, $color = 'Gray') { Write-Host $texto -ForegroundColor $color }

Escribir ""
Escribir "=== SACAR CARPETAS CONOCIDAS DE ONEDRIVE ===" Cyan
if (-not $Aplicar) {
    Escribir "MODO EN SECO. No se toca nada. Agrega -Aplicar para ejecutar." Yellow
}
Escribir ""

# --- 1. OneDrive tiene que estar detenido -----------------------------------
$od = Get-Process OneDrive -ErrorAction SilentlyContinue
if ($od) {
    Escribir "ABORTADO: OneDrive esta corriendo (PID $($od.Id))." Red
    Escribir "Cerralo desde la bandeja del sistema y volve a correr esto." Red
    exit 1
}
Escribir "[OK] OneDrive no esta corriendo." Green

# --- 2. Respaldo del registro ------------------------------------------------
$sello   = Get-Date -Format 'yyyyMMdd-HHmmss'
$respaldo = Join-Path $PERFIL "carpetas-conocidas-respaldo-$sello.reg"
if ($Aplicar) {
    reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" $respaldo /y | Out-Null
    Escribir "[OK] respaldo del registro -> $respaldo" Green
} else {
    Escribir "[seco] exportaria el registro a $respaldo"
}

# --- 3. Una carpeta por vez --------------------------------------------------
$errores = 0
foreach ($clave in $Carpetas) {
    $nombre  = $MAPA[$clave]
    $actual  = (Get-ItemProperty -Path $CLAVE -Name $clave).$clave
    $destino = Join-Path $PERFIL $nombre

    Escribir ""
    Escribir "--- $nombre ---" Cyan
    Escribir "    ahora : $actual"
    Escribir "    quiere: $destino"

    if ($actual -notlike '*OneDrive*') {
        Escribir "    [saltado] ya esta fuera de OneDrive." Green
        continue
    }

    $origen = [Environment]::ExpandEnvironmentVariables($actual)
    if (-not (Test-Path $origen)) {
        Escribir "    [saltado] el origen no existe." Yellow
        continue
    }

    $n = (Get-ChildItem $origen -Force -ErrorAction SilentlyContinue | Measure-Object).Count
    Escribir "    $n elementos a copiar"

    if (-not $Aplicar) {
        Escribir "    [seco] robocopy `"$origen`" `"$destino`" /E /COPY:DAT /XJ /R:1 /W:1"
        Escribir "    [seco] y despues pondria la clave del registro en $destino"
        continue
    }

    if (-not (Test-Path $destino)) { New-Item -ItemType Directory -Path $destino -Force | Out-Null }

    # /E subdirectorios incluidos vacios; /XJ ignora junctions (evita bucles);
    # NO se usa /MOVE a proposito: nada se borra del origen.
    robocopy $origen $destino /E /COPY:DAT /XJ /R:1 /W:1 /NFL /NDL /NJH /NJS | Out-Null
    $rc = $LASTEXITCODE
    if ($rc -ge 8) {
        Escribir "    [MAL] robocopy devolvio $rc. NO se toca el registro." Red
        $errores++
        continue
    }
    Escribir "    [OK] copiado (robocopy rc=$rc)" Green

    Set-ItemProperty -Path $CLAVE  -Name $clave -Value $destino -Type ExpandString
    Set-ItemProperty -Path $CLAVE2 -Name $clave -Value $destino -ErrorAction SilentlyContinue
    Escribir "    [OK] registro apuntando a $destino" Green
}

Escribir ""
Escribir "=== RESUMEN ===" Cyan
if (-not $Aplicar) {
    Escribir "Nada cambio. Volve a correrlo con -Aplicar cuando quieras hacerlo." Yellow
    exit 0
}
if ($errores -gt 0) {
    Escribir "$errores carpeta(s) fallaron. Revisa arriba." Red
    exit 1
}
Escribir "Listo. AHORA:" Green
Escribir "  1. Cerra sesion de Windows y volve a entrar." Green
Escribir "  2. Verifica: python herramientas\inventario.py" Green
Escribir "  3. En PCSX2, confirma que encuentra sus savestates." Green
Escribir "  4. Recien cuando TODO ande, borra a mano lo que quedo en OneDrive." Green
Escribir "     El script no borro nada: los originales siguen ahi." Green
exit 0
