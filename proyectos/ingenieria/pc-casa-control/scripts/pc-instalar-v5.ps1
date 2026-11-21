# v5 (filas del menu con temas famosos): se corre EN LA PC. Cierra el juego SOLO si se pasa -CerrarJuego.
# Chequea md5 de la copia contra md5-v5.txt, aparta lo que reemplaza (no borra) y copia la v5.
# Reemplaza: ~mods\zzLinkinParkTodo_P.* (v4 -> v5) y Mods\ZeroSpark\Json\LinkinParkNombres.json (nombres de las filas).
# NO toca el DLC, el guardado ni los demas mods. Deshacer: devolver lo de Mods-desactivados\paks\v4-conocidas.
param([switch]$CerrarJuego)
$juego = 'C:\Games\Dragon Ball Sparking ZERO'
$mods = "$juego\SparkingZERO\Content\Paks\~mods"
$json = "$juego\SparkingZERO\Mods\ZeroSpark\Json"
$des = "$juego\SparkingZERO\Mods-desactivados\paks\v4-conocidas"
$ent = 'C:\Users\Fran\lp-todo\v5'
$p = Get-Process | Where-Object { $_.ProcessName -like 'SparkingZERO*' }
if ($p -and -not $CerrarJuego) { 'EL JUEGO ESTA ABIERTO: no toco nada. Cerralo o pasame -CerrarJuego.'; exit 2 }
if ($p) { $p | Stop-Process -Force; Start-Sleep 4 }
if (Get-Process | Where-Object { $_.ProcessName -like 'SparkingZERO*' }) { 'no se pudo cerrar el juego'; exit 3 }
$esp = @{}
Get-Content "$ent\md5-v5.txt" | ForEach-Object { $n, $h = $_ -split '\s+'; if ($h) { $esp[$n] = $h.ToLower() } }
$mal = @($esp.Keys | Where-Object { -not (Test-Path "$ent\$_") -or (Get-FileHash "$ent\$_" -Algorithm MD5).Hash.ToLower() -ne $esp[$_] })
if ($mal.Count -or -not $esp.Count) { "MD5 MAL en la copia: $($mal -join ', ') -- no toco nada"; exit 1 }
"md5 copia $($esp.Count)/$($esp.Count) OK"
New-Item -ItemType Directory -Force $des | Out-Null
foreach ($n in 'zzLinkinParkTodo_P.pak', 'zzLinkinParkTodo_P.ucas', 'zzLinkinParkTodo_P.utoc') {
  if (Test-Path "$mods\$n") { Move-Item "$mods\$n" $des -Force }
  Copy-Item "$ent\$n" $mods -Force
}
if (Test-Path "$json\LinkinParkNombres.json") { Copy-Item "$json\LinkinParkNombres.json" "$des\LinkinParkNombres.json" -Force }
Copy-Item "$ent\LinkinParkNombres.json" "$json\LinkinParkNombres.json" -Force
$ok = @('zzLinkinParkTodo_P.pak', 'zzLinkinParkTodo_P.ucas', 'zzLinkinParkTodo_P.utoc' | Where-Object { (Get-FileHash "$mods\$_" -Algorithm MD5).Hash.ToLower() -eq $esp[$_] }).Count
$okj = (Get-FileHash "$json\LinkinParkNombres.json" -Algorithm MD5).Hash.ToLower() -eq $esp['LinkinParkNombres.json']
"instalado: $ok/3 con md5 igual; nombres igual=$okj; la v4 quedo en $des"
