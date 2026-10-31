# Pasarle a la PC TODO lo de BLACK sin internet, por pendrive. Sesion (133b). Se corre en la NOTEBOOK:
#
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\PAQUETE-PC.ps1" -Destino E:\
#
# El pendrive: 16 GB o mas, en exFAT o NTFS (FAT32 no acepta archivos de mas de 4 GB y el disco pesa 7,3 GB).
# Arma en el pendrive la carpeta BLACK-para-la-PC con: el juego con el coop y el disco (C:\Games\BLACK\coop, sin
# partidas, registros ni ajustes de esta maquina), el repo claude-acceso (main) en un git bundle, pygame 2.6.1 para
# Python 3.11/3.12/3.13, el instalador de Python 3.11 (por si la PC no lo tiene), los lanzadores y el puente sueltos,
# un manifiesto con el sha256 de cada archivo, y TRAER.ps1, que en la PC copia, verifica y corre PREPARAR-BLACK.ps1.

#   -SoloArmar: arma el paquete en C:\Games\BLACK\paquete-pc y no copia (lo usa SERVIR-A-LA-PC.ps1, por el cable)

param([string]$Destino, [switch]$SoloArmar)

$ErrorActionPreference = 'Stop'
if (-not $Destino -and -not $SoloArmar) { Write-Host "Decime el pendrive: -Destino E:\" -ForegroundColor Red; exit 1 }
$ProgressPreference = 'SilentlyContinue'
$raiz = 'C:\Games\BLACK'
$paq = Join-Path $raiz 'paquete-pc'
$repo = Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')
$black = Split-Path $PSScriptRoot -Parent
New-Item -ItemType Directory -Force $paq, "$paq\wheels", "$paq\scripts\lanzadores", "$paq\scripts\herramientas" | Out-Null

Write-Host "Armando el paquete..." -ForegroundColor Cyan
git -C $repo bundle create (Join-Path $paq 'claude-acceso.bundle') main 2>&1 | Out-Null
if (-not (Get-ChildItem "$paq\wheels" -Filter 'pygame-2.6.1-*.whl' -ErrorAction SilentlyContinue)) {
    foreach ($v in '3.11', '3.12', '3.13') {
        python -m pip download pygame==2.6.1 --only-binary=:all: --platform win_amd64 --python-version $v --implementation cp -d "$paq\wheels" -q 2>&1 | Out-Null
    }
}
$py = Join-Path $paq 'python-3.11.9-amd64.exe'
if (-not (Test-Path -LiteralPath $py)) {
    Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe' -OutFile $py -UseBasicParsing
}
Copy-Item "$PSScriptRoot\plataforma-comun.ps1", "$PSScriptRoot\PREPARAR-BLACK.ps1", "$PSScriptRoot\JUGAR-COOP-RED.ps1", "$PSScriptRoot\PROBAR-COOP-PC.ps1", "$PSScriptRoot\PROBAR-PLATAFORMA-S1.ps1" "$paq\scripts\lanzadores\" -Force
Copy-Item "$black\herramientas\puente_mandos.py" "$paq\scripts\herramientas\" -Force
Copy-Item "$PSScriptRoot\TRAER.ps1" "$paq\" -Force
# el instalador de doble clic (134): Fran abre el pendrive, doble clic, y TRAER corre solo (sin tipear nada en la PC).
# resuelve su propia carpeta base (%~dp0..), asi no depende de la letra del pendrive.
$bat = @'
@echo off
title INSTALAR BLACK en esta PC
pushd "%~dp0.."
echo Instalando BLACK en esta PC (no cierres esta ventana)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0TRAER.ps1" -Origen "%CD%"
popd
echo.
echo Si arriba dice LISTO, ya podes cerrar esta ventana.
pause
'@
[IO.File]::WriteAllText((Join-Path $paq 'INSTALAR-BLACK.bat'), ($bat -replace "`r?`n", "`r`n"), (New-Object Text.ASCIIEncoding))

# el manifiesto: sha256, tamano y ruta relativa a C:\Games\BLACK, de cada archivo que va
$fuera = '\\coop\\(logs|hdd\d*|CrashDumps)\\|\\coop\\(black\.toml|calidad\.toml|ultima-ip\.txt)$'
$archivos = @(Get-ChildItem "$raiz\coop", $paq -Recurse -File | Where-Object { $_.FullName -notmatch $fuera -and $_.Name -ne 'manifiesto.txt' })
$total = ($archivos | Measure-Object Length -Sum).Sum

if (-not $SoloArmar) {
    $letra = (Split-Path $Destino -Qualifier).TrimEnd(':')
    $vol = Get-Volume -DriveLetter $letra
    if ($vol.FileSystem -eq 'FAT32') { Write-Host "El pendrive es FAT32: no acepta el disco (7,3 GB en un archivo). Formatealo en exFAT." -ForegroundColor Red; exit 1 }
    if ($vol.SizeRemaining -lt $total + 200MB) { Write-Host ("Al pendrive le faltan {0:N1} GB." -f (($total + 200MB - $vol.SizeRemaining) / 1GB)) -ForegroundColor Red; exit 1 }
}

Write-Host "Calculando las huellas de $($archivos.Count) archivos (el disco tarda ~30 s)..." -ForegroundColor Cyan
$lineas = foreach ($f in $archivos) {
    "{0}`t{1}`t{2}" -f (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA256).Hash, $f.Length, $f.FullName.Substring($raiz.Length + 1)
}
[IO.File]::WriteAllText("$paq\manifiesto.txt", (($lineas -join "`n") + "`n"), (New-Object Text.UTF8Encoding($false)))
if ($SoloArmar) { Write-Host ("Paquete armado: {0} archivos, {1:N2} GB." -f $archivos.Count, ($total / 1GB)) -ForegroundColor Green; return }

$base = Join-Path $Destino 'BLACK-para-la-PC'
Write-Host ("Copiando {0:N2} GB al pendrive (unos minutos)..." -f ($total / 1GB)) -ForegroundColor Cyan
foreach ($f in $archivos) {
    $d = Join-Path $base $f.FullName.Substring($raiz.Length + 1)
    New-Item -ItemType Directory -Force (Split-Path $d) | Out-Null
    Copy-Item -LiteralPath $f.FullName -Destination $d -Force
}
Copy-Item "$paq\manifiesto.txt" (Join-Path $base 'paquete-pc\') -Force
Write-Host "LISTO en $base." -ForegroundColor Green
Write-Host "En la PC: abri el pendrive y hace DOBLE CLIC en  BLACK-para-la-PC\paquete-pc\INSTALAR-BLACK.bat" -ForegroundColor White
Write-Host "(o por consola: powershell -ExecutionPolicy Bypass -File `"$base\paquete-pc\TRAER.ps1`" -Origen `"$base`")" -ForegroundColor DarkGray
