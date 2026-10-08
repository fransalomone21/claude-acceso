# Regenera las imagenes de los mecanismos desde dibujo-mecanismos.html (que las dibuja con
# dibujos-mecanismos.js, la misma fuente que usa el modelo 3D):
#   docs/img/mec-*.png  -> las que md-a-gdoc.py incrusta en el Doc «3 - Mecanismos, proveedores y cielo»
# Uso: .\docs\dibujos-mecanismos.ps1   (mismo molde que dibujos-cdm.ps1)
$docs = $PSScriptRoot
$src = "file:///" + ((Join-Path $docs "dibujo-mecanismos.html") -replace '\\', '/')
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (-not (Test-Path $chrome)) { Write-Output "ROJO: no esta Chrome en $chrome"; exit 1 }
$perfil = Join-Path $env:TEMP "chrome-dibujos-mec"
$alto = @{ trans = 720; estrella = 290; palanca = 400; empujon = 600 }
$rojos = 0
foreach ($f in $alto.Keys) {
  $png = Join-Path $docs "img\mec-$f.png"
  if (Test-Path $png) { Remove-Item $png }
  $q = Start-Process -FilePath $chrome -ArgumentList @("--headless=new", "--disable-gpu", "--hide-scrollbars", "--user-data-dir=$perfil", "--virtual-time-budget=3000", "--window-size=852,$($alto[$f])", "--screenshot=`"$png`"", "$src`?fig=$f") -Wait -PassThru -WindowStyle Hidden
  if (-not (Test-Path $png)) { Write-Output "ROJO  $png no se genero (exit=$($q.ExitCode))"; $rojos++; continue }
  Write-Output "PNG  exit=$($q.ExitCode)  $png  $((Get-Item $png).Length) B"
}
exit $rojos
