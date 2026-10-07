# Regenera lo que sale de dibujo-cdm.html (la fuente unica de los dibujos del centro de masa):
#   docs/img/cdm-*.png  -> las imagenes que md-a-gdoc.py incrusta en el Doc «2 - Paso a paso»
#   <salida>\Medir el centro de masa.pdf -> la hoja para el celular y para imprimir (va al Drive)
# Uso: .\docs\dibujos-cdm.ps1 [-Salida <carpeta del PDF>]   (por defecto, %TEMP%)
param([string]$Salida = $env:TEMP)
$docs = $PSScriptRoot
$src = "file:///" + ((Join-Path $docs "dibujo-cdm.html") -replace '\\', '/')
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (-not (Test-Path $chrome)) { Write-Output "ROJO: no esta Chrome en $chrome"; exit 1 }
$perfil = Join-Path $env:TEMP "chrome-dibujos-cdm"
$pdf = Join-Path $Salida "Medir el centro de masa.pdf"
$p = Start-Process -FilePath $chrome -ArgumentList @("--headless=new", "--disable-gpu", "--no-pdf-header-footer", "--user-data-dir=$perfil", "--virtual-time-budget=3000", "--print-to-pdf=`"$pdf`"", $src) -Wait -PassThru -WindowStyle Hidden
Write-Output "PDF  exit=$($p.ExitCode)  $pdf"
$alto = @{ vuelco = 820; cantos = 360; celular = 320; eje = 640 }
foreach ($f in $alto.Keys) {
  $png = Join-Path $docs "img\cdm-$f.png"
  $q = Start-Process -FilePath $chrome -ArgumentList @("--headless=new", "--disable-gpu", "--hide-scrollbars", "--user-data-dir=$perfil", "--virtual-time-budget=2000", "--window-size=852,$($alto[$f])", "--screenshot=`"$png`"", "$src`?fig=$f") -Wait -PassThru -WindowStyle Hidden
  Write-Output "PNG  exit=$($q.ExitCode)  $png  $((Get-Item $png).Length) B"
}
