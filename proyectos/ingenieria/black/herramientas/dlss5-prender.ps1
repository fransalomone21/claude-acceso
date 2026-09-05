# dlss5-prender.ps1 -- prende y apaga el pipeline DLSS 5 sin entrar al overlay.
#
# POR QUE EXISTE
#   Que DLSS 5 corra o no depende de UNA linea del ReShadePreset.ini: si
#   `DLSS5_Feed@DLSS5_Feed.fx` no esta en `Techniques=`, el add-on carga igual,
#   el log dice "technique found" y NO PASA NADA. Es una falla silenciosa: no
#   hay error, no hay aviso, y el juego se ve normal. El 2026-09-05 se encontro
#   asi -- instalado, cableado y apagado -- sin que quedara anotado en ningun
#   lado cuando ni por que.
#
#   Prenderlo o apagarlo a mano en el overlay son cuatro clicks adentro del
#   juego y no deja rastro. Esto es un comando, y se puede medir.
#
# EL NUMERO QUE HAY QUE SABER ANTES DE DECIDIR (medido el 2026-09-05, mismo
# savestate del nivel 2, jugador quieto, D3D12, upscale 3):
#
#     DLSS 5 apagado ... 58.19 fps   GS 16.48 ms   GPU 5.28 ms
#     DLSS 5 prendido .. 48.09 fps   GS 20.15 ms   GPU 3.37 ms      -17.4%
#
#   Y el atajo que NO funciona: bajar `upscale_multiplier` de 3 a 2 con DLSS 5
#   prendido da 50.42 fps -- apenas +2.3 -- porque el GS solo baja de 20.15 a
#   19.38 ms con 56% menos pixeles. EL CUELLO DEL GS EN BLACK NO ES DE RELLENO
#   DE PIXELES: no escala con la resolucion interna. Bajarla empeora la imagen
#   y no compra framerate. Queda medido para no volver a intentarlo.
#
# USO
#   .\dlss5-prender.ps1            # dice como esta
#   .\dlss5-prender.ps1 -On
#   .\dlss5-prender.ps1 -Off
param(
    [switch]$On,
    [switch]$Off,
    [string]$Preset = 'C:\Program Files\PCSX2\ReShadePreset.ini'
)
$ErrorActionPreference = 'Stop'
$TECNICA = 'DLSS5_Feed@DLSS5_Feed.fx'
$KERNEL  = 'Lumenite_Kernel@lumenite_Kernel.fx'

if (-not (Test-Path -LiteralPath $Preset)) { throw "No existe el preset: $Preset" }

function LeerTecnicas {
    $l = (Get-Content -LiteralPath $Preset) | Where-Object { $_ -match '^Techniques=' } | Select-Object -First 1
    if (-not $l) { return @() }
    return ($l -replace '^Techniques=','').Split(',') | Where-Object { $_ -ne '' }
}

$actual = @(LeerTecnicas)
$prendido = $actual -contains $TECNICA

if (-not $On -and -not $Off) {
    Write-Host ''
    if ($prendido) { Write-Host '  DLSS 5 esta PRENDIDO  (~48 fps en el nivel 2)' -ForegroundColor Green }
    else           { Write-Host '  DLSS 5 esta APAGADO   (~58 fps en el nivel 2)' -ForegroundColor Yellow }
    Write-Host ''
    Write-Host '  tecnicas activas:'
    foreach ($t in $actual) { Write-Host "    $t" }
    Write-Host ''
    exit 0
}

if (Get-Process pcsx2-qt -ErrorAction SilentlyContinue) {
    Write-Host '  PCSX2 esta ABIERTO. ReShade pisa el preset al salir y el cambio se pierde.' -ForegroundColor Red
    Write-Host '  Cerralo y volve a correr esto.' -ForegroundColor Red
    exit 1
}

$nueva = @($actual | Where-Object { $_ -ne $TECNICA })
if ($On) {
    # el feeder EXIGE que Lumenite_Kernel corra ANTES: es su proveedor de
    # motion vectors (DLSS5_MV_PROVIDER=3). Si falta, avisa por log y no sirve.
    if ($nueva -notcontains $KERNEL) { $nueva = @($nueva) + $KERNEL }
    $nueva = @($nueva) + $TECNICA     # ultima: el feed consume lo que produjeron los otros
}

$bak = "$Preset.bak-$(Get-Date -Format yyyyMMdd-HHmmss)"
Copy-Item -LiteralPath $Preset -Destination $bak -Force

$lineas = Get-Content -LiteralPath $Preset
$salida = foreach ($l in $lineas) {
    if ($l -match '^Techniques=') { 'Techniques=' + ($nueva -join ',') } else { $l }
}
$enc = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($Preset, (($salida -join "`r`n") + "`r`n"), $enc)

# VERIFICA POR EFECTO: relee el archivo del disco, no confia en la variable
$tras = @(LeerTecnicas)
$ahora = $tras -contains $TECNICA
if ($On -and -not $ahora) { throw 'NO quedo prendido en el preset.' }
if ($Off -and $ahora)     { throw 'NO quedo apagado en el preset.' }
if ($ahora) { Write-Host '  DLSS 5 PRENDIDO. Contando ~48 fps en el nivel 2.' -ForegroundColor Green }
else        { Write-Host '  DLSS 5 APAGADO. Contando ~58 fps en el nivel 2.' -ForegroundColor Yellow }
Write-Host "  respaldo: $(Split-Path $bak -Leaf)"
Write-Host ''
Write-Host '  Recorda: la seleccion del depth buffer en Add-ons -> Generic Depth se pierde'
Write-Host '  cada vez que cambia el renderer o la resolucion interna, y sin ella el'
Write-Host '  pipeline queda mudo SIN dar ningun error.'
