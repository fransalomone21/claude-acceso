# Prueba en caliente de los clasicos de Sega (L1-03): abre cada juego de juegos-de-a-dos.csv con RetroArch
# («los dos en esta maquina»), espera, saca una captura y lo cierra. Corre en la sesion del usuario (en la PC:
# tarea interactiva de una vez). Nada mientras juegan. Las capturas quedan en C:\Games\_pruebas\caliente-<fecha>\.
param([int]$Espera = 12, [string]$Lista = (Join-Path $PSScriptRoot "juegos-de-a-dos.csv"))
if (Get-Process retroarch -ErrorAction SilentlyContinue) { "RetroArch ya esta abierto: alguien esta jugando, no se prueba nada"; exit 2 }
$ra = "C:\Games\RetroArch"; $core = "cores\genesis_plus_gx_libretro.dll"
$dst = "C:\Games\_pruebas\caliente-" + (Get-Date -Format 'yyyy-MM-dd'); New-Item -ItemType Directory -Force $dst | Out-Null
$cap = Join-Path $PSScriptRoot "abrir-y-capturar.ps1"
foreach ($j in Import-Csv -LiteralPath $Lista) {
    $rom = Join-Path $ra "roms\megadrive\$($j.Rom)"
    if (-not (Test-Path -LiteralPath $rom)) { "{0} | SIN ROM" -f $j.Nombre; continue }
    $png = Join-Path $dst (($j.Nombre -replace '[\\/:*?"<>|]', '-') + ".png")
    $r = & $cap -Exe (Join-Path $ra "retroarch.exe") -Argumentos "-L `"$core`" `"$rom`"" -Captura $png -Espera $Espera
    "{0} | {1}" -f $j.Nombre, $r
    Start-Sleep -Milliseconds 800
}
