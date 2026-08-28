# abrir-sesion.ps1 -- lo primero de cualquier sesion de BLACK, en UN comando.
#
# ESTADO_ACTUAL.md decia "corre estos tres comandos" y eso dependia de que
# alguien los leyera y los tipeara. El 2026-08-28 ubicaciones.py abrio en ROJO
# con un critico roto y solo se noto porque el mensaje de retome lo recordaba:
# una regla que nadie mide se corre sola. Esto la mide.
#
# Ademas corre la CAPA 3 de los frenos: la integridad de los archivos
# protegidos. Es la unica capa sin agujeros, porque mide el OBJETO en vez de
# adivinar la intencion de un comando.
#
#   .\abrir-sesion.ps1                 los tres controles + integridad
#   .\abrir-sesion.ps1 -Rapido         saltea Ghidra (el unico lento)
#   .\abrir-sesion.ps1 -SoloIntegridad solo los archivos protegidos
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

[CmdletBinding()]
param(
    [switch]$Rapido,
    [switch]$SoloIntegridad,
    # Solo para probar-hooks.ps1: fuerza una huella que el disco no puede
    # cumplir, para verificar que el chequeo se pone en rojo de verdad.
    [long]$TamEsperadoDePrueba = 0
)

$ErrorActionPreference = 'Stop'
$proyecto = $PSScriptRoot
$raiz     = (Resolve-Path (Join-Path $proyecto '..\..\..')).Path
$fallas   = 0

function Linea([string]$estado, [string]$txt) { Write-Output ("  [{0}] {1}" -f $estado, $txt) }

Write-Output ""
Write-Output "=== abrir sesion de BLACK ==="
Write-Output "  Proyecto: $proyecto"
Write-Output ""

# ------------------------------------------------ capa 3: integridad medida
Write-Output "integridad de los archivos protegidos (.claude/protegidos.json)"

$cfg = Join-Path $raiz '.claude\protegidos.json'
if (-not (Test-Path -LiteralPath $cfg)) {
    Linea 'FAIL' "falta $cfg -- el sistema de frenos no esta instalado"
    $fallas++
} else {
    $prot = (Get-Content -LiteralPath $cfg -Raw -Encoding UTF8 | ConvertFrom-Json).archivos
    foreach ($a in $prot) {
        if (-not (Test-Path -LiteralPath $a.ruta)) {
            Linea 'FAIL' "$($a.nombre): no esta en $($a.ruta)"
            $fallas++
            continue
        }
        $i = Get-Item -LiteralPath $a.ruta

        $tamEsperado = [long]$a.tam
        if ($TamEsperadoDePrueba -gt 0) { $tamEsperado = $TamEsperadoDePrueba }

        if ($i.Length -ne $tamEsperado) {
            Linea 'FAIL' ("$($a.nombre): TAMANO CAMBIADO. esperado={0} medido={1}" -f $tamEsperado, $i.Length)
            Linea '    ' "  Alguien lo escribio. $($a.por_que)"
            $fallas++
            continue
        }

        $mtimeEsperado = [datetime]::Parse($a.mtime_utc, [cultureinfo]::InvariantCulture, [System.Globalization.DateTimeStyles]::AdjustToUniversal)
        $delta = [math]::Abs(($i.LastWriteTimeUtc - $mtimeEsperado).TotalSeconds)
        if ($delta -gt 2) {
            Linea 'FAIL' ("$($a.nombre): FECHA CAMBIADA. esperada={0:u} medida={1:u}" -f $mtimeEsperado, $i.LastWriteTimeUtc)
            $fallas++
            continue
        }

        if ($a.se_puede_escribir -eq $false) {
            $ro = [bool]($i.Attributes -band [System.IO.FileAttributes]::ReadOnly)
            if (-not $ro) {
                Linea 'WARN' "$($a.nombre): integridad OK pero SIN el atributo ReadOnly (capa 1 caida). Correr .claude\instalar-hooks.ps1"
            } else {
                Linea 'OK  ' "$($a.nombre): integridad OK (tam, fecha y ReadOnly)"
            }
        } else {
            Linea 'OK  ' "$($a.nombre): integridad OK (tam y fecha)"
        }
    }
}

if ($SoloIntegridad) {
    Write-Output ""
    if ($fallas -eq 0) { Write-Output "  integridad OK."; exit 0 }
    Write-Output "  $fallas falla(s) de integridad."; exit 1
}

# ------------------------------------------------ los tres controles de apertura
Push-Location $proyecto
try {
    Write-Output ""
    Write-Output "control 1/3 -- ubicaciones.py (DONDE esta cada cosa, medido)"
    & python herramientas/ubicaciones.py
    if ($LASTEXITCODE -ne 0) { Linea 'FAIL' "ubicaciones.py salio $LASTEXITCODE -- corregir kb/ubicaciones.json, en UN solo lugar"; $fallas++ }

    Write-Output ""
    Write-Output "control 2/3 -- inventario.py (que hay en LA MAQUINA)"
    & python herramientas/inventario.py
    if ($LASTEXITCODE -ne 0) { Linea 'FAIL' "inventario.py salio $LASTEXITCODE"; $fallas++ }

    if ($Rapido) {
        Write-Output ""
        Linea 'SKIP' "control 3/3 -- Ghidra salteado por -Rapido. Correrlo ANTES de leer desensamblado:"
        Write-Output "         python herramientas/decompilar.py info"
    } else {
        Write-Output ""
        Write-Output "control 3/3 -- decompilar.py info (control positivo de Ghidra)"
        & python herramientas/decompilar.py info
        if ($LASTEXITCODE -ne 0) { Linea 'FAIL' "decompilar.py info salio $LASTEXITCODE"; $fallas++ }
    }
} finally { Pop-Location }

Write-Output ""
Write-Output "------------------------------------------------------------"
if ($fallas -eq 0) {
    Write-Output "  Sesion de BLACK lista. integridad OK y controles en verde."
    Write-Output "  Donde quedamos: proyectos\ingenieria\black\sesiones\HANDOFF.md"
    exit 0
} else {
    Write-Output "  $fallas control(es) en ROJO. Arreglar ANTES de trabajar:"
    Write-Output "  arrancar con un critico roto es como empezo la sesion del 2026-08-28."
    exit 1
}
