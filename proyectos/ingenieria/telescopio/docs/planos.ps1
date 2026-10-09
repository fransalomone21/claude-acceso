# Saca el PDF de los planos de disposicion desde planos.html (que los dibuja con geometria-vns.js y
# contacto-vns.js, las mismas fuentes que el modelo 3D): cinco hojas A3 apaisadas, para el Drive.
# Uso: .\docs\planos.ps1 [-Salida <carpeta>]   (por defecto, %TEMP%; mismo molde que dibujos-cdm.ps1)
param([string]$Salida = $env:TEMP)
$docs = $PSScriptRoot
$src = "file:///" + ((Join-Path $docs "planos.html") -replace '\\', '/')
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (-not (Test-Path $chrome)) { Write-Output "ROJO: no esta Chrome en $chrome"; exit 1 }
$perfil = Join-Path $env:TEMP "chrome-planos"
$pdf = Join-Path $Salida "Planos de disposicion (preliminar).pdf"
if (Test-Path $pdf) { Remove-Item $pdf }
# la hoja 5 (tolerancias) se calcula despues de dibujar: el presupuesto de tiempo la espera
$p = Start-Process -FilePath $chrome -ArgumentList @("--headless=new", "--disable-gpu", "--no-pdf-header-footer", "--user-data-dir=$perfil", "--virtual-time-budget=20000", "--run-all-compositor-stages-before-draw", "--print-to-pdf=`"$pdf`"", $src) -Wait -PassThru -WindowStyle Hidden
if (-not (Test-Path $pdf)) { Write-Output "ROJO  no se genero el PDF (exit=$($p.ExitCode))"; exit 1 }
Write-Output "PDF  exit=$($p.ExitCode)  $pdf  $((Get-Item $pdf).Length) B"
