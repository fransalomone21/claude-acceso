# cascada.ps1 -- el flujo de lectura de UN proyecto, emitido en orden.
#
# QUE PROBLEMA RESUELVE. La cascada de seis niveles esta escrita en CLAUDE.md
# desde el principio, pero como TABLA: dice que clase de archivo va en cada
# nivel, no cual es el archivo para el proyecto que se esta por abrir. Esa
# traduccion --de "nivel 3: la naturaleza" a "plantillas/naturalezas/
# seguimiento.md"-- la hacia la sesion, de memoria, cada vez. Y lo que depende
# de que alguien lo recuerde no es una regla: es una intencion.
#
# Esto no agrega ninguna regla nueva. Agrega el FLUJO DE INFORMACION que
# faltaba, que es el escalon de arriba en la escala de Meadows: el medidor en
# la entrada en vez de en el sotano.
#
# NO TIENE NINGUNA LISTA PROPIA. Todo sale del disco y de los archivos que ya
# son la fuente: el enrutador para el estado, la carpeta de naturaleza para el
# nivel 3, el contrato del proyecto para el nivel 6. Una segunda lista seria
# exactamente el problema que este archivo existe para no crear -- un dato que
# vive en dos lados diverge.
#
# CONTRA LA DIVERGENCIA, ademas, imprime JUNTAS las dos fuentes que ya se
# contradijeron una vez: la fila del enrutador y el encabezado del
# ESTADO_ACTUAL del proyecto. Si no coinciden, se ve en el momento en que
# importa, y manda el proyecto (regla 4 de CLAUDE.md).
#
# Uso:
#   .\cascada.ps1                 lista los proyectos
#   .\cascada.ps1 coaching        el flujo de lectura de ese proyecto
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

[CmdletBinding()]
param(
    [Parameter(Position = 0)][string]$Proyecto,
    [string]$Raiz = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'
$faltantes = 0

function Nivel($n, $que)  { Write-Host ""; Write-Host ("  NIVEL $n -- $que") -ForegroundColor Cyan }
function Hay($ruta, $nota) {
    $rel = $ruta
    if ($ruta.StartsWith($Raiz)) { $rel = $ruta.Substring($Raiz.Length).TrimStart('\') }
    if (Test-Path -LiteralPath $ruta) {
        $kb = [math]::Round((Get-Item -LiteralPath $ruta).Length / 1KB, 1)
        Write-Host ("    [x] {0}  ({1} KB)" -f $rel, $kb) -ForegroundColor Green
        if ($nota) { Write-Host ("        {0}" -f $nota) -ForegroundColor DarkGray }
        return $true
    }
    Write-Host ("    [ ] {0}  -- NO EXISTE" -f $rel) -ForegroundColor Red
    if ($nota) { Write-Host ("        {0}" -f $nota) -ForegroundColor DarkGray }
    $script:faltantes++
    return $false
}

# --- el disco, medido. No se lee de ningun documento. ---
$proyectos = @()
$dirProyectos = Join-Path $Raiz 'proyectos'
if (Test-Path $dirProyectos) {
    foreach ($nat in Get-ChildItem -Path $dirProyectos -Directory) {
        foreach ($p in Get-ChildItem -Path $nat.FullName -Directory) {
            $proyectos += [PSCustomObject]@{
                Nombre = $p.Name; Naturaleza = $nat.Name; Ruta = $p.FullName
                Rel    = "proyectos/$($nat.Name)/$($p.Name)"
            }
        }
    }
}

if (-not $Proyecto) {
    Write-Host ""
    Write-Host "=== proyectos en el disco ===" -ForegroundColor Cyan
    Write-Host "  (el estado sale del enrutador; el flujo, de .\cascada.ps1 <nombre>)"
    Write-Host ""
    foreach ($p in $proyectos | Sort-Object Naturaleza, Nombre) {
        Write-Host ("  {0,-14} {1}" -f $p.Naturaleza, $p.Nombre)
    }
    Write-Host ""
    exit 0
}

$elegido = @($proyectos | Where-Object { $_.Nombre -eq $Proyecto })
if ($elegido.Count -eq 0) {
    $elegido = @($proyectos | Where-Object { $_.Nombre -like "*$Proyecto*" })
}
if ($elegido.Count -eq 0) {
    Write-Host ""
    Write-Host "  No hay ningun proyecto que matchee '$Proyecto'." -ForegroundColor Red
    Write-Host "  Correr .\cascada.ps1 sin argumentos para ver la lista." -ForegroundColor Red
    Write-Host ""
    exit 1
}
if ($elegido.Count -gt 1) {
    Write-Host ""
    Write-Host "  '$Proyecto' matchea mas de uno: $(($elegido | ForEach-Object { $_.Nombre }) -join ', ')" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}
$pr = $elegido[0]

Write-Host ""
Write-Host "=== cascada de lectura: $($pr.Rel) ===" -ForegroundColor Cyan
Write-Host "  Se baja SOLO hasta donde la tarea necesite. Cada nivel cuesta contexto,"
Write-Host "  y el contexto es lo que despues falta para pensar el problema dificil."

# ---------------------------------------------------------------- 0, 1 y 2
# No se listan como "para leer" porque ya llegaron: se mide que hayan llegado.
Nivel "0-2" "llegan solos por hook -- no cuestan decision"
$destPerfil = Join-Path $env:USERPROFILE '.claude'
foreach ($f in @('pilares.md', 'CLAUDE.md', 'apertura-proyecto.md', 'chequeo-de-trabajo.md')) {
    $ruta = Join-Path $destPerfil $f
    if (Test-Path -LiteralPath $ruta) {
        Write-Host ("    [x] ~/.claude/{0}" -f $f) -ForegroundColor Green
    } else {
        Write-Host ("    [ ] ~/.claude/{0}  -- NO INSTALADO: correr perfil-global\install.ps1" -f $f) -ForegroundColor Red
        $faltantes++
    }
}
[void](Hay (Join-Path $Raiz 'CLAUDE.md') 'nivel 2: el enrutador. Se carga solo al abrir esta carpeta.')

# ------------------------------------------------------------------ nivel 3
Nivel 3 "la naturaleza -- que se lee SIEMPRE en esta clase de proyecto"
[void](Hay (Join-Path $Raiz "plantillas\naturalezas\$($pr.Naturaleza).md") `
       "naturaleza '$($pr.Naturaleza)', deducida de la carpeta en la que vive el proyecto")

# ------------------------------------------------------------------ nivel 4
Nivel 4 "el contrato del proyecto -- el indice de que leer segun la tarea"
$contrato = Join-Path $pr.Ruta 'CLAUDE.md'
$hayContrato = Hay $contrato 'se carga solo SOLO si abris la sesion en esa carpeta; desde la raiz hay que leerlo'

# ------------------------------------------------------------------ nivel 5
Nivel 5 "donde quedamos"
[void](Hay (Join-Path $pr.Ruta 'ESTADO_ACTUAL.md') $null)

# El HANDOFF no siempre vive en la raiz (black lo tiene en sesiones/). Se busca
# en el disco en vez de asumir: el estado de la maquina se mide, no se lee.
$handoffRaiz = Join-Path $pr.Ruta 'HANDOFF.md'
if (Test-Path -LiteralPath $handoffRaiz) {
    [void](Hay $handoffRaiz $null)
} else {
    $otros = @(Get-ChildItem -Path $pr.Ruta -Recurse -Filter 'HANDOFF*.md' -File -ErrorAction SilentlyContinue)
    if ($otros.Count -gt 0) {
        foreach ($o in $otros) { [void](Hay $o.FullName 'el HANDOFF no esta en la raiz: sale del disco, no de una suposicion') }
    } else {
        Write-Host "    [ ] HANDOFF.md -- NO EXISTE en ningun lado del proyecto" -ForegroundColor Red
        Write-Host "        La regla 5 del perfil pide los cuatro: ESTADO_ACTUAL + HANDOFF + commit + push." -ForegroundColor DarkGray
        $faltantes++
    }
}

# ------------------------------------------------------------------ nivel 6
Nivel 6 "solo si la tarea lo pide -- lo que manda el contrato"
if ($hayContrato) {
    $txt = Get-Content -Raw -Encoding UTF8 -LiteralPath $contrato
    $vistos = @()
    foreach ($m in [regex]::Matches($txt, '\]\(([^)#:]+?)\)')) {
        $d = $m.Groups[1].Value
        if ($d -match '^(https?|mailto)') { continue }
        if ($vistos -contains $d) { continue }
        $vistos += $d
        $abs = Join-Path $pr.Ruta ($d -replace '/', '\')
        if (Test-Path -LiteralPath $abs) {
            Write-Host ("    -   {0}" -f $d) -ForegroundColor DarkGray
        } else {
            Write-Host ("    [ ] {0}  -- ROTO: la cascada se corta aca" -f $d) -ForegroundColor Red
            $faltantes++
        }
    }
    if ($vistos.Count -eq 0) { Write-Host "    (el contrato no enlaza a nada: el nivel 6 esta vacio)" -ForegroundColor DarkGray }
} else {
    Write-Host "    (sin contrato no hay nivel 6: la cascada se corta en el 4)" -ForegroundColor Red
}

# ------------------------------------------- las dos fuentes que ya divergieron
Write-Host ""
Write-Host "  ESTADO -- las dos fuentes, juntas a proposito" -ForegroundColor Cyan
Write-Host "  Ya se contradijeron una vez. Si no coinciden, MANDA EL PROYECTO y el" -ForegroundColor DarkGray
Write-Host "  enrutador se corrige en el mismo turno (regla 4 de CLAUDE.md)." -ForegroundColor DarkGray

$textoClaude = Get-Content -Raw -Encoding UTF8 -LiteralPath (Join-Path $Raiz 'CLAUDE.md')
$fila = @($textoClaude -split "`n" | Where-Object { $_ -match [regex]::Escape($pr.Nombre + '/') -and $_ -match '^\|' })
if ($fila.Count -gt 0) {
    Write-Host ("    enrutador : {0}" -f $fila[0].Trim())
} else {
    Write-Host "    enrutador : el proyecto NO figura en el enrutador (lo dice tambien la regla 3)" -ForegroundColor Red
    $faltantes++
}

$ea = Join-Path $pr.Ruta 'ESTADO_ACTUAL.md'
if (Test-Path -LiteralPath $ea) {
    # Se descartan los titulos: '# Estado actual' matchea 'Estado' y no dice
    # NADA, que es peor que no imprimir nada -- da la sensacion de haber
    # contrastado. Se busca una linea que ademas afirme algo.
    $lineas = @(Get-Content -Encoding UTF8 -LiteralPath $ea -TotalCount 40 |
                Where-Object { $_.Trim() -ne '' -and $_ -notmatch '^#{1,6}\s' })
    $dice = @($lineas | Where-Object { $_ -match '(?i)(fase|estado)\s*\**\s*[:=]' })
    if ($dice.Count -eq 0) { $dice = @($lineas | Where-Object { $_ -match '(?i)\bfase\b' }) }
    if ($dice.Count -eq 0) { $dice = @($lineas | Where-Object { $_ -match '\*\*' }) }
    if ($dice.Count -gt 0) { Write-Host ("    proyecto  : {0}" -f $dice[0].Trim()) }
    elseif ($lineas.Count -gt 0) { Write-Host ("    proyecto  : {0}" -f $lineas[0].Trim()) }
    else { Write-Host "    proyecto  : ESTADO_ACTUAL.md existe pero esta vacio" -ForegroundColor Yellow }
} else {
    Write-Host "    proyecto  : sin ESTADO_ACTUAL.md -- no hay con que contrastar" -ForegroundColor Yellow
}

# exit EXPLICITO en los dos caminos. Sin el, el script termina con el
# $LASTEXITCODE que hubiera quedado de antes y "EXIT=1" aparece sobre una
# corrida que salio perfecta -- ya paso al probar este mismo archivo.
Write-Host ""
if ($faltantes -gt 0) {
    Write-Host "  $faltantes archivo(s) de la cascada faltan o estan rotos." -ForegroundColor Red
    Write-Host "  Un nivel que falta no se saltea: se crea, o se dice explicitamente por que no va." -ForegroundColor Red
    Write-Host ""
    exit 1
}
Write-Host "  La cascada esta completa. Bajar solo hasta donde la tarea pida." -ForegroundColor Green
Write-Host ""
exit 0
