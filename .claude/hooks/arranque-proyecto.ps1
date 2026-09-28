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
# SOLO el texto, y es a proposito (T1 de arquitectura-se, 2026-09-28): hasta
# ese dia este mismo proceso corria despues la capa rapida de medidores, que
# llego a tardar 58 s contra un timeout de 60. En 13 de 30 sesiones el harness
# lo corto, y un hook cortado no entrega nada: se perdia este texto junto con
# la medicion. La medicion es ahora arranque-medicion.ps1, un hook aparte.
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

$ErrorActionPreference = 'Stop'

$raiz = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$md   = Join-Path $raiz '.claude\arranque.md'

if (-not (Test-Path -LiteralPath $md)) {
    Write-Output "ARRANQUE DE PROYECTO: falta $md -- el hook esta instalado pero no tiene que emitir. Correr .claude\instalar-hooks.ps1 o revisar el repo."
} else {
    Get-Content -LiteralPath $md -Raw -Encoding UTF8 | Write-Output
}

exit 0
