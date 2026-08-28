# nuevo-proyecto.ps1 -- crea (o adopta) un proyecto con todo lo que la regla 3 pide.
#
# Por que existe: hasta el 2026-08-28 hacer las cosas bien costaba seis pasos
# --carpeta, PDP, contrato, ESTADO_ACTUAL, HANDOFF, fila en el enrutador-- y
# hacerlas mal costaba un mkdir en el Escritorio. Con esa diferencia de precio
# la regla iba a seguir perdiendo, y no por indisciplina: exactamente la misma
# senal de impracticabilidad que ya archivo el esquema de un proyecto por rama
# (MAPA.md, seccion 4). Una regla que se elude no se escribe mas fuerte.
#
# El companero de este script es la regla 6 de verificar-estructura.ps1, que
# es la que AVISA. Este es el que hace que atender el aviso sea barato: los
# dos juntos son el flujo de informacion que le faltaba a la regla 3.
#
# ASCII puro a proposito: la consola de Windows lee cp1252.
#
# Uso:
#   .\nuevo-proyecto.ps1 apunte-fisica -Naturaleza documentos
#   .\nuevo-proyecto.ps1 teoria-circuitos -Naturaleza documentos -Sensible
#   .\nuevo-proyecto.ps1 informe-tc -Naturaleza documentos -Desde "C:\Users\frans\Desktop\Informe TC"

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Nombre,

    [Parameter(Mandatory = $true)]
    [ValidateSet('ingenieria', 'documentos', 'seguimiento')]
    [string]$Naturaleza,

    # Adopta una carpeta que ya existe (el caso del huerfano del Escritorio).
    # Mueve su contenido adentro del proyecto en vez de arrancar vacio.
    [string]$Desde,

    # El proyecto lleva datos personales o de terceros que NO pueden
    # publicarse: repo propio + linea en .gitignore. Ver la regla 2 del
    # CLAUDE.md, fila del medio de la tabla de sensibilidad.
    [switch]$Sensible,

    [string]$Raiz = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'

function Ok($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green }
function Info($m) { Write-Host "  $m" }
function Warn($m) { Write-Host "  [!]    $m" -ForegroundColor Yellow }
function Alto($m) { Write-Host "  [X]    $m" -ForegroundColor Red }

Write-Host ""
Write-Host "=== proyecto nuevo: $Nombre ($Naturaleza) ===" -ForegroundColor Cyan

# --- chequeos previos ------------------------------------------------------

$plantillas = Join-Path $Raiz 'plantillas'
$natMd = Join-Path $plantillas "naturalezas\$Naturaleza.md"
if (-not (Test-Path $natMd)) {
    Alto "no existe $natMd. Sin nivel 3 no se puede abrir un proyecto de esa clase."
    exit 1
}

$destino = Join-Path $Raiz "proyectos\$Naturaleza\$Nombre"
if (Test-Path $destino) {
    Alto "$destino ya existe. Si querias adoptar una carpeta, usa -Desde."
    exit 1
}

if ($Desde -and -not (Test-Path -LiteralPath $Desde)) {
    Alto "-Desde apunta a '$Desde' y no existe."
    exit 1
}

New-Item -ItemType Directory -Force -Path $destino | Out-Null
Ok "carpeta: proyectos/$Naturaleza/$Nombre"

# --- adopcion --------------------------------------------------------------

if ($Desde) {
    $bloqueados = @()
    foreach ($item in (Get-ChildItem -LiteralPath $Desde -Force)) {
        try {
            Move-Item -LiteralPath $item.FullName -Destination $destino -ErrorAction Stop
        } catch {
            $bloqueados += $item.Name
        }
    }
    if ($bloqueados.Count -eq 0) {
        Ok "contenido movido desde '$Desde'"
        try {
            if ((Get-ChildItem -LiteralPath $Desde -Force | Measure-Object).Count -eq 0) {
                Info "la carpeta de origen quedo vacia: borrala a mano cuando quieras"
            }
        } catch {}
    } else {
        Warn "no se pudieron mover $($bloqueados.Count) archivo(s), en uso por otro programa:"
        foreach ($b in $bloqueados) { Info "         $b" }
        Warn "cerra el programa que los tiene abiertos y moveelos a mano."
        Warn "OJO: hasta que los muevas hay DOS copias, y dos copias divergen."
    }
}

# --- los cuatro archivos que la regla 3 y la regla 5 del perfil piden ------

$copias = @(
    @{ De = 'PDP.md';             A = 'PDP.md' },
    @{ De = 'proyecto-CLAUDE.md'; A = 'CLAUDE.md' },
    @{ De = 'ESTADO_ACTUAL.md';   A = 'ESTADO_ACTUAL.md' },
    @{ De = 'HANDOFF.md';         A = 'HANDOFF.md' }
)
foreach ($c in $copias) {
    $origen = Join-Path $plantillas $c.De
    $final  = Join-Path $destino $c.A
    if (-not (Test-Path $origen)) { Warn "falta la plantilla $($c.De)"; continue }
    if (Test-Path $final) { Warn "$($c.A) ya venia en la carpeta adoptada: NO se piso"; continue }
    Copy-Item -LiteralPath $origen -Destination $final
    Ok "$($c.A) desde plantillas/$($c.De)"
}

# --- sensible: repo propio -------------------------------------------------

$rel = "proyectos/$Naturaleza/$Nombre/"
if ($Sensible) {
    Push-Location $destino
    try {
        git init -q
        Ok "repo propio inicializado (sin remote: ponerle uno PRIVADO o ninguno)"
    } finally {
        Pop-Location
    }

    $rutaGitignore = Join-Path $Raiz '.gitignore'
    $gi = Get-Content -Raw -LiteralPath $rutaGitignore
    if ($gi -notmatch [regex]::Escape($rel)) {
        Add-Content -LiteralPath $rutaGitignore -Value $rel -Encoding utf8
        Ok ".gitignore: agregado '$rel'"
    }
    Warn "agregale a MAPA.md la fila de la tabla de duenos (seccion 2), o la regla 3c falla."
}

# --- lo unico que no se puede automatizar: la fila del enrutador -----------

Write-Host ""
Write-Host "  FALTA UNA COSA, Y ES A MANO A PROPOSITO:" -ForegroundColor Cyan
Info "  agregar la fila en CLAUDE.md, tabla de 'proyectos/$Naturaleza/'."
Info "  Que es y en que estado esta lo sabe una persona, no un script; y la"
Info "  regla 3a de verificar-estructura.ps1 falla hasta que este puesta."
Write-Host ""
Write-Host "  | [``$Nombre/``](proyectos/$Naturaleza/$Nombre/CLAUDE.md) | <que es> | <estado> |" -ForegroundColor Gray
Write-Host ""
Info "  Despues: llena PDP.md ANTES de la primera linea de trabajo -- sobre"
Info "  todo la seccion 4, que es donde vive el criterio de salida."
Write-Host ""
Info "  Y para comprobarlo:  .\verificar-estructura.ps1"
Write-Host ""
