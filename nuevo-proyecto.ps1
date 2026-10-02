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

    # Las necesidades con que la puerta de la cascada lo trata (.claude/cascada.json).
    # Por defecto, segun la naturaleza: documentos -> materia, ingenieria ->
    # ingenieria-inversa, seguimiento -> ninguna.
    [string[]]$Necesidades,

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

# --- la fila del catalogo de la cascada (.claude/cascada.json) -------------
#
# (2026-10-02, regla 15) carrera nacio con este script y SIN fila en el
# catalogo: la puerta no sabia que exigirle y solo lo vio el arranque
# siguiente, en rojo. El medidor detectaba; faltaba que no pudiera nacer asi.
# Se escribe como TEXTO, una linea: el catalogo es un registro por linea y
# ConvertTo-Json lo reformatearia entero. Antes de escribir se valida con el
# mismo parser que usa la puerta (json de Python); si no parsea, no se toca.
# Lo prueba .\probar-nuevo-proyecto.ps1.
if ($null -eq $Necesidades) {
    $Necesidades = @{ documentos = @('materia'); ingenieria = @('ingenieria-inversa'); seguimiento = @() }[$Naturaleza]
}
$cat = Join-Path $Raiz '.claude\cascada.json'
if (-not (Test-Path -LiteralPath $cat)) {
    Alto "no existe $cat : la puerta no va a saber que exigirle a '$Nombre'."
    exit 1
}
$txt = [System.IO.File]::ReadAllText($cat, [System.Text.UTF8Encoding]::new($false))
$nl  = if ($txt.Contains("`r`n")) { "`r`n" } else { "`n" }
$lin = [System.Collections.Generic.List[string]]::new([string[]]($txt -split "\r?\n"))
$i0 = -1; $i1 = -1; $ya = $false
for ($k = 0; $k -lt $lin.Count; $k++) { if ($lin[$k] -match '^\s*"proyectos"\s*:\s*\{\s*$') { $i0 = $k; break } }
if ($i0 -ge 0) {
    for ($k = $i0 + 1; $k -lt $lin.Count; $k++) { if ($lin[$k] -match '^  \}') { $i1 = $k; break } }
    for ($k = $i0 + 1; $k -lt $i1; $k++) {
        if ($lin[$k] -match ('^\s*"' + [regex]::Escape($Nombre) + '"\s*:')) { $ya = $true }
    }
}
if ($i0 -lt 0 -or $i1 -lt 0) {
    Alto "no encontre el bloque `"proyectos`" de cascada.json: agrega la fila a mano."
    exit 1
} elseif ($ya) {
    Ok "cascada.json ya tenia la fila de '$Nombre' (no se toco)"
} else {
    $necJson = (@($Necesidades) | ForEach-Object { '"' + $_ + '"' }) -join ', '
    $fila = '    {0,-24} {{"necesidades": [{1}]}}' -f ('"' + $Nombre + '":'), $necJson
    if ($i1 - 1 -gt $i0) { $lin[$i1 - 1] = $lin[$i1 - 1].TrimEnd() + ',' }
    $lin.Insert($i1, $fila)
    $nuevo = $lin -join $nl
    $tmp = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($tmp, $nuevo, [System.Text.UTF8Encoding]::new($false))
        & python -c "import json,sys; d=json.load(open(sys.argv[1],encoding='utf-8')); n=d['proyectos'][sys.argv[2]]['necesidades']; m=[x for x in n if x not in d['necesidades']]; sys.exit('necesidad desconocida: %s' % m if m else 0)" $tmp $Nombre
        $valida = ($LASTEXITCODE -eq 0)
    } finally { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
    if (-not $valida) {
        Alto "la fila nueva no deja un cascada.json valido: NO se escribio. Agregala a mano:"
        Info "  $fila"
        exit 1
    }
    [System.IO.File]::WriteAllText($cat, $nuevo, [System.Text.UTF8Encoding]::new($false))
    Ok "cascada.json: fila de '$Nombre' con necesidades [$necJson] (cambiala ahi si no es esa)"
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
