# Pone la carpeta mods de una instancia de Prism IGUAL al pack publicado por la tienda (L1-03, L1-04).
# Prism lo corre antes de abrir el juego (comando previo de la instancia). Compara por SHA-1:
#   - baja lo que falta o lo que cambio (verifica el SHA-1 de lo bajado);
#   - lo que sobra va a mods_fuera_de_pack (no se borra).
# Si la tienda de la notebook no contesta, avisa y deja jugar con lo que hay.
param(
    [string]$Pack = "http://10.147.20.2:8765/pack/lista.json",
    [Parameter(Mandatory = $true)][string]$Mods
)
$ErrorActionPreference = 'Continue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$wc = New-Object Net.WebClient
$wc.Headers.Add("User-Agent", "minecraft-amigos-tienda")
try {
    $lista = [Text.Encoding]::UTF8.GetString($wc.DownloadData($Pack)) | ConvertFrom-Json
} catch {
    Write-Output "AVISO: la tienda no contesta en $Pack ($($_.Exception.Message)). Se juega con los mods que ya hay."
    exit 0
}
$base = $Pack.Substring(0, $Pack.LastIndexOf('/') + 1)
New-Item -ItemType Directory -Force $Mods | Out-Null
$fuera = Join-Path (Split-Path $Mods) "mods_fuera_de_pack"
$quiero = @{}
foreach ($m in $lista.mods) { if ($m.lado -ne 'server') { $quiero[$m.archivo] = $m } }

$movidos = 0
foreach ($f in Get-ChildItem -LiteralPath $Mods -File) {
    if (-not $quiero.ContainsKey($f.Name)) {
        New-Item -ItemType Directory -Force $fuera | Out-Null
        Move-Item -LiteralPath $f.FullName -Destination (Join-Path $fuera $f.Name) -Force
        $movidos++
    }
}
$bajados = 0; $mal = @()
foreach ($a in $quiero.Keys) {
    $m = $quiero[$a]; $dst = Join-Path $Mods $a
    if ((Test-Path -LiteralPath $dst) -and ((Get-FileHash -LiteralPath $dst -Algorithm SHA1).Hash -eq $m.sha1.ToUpper())) { continue }
    $url = if ($m.url -match '^https?://') { $m.url } else { $base + $m.url }
    try { $wc.DownloadFile($url, "$dst.part"); Move-Item -LiteralPath "$dst.part" -Destination $dst -Force } catch { $mal += "$a (no bajo: $($_.Exception.Message))"; continue }
    if ((Get-FileHash -LiteralPath $dst -Algorithm SHA1).Hash -ne $m.sha1.ToUpper()) { Remove-Item -LiteralPath $dst; $mal += "$a (SHA-1 distinto)" } else { $bajados++ }
}
Write-Output ("pack '{0}' ({1}): {2} mods de cliente, {3} bajados, {4} apartados a mods_fuera_de_pack" -f $lista.nombre, $lista.publicado, $quiero.Count, $bajados, $movidos)
if ($mal) { Write-Output ("FALTAN: " + ($mal -join ' | ')); exit 1 }
exit 0
