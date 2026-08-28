# verificar-estructura.ps1 -- las reglas de estructura de claude-acceso, ejecutables.
#
# Y un aviso que MIENTE es peor que no tenerlo: entrena a saltear la lista
# entera, que es la unica forma de romper una alarma sin tocarla. El bloque del
# HANDOFF de la regla 4 avisaba en falso sobre black --su handoff vive en
# sesiones/ y el chequeo miraba solo la raiz-- y por eso el 2026-08-28 se
# corrigio ahi mismo. Un falso positivo se arregla con la misma urgencia que un
# falso negativo.
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
        # El HANDOFF no siempre vive en la raiz: black lo tiene en
        # sesiones/HANDOFF.md desde antes de que este chequeo existiera, y por
        # eso este bloque avisaba en falso. Un aviso que miente es peor que no
        # tenerlo: entrena a saltearse la lista entera, que es la unica forma
        # de romper una alarma sin tocarla.
        #
        # Pero aceptarlo por ruta a secas lo convertiria en "existe un archivo
        # que se llama asi en alguna parte" -- la precondicion, no el efecto.
        # El efecto que importa es que la PROXIMA SESION lo encuentre: o esta
        # en la raiz, donde el nivel 5 de la cascada lo busca solo, o el
        # contrato del proyecto (nivel 4) dice donde esta. Un HANDOFF enterrado
        # en una subcarpeta que nadie nombra es un handoff perdido aunque el
        # archivo exista.
        if (Test-Path -LiteralPath (Join-Path $p.Ruta 'HANDOFF.md')) {
            Ok "$($p.Rel) : ACTIVO y con HANDOFF.md"
        } else {
            $contratoTxt = ''
            $contratoP = Join-Path $p.Ruta 'CLAUDE.md'
            if (Test-Path -LiteralPath $contratoP) {
                $contratoTxt = (Get-Content -LiteralPath $contratoP -Raw -ErrorAction SilentlyContinue)
            }
            $declarado = $null
            $candidatos = @(Get-ChildItem -LiteralPath $p.Ruta -Filter 'HANDOFF.md' -Recurse -File -ErrorAction SilentlyContinue)
            foreach ($h in $candidatos) {
                $relH = $h.FullName.Substring($p.Ruta.Length + 1).Replace('\', '/')
                if ($contratoTxt -match [regex]::Escape($relH)) { $declarado = $relH; break }
            }
            if ($declarado) {
                Ok "$($p.Rel) : ACTIVO y con HANDOFF en $declarado, declarado en su CLAUDE.md"
            } elseif ($candidatos.Count -gt 0) {
                $donde = ($candidatos | ForEach-Object { $_.FullName.Substring($p.Ruta.Length + 1).Replace('\', '/') }) -join ', '
                Warn "$($p.Rel) : ACTIVO y el HANDOFF esta en $donde, pero su CLAUDE.md no lo nombra: la proxima sesion no lo encuentra."
            } else {
                Warn "$($p.Rel) : ACTIVO y sin HANDOFF.md (regla 5 del perfil: el checkpoint son los cuatro)."
            }
        }
    }
}

# =========================================================================
# REGLA 5 -- Nada personal en lo que este repo PUBLICA.
# =========================================================================
# La regla 2 elige el repo dueno segun la sensibilidad. Elegir mal para abajo
# pierde el trabajo; elegir mal para arriba lo PUBLICA. Las dos fallas son
# silenciosas. Esta mide la segunda sobre el objeto real: lo que git trackea.
#
# Cuando se escribio, ya estaba en rojo: electronica-analogica/fuentes/ tenia
# un mail y un telefono commiteados desde siempre y nadie los habia mirado.
# Resultaron ser el pie institucional de la escuela, y ESO ES EL PUNTO: la
# diferencia entre 'dato legitimo' y 'fuga' la decide una persona, una vez, y
# queda escrita en .claude/datos-permitidos.json. Un chequeo sin forma de
# declarar excepciones se apaga entero al primer falso positivo.
Titulo "regla 5: datos personales en lo que este repo publica"

$permitidos = @()
$rutaPermitidos = Join-Path $Raiz '.claude\datos-permitidos.json'
$configOk = $true
if (-not (Test-Path $rutaPermitidos)) {
    Warn "no hay .claude/datos-permitidos.json: se escanea sin excepciones declaradas"
} else {
    try {
        $permitidos = @((Get-Content -Raw -LiteralPath $rutaPermitidos | ConvertFrom-Json).excepciones)
    } catch {
        # Falla CERRADO. Un guardia que se rinde cuando su propio config no
        # parsea deja pasar todo justo cuando menos se lo espera -- ya paso con
        # el guardia del ISO (commit 3ea0054). Aca eso es una falla, no un aviso.
        Fail ".claude/datos-permitidos.json no parsea: $($_.Exception.Message)"
        Write-Host "         El chequeo NO corre sin su lista de excepciones. Arreglar el JSON." -ForegroundColor Red
        $configOk = $false
    }
}

if ($configOk) {
    # Los binarios no se escanean como texto, y el archivo de declaraciones
    # contiene los patrones por definicion: escanearlo seria acusarse solo.
    $binarias = '\.(png|jpg|jpeg|gif|bmp|pdf|docx|xlsx|pptx|zip|exe|dll|bin|iso|p2s|ttf|otf|ico|mp3|wav|mp4|sav)$'
    $patrones = @(
        @{ Nombre = 'mail';     Rx = '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' },
        # Telefono argentino, a proposito ESPECIFICO: prefijo entre parentesis
        # o +54. Un patron laxo de "8 a 10 digitos" da cientos de falsos
        # positivos sobre las direcciones y offsets del proyecto black, y una
        # alarma que salta para todo entrena a ignorarla.
        @{ Nombre = 'telefono'; Rx = '\(0\d{2,4}\)\s*\d{6,8}|\+54[\s-]*9?[\s-]*\d{2,4}[\s-]*\d{6,8}' }
    )

    Push-Location $Raiz
    try {
        # La lista de extensiones es un ATAJO para no abrir archivos grandes,
        # no el criterio. El criterio es el contenido: un binario tiene bytes
        # NUL y un texto no. Enumerar extensiones siempre deja una afuera -- la
        # primera corrida acuso como mail una tira de basura binaria adentro de
        # un .swp de SolidWorks. Un positivo vale lo que valga el parametro.
        #
        # Y ese ejemplo NO se transcribe literal en este comentario: la corrida
        # siguiente lo encontro aca y se acuso a si misma. Este script se
        # escanea como cualquier otro, a proposito -- excluirlo seria dejar el
        # unico archivo donde un mail pegado por error no se veria nunca.
        $tracked = @(git ls-files | Where-Object {
            $_ -notmatch $binarias -and $_ -ne '.claude/datos-permitidos.json'
        } | Where-Object {
            $esTexto = $false
            try {
                $fs  = [System.IO.File]::OpenRead((Join-Path $Raiz $_))
                $buf = New-Object byte[] 8192
                $n   = $fs.Read($buf, 0, 8192)
                $fs.Close()
                $esTexto = $true
                for ($i = 0; $i -lt $n; $i++) { if ($buf[$i] -eq 0) { $esTexto = $false; break } }
            } catch { $esTexto = $false }
            $esTexto
        })

        $fugas = @{}
        $usadas = @{}
        foreach ($pat in $patrones) {
            if ($tracked.Count -eq 0) { continue }
            $hits = Select-String -Path $tracked -Pattern $pat.Rx -AllMatches -ErrorAction SilentlyContinue
            foreach ($h in $hits) {
                $rel = $h.Path
                if ([System.IO.Path]::IsPathRooted($rel)) {
                    $rel = $rel.Substring($Raiz.Length + 1)
                }
                $rel = $rel.Replace('\', '/')
                foreach ($m in $h.Matches) {
                    $valor = $m.Value
                    $exc = $permitidos | Where-Object {
                        $_.patron -eq $valor -and $rel.StartsWith($_.donde)
                    } | Select-Object -First 1
                    if ($exc) {
                        $usadas[$exc.patron] = $true
                        continue
                    }
                    $clave = "$($pat.Nombre)|$valor|$rel"
                    if (-not $fugas.ContainsKey($clave)) { $fugas[$clave] = 0 }
                    $fugas[$clave]++
                }
            }
        }

        if ($fugas.Count -eq 0) {
            Ok "ningun mail ni telefono sin declarar en los $($tracked.Count) archivos de texto que este repo publica"
        } else {
            foreach ($k in ($fugas.Keys | Sort-Object)) {
                $p = $k -split '\|', 3
                Fail "$($p[0]) sin declarar: '$($p[1])' en $($p[2]) ($($fugas[$k]) vez/veces)"
            }
            Write-Host "         claude-acceso es PUBLICO. Dos arreglos validos, ninguno es borrar el chequeo:" -ForegroundColor Red
            Write-Host "           a) el dato es de un tercero -> el proyecto va a repo propio (regla 2, fila del medio)" -ForegroundColor Red
            Write-Host "           b) el dato es legitimamente publico -> declararlo en .claude/datos-permitidos.json" -ForegroundColor Red
        }

        # Una excepcion que ya no matchea nada es ruido que se acumula: la
        # proxima persona que lea el archivo no sabe cual sigue viva.
        foreach ($e in $permitidos) {
            if (-not $usadas.ContainsKey($e.patron)) {
                Warn "datos-permitidos.json declara '$($e.patron)' y ya no aparece en ningun archivo tracked. Sacarlo."
            }
        }
    } finally {
        Pop-Location
    }
}

# =========================================================================
# REGLA 6 -- Censo del Escritorio: los proyectos que nacieron afuera.
# =========================================================================
# Las reglas 1 a 4 miran adentro de proyectos/. Un proyecto que nace en el
# Escritorio es invisible para las cuatro, por construccion -- no por
# distraccion. Paso el 2026-08-28: un informe de Teoria de Circuitos se
# trabajo una sesion entera sin PDP, sin contrato y sin bajar al nivel 3 de
# la cascada, y ninguna regla dijo una palabra.
#
# Meadows: una regla que se incumple no se escribe mas fuerte, se le agrega el
# flujo de informacion que falta. Esto es el medidor electrico mudado del
# sotano a la entrada.
Titulo "regla 6: censo del Escritorio -- proyectos que nacieron afuera"

$escritorio = Split-Path $Raiz -Parent
$fuera = @()
$rutaFuera = Join-Path $Raiz '.claude\fuera-del-sistema.txt'
if (Test-Path $rutaFuera) {
    $fuera = @(Get-Content -LiteralPath $rutaFuera |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -ne '' -and -not $_.StartsWith('#') })
} else {
    Warn "no hay .claude/fuera-del-sistema.txt: el censo va a avisar por toda carpeta del Escritorio"
}

# Que hace que una carpeta "parezca proyecto": tener archivos de trabajo.
# Una carpeta de programas o de fotos no los tiene, y por eso no hace ruido.
$marcasDeProyecto = '\.(md|typ|tex|py|ps1|ipynb|c|h|cpp|rs|go|docx|xlsx|csv|json|sql)$'
$huerfanos = @()
foreach ($d in (Get-ChildItem -LiteralPath $escritorio -Directory -Force -ErrorAction SilentlyContinue)) {
    if ($d.FullName -eq $Raiz -or $d.Name -eq (Split-Path $Raiz -Leaf)) { continue }
    if ($fuera -contains $d.Name) { continue }
    $marcas = @(Get-ChildItem -LiteralPath $d.FullName -File -Recurse -Depth 2 -Force -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match $marcasDeProyecto } | Select-Object -First 3)
    if ($marcas.Count -gt 0) { $huerfanos += ,@($d.Name, $marcas) }
}

if ($huerfanos.Count -eq 0) {
    Ok "ninguna carpeta del Escritorio quedo fuera del sistema sin declarar"
} else {
    foreach ($h in $huerfanos) {
        Warn "'$($h[0])' esta en el Escritorio, parece proyecto y no esta en el sistema."
        Write-Host "         Lo delata: $(($h[1] | ForEach-Object { $_.Name }) -join ', ')" -ForegroundColor Yellow
        Write-Host "         Si ES un proyecto : .\nuevo-proyecto.ps1 '$($h[0])' -Naturaleza <ingenieria|documentos|seguimiento>" -ForegroundColor Yellow
        Write-Host "         Si NO lo es       : agregar '$($h[0])' a .claude\fuera-del-sistema.txt" -ForegroundColor Yellow
    }
}

# =========================================================================
# REGLA 7 -- La cascada no se corta en el nivel 6.
# =========================================================================
# El nivel 6 es "el detalle que la tarea pida", y quien lo manda es el contrato
# del proyecto (nivel 4). La regla 3b ya exige que los enlaces del ENRUTADOR
# resuelvan, pero nadie miraba los de cada contrato -- y ahi es donde la
# cascada se corta sin hacer ruido: la sesion baja hasta el nivel 4, sigue el
# puntero al nivel 6 y cae en un archivo que no existe.
#
# Es la misma ceguera POR CONSTRUCCION que motivo las reglas 5 y 6: un
# verificador solo ve donde vive, y este vivia un nivel mas arriba.
Titulo "regla 7: la cascada no se corta en el nivel 6"

$cortes = 0
$conContrato = 0
foreach ($p in $proyectos) {
    $contrato = Join-Path $p.Ruta 'CLAUDE.md'
    if (-not (Test-Path -LiteralPath $contrato)) { continue }  # ya lo dijo la regla 1
    $conContrato++
    $txtContrato = Get-Content -Raw -LiteralPath $contrato
    foreach ($m in [regex]::Matches($txtContrato, '\]\(([^)#:]+?)\)')) {
        $destino = $m.Groups[1].Value
        if ($destino -match '^(https?|mailto)') { continue }
        # -LiteralPath obligatorio: los corchetes de una ruta son wildcard en
        # PowerShell y Test-Path devuelve False SIN ERROR sobre algo que existe.
        $abs = Join-Path $p.Ruta ($destino -replace '/', '\')
        if (-not (Test-Path -LiteralPath $abs)) {
            Fail "$($p.Rel)/CLAUDE.md enlaza a '$destino' y no existe: la cascada se corta en el nivel 6."
            $cortes++
        }
    }
}
if ($cortes -eq 0) {
    Ok "los enlaces de los $conContrato contratos resuelven: la cascada llega hasta el nivel 6"
}

# El flujo mismo --que archivos leer, en que orden, para UN proyecto-- lo emite
# .\cascada.ps1 <proyecto>. Aca solo se verifica que no este roto.

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
#   regla 4b sacar el HANDOFF de un proyecto ACTIVO         -> [WARN] nombrandolo
#   regla 4c dejar el HANDOFF fuera de la raiz y sacar del  -> [WARN]: "no lo nombra"
#            contrato la linea que lo nombra
#   regla 4  ...con el HANDOFF fuera de la raiz DECLARADO   -> silencio (control negativo)
#   regla 5  pegar un mail en un archivo tracked            -> [FAIL] con archivo y valor
#   regla 5b romper el JSON de datos-permitidos             -> [FAIL]: falla CERRADO
#   regla 6  crear una carpeta con un .md en el Escritorio  -> [WARN] nombrandola
#   regla 6  ...y con una carpeta YA declarada              -> silencio (control negativo)
#
# Un bloque que se agregue aca abajo sin su linea de sabotaje esta sin
# verificar, por bien escrito que parezca. Y las dos ultimas lineas van
# juntas: probar solo que el aviso salta deja sin probar que se calla, y un
# aviso que salta para todo se rompe solo -- la gente aprende a ignorarlo.
