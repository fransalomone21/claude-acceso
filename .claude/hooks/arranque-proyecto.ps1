# arranque-proyecto.ps1 -- hook SessionStart.
#
# Emite .claude/arranque.md: lo que hoy vive en archivos que NO se leen solos
# (lanzadores/LEEME.md, sesiones/HANDOFF.md, el CLAUDE.md del proyecto que solo
# carga si abris ahi) y que por eso se olvidaba cada sesion.
#
# El texto vive en UN solo lugar -- el .md -- y este script solo lo emite.
# Si el .md falta, el hook lo DICE en vez de callarse: un hook que falla en
# silencio es peor que no tenerlo, porque nadie se entera de que dejo de andar.
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

$ErrorActionPreference = 'Stop'

$raiz = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$md   = Join-Path $raiz '.claude\arranque.md'

if (-not (Test-Path -LiteralPath $md)) {
    Write-Output "ARRANQUE DE PROYECTO: falta $md -- el hook esta instalado pero no tiene que emitir. Correr .claude\instalar-hooks.ps1 o revisar el repo."
    exit 0
}

Get-Content -LiteralPath $md -Raw -Encoding UTF8 | Write-Output
exit 0
