# probar-cascada.ps1 -- rompe cascada.ps1 a proposito y exige ver el rojo.
#
# La cascada decia "completa" mirando solo que los archivos EXISTIERAN. Desde
# 2026-09-28 tambien mide si el repo REGISTRO el estado (sin commitear, sin
# pushear, ESTADO/HANDOFF atrasados respecto del ultimo commit, fila del
# enrutador mas vieja que el ESTADO) y lista los documentos que el contrato no
# nombra. Un chequeo que nunca fallo esta sin verificar (regla 3 del perfil):
# aca cada falla se provoca sobre un repo SINTETICO, con remote propio, y se
# exige el rojo; y el control (todo al dia) tiene que dar verde.
#
# No toca el repo real: todo vive en %TEMP% y se borra al final.
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

$ErrorActionPreference = 'Stop'
$cascada = Join-Path $PSScriptRoot 'cascada.ps1'
$fallas = 0
$utf8 = New-Object System.Text.UTF8Encoding $false

function Escribir($ruta, $texto) {
    $dir = Split-Path $ruta -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
    [IO.File]::WriteAllText($ruta, $texto, $utf8)
}
function G {
    param([string]$En, [string[]]$a, [string]$Fecha)
    $ErrorActionPreference = 'Continue'
    if ($Fecha) { $env:GIT_AUTHOR_DATE = $Fecha; $env:GIT_COMMITTER_DATE = $Fecha }
    & git -C $En -c user.name=prueba -c user.email=prueba-sin-arroba -c core.autocrlf=false @a *> $null
    Remove-Item Env:GIT_AUTHOR_DATE, Env:GIT_COMMITTER_DATE -ErrorAction SilentlyContinue
}

function Armar {
    $base = Join-Path $env:TEMP ("probar-cascada-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
    $remoto = "$base-remoto.git"
    $raiz = Join-Path $base 'raiz'
    New-Item -ItemType Directory -Force $raiz | Out-Null
    & git init -q --bare $remoto *> $null
    G $raiz @('init', '-q', '-b', 'main')
    Escribir (Join-Path $raiz 'plantillas\naturalezas\ingenieria.md') "# ingenieria`n"
    $pr = Join-Path $raiz 'proyectos\ingenieria\demo'
    Escribir (Join-Path $pr 'CLAUDE.md') "# demo`n`nLeer [el doc](docs/a.md) y ``PDP.md``.`n"
    Escribir (Join-Path $pr 'PDP.md') "# PDP`n"
    Escribir (Join-Path $pr 'docs\a.md') "# a`n"
    Escribir (Join-Path $pr 'ESTADO_ACTUAL.md') "# Estado actual`n`nPreambulo que no afirma nada.`n`n## Fase 1 -- ABIERTA el 2026-01-01`n"
    Escribir (Join-Path $pr 'HANDOFF.md') "# Handoff`n"
    G $raiz @('add', '-A')
    G $raiz @('commit', '-q', '-m', 'proyecto') -Fecha '2026-01-01T10:00:00'
    Escribir (Join-Path $raiz 'CLAUDE.md') "# enrutador`n`n| [``demo/``](proyectos/ingenieria/demo/CLAUDE.md) | demo | fase 1 |`n"
    G $raiz @('add', '-A')
    G $raiz @('commit', '-q', '-m', 'enrutador') -Fecha '2026-01-01T11:00:00'
    G $raiz @('remote', 'add', 'origin', $remoto)
    G $raiz @('push', '-q', '-u', 'origin', 'main')
    return [PSCustomObject]@{ Base = $base; Remoto = $remoto; Raiz = $raiz; Pr = $pr }
}

function Correr($f) {
    $salida = @(& powershell -NoProfile -ExecutionPolicy Bypass -File $cascada demo -Raiz $f.Raiz *>&1 | ForEach-Object { "$_" })
    return [PSCustomObject]@{ Codigo = $LASTEXITCODE; Texto = ($salida -join "`n") }
}

function Caso($nombre, [scriptblock]$romper, [int]$codigo, [string]$debe) {
    $f = Armar
    try {
        & $romper $f
        $r = Correr $f
        $bien = ($r.Codigo -eq $codigo) -and ($r.Texto -match $debe)
        if ($bien) { Write-Host ("  ok    {0}" -f $nombre) -ForegroundColor Green }
        else {
            Write-Host ("  FALLA {0}  (codigo {1}, esperado {2}; buscaba '{3}')" -f $nombre, $r.Codigo, $codigo, $debe) -ForegroundColor Red
            $script:fallas++
        }
    } finally {
        Remove-Item -Recurse -Force $f.Base, $f.Remoto -ErrorAction SilentlyContinue
    }
}

Write-Host ""
Write-Host "=== probar-cascada: cada falla provocada tiene que dar rojo ===" -ForegroundColor Cyan

Caso 'CONTROL: todo al dia da verde y elige el titulo que afirma la fase' { param($f) } 0 'proyecto  : Fase 1 -- ABIERTA'

Caso 'archivo del proyecto sin commitear' {
    param($f); Escribir (Join-Path $f.Pr 'docs\a.md') "# a cambiado`n"
} 1 'SIN COMMITEAR'

Caso 'commit sin pushear' {
    param($f)
    Escribir (Join-Path $f.Pr 'ESTADO_ACTUAL.md') "# Estado actual`n`n## Fase 1 -- ABIERTA el 2026-01-02`n"
    Escribir (Join-Path $f.Pr 'HANDOFF.md') "# Handoff 2`n"
    Escribir (Join-Path $f.Raiz 'CLAUDE.md') "# enrutador`n`n| [``demo/``](proyectos/ingenieria/demo/CLAUDE.md) | demo | fase 1, dia 2 |`n"
    G $f.Raiz @('add', '-A'); G $f.Raiz @('commit', '-q', '-m', 'checkpoint local') -Fecha '2026-01-02T10:00:00'
} 1 'SIN PUSHEAR'

Caso 'ESTADO_ACTUAL y HANDOFF atrasados (commit que no los toca)' {
    param($f)
    Escribir (Join-Path $f.Pr 'docs\a.md') "# a v2`n"
    G $f.Raiz @('add', '-A'); G $f.Raiz @('commit', '-q', '-m', 'trabajo sin checkpoint') -Fecha '2026-01-02T10:00:00'
    G $f.Raiz @('push', '-q')
} 1 'ESTADO_ACTUAL\.md ATRASADO'

Caso 'fila del enrutador mas vieja que el ESTADO' {
    param($f)
    Escribir (Join-Path $f.Pr 'ESTADO_ACTUAL.md') "# Estado actual`n`n## Fase 2 -- ABIERTA el 2026-01-03`n"
    Escribir (Join-Path $f.Pr 'HANDOFF.md') "# Handoff 3`n"
    G $f.Raiz @('add', '-A'); G $f.Raiz @('commit', '-q', '-m', 'fase 2') -Fecha '2026-01-03T10:00:00'
    G $f.Raiz @('push', '-q')
} 1 'ENRUTADOR es mas vieja'

Caso 'CONTROL: fila que no copia el estado no se atrasa aunque el ESTADO cambie' {
    param($f)
    Escribir (Join-Path $f.Raiz 'CLAUDE.md') "# enrutador`n`n| [``demo/``](proyectos/ingenieria/demo/CLAUDE.md) | demo | ACTIVO |`n"
    G $f.Raiz @('add', '-A'); G $f.Raiz @('commit', '-q', '-m', 'fila sin estado') -Fecha '2026-01-02T10:00:00'
    Escribir (Join-Path $f.Pr 'ESTADO_ACTUAL.md') "# Estado actual`n`n## Fase 2 -- ABIERTA el 2026-01-03`n"
    Escribir (Join-Path $f.Pr 'HANDOFF.md') "# Handoff 3`n"
    G $f.Raiz @('add', '-A'); G $f.Raiz @('commit', '-q', '-m', 'fase 2') -Fecha '2026-01-03T10:00:00'
    G $f.Raiz @('push', '-q')
} 0 'no copia el estado'

Caso 'documento en el disco que el contrato no nombra (aviso, no corta)' {
    param($f)
    Escribir (Join-Path $f.Pr 'docs\b-nuevo.md') "# b`n"
    Escribir (Join-Path $f.Pr 'ESTADO_ACTUAL.md') "# Estado actual`n`n## Fase 1 -- ABIERTA el 2026-01-02`n"
    Escribir (Join-Path $f.Pr 'HANDOFF.md') "# Handoff 2`n"
    Escribir (Join-Path $f.Raiz 'CLAUDE.md') "# enrutador`n`n| [``demo/``](proyectos/ingenieria/demo/CLAUDE.md) | demo | fase 1, con b |`n"
    G $f.Raiz @('add', '-A'); G $f.Raiz @('commit', '-q', '-m', 'doc nuevo con checkpoint') -Fecha '2026-01-02T10:00:00'
    G $f.Raiz @('push', '-q')
} 0 '\?\s+docs/b-nuevo\.md'

Caso 'enlace markdown roto en el contrato' {
    param($f)
    Escribir (Join-Path $f.Pr 'CLAUDE.md') "# demo`n`nLeer [el doc](docs/no-existe.md).`n"
    Escribir (Join-Path $f.Pr 'ESTADO_ACTUAL.md') "# Estado actual`n`n## Fase 1 -- ABIERTA el 2026-01-02`n"
    Escribir (Join-Path $f.Pr 'HANDOFF.md') "# Handoff 2`n"
    Escribir (Join-Path $f.Raiz 'CLAUDE.md') "# enrutador`n`n| [``demo/``](proyectos/ingenieria/demo/CLAUDE.md) | demo | fase 1, roto |`n"
    G $f.Raiz @('add', '-A'); G $f.Raiz @('commit', '-q', '-m', 'contrato roto') -Fecha '2026-01-02T10:00:00'
    G $f.Raiz @('push', '-q')
} 1 'ROTO: la cascada se corta'

Write-Host ""
if ($fallas -gt 0) {
    Write-Host "  $fallas caso(s) no dieron lo esperado: la cascada esta ciega en algo." -ForegroundColor Red
    Write-Host ""
    exit 1
}
Write-Host "  probar-cascada: TODO BIEN (8 casos, los 2 controles en verde y 6 fallas en rojo o aviso)" -ForegroundColor Green
Write-Host ""
exit 0
