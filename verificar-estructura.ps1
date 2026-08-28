# verificar-estructura.ps1 -- las reglas de estructura de claude-acceso, ejecutables.
#
# Por que existe: hasta hoy, de las cuatro reglas del CLAUDE.md la unica que
# tenia un chequeo era la del invariante (un archivo, un repo dueno). Las otras
# tres las sostenia que alguien se acordara, y una regla que nadie mide se
# corre sola. Paso: el CLAUDE.md decia que los repos con dueno propio eran dos
# cuando en el disco ya eran tres, y nadie se entero porque nada lo miraba.
#
# La regla de fondo (pilares.md, Meadows): una regla que se incumple no se
# escribe mas fuerte, se le agrega el flujo de informacion que falta.
#
# Cada bloque de aca fue probado ROMPIENDOLO a proposito -- ver el registro de
# sabotajes al pie de este archivo. Un chequeo que nunca se puso en rojo esta
# sin verificar.
#
# ASCII puro a proposito: la consola de Windows lee cp1252 y los acentos salen
# mojibake.
#
# Uso:
#   .\verificar-estructura.ps1

param(
    [string]$Raiz = $PSScriptRoot
)

$fallas = 0
$avisos = 0

function Ok($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  [WARN] $m" -ForegroundColor Yellow; $script:avisos++ }
function Fail($m) { Write-Host "  [FAIL] $m" -ForegroundColor Red;    $script:fallas++ }
function Titulo($m) { Write-Host ""; Write-Host $m -ForegroundColor Cyan }

Write-Host ""
Write-Host "=== estructura de claude-acceso ===" -ForegroundColor Cyan
Write-Host "  Raiz: $Raiz"

$claudeMd = Join-Path $Raiz 'CLAUDE.md'
$mapaMd   = Join-Path $Raiz 'MAPA.md'

if (-not (Test-Path $claudeMd)) {
    Fail "no hay CLAUDE.md en la raiz: sin enrutador no hay estructura que chequear"
    exit 1
}
$textoClaude = Get-Content -Raw -LiteralPath $claudeMd

# --- Lo que hay en el disco, medido. No lo que dice ningun documento. -------
# El estado de la maquina se mide, no se lee (CLAUDE.md, regla 4 del perfil).

$proyectos = @()
$dirProyectos = Join-Path $Raiz 'proyectos'
if (Test-Path $dirProyectos) {
    foreach ($nat in Get-ChildItem -Path $dirProyectos -Directory) {
        foreach ($p in Get-ChildItem -Path $nat.FullName -Directory) {
            $proyectos += [PSCustomObject]@{
                Nombre     = $p.Name
                Naturaleza = $nat.Name
                Ruta       = $p.FullName
                Rel        = "proyectos/$($nat.Name)/$($p.Name)"
                RepoPropio = (Test-Path (Join-Path $p.FullName '.git'))
            }
        }
    }
}

# Carpetas con .git propio en cualquier lado del arbol (menos el .git de la raiz).
$repoPropio = @()
Get-ChildItem -Path $Raiz -Directory -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue |
    Where-Object { Test-Path (Join-Path $_.FullName '.git') } |
    ForEach-Object {
        $repoPropio += $_.FullName.Substring($Raiz.Length + 1).Replace('\', '/')
    }

# =========================================================================
# REGLA 1 -- Un proyecto, una carpeta. Y toda carpeta tiene su contrato.
# =========================================================================
Titulo "regla 1: un proyecto, una carpeta (y su contrato)"

if ($proyectos.Count -eq 0) {
    Fail "no se encontro ningun proyecto en proyectos/<naturaleza>/<proyecto>/"
} else {
    foreach ($p in $proyectos) {
        $plantilla = Join-Path $Raiz "plantillas\naturalezas\$($p.Naturaleza).md"
        if (-not (Test-Path $plantilla)) {
            Fail "$($p.Rel) : naturaleza '$($p.Naturaleza)' sin plantilla en plantillas/naturalezas/"
        }

        $contrato = Join-Path $p.Ruta 'CLAUDE.md'
        if (Test-Path $contrato) {
            Ok "$($p.Rel) : contrato presente"
        } elseif ($p.RepoPropio) {
            # Su contrato es asunto de SU repo, no de este. Se avisa igual:
            # una sesion que abre ahi entra sin nivel 4 de la cascada.
            Warn "$($p.Rel) : sin CLAUDE.md. Tiene repo propio, asi que el arreglo va alla."
        } else {
            Fail "$($p.Rel) : sin CLAUDE.md y lo trackea este repo. La cascada se corta en el nivel 4."
        }
    }
}

# =========================================================================
# REGLA 2 -- Un archivo, un repo dueno.
# =========================================================================
# Se rompio una vez y costo 23 lecciones que vivian en un repo y no en el otro
# (2026-08-27). Este bloque vivia en bootstrap.ps1 y se mudo aca para que todas
# las reglas se chequeen en un solo lugar y con una sola salida.
Titulo "regla 2: un archivo, un repo dueno"

$gitignore = ''
$rutaGitignore = Join-Path $Raiz '.gitignore'
if (Test-Path $rutaGitignore) { $gitignore = Get-Content -Raw -LiteralPath $rutaGitignore }

Push-Location $Raiz
try {
    foreach ($rel in $repoPropio) {
        $n = (git ls-files -- "$rel" | Measure-Object -Line).Lines
        if ($n -gt 0) {
            Fail "$rel tiene su propio .git y claude-acceso trackea $n archivo(s)."
            Write-Host "         Arreglo: git rm -r --cached '$rel'  y agregarlo a .gitignore" -ForegroundColor Red
        } elseif ($gitignore -notmatch [regex]::Escape($rel)) {
            # 0 tracked hoy no alcanza: sin la linea en .gitignore, el proximo
            # 'git add -A' lo vuelve a meter. La ausencia de sintoma no es salud.
            Fail "$rel tiene repo propio y 0 archivos tracked, pero NO esta en .gitignore."
            Write-Host "         El proximo 'git add -A' lo vuelve a trackear. Agregar la linea." -ForegroundColor Red
        } else {
            Ok "$rel : repo propio, 0 tracked, y en .gitignore"
        }
    }
} finally {
    Pop-Location
}

# =========================================================================
# REGLA 3 -- Lo que los documentos dicen se verifica contra el disco.
# =========================================================================
# Un documento no se entera de que alguien cambio el disco. Los dos que hablan
# de la estructura son CLAUDE.md (el enrutador) y MAPA.md (el inventario).
Titulo "regla 3: el enrutador y el inventario contra el disco"

# 3a. Todo proyecto del disco esta nombrado en el enrutador.
foreach ($p in $proyectos) {
    if ($textoClaude -match [regex]::Escape($p.Nombre + '/')) {
        Ok "$($p.Rel) : figura en el enrutador"
    } else {
        Fail "$($p.Rel) existe en el disco y NO figura en CLAUDE.md. Sesion nueva no lo encuentra."
    }
}

# 3b. Todo enlace relativo del enrutador apunta a algo que existe.
$rotos = 0
foreach ($m in [regex]::Matches($textoClaude, '\]\(([^)#:]+?)\)')) {
    $destino = $m.Groups[1].Value
    if ($destino -match '^(https?|mailto)') { continue }
    $abs = Join-Path $Raiz ($destino -replace '/', '\')
    if (-not (Test-Path $abs)) {
        Fail "CLAUDE.md enlaza a '$destino' y no existe."
        $rotos++
    }
}
if ($rotos -eq 0) { Ok "todos los enlaces relativos de CLAUDE.md resuelven" }

# 3c. La tabla de duenos de MAPA.md declara exactamente los repos que hay.
# Esta es la que fallaba: el disco tenia tres repos propios y los documentos
# hablaban de dos.
if (-not (Test-Path $mapaMd)) {
    Warn "no hay MAPA.md: no se puede contrastar la tabla de duenos"
} else {
    $textoMapa = Get-Content -Raw -LiteralPath $mapaMd

    # Solo la seccion 2 (la tabla de duenos). Sin acotar, el parser tambien
    # levanta las rutas de la seccion 3 -- "lo que NO se versiona" -- y avisa
    # de repos que nunca existieron. Un parametro de busqueda mal puesto no se
    # arregla filtrando la salida, se arregla acotando la busqueda.
    $sec2 = [regex]::Match($textoMapa, '(?s)##\s*2\.[^\n]*\n(.*?)(?=\n##\s)')
    $tablaDuenos = ''
    if ($sec2.Success) { $tablaDuenos = $sec2.Groups[1].Value }
    else { Warn "MAPA.md no tiene una seccion '## 2.' con la tabla de duenos" }

    $declarados = @()
    foreach ($m in [regex]::Matches($tablaDuenos, '\|\s*`([^`]+/)`')) {
        $d = $m.Groups[1].Value.TrimEnd('/')
        if ($d -eq 'claude-acceso') { continue }   # la fila del repo raiz
        $declarados += $d
    }
    $enDisco = $repoPropio | Sort-Object -Unique

    foreach ($d in $enDisco) {
        if ($declarados -notcontains $d) {
            Fail "$d tiene repo propio en el disco y MAPA.md no lo declara en la tabla de duenos."
        }
    }
    foreach ($d in ($declarados | Sort-Object -Unique)) {
        if ($enDisco -notcontains $d) {
            Warn "MAPA.md declara '$d' como repo propio y en el disco no esta (o no tiene .git)."
        }
    }
    if (($enDisco | Where-Object { $declarados -notcontains $_ }).Count -eq 0) {
        Ok "la tabla de duenos de MAPA.md cubre los $($enDisco.Count) repos propios del disco"
    }
}

# =========================================================================
# REGLA 4 -- Todo proyecto nace de un PDP, y todo proyecto activo tiene
#            de donde retomarse.
# =========================================================================
Titulo "regla 4: PDP y punto de retome"

# El PDP se le pide a los proyectos VIVOS y que este repo pueda arreglar. Un
# proyecto cerrado no necesita un PDP retroactivo, y uno con repo propio se
# arregla en su repo. Un aviso que salta para todo entrena a ignorarlo, que es
# la unica forma de romper una alarma sin tocarla.
$cerrado = 'cerrado|dormido|suspendido|terminado'
foreach ($p in $proyectos) {
    if ($p.RepoPropio) { continue }
    $fila = ($textoClaude -split "`n" | Where-Object { $_ -match [regex]::Escape($p.Nombre + '/') }) -join ' '
    if ($fila -match $cerrado) { continue }
    if (-not (Test-Path (Join-Path $p.Ruta 'PDP.md'))) {
        Warn "$($p.Rel) : vivo y sin PDP.md (plantillas/PDP.md). Los criterios de salida quedan implicitos."
    }
}

# Un proyecto marcado ACTIVO en el enrutador tiene que poder retomarse.
# Se lee la fila del proyecto en las tablas del CLAUDE.md.
foreach ($linea in ($textoClaude -split "`n")) {
    if ($linea -notmatch 'ACTIVO') { continue }
    foreach ($p in $proyectos) {
        if ($linea -notmatch [regex]::Escape($p.Nombre + '/')) { continue }
        if (Test-Path (Join-Path $p.Ruta 'ESTADO_ACTUAL.md')) {
            Ok "$($p.Rel) : ACTIVO y con ESTADO_ACTUAL.md"
        } else {
            Fail "$($p.Rel) esta marcado ACTIVO y no tiene ESTADO_ACTUAL.md: la proxima sesion arranca de cero."
        }
        if (-not (Test-Path (Join-Path $p.Ruta 'HANDOFF.md'))) {
            Warn "$($p.Rel) : ACTIVO y sin HANDOFF.md (regla 5 del perfil: el checkpoint son los cuatro)."
        }
    }
}

# =========================================================================
Write-Host ""
if ($fallas -gt 0) {
    Write-Host "ESTRUCTURA CON $fallas FALLA(S) y $avisos aviso(s)." -ForegroundColor Red
    Write-Host "Cada [FAIL] trae impreso su arreglo. Los [WARN] no bloquean."
    Write-Host ""
    exit 1
}
Write-Host "Estructura OK. $avisos aviso(s), ninguna falla." -ForegroundColor Green
Write-Host ""

# =========================================================================
# REGISTRO DE SABOTAJES -- que se rompio para probar que cada bloque discrimina
# =========================================================================
# Toda alarma se prueba rompiendola (pilares.md). Lo que se hizo el 2026-08-28,
# cada uno provocado a proposito y revertido despues:
#
#   regla 1  renombrar el CLAUDE.md de un proyecto tracked  -> [FAIL] nombrandolo
#   regla 2  sacar una carpeta con .git del .gitignore      -> [FAIL] nombrandola
#   regla 3a crear proyectos/ingenieria/fantasma/           -> [FAIL] nombrandolo
#   regla 3b enlazar a un archivo inexistente en CLAUDE.md  -> [FAIL] nombrando el enlace
#   regla 3c borrar una fila de la tabla de duenos de MAPA  -> [FAIL] nombrando el repo
#   regla 4  sacar el ESTADO_ACTUAL.md de un proyecto ACTIVO-> [FAIL] nombrandolo
#
# Un bloque que se agregue aca abajo sin su linea de sabotaje esta sin
# verificar, por bien escrito que parezca.
