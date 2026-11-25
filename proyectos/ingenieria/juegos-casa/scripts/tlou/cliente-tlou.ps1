# Lado jugador de TLOU (PS3) Factions en RPCS3: config propia del juego, RPCN apuntado al servidor de la casa y
# los parches de comradesean/tlou-factions-server. No pisa nada que ya exista: si un archivo esta, lo dice y sigue.
# Uso: cliente-tlou.ps1 [-Rpcs3 C:\Games\RPCS3] [-Servidor 10.147.20.3] [-Deshacer]
# Deshacer saca lo que este script puso (lo marca con '# juegos-casa tlou' o lo lista en tlou-puesto.txt).
param([string]$Rpcs3 = 'C:\Games\RPCS3', [string]$Servidor = '10.147.20.3', [switch]$Deshacer)
$cfg = Join-Path $Rpcs3 'config'
$puesto = Join-Path $cfg 'tlou-puesto.txt'
$parchesOrigen = 'C:\Games\tlou-factions\servidor\client\patches'
$utf8 = New-Object Text.UTF8Encoding($false)

if ($Deshacer) {
  if (Test-Path $puesto) { Get-Content $puesto | Where-Object { $_ } | ForEach-Object { Remove-Item -LiteralPath $_ -Force -ErrorAction SilentlyContinue; "sacado: $_" }; Remove-Item $puesto }
  exit 0
}

function Write-Nuevo([string]$ruta, [string]$texto) {
  if (Test-Path -LiteralPath $ruta) { "YA ESTABA (no se toca): $ruta"; return }
  New-Item -ItemType Directory -Force (Split-Path $ruta) | Out-Null
  [IO.File]::WriteAllText($ruta, $texto, $utf8)
  Add-Content -LiteralPath $puesto -Value $ruta
  "puesto: $ruta"
}

$hosts = @('t1.patch.s3.amazonaws.com', 't1.campaign.config.s3.amazonaws.com', 't1.final.*.s3.amazonaws.com', 's3.amazonaws.com', 'graph.facebook.com') |
  ForEach-Object { "$_=$Servidor" }
$swap = $hosts -join '&&'

Write-Nuevo (Join-Path $cfg 'custom_configs\config_BCUS98174.yml') @"
# juegos-casa tlou: Factions contra el servidor de la casa
Core:
  Stub PPU Traps: 1
Net:
  Internet enabled: Connected
  PSN status: RPCN
  IP swap list: "$swap"
"@

Write-Nuevo (Join-Path $cfg 'rpcn.yml') @"
Version: 2
Host: ${Servidor}:31313
NPID: ""
Password: ""
Token: ""
Hosts: "Official RPCN Server|np.rpcs3.net|||Casa (PC)|${Servidor}:31313"
Experimental IPv6 support: false
"@

# RPCS3 0.0.43 solo lee patches\patch.yml, imported_patch.yml y <TITLE_ID>_patch.yml: los dos se unen en uno
$d = Join-Path $Rpcs3 'patches\BCUS98174_patch.yml'
$o = @('minplayers_patch.yml', 'facebook_stub_patch.yml') | ForEach-Object { Join-Path $parchesOrigen $_ }
if ($o | Where-Object { -not (Test-Path $_) }) { "FALTA un parche de origen en $parchesOrigen"; exit 1 }
if (Test-Path $d) { "YA ESTABA (no se toca): $d" } else {
  python (Join-Path $PSScriptRoot 'unir-parches.py') $d @o
  Add-Content -LiteralPath $puesto -Value $d; "puesto: $d"
}

$h100 = 'PPU-9df60dc1aa5005a0c80e9066e4951dc0471553e6'; $h111 = 'PPU-120fb71f7352d62521c639b0e99f960018c10a56'
$descs = 'TLOU Factions - Find Match min players = 2 (TESTING ONLY)', 'TLOU Factions - Facebook sign-in success (stub)', 'TLOU Factions - Facebook Graph http scheme, names (stub)'
$txt = "# juegos-casa tlou`n"
foreach ($par in @(@($h100, '01.00'), @($h111, '01.11'))) {
  $txt += "$($par[0]):`n"
  foreach ($d in $descs) { $txt += "  `"$d`":`n    The Last of Us:`n      BCUS98174:`n        $($par[1]):`n          Enabled: true`n" }
}
Write-Nuevo (Join-Path $cfg 'patch_config.yml') $txt
