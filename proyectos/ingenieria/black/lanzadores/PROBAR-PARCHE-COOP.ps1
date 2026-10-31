# Probar un parche del coop (BLACK (135c)) sin tocar la instalacion de jugar: arma C:\Games\BLACK\prueba-coop con el
# BLACK.exe que se quiere probar y abre las dos copias en la notebook (PROBAR-COOP-PC.ps1: anfitriona a la izquierda,
# companero a la derecha, un mando cada una). Lo corre Fran.
#
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\PROBAR-PARCHE-COOP.ps1"
#   ... -Control   # el BLACK.exe del release que se juega hoy (C:\Games\BLACK\coop), sin ningun parche nuestro
#
# Sin -Control usa el que dejo COMPILAR-COOP.ps1 (C:\Games\BLACK\src\black-recomp\out\build\release\BLACK.exe), y se
# niega si es mas viejo que el ultimo parche de black\parches-coop (todavia no se compilo con el).
# La carpeta de prueba comparte la ISO con la de jugar (un enlace a su carpeta assets), no la copia.
# Deshacer: borrar C:\Games\BLACK\prueba-coop (el enlace se borra sin tocar la ISO).

param([switch]$Control)

$Jugar   = 'C:\Games\BLACK\coop'
$Prueba  = 'C:\Games\BLACK\prueba-coop'
$Armado  = 'C:\Games\BLACK\src\black-recomp\out\build\release\BLACK.exe'
$Parches = Join-Path (Split-Path $PSScriptRoot -Parent) 'parches-coop'

$exe = if ($Control) { Join-Path $Jugar 'BLACK.exe' } else { $Armado }
if (-not (Test-Path -LiteralPath $exe)) {
    Write-Host "No esta $exe. $(if (-not $Control) { 'Primero COMPILAR-COOP.ps1.' })" -ForegroundColor Red
    Read-Host "Enter para cerrar"; exit 1
}
if (-not $Control) {
    $ultimo = Get-ChildItem $Parches -Filter *.patch | Sort-Object LastWriteTime | Select-Object -Last 1
    if ($ultimo -and (Get-Item -LiteralPath $exe).LastWriteTime -lt $ultimo.LastWriteTime) {
        Write-Host "El BLACK.exe compilado es mas viejo que $($ultimo.Name): primero COMPILAR-COOP.ps1." -ForegroundColor Red
        Read-Host "Enter para cerrar"; exit 1
    }
}

# La carpeta de prueba: lo de la de jugar menos el exe y los registros, y la ISO por enlace.
New-Item -ItemType Directory -Force $Prueba | Out-Null
Get-ChildItem -LiteralPath $Jugar -File | Where-Object { $_.Name -ne 'BLACK.exe' } |
    ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $Prueba -Force }
foreach ($d in 'hdd', 'hdd2') { New-Item -ItemType Directory -Force (Join-Path $Prueba $d) | Out-Null }
$assets = Join-Path $Prueba 'assets'
if (-not (Test-Path -LiteralPath $assets)) { cmd /c "mklink /J `"$assets`" `"$Jugar\assets`"" | Out-Null }
if (-not (Get-ChildItem -LiteralPath $assets -Filter '*.iso' -ErrorAction SilentlyContinue)) {
    Write-Host "No pude enlazar la ISO en $assets." -ForegroundColor Red
    Read-Host "Enter para cerrar"; exit 1
}
Copy-Item -LiteralPath $exe -Destination (Join-Path $Prueba 'BLACK.exe') -Force
$sha = (Get-FileHash -LiteralPath (Join-Path $Prueba 'BLACK.exe') -Algorithm SHA256).Hash
$cual = if ($Control) { 'control (release, sin parches)' } else { 'con los parches' }
Write-Host "Prueba $cual : BLACK.exe $($sha.Substring(0, 12))" -ForegroundColor Cyan

$etiqueta = if ($Control) { 'parche02-control' } else { 'parche02' }
& (Join-Path $PSScriptRoot 'PROBAR-COOP-PC.ps1') -Carpeta $Prueba -Etiqueta $etiqueta
