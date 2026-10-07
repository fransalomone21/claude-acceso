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
#   .\cascada.ps1 black -Necesidad ingenieria-inversa,diseno
#                                 declara la necesidad e imprime lo que la PUERTA exige leer (T11)
#   .\cascada.ps1 black -Excepcion "motivo"   la salida explicita de la puerta, registrada
#
# Desde T11 (2026-10-02) la cascada no es un consejo: .claude/hooks/cascada_puerta.py NO DEJA ACTUAR sobre un
# proyecto hasta que la sesion declaro la necesidad y LEYO con Read lo que el catalogo .claude/cascada.json exige.
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

[CmdletBinding()]
param(
    [Parameter(Position = 0)][string]$Proyecto,
    [string[]]$Necesidad,       # T11: la necesidad de Fran que se va a resolver (la puerta la exige)
    [string]$Excepcion,         # T11: salida explicita de la puerta, con motivo; queda registrada
    [string]$Raiz = $PSScriptRoot
)

$ErrorActionPreference = 'Stop'
$faltantes = 0
$avisos = 0      # lo que existe pero el indice no nombra: se ve, no corta
$atrasos = 0     # lo que el repo no registro todavia: corta, como un faltante

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

# ----------------------------------------------------------------- nivel 0b
# El libro de bolsillo de arquitectura e ingenieria de sistemas: NO llega por hook, se LEE, y es lo primero que
# exige la puerta para cualquier proyecto (2026-10-07: nueve sesiones de diseno sin requisitos, con el libro en casa).
Nivel "0b" "el libro de bolsillo: arquitectura e ingenieria de sistemas -- SIEMPRE primero, antes del proyecto"
# Adentro del arbol en la PC; AL LADO en la nube (traer-perfil.sh), igual que expandir() de la puerta.
$nucleo = Join-Path $Raiz 'perfil-global\pilares\nucleo-ise.md'
$nucleoAlLado = Join-Path (Split-Path $Raiz -Parent) 'perfil-global\pilares\nucleo-ise.md'
if (-not (Test-Path -LiteralPath $nucleo) -and (Test-Path -LiteralPath $nucleoAlLado)) { $nucleo = $nucleoAlLado }
[void](Hay $nucleo 'fases, requisitos, arquitectura, V&V y donde esta el resto del libro (si NO EXISTE: falta el libro -> perfil-global\install.ps1, o en la nube bash .claude/nube/traer-perfil.sh)')

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
    # Las rutas entre comillas invertidas (`PDP.md`, `docs/03-bitacora.md`) son
    # la mitad del indice que el regex de arriba no veia: el contrato de black
    # nombra asi casi todo. Se miden igual: si no existen, la cascada se corta.
    foreach ($m in [regex]::Matches($txt, '`([A-Za-z0-9_./-]+\.md)`')) {
        $d = $m.Groups[1].Value
        if ($vistos -contains $d) { continue }
        $abs = Join-Path $pr.Ruta ($d -replace '/', '\')
        if (-not (Test-Path -LiteralPath $abs)) { continue }   # un nombre suelto de otro proyecto no es un enlace
        $vistos += $d
        Write-Host ("    -   {0}" -f $d) -ForegroundColor DarkGray
    }
    if ($vistos.Count -eq 0) { Write-Host "    (el contrato no enlaza a nada: el nivel 6 esta vacio)" -ForegroundColor DarkGray }

    # Los documentos que HAY y el contrato no nombra. Sin esto la cascada da
    # "completa" mientras la sesion ignora los documentos nuevos: el indice
    # envejece en silencio y nadie lo nota hasta que alguien no lee algo.
    $nombrados = @($vistos | ForEach-Object { ($_ -replace '\\', '/').TrimStart('./') })
    $sinIndice = @()
    foreach ($sub in @('', 'docs', 'sesiones')) {
        $dir = if ($sub) { Join-Path $pr.Ruta $sub } else { $pr.Ruta }
        if (-not (Test-Path -LiteralPath $dir)) { continue }
        foreach ($f in Get-ChildItem -LiteralPath $dir -Filter '*.md' -File) {
            $rel = if ($sub) { "$sub/$($f.Name)" } else { $f.Name }
            if ($rel -in @('CLAUDE.md', 'ESTADO_ACTUAL.md', 'HANDOFF.md', 'sesiones/HANDOFF.md')) { continue }
            if ($nombrados -contains $rel) { continue }
            if ($txt -match [regex]::Escape($f.Name)) { continue }   # nombrado sin ruta, igual cuenta
            $sinIndice += $rel
        }
    }
    if ($sinIndice.Count -gt 0) {
        Write-Host ("    EN EL DISCO Y SIN NOMBRAR EN EL CONTRATO ({0}) -- existen; el indice no los ve:" -f $sinIndice.Count) -ForegroundColor Yellow
        foreach ($s in $sinIndice) { Write-Host ("    ?   {0}" -f $s) -ForegroundColor Yellow }
        $avisos += $sinIndice.Count
    }
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
    # Un ESTADO_ACTUAL largo (black: 118 KB) abre con un parrafo de COMO leerlo
    # y el estado vive en su primer titulo de seccion que afirma una fase. Ese
    # titulo manda sobre cualquier renglon del preambulo: hasta 2026-09-28 aca
    # salia "Indice operativo compacto...", y el contraste quedaba ciego.
    # Solo "abierta/cerrada": con "fase" a secas salian titulos como "Lo que
    # FALTA, para la fase 7", que nombran una fase sin afirmar su estado.
    $titulo = @(Get-Content -Encoding UTF8 -LiteralPath $ea -TotalCount 120 |
                Where-Object { $_ -match '^##\s' -and $_ -match '(?i)(abiert|cerrad)' })
    $dice = @($titulo | ForEach-Object { $_ -replace '^##\s+', '' })
    # El encabezado de una tabla ("| Fase | Estado |") y su separador no afirman
    # nada: se sacan antes de los otros intentos.
    $crudo = @(Get-Content -Encoding UTF8 -LiteralPath $ea -TotalCount 40)
    $cabeceras = @()
    for ($k = 0; $k -lt $crudo.Count - 1; $k++) {
        if ($crudo[$k + 1] -match '^\s*\|[\s\-:|]+\|\s*$') { $cabeceras += $crudo[$k] }
    }
    $lineas = @($lineas | Where-Object { $_ -notmatch '^\s*\|[\s\-:|]+\|\s*$' -and $cabeceras -notcontains $_ })
    if ($dice.Count -eq 0) { $dice = @($lineas | Where-Object { $_ -match '(?i)(fase|estado)\s*\**\s*[:=]' }) }
    if ($dice.Count -eq 0) { $dice = @($lineas | Where-Object { $_ -match '(?i)\bfase\b' }) }
    if ($dice.Count -eq 0) { $dice = @($lineas | Where-Object { $_ -match '\*\*' }) }
    if ($dice.Count -gt 0) { Write-Host ("    proyecto  : {0}" -f $dice[0].Trim()) }
    elseif ($lineas.Count -gt 0) { Write-Host ("    proyecto  : {0}" -f $lineas[0].Trim()) }
    else { Write-Host "    proyecto  : ESTADO_ACTUAL.md existe pero esta vacio" -ForegroundColor Yellow }
} else {
    Write-Host "    proyecto  : sin ESTADO_ACTUAL.md -- no hay con que contrastar" -ForegroundColor Yellow
}

# ------------------------------------------------------------ AL DIA (git)
# Que los archivos EXISTAN no dice que esten al dia. Lo que si se puede medir,
# sin ninguna lista propia, es lo que el repo registro: (1) nada del proyecto
# sin commitear, (2) nada sin pushear, (3) que el ultimo checkpoint haya tocado
# ESTADO_ACTUAL y HANDOFF (regla 5: los cuatro), y (4) que la fila del
# enrutador no sea mas vieja que el ESTADO_ACTUAL (regla 4 de CLAUDE.md).
# Mide el REGISTRO, no el contenido: un ESTADO reescrito con datos viejos pasa.
# Eso sigue siendo del que lo escribe; esto atrapa el que ni se escribio.
Write-Host ""
Write-Host "  AL DIA -- lo que el repo registro (git), no lo que dice el disco" -ForegroundColor Cyan
# En PS 5.1, con 'Stop', el stderr de un ejecutable nativo redirigido se vuelve
# una excepcion: adentro de git se baja a 'Continue' y manda el codigo de salida.
function Git-P {
    param([string[]]$a, [string]$En = $pr.Ruta)
    $ErrorActionPreference = 'Continue'
    $o = & git -C $En @a 2>$null
    if ($LASTEXITCODE -ne 0) { return $null }
    return $o
}
$top = Git-P @('rev-parse', '--show-toplevel')
if (-not $top) {
    Write-Host "    [ ] el proyecto no esta en ningun repo git: nada de esto quedo registrado" -ForegroundColor Red
    $atrasos++
} else {
    $sucio = @(Git-P @('status', '--porcelain', '--', '.'))
    if ($sucio.Count -gt 0) {
        Write-Host ("    [ ] {0} archivo(s) del proyecto SIN COMMITEAR:" -f $sucio.Count) -ForegroundColor Red
        $sucio | Select-Object -First 8 | ForEach-Object { Write-Host "          $_" -ForegroundColor Red }
        $atrasos++
    } else { Write-Host "    [x] nada del proyecto sin commitear" -ForegroundColor Green }

    $up = Git-P @('rev-parse', '--abbrev-ref', '--symbolic-full-name', '@{u}')
    if (-not $up) {
        Write-Host "    [~] la rama no sigue a ningun remote: lo commiteado no salio de esta maquina" -ForegroundColor Yellow
        $avisos++
    } else {
        $sinPush = @(Git-P @('rev-list', "$up..HEAD", '--', '.'))
        if ($sinPush.Count -gt 0) {
            Write-Host ("    [ ] {0} commit(s) del proyecto SIN PUSHEAR a {1}" -f $sinPush.Count, $up) -ForegroundColor Red
            $atrasos++
        } else { Write-Host "    [x] nada del proyecto sin pushear a $up" -ForegroundColor Green }
    }

    # El HANDOFF sale del disco, igual que en el nivel 5.
    $hoRel = if (Test-Path -LiteralPath (Join-Path $pr.Ruta 'HANDOFF.md')) { 'HANDOFF.md' } else {
        $h = @(Get-ChildItem -Path $pr.Ruta -Recurse -Filter 'HANDOFF.md' -File -ErrorAction SilentlyContinue | Select-Object -First 1)
        if ($h.Count) { $h[0].FullName.Substring($pr.Ruta.Length).TrimStart('\') -replace '\\', '/' } else { $null } }
    foreach ($doc in @('ESTADO_ACTUAL.md', $hoRel)) {
        if (-not $doc -or -not (Test-Path -LiteralPath (Join-Path $pr.Ruta $doc))) { continue }
        $ultimo = Git-P @('log', '-1', '--format=%H', '--', $doc)
        if (-not $ultimo) {
            Write-Host "    [ ] $doc nunca se commiteo" -ForegroundColor Red; $atrasos++; continue
        }
        $despues = @(Git-P @('log', '--format=%h %s', "$ultimo..HEAD", '--', '.', ":(exclude)$doc"))
        if ($despues.Count -gt 0) {
            Write-Host ("    [ ] {0} ATRASADO: {1} commit(s) del proyecto despues de su ultimo cambio" -f $doc, $despues.Count) -ForegroundColor Red
            $despues | Select-Object -First 3 | ForEach-Object {
                $l = if ($_.Length -gt 110) { $_.Substring(0, 110) + '...' } else { $_ }
                Write-Host "          $l" -ForegroundColor Red }
            $atrasos++
        } else { Write-Host "    [x] $doc lo toco el ultimo commit del proyecto" -ForegroundColor Green }
    }

    # La fila del enrutador vive en OTRO archivo (y a veces en otro repo): se
    # compara por fecha. Mas vieja que el ESTADO_ACTUAL = el enrutador no se
    # entero del ultimo estado (regla 4: gana el proyecto, se corrige la fila).
    # T12 (2026-10-02): la fila que NO copia el estado (solo que es y si esta activo) no tiene nada que se
    # atrase, y exigirle la fecha obligaba a tocarla por tramite en cada checkpoint. Se vigila la que copia
    # una fase, que es la que ya se contradijo con el proyecto (decia fase 5 cuando iba por la 7e).
    $copiaEstado = ($fila.Count -gt 0) -and ($fila[0] -match '(?i)\bfase\b')
    $tEstado = Git-P @('log', '-1', '--format=%ct', '--', 'ESTADO_ACTUAL.md')
    $tFila = Git-P @('log', '-1', '--format=%ct', '-G', ([regex]::Escape($pr.Nombre + '/')), '--', 'CLAUDE.md') -En $Raiz
    if (-not $copiaEstado -and $fila.Count -gt 0) {
        Write-Host "    [x] la fila del enrutador no copia el estado (no nombra una fase): nada que se atrase" -ForegroundColor Green
    } elseif ($tEstado -and $tFila) {
        if ([long]$tFila -lt [long]$tEstado) {
            $dias = [math]::Round(([long]$tEstado - [long]$tFila) / 86400, 1)
            Write-Host ("    [ ] la fila del ENRUTADOR es mas vieja que el ESTADO_ACTUAL ({0} dias): corregirla" -f $dias) -ForegroundColor Red
            $atrasos++
        } else { Write-Host "    [x] la fila del enrutador se toco despues del ultimo ESTADO_ACTUAL" -ForegroundColor Green }
    }
}

# ------------------------------------------- T11: lo que la PUERTA exige
# No hay segunda lista: lo calcula cascada_puerta.py desde .claude/cascada.json, igual que la puerta.
$py = Join-Path $Raiz '.claude\hooks\cascada_puerta.py'
Write-Host ""
if ($Excepcion) {
    Write-Host "  EXCEPCION a la puerta para $($pr.Nombre): '$Excepcion'. Pasa en esta sesion y queda registrada." -ForegroundColor Yellow
} elseif (Test-Path -LiteralPath $py) {
    $pyArgs = @($py, '--exige', $pr.Nombre)
    if ($Necesidad) { $pyArgs += @('--necesidad', ($Necesidad -join ',')) }
    $ErrorActionPreference = 'Continue'
    & python @pyArgs 2>&1 | ForEach-Object { Write-Host $_ }
    $ErrorActionPreference = 'Stop'
} else {
    # aviso y no faltante: en un repo sintetico (probar-cascada.ps1) no esta, y en el real lo mide --verificar
    Write-Host "  [~] falta .claude\hooks\cascada_puerta.py: la puerta de T11 no esta en esta raiz" -ForegroundColor Yellow
    $avisos++
}

# exit EXPLICITO en los dos caminos. Sin el, el script termina con el
# $LASTEXITCODE que hubiera quedado de antes y "EXIT=1" aparece sobre una
# corrida que salio perfecta -- ya paso al probar este mismo archivo.
Write-Host ""
if ($avisos -gt 0) {
    Write-Host "  $avisos aviso(s): documentos que existen y el contrato no nombra, o rama sin remote." -ForegroundColor Yellow
}
if ($atrasos -gt 0) {
    Write-Host "  $atrasos atraso(s): el repo no registro el estado actual. Commit + push, y ESTADO/HANDOFF/enrutador al dia." -ForegroundColor Red
    if ($faltantes -eq 0) { Write-Host ""; exit 1 }
}
if ($faltantes -gt 0) {
    Write-Host "  $faltantes archivo(s) de la cascada faltan o estan rotos." -ForegroundColor Red
    Write-Host "  Un nivel que falta no se saltea: se crea, o se dice explicitamente por que no va." -ForegroundColor Red
    Write-Host ""
    exit 1
}
Write-Host "  La cascada esta completa. Bajar solo hasta donde la tarea pida." -ForegroundColor Green
Write-Host ""
exit 0
