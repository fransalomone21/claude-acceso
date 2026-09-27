# rafaga-capturas.ps1 -- N capturas de pantalla seguidas, sin depender de PINE.
#
# Nacio en la bitacora (77): despues de forzar la secuencia de camara de F504,
# PINE no respondio durante varios segundos, y lo que pasa en ese lapso solo
# se puede ver en pantalla. Cada captura lleva en el nombre los ms desde el
# arranque de la rafaga.
#
#   .\herramientas\rafaga-capturas.ps1 -Carpeta C:\ruta -N 10 -Intervalo 700
param(
    [Parameter(Mandatory=$true)][string]$Carpeta,
    [int]$N = 10,
    [int]$Intervalo = 700
)
$cap = Join-Path $PSScriptRoot 'capturar-pantalla.ps1'
$t0 = Get-Date
for ($i = 0; $i -lt $N; $i++) {
    $ms = [int]((Get-Date) - $t0).TotalMilliseconds
    & $cap -Salida (Join-Path $Carpeta ("rafaga-{0:D2}-{1:D5}ms.png" -f $i, $ms)) -SinFoco | Out-Null
    Start-Sleep -Milliseconds $Intervalo
}
