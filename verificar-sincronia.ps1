# verificar-sincronia.ps1 -- mide si este arbol esta atrasado respecto de origin.
#
# POR QUE EXISTE. Con UNA maquina, "el repo es la memoria" se cumple solo:
# no hay otra copia que pueda estar mas adelante. Con DOS, aparece una falla
# que no existia y que no duele el mismo dia: abrir una sesion sobre un arbol
# atrasado. El sintoma no es un error -- es peor: la sesion trabaja bien,
# sobre una base vieja, y el precio se paga al pushear, o no se paga nunca
# porque la version buena queda tapada.
#
# La regla "pullear antes de trabajar" sin un medidor es una intencion. Esto
# es el medidor mudado del sotano a la entrada (pilares.md, Meadows): corre en
# cada arranque, dentro de chequeo-completo.ps1.
#
# ROJO solo para ATRASADO. Tener commits sin pushear es el estado NORMAL de
# una sesion a mitad de camino; ponerlo en rojo entrenaria a ignorar el aviso,
# que es como se pierde una alarma. Eso sale en amarillo y lo cierra la regla
# 5 del perfil (checkpoint antes de parar).
#
# FALLA ABIERTO ante la red, no ante el atraso: sin conexion no se puede
# medir, y bloquear la sesion por eso seria un freno pasado de rosca. Pero NO
# en silencio: dice que no midio.
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

[CmdletBinding()]
param(
    [string]$Raiz = $PSScriptRoot,
    [int]$TimeoutSeg = 20
)

$ErrorActionPreference = 'Continue'

# Sin esto, un repo privado sin credenciales cacheadas deja a git esperando
# un usuario que nunca va a llegar, y el hook de SessionStart se cuelga con el
# la sesion entera. Un medidor que puede colgar el arranque no se instala.
$env:GIT_TERMINAL_PROMPT = '0'

$fallas = 0
$avisos = 0

function Ok($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  [WARN] $m" -ForegroundColor Yellow; $script:avisos++ }
function Fail($m) { Write-Host "  [FAIL] $m" -ForegroundColor Red;    $script:fallas++ }

Write-Host ""
Write-Host "=== sincronia con origin ===" -ForegroundColor Cyan

# Los repos a medir se DESCUBREN: cualquier carpeta con .git dentro del arbol,
# mas la raiz. No hay lista escrita a mano, por el mismo motivo de siempre --
# una segunda lista diverge, y ya paso con la de los repos duenos.
$repos = @($Raiz)
$repos += @(Get-ChildItem -LiteralPath $Raiz -Directory -Recurse -Force -Filter '.git' -ErrorAction SilentlyContinue |
            ForEach-Object { Split-Path -Parent $_.FullName } |
            Where-Object { $_ -ne $Raiz })

$medidos = 0
foreach ($r in ($repos | Sort-Object -Unique)) {
    $nombre = if ($r -eq $Raiz) { Split-Path -Leaf $r } else { $r.Substring($Raiz.Length).TrimStart('\', '/') }

    $remote = (& git -C $r remote 2>$null | Select-Object -First 1)
    if (-not $remote) {
        # Sin remote no hay con que comparar. No es un fallo: caso-tio y
        # teoria-circuitos existen a proposito solo en la maquina donde se
        # crearon. Se nombra igual, porque "no viaja" es un dato, no un hueco.
        Write-Host "  [----] $nombre : sin remote, solo existe en esta maquina" -ForegroundColor DarkGray
        continue
    }

    # El fetch se corre en un job para poder cortarlo: sin timeout, una red
    # caida convierte a este medidor en el problema que vino a evitar.
    $job = Start-Job -ScriptBlock {
        param($ruta, $rem)
        $env:GIT_TERMINAL_PROMPT = '0'
        & git -C $ruta fetch --quiet $rem 2>&1 | Out-Null
        return $LASTEXITCODE
    } -ArgumentList $r, $remote

    $term = Wait-Job $job -Timeout $TimeoutSeg
    $code = if ($term) { Receive-Job $job } else { $null }
    Remove-Job $job -Force -ErrorAction SilentlyContinue

    if ($null -eq $code) {
        Warn "$nombre : el fetch no respondio en $TimeoutSeg s. NO se midio la sincronia."
        continue
    }
    if ($code -ne 0) {
        Warn "$nombre : el fetch fallo (exit=$code, sin red o sin credenciales). NO se midio."
        continue
    }

    $cuenta = (& git -C $r rev-list --left-right --count 'HEAD...@{u}' 2>$null)
    if (-not $cuenta) {
        Warn "$nombre : la rama no tiene upstream configurado. NO se midio."
        continue
    }
    $medidos++
    $partes  = $cuenta -split '\s+'
    $adelante = [int]$partes[0]
    $atras    = [int]$partes[1]

    if ($atras -gt 0) {
        Fail "$nombre : ATRASADO $atras commit(s) respecto de origin."
        Write-Host "         Trabajar asi produce la version que despues queda tapada." -ForegroundColor Red
        Write-Host "         Antes de tocar nada:  git -C `"$r`" pull --ff-only" -ForegroundColor Red
    } elseif ($adelante -gt 0) {
        Warn "$nombre : $adelante commit(s) sin pushear (la otra maquina no los ve)."
    } else {
        Ok "$nombre : al dia con origin"
    }
}

if ($medidos -eq 0 -and $fallas -eq 0) {
    # Un medidor que no midio nada y sale en verde es exactamente la clase de
    # verde silencioso que este sistema existe para no tener.
    Warn "no se pudo medir NINGUN repo: este chequeo no dice nada hoy."
}

Write-Host ""
if ($fallas -gt 0) {
    Write-Host "  Hay arboles ATRASADOS: pullear antes de trabajar." -ForegroundColor Red
    exit 1
}
if ($avisos -gt 0) {
    Write-Host "  Sin atrasos. $avisos aviso(s) arriba." -ForegroundColor Yellow
} else {
    Write-Host "  Todo al dia con origin." -ForegroundColor Green
}
exit 0
