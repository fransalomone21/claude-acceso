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
} else {
    Get-Content -LiteralPath $md -Raw -Encoding UTF8 | Write-Output
}

# ---------------------------------------------------------------------------
# ESTADO DEL SISTEMA, MEDIDO EN ESTE ARRANQUE
#
# Todo lo de arriba es TEXTO: le dice a la sesion que existen siete
# verificadores. Correrlos seguia dependiendo de que alguien se acordara, y
# lo unico que avisaba del estado real era el HANDOFF que dejo la sesion
# anterior -- un archivo escrito por otra sesion, que no se entera de nada
# que haya pasado despues de escribirse.
#
# Esto es el medidor sacado del sotano y puesto en la entrada (Meadows): la
# capa rapida se corre sola, en cada arranque, y el resultado entra a la
# sesion medido. 7,0 s medidos el 2026-08-29 contra un timeout de 60.
#
# Falla ABIERTO a proposito, y por una razon distinta a la del guardia-iso:
# ese frena una accion destructiva y por eso falla cerrado; este solo
# informa, y un arranque que se cae por no poder medir deja a la sesion sin
# el resto del contexto. Pero no se calla: dice que no pudo medir.
# ---------------------------------------------------------------------------

$chequeo = Join-Path $raiz 'chequeo-completo.ps1'

Write-Output ""
Write-Output "=========================================================================="
Write-Output "ESTADO DEL SISTEMA -- medido en ESTE arranque, no leido de un HANDOFF"

if (-not (Test-Path -LiteralPath $chequeo)) {
    Write-Output "  NO SE PUDO MEDIR: falta $chequeo."
    Write-Output "  La bateria de verificadores existe igual; hay que correrla a mano."
    exit 0
}

try {
    $salida = & powershell -NoProfile -ExecutionPolicy Bypass `
                -File $chequeo -SoloMedidores -Compacto 2>&1 | Out-String
    $code = $LASTEXITCODE
    Write-Output ($salida.TrimEnd())
    if ($code -ne 0) {
        Write-Output ""
        Write-Output "  >>> HAY ROJO EN EL ARRANQUE. Corregirlo ANTES de la tarea que traiga"
        Write-Output "      esta sesion: la bateria mide las capas de las que depende todo lo"
        Write-Output "      demas. El detalle completo, con cuerpo:  .\chequeo-completo.ps1"
    }
} catch {
    Write-Output "  NO SE PUDO MEDIR: $($_.Exception.Message)"
    Write-Output "  Correr a mano:  .\chequeo-completo.ps1"
}

exit 0
