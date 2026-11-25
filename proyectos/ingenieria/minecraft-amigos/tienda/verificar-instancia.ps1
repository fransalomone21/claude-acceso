# L1-03: compara la carpeta mods de una instancia contra el pack publicado, por SHA-1. No cambia nada.
# Sale 0 si es igual; 1 nombrando cada jar de mas, de menos o distinto; 2 si no puede leer el pack (nunca verde a ciegas).
param(
    [string]$Pack = "http://10.147.20.2:8765/pack/lista.json",
    [string]$Mods = (Join-Path $env:APPDATA "PrismLauncher\instances\Tienda 1.21.1\.minecraft\mods")
)
try {
    $wc = New-Object Net.WebClient
    $lista = [Text.Encoding]::UTF8.GetString($wc.DownloadData($Pack)) | ConvertFrom-Json
} catch { "NO SE PUDO LEER EL PACK ($Pack): $($_.Exception.Message)"; exit 2 }
if (-not $lista.mods) { "EL PACK NO TRAE MODS: no se puede verificar"; exit 2 }
$quiero = @{}; foreach ($m in $lista.mods) { if ($m.lado -ne 'server') { $quiero[$m.archivo] = $m.sha1.ToUpper() } }
$hay = @{}; foreach ($f in Get-ChildItem -LiteralPath $Mods -File) { $hay[$f.Name] = (Get-FileHash -LiteralPath $f.FullName -Algorithm SHA1).Hash }
$demas = @($hay.Keys | Where-Object { -not $quiero.ContainsKey($_) })
$faltan = @($quiero.Keys | Where-Object { -not $hay.ContainsKey($_) })
$distintos = @($quiero.Keys | Where-Object { $hay.ContainsKey($_) -and $hay[$_] -ne $quiero[$_] })
"pack '{0}': {1} esperados, {2} en la instancia | de mas: {3} | faltan: {4} | distintos: {5}" -f $lista.nombre, $quiero.Count, $hay.Count, $demas.Count, $faltan.Count, $distintos.Count
foreach ($x in $demas) { "  DE MAS: $x" }; foreach ($x in $faltan) { "  FALTA: $x" }; foreach ($x in $distintos) { "  DISTINTO: $x" }
if ($demas.Count + $faltan.Count + $distintos.Count) { exit 1 } else { exit 0 }
