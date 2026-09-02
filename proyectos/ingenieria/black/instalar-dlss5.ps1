# instalar-dlss5.ps1 -- arma el pipeline DLSS5-Feeder sobre PCSX2 2.8.0 (D3D12).
#
# Por que existe: la sesion de Claude no puede escribir en C:\Program Files
# (lo bloquea el clasificador de permisos, por dos vias distintas). Todo lo
# que sigue esta medido y verificado por la sesion; faltaba el permiso.
#
# POR QUE ES COPIA PURA Y NO ABRE NINGUN ZIP: la version anterior fallaba en
# el paso 1 con "ArgumentNullException: source". Medido: el instalador de
# ReShade tiene un stub .exe antes del archivo comprimido, y
# [IO.Compression.ZipFile]::OpenRead lo abre con CERO entradas -- no ajusta
# el offset por los datos prepended. Python si lo hace. Asi que la sesion ya
# desempaqueto todo en Downloads\_dlss5_staging\ y aca solo se copia.
#
# Reversible: -Desinstalar restaura ReShade 6.6.2 y borra lo instalado.
# No toca el ISO, los savestates ni PCSX2.ini.

param(
    [switch]$Desinstalar
)

$ErrorActionPreference = "Stop"

$DST  = "C:\Program Files\PCSX2"
$SH   = Join-Path $DST "reshade-shaders\Shaders"
$TX   = Join-Path $DST "reshade-shaders\Textures"
$DL   = Join-Path $env:USERPROFILE "Downloads"
$ST   = Join-Path $DL "_dlss5_staging"
$REPO = Split-Path -Parent $MyInvocation.MyCommand.Path
$BK   = Join-Path $REPO "pruebas\reshade-662-respaldo"

# El v4.55 confirmado: adjunto del mensaje de Krish en #DLSS5 del 30/8/26 7:31
# ("v4.55 - Should now work with RE Engine games"), 1.62 MB. Se bajo dos veces
# con nombres distintos y las dos copias son identicas byte a byte.
$SHA_V455    = "9150097CDEE2953CDC9894D2E5606EA5100E6C8F95FC7BB1B407328B4391A07A"
$BYTES_R68   = 5592064      # ReShade64.dll 6.8.0, sacado del instalador
$BYTES_DLSSNR = 165840496   # nvngx_dlssnr.dll 310.8.0.0

function Verde($m) { Write-Host "  [OK]   $m" -ForegroundColor Green }
function Rojo($m)  { Write-Host "  [FALLA] $m" -ForegroundColor Red }

if (Get-Process pcsx2-qt -ErrorAction SilentlyContinue) {
    Rojo "PCSX2 esta corriendo. Cerralo primero: al salir pisa PCSX2.ini y se pierde el mapeo de teclado."
    exit 1
}

# ---------------------------------------------------------------- desinstalar
if ($Desinstalar) {
    Write-Host "`nDESINSTALANDO -- restaurando ReShade 6.6.2`n"
    foreach ($f in @("dlss5-feed.addon64","renodx-dlss5.addon64","nvngx_dlssnr.dll","dlss5-feed.log","dlss5-feed.cfg")) {
        $p = Join-Path $DST $f
        if (Test-Path $p) { Remove-Item $p -Force; Verde "borrado: $f" }
    }
    $fx = Join-Path $SH "DLSS5_Feed.fx"
    if (Test-Path $fx) { Remove-Item $fx -Force; Verde "borrado: DLSS5_Feed.fx" }
    Get-ChildItem $SH -Filter "lumenite_*" -ErrorAction SilentlyContinue | Remove-Item -Force
    Get-ChildItem (Join-Path $SH "include") -Filter "lumenite_*" -ErrorAction SilentlyContinue | Remove-Item -Force
    Remove-Item (Join-Path $TX "lumenite_bluenoise256.png") -Force -ErrorAction SilentlyContinue
    Verde "borrado: LumeniteFX"
    if (Test-Path (Join-Path $BK "dxgi.dll")) {
        Copy-Item (Join-Path $BK "dxgi.dll") (Join-Path $DST "dxgi.dll") -Force
        Verde ("dxgi.dll restaurado a " + (Get-Item (Join-Path $DST "dxgi.dll")).VersionInfo.FileVersion)
    } else { Rojo "no hay respaldo de dxgi.dll en $BK" }
    Write-Host "`nListo. El ISO, los savestates y PCSX2.ini no se tocaron.`n"
    exit 0
}

# ------------------------------------------------------------------ instalar
Write-Host "`nINSTALANDO pipeline DLSS5-Feeder en $DST`n"

# 0) que este TODO antes de tocar nada -- origen => destino
$copias = @(
    @{ src = (Join-Path $ST "ReShade64.dll");            dst = (Join-Path $DST "dxgi.dll");             que = "ReShade 6.8.0 (como dxgi.dll)" },
    @{ src = (Join-Path $DL "dlss5-feed.addon64");       dst = (Join-Path $DST "dlss5-feed.addon64");   que = "el feeder v0.7.0" },
    @{ src = (Join-Path $DL "renodx-dlss5 (2).addon64"); dst = (Join-Path $DST "renodx-dlss5.addon64"); que = "neural rendering v4.55" },
    @{ src = (Join-Path $DL "nvngx_dlssnr (1).dll");     dst = (Join-Path $DST "nvngx_dlssnr.dll");     que = "runtime DLSSNR 310.8.0" },
    @{ src = (Join-Path $DL "DLSS5_Feed.fx");            dst = (Join-Path $SH  "DLSS5_Feed.fx");        que = "shader del feeder" }
)

$falta = $false
foreach ($c in $copias) {
    if (-not (Test-Path $c.src)) { Rojo ("falta: " + $c.src + "   (" + $c.que + ")"); $falta = $true }
}
foreach ($sub in @("Shaders\lumenite_Kernel.fx","Textures\lumenite_bluenoise256.png")) {
    if (-not (Test-Path (Join-Path $ST $sub))) { Rojo ("falta en el staging: $sub"); $falta = $true }
}
if ($falta) {
    Write-Host "`nAbortado sin tocar nada. El staging lo arma la sesion en $ST`n"
    exit 1
}

# el chequeo que de verdad importa: que el addon sea el v4.55 y no otro build
$h = (Get-FileHash (Join-Path $DL "renodx-dlss5 (2).addon64") -Algorithm SHA256).Hash
if ($h -ne $SHA_V455) {
    Rojo "renodx-dlss5 (2).addon64 NO es el v4.55 esperado."
    Rojo "  esperado: $SHA_V455"
    Rojo "  medido  : $h"
    Rojo "Un build posterior a v4.55 arma su propio contrato sintetico y choca con el feeder."
    exit 1
}
Verde "renodx v4.55 verificado por hash"

# respaldo de ReShade 6.6.2, si todavia no esta
New-Item -ItemType Directory -Force -Path $BK | Out-Null
foreach ($f in @("dxgi.dll","ReShade.ini","ReShadePreset.ini")) {
    if ((Test-Path "$DST\$f") -and -not (Test-Path "$BK\$f")) { Copy-Item "$DST\$f" "$BK\$f" -Force }
}
Verde "respaldo de ReShade 6.6.2 en $BK"

New-Item -ItemType Directory -Force -Path $SH, (Join-Path $SH "include"), $TX | Out-Null

# 1..5) las copias sueltas
foreach ($c in $copias) {
    Copy-Item $c.src $c.dst -Force
    Verde ($c.que + "  ->  " + (Split-Path $c.dst -Leaf))
}

# 6) LumeniteFX, desde el staging
Copy-Item (Join-Path $ST "Shaders\*.fx")          $SH -Force
Copy-Item (Join-Path $ST "Shaders\include\*.fxh") (Join-Path $SH "include") -Force
Copy-Item (Join-Path $ST "Textures\*.png")        $TX -Force
$nfx = (Get-ChildItem $SH -Filter "lumenite_*.fx").Count
Verde "LumeniteFX: $nfx shaders + includes + bluenoise"

# ------------------------------------------------------- verificar por EFECTO
Write-Host "`nVERIFICACION (por efecto, no por 'copie el archivo'):`n"
$ok = $true

$esperado = @(
    @{ p = (Join-Path $DST "dxgi.dll");                  n = $BYTES_R68 },
    @{ p = (Join-Path $DST "dlss5-feed.addon64");        n = 164352 },
    @{ p = (Join-Path $DST "renodx-dlss5.addon64");      n = 1694720 },
    @{ p = (Join-Path $DST "nvngx_dlssnr.dll");          n = $BYTES_DLSSNR },
    @{ p = (Join-Path $SH  "DLSS5_Feed.fx");             n = 44814 },
    @{ p = (Join-Path $SH  "lumenite_Kernel.fx");        n = $null },
    @{ p = (Join-Path $TX  "lumenite_bluenoise256.png"); n = $null }
)
foreach ($e in $esperado) {
    $nombre = Split-Path $e.p -Leaf
    if (-not (Test-Path $e.p)) { Rojo "NO existe: $nombre"; $ok = $false; continue }
    $len = (Get-Item $e.p).Length
    if ($e.n -ne $null -and $len -ne $e.n) { Rojo "$nombre : $len bytes, se esperaban $($e.n)"; $ok = $false }
    else { Verde "$nombre  $len bytes" }
}

# la version de ReShade, leida del archivo instalado -- no del que copiamos
$vr = (Get-Item (Join-Path $DST "dxgi.dll")).VersionInfo.FileVersion
if ($vr -notlike "6.8*") { Rojo "dxgi.dll quedo en $vr, se esperaba 6.8.x"; $ok = $false }
else { Verde "dxgi.dll = ReShade $vr" }

$hh = (Get-FileHash (Join-Path $DST "renodx-dlss5.addon64") -Algorithm SHA256).Hash
if ($hh -ne $SHA_V455) { Rojo "el renodx instalado NO es v4.55"; $ok = $false }
else { Verde "renodx instalado = v4.55 (hash correcto)" }

if ($ok) {
    Write-Host "`nINSTALACION OK.`n" -ForegroundColor Green
    Write-Host "Falta la config del overlay, que es a mano:"
    Write-Host "  1. Arrancar PCSX2. Home abre el overlay de ReShade."
    Write-Host "  2. Add-ons -> Generic Depth: tildar la fila del buffer GRANDE (2568x1800,"
    Write-Host "     ~1000 draw calls). Con el default elige uno de 128x64 y sale violeta"
    Write-Host "     plano, indistinguible de 'este juego no expone depth'."
    Write-Host "  3. DLSS5_Feed.fx -> Preprocessor definitions -> DLSS5_MV_PROVIDER = 3 -> reload."
    Write-Host "  4. Habilitar 'LUMENITE: Kernel 2.0' y DEBAJO 'DLSS 5 Feed'. Un solo proveedor."
    Write-Host "  5. Encender neural rendering en el panel 'DLSS 5 Neural Rendering'."
    Write-Host "  6. Leer C:\Program Files\PCSX2\dlss5-feed.log -- 'feature ready ... DLAA'"
    Write-Host "     y 'frame N delivered'. Eso es lo que cierra R2.`n"
} else {
    Write-Host "`nQUEDO ALGO MAL. Revertir con:  .\instalar-dlss5.ps1 -Desinstalar`n" -ForegroundColor Red
}
