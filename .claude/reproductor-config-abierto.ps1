# reproductor-config-abierto.ps1
#
# NO es parte de probar-hooks.ps1. Es la EVIDENCIA de un hallazgo abierto:
# el pendiente 8 de perfil-global/PENDIENTES.md (2026-08-28).
#
# QUE MUESTRA: el guardia falla ABIERTO, y en silencio, cuando el que no
# parsea no es el JSON del evento --ese agujero lo tapo la leccion 70-- sino
# protegidos.json. Tres lineas de guardia-iso.ps1: el Test-Path, el catch del
# ConvertFrom-Json del config, y el -not $prot.
#
# POR QUE NO ESTA ARREGLADO: poner deny cuando falta el config romperia
# cualquier repo donde el hook este instalado y el archivo no exista -- el
# freno pasado de rosca que despues hace que se saquen todos. Las tres salidas
# posibles estan en el pendiente 8; hay que ELEGIR una. Cuando se elija, el
# caso se folclea en probar-hooks.ps1 y este archivo se borra.
#
# CORRE SOBRE UNA COPIA AISLADA. No toca el repo ni el guardia instalado: el
# guardia calcula su raiz desde $PSScriptRoot, asi que mudarlo de carpeta
# cambia que config lee. Ese es el seam que hace que esto cueste un comando.
#
# El nombre del archivo protegido y el verbo se arman POR PARTES a proposito:
# el guardia real inspecciona el texto de los comandos, asi que un payload
# literal hace que el freno bloquee su propia prueba (leccion 72).
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

$ErrorActionPreference = 'Stop'

$raiz = Split-Path -Parent $PSScriptRoot
$caja = Join-Path $env:TEMP ('guardia-config-' + $PID)

New-Item -ItemType Directory -Force (Join-Path $caja '.claude\hooks') | Out-Null
Copy-Item (Join-Path $raiz '.claude\hooks\guardia-iso.ps1') `
          (Join-Path $caja '.claude\hooks\guardia-iso.ps1') -Force
$cfg  = Join-Path $caja '.claude\protegidos.json'
$hook = Join-Path $caja '.claude\hooks\guardia-iso.ps1'
Copy-Item (Join-Path $raiz '.claude\protegidos.json') $cfg -Force

$pf      = 'C:\Prog' + 'ram Files'
$blanco  = "$pf\PCSX2\PCSX2\games\Black [NTSC]\" + 'Bla' + 'ck.iso'
$payload = @{ tool_name  = 'Bash'
              tool_input = @{ command = ('att' + 'rib -R "{0}"' -f $blanco) } } |
           ConvertTo-Json -Compress

$fallas = 0
function Probar([string]$etiqueta, [bool]$esperaDeny) {
    $out  = $payload | & powershell -NoProfile -ExecutionPolicy Bypass -File $hook 2>$null
    $deny = ("$out" -match 'deny')
    $marca = if ($deny -eq $esperaDeny) { '[OK]  ' } else { $script:fallas++; '[FAIL]' }
    $v = if ($deny) { 'DENY    -- frena' } else { 'PERMITE -- silencio total' }
    '{0} {1,-38} -> {2}' -f $marca, $etiqueta, $v
}

Write-Output 'Hallazgo abierto: el guardia falla ABIERTO si protegidos.json no parsea.'
Write-Output 'Los tres [FAIL] de abajo son el hallazgo, no un error del script.'
Write-Output ''

# Control positivo: sin esto, un guardia que dijera "permitir" a todo tambien
# pasaria los tres casos de abajo (leccion 70).
Probar 'config VALIDO (control positivo)' $true

Set-Content -LiteralPath $cfg -Value '{ esto no es json valido' -Encoding UTF8
Probar 'config CORRUPTO'                  $true

[System.IO.File]::Delete($cfg)
Probar 'config AUSENTE'                   $true

Set-Content -LiteralPath $cfg -Value '{ "archivos": [] }' -Encoding UTF8
Probar 'config con lista VACIA'           $true

Remove-Item -Recurse -Force $caja -ErrorAction SilentlyContinue

Write-Output ''
if ($fallas -eq 0) {
    Write-Output "Los 4 casos frenaron: el hallazgo esta ARREGLADO."
    Write-Output "Folclear el caso en probar-hooks.ps1 y borrar este archivo."
} else {
    Write-Output "$fallas de 4 dejan pasar en silencio. Hallazgo VIGENTE."
    Write-Output "Detalle y las tres salidas posibles: perfil-global/PENDIENTES.md, pendiente 8."
}
