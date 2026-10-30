# arranque-medicion.ps1 -- hook SessionStart (startup|resume|clear, no compact).
#
# ESTADO DEL SISTEMA, MEDIDO EN ESTE ARRANQUE
#
# El texto fijo (arranque.md) le dice a la sesion que existen los
# verificadores. Correrlos seguia dependiendo de que alguien se acordara, y lo
# unico que avisaba del estado real era el HANDOFF que dejo la sesion anterior
# -- un archivo escrito por otra sesion, que no se entera de nada que haya
# pasado despues de escribirse. Esto es el medidor sacado del sotano y puesto
# en la entrada (Meadows).
#
# POR QUE ES UN HOOK APARTE (T1 de arquitectura-se, 2026-09-28). Hasta hoy el
# texto y la medicion salian del mismo proceso. La medicion, que el 2026-08-29
# tardaba 7 s, llego a 58 s contra un timeout de 60, y el harness la corto en
# 13 de las ultimas 30 sesiones. Un hook cortado no entrega NADA: se perdian
# tambien las autorizaciones permanentes, que no tienen nada que ver. Ahora el
# texto sale solo (arranque-proyecto.ps1, instantaneo) y esto corre la capa
# rapida EN PARALELO con una fecha limite (44 s desde que arranca el hook, ver
# $hasta abajo): entrega lo que termino y
# NOMBRA lo que no. No corre en compact: el estado de la maquina no cambio por
# compactar la conversacion.
#
# Falla ABIERTO a proposito, y por una razon distinta a la del guardia-iso:
# ese frena una accion destructiva y por eso falla cerrado; este solo informa.
# Pero no se calla: dice que no pudo medir.
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

# 44 s desde que arranca el hook (2026-10-30): con el corte en 40 desde el reloj
# interno la sincronia con origin (~38 s) entraba; contado desde el hook, 40 la
# dejaba afuera. Despues del corte quedan <= 5 s de taskkill y la impresion:
# ~10 s de margen contra el timeout de 60 aun con la maquina cargada.
param([int]$FechaLimite = 44)

$ErrorActionPreference = 'Stop'

$raiz    = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$chequeo = Join-Path $raiz 'chequeo-completo.ps1'

Write-Output "=========================================================================="
Write-Output "ESTADO DEL SISTEMA -- medido en ESTE arranque, no leido de un HANDOFF"

# Lo corre medir-inyeccion.py para medir el tamano de este hook: si ademas
# midiera, correria chequeo-completo, que corre medir-inyeccion, que corre
# este hook... El tiempo real lo mide la mitad DESPUES de ese script, sobre
# los transcripts (hook_cancelled).
if ($env:MEDIR_INYECCION) {
    Write-Output "  (medicion salteada: corrida desde medir-inyeccion.py)"
    exit 0
}

if (-not (Test-Path -LiteralPath $chequeo)) {
    Write-Output "  NO SE PUDO MEDIR: falta $chequeo."
    Write-Output "  La bateria de verificadores existe igual; hay que correrla a mano."
    exit 0
}

# La fecha limite cuenta desde que ARRANCO ESTE PROCESO, no desde que arranca
# el reloj de chequeo-completo: el 2026-10-29, con la maquina cargada, los dos
# arranques de PowerShell se comieron ~14 s antes de ese reloj y el hook llego
# a 60,8 s contra 60 de timeout (el harness no entrego NADA). Con el instante
# absoluto, lo que tarde en arrancar sale de la medicion, no del margen.
try { $inicio = (Get-Process -Id $PID).StartTime.ToUniversalTime() } catch { $inicio = [datetime]::UtcNow }
$hasta = $inicio.AddSeconds($FechaLimite).ToString('o')

try {
    $salida = & powershell -NoProfile -ExecutionPolicy Bypass `
                -File $chequeo -SoloMedidores -Compacto -FechaLimite $FechaLimite -Hasta $hasta 2>&1 | Out-String
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
