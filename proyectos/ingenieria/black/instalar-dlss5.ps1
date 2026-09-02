# instalar-dlss5.ps1 -- arma el pipeline DLSS5-Feeder sobre PCSX2 2.8.0 (D3D12).
#
# Por que existe: la sesion de Claude no puede escribir en C:\Program Files
# (lo bloquea el clasificador de permisos, dos veces, por dos vias distintas).
# Todo lo que sigue estaba medido y verificado por la sesion; lo unico que
# faltaba era el permiso de escritura. Correlo vos.
#
# Reversible: -Desinstalar restaura ReShade 6.6.2 desde pruebas\reshade-662-respaldo
# y borra lo que este script instalo. Nada de esto toca el ISO ni los savestates.

param(
    [switch]$Desinstalar
)

$ErrorActionPreference = "Stop"

$DST  = "C:\Program Files\PCSX2"
$SH   = Join-Path $DST "reshade-shaders\Shaders"
$TX   = Join-Path $DST "reshade-shaders\Textures"
$DL   = Join-Path $env:USERPROFILE "Downloads"
$REPO = Split-Path -Parent $MyInvocation.MyCommand.Path
$BK   = Join-Path $REPO "pruebas\reshade-662-respaldo"

# El v4.55 confirmado: es el adjunto del mensaje de Krish del 30/8/26 7:31
# ("v4.55 - Should now work with RE Engine games"), 1.62 MB. Se bajo dos veces
# con nombres distintos y las dos copias son identicas byte a byte.
$SHA_V455 = "9150097CDEE2953CDC9894D2E5606EA5100E6C8F95FC7BB1B407328B4391A07A"

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
    Remove-Item (Join-Path $SH "include\lumenite_*") -Force -ErrorAction SilentlyContinue
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

# 0) que este todo lo que hace falta, ANTES de tocar nada
$need = @{
    "ReShade_Setup_6.8.0_Addon.exe" = "instalador de ReShade 6.8.0 (Addon)"
    "dlss5-feed.addon64"            = "el feeder"
    "DLSS5_Feed.fx"                 = "el shader del feeder"
    "LumeniteFX-mainline.zip"       = "proveedor de motion vectors"
    "nvngx_dlssnr (1).dll"          = "runtime DLSSNR de NVIDIA"
    "renodx-dlss5 (2).addon64"      = "el addon de neural rendering, v4.55"
}
$falta = $false
foreach ($k in $need.Keys) {
    if (-not (Test-Path (Join-Path $DL $k))) { Rojo ("falta en Downloads: $k  (" + $need[$k] + ")"); $falta = $true }
}
if ($falta) { Write-Host "`nAbortado sin tocar nada.`n"; exit 1 }

# la comprobacion que de verdad importa: que el addon sea el v4.55 y no otro
$h = (Get-FileHash (Join-Path $DL "renodx-dlss5 (2).addon64") -Algorithm SHA256).Hash
if ($h -ne $SHA_V455) {
    Rojo "renodx-dlss5 (2).addon64 NO es el v4.55 esperado."
    Rojo "  esperado: $SHA_V455"
    Rojo "  medido  : $h"
    Rojo "Un build posterior a v4.55 arma su propio contrato sintetico y choca con el feeder."
    exit 1
}
Verde "renodx-dlss5 (2).addon64 verificado = v4.55"

# respaldo de ReShade 6.6.2, si todavia no esta
New-Item -ItemType Directory -Force -Path $BK | Out-Null
foreach ($f in @("dxgi.dll","ReShade.ini","ReShadePreset.ini")) {
    if ((Test-Path "$DST\$f") -and -not (Test-Path "$BK\$f")) { Copy-Item "$DST\$f" "$BK\$f" -Force }
}
Verde "respaldo de ReShade 6.6.2 en $BK"

New-Item -ItemType Directory -Force -Path $SH, (Join-Path $SH "include"), $TX | Out-Null

# 1) ReShade 6.8.0 -- el instalador es un ZIP, se saca ReShade64.dll y va como dxgi.dll
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead((Join-Path $DL "ReShade_Setup_6.8.0_Addon.exe"))
$ent = $zip.Entries | Where-Object { $_.Name -eq "ReShade64.dll" }
[System.IO.Compression.ZipFileExtensions]::ExtractToFile($ent, (Join-Path $DST "dxgi.dll"), $true)
$zip.Dispose()
Verde ("dxgi.dll -> ReShade " + (Get-Item (Join-Path $DST "dxgi.dll")).VersionInfo.FileVersion)

# 2..4) los binarios, al lado de pcsx2-qt.exe
Copy-Item (Join-Path $DL "dlss5-feed.addon64")       (Join-Path $DST "dlss5-feed.addon64")   -Force; Verde "dlss5-feed.addon64"
Copy-Item (Join-Path $DL "renodx-dlss5 (2).addon64") (Join-Path $DST "renodx-dlss5.addon64") -Force; Verde "renodx-dlss5.addon64 (v4.55)"
Copy-Item (Join-Path $DL "nvngx_dlssnr (1).dll")     (Join-Path $DST "nvngx_dlssnr.dll")     -Force; Verde "nvngx_dlssnr.dll (158 MB)"

# 5) el shader del feeder
Copy-Item (Join-Path $DL "DLSS5_Feed.fx") (Join-Path $SH "DLSS5_Feed.fx") -Force; Verde "DLSS5_Feed.fx -> Shaders\"

# 6) LumeniteFX
$lz = [System.IO.Compression.ZipFile]::OpenRead((Join-Path $DL "LumeniteFX-mainline.zip"))
$nfx = 0; $ninc = 0
foreach ($e in $lz.Entries) {
    if ([string]::IsNullOrEmpty($e.Name)) { continue }
    if     ($e.FullName -like "*/Shaders/include/*") { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($e, (Join-Path $SH "include\$($e.Name)"), $true); $ninc++ }
    elseif ($e.FullName -like "*/Shaders/*" -and $e.Name -like "*.fx") { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($e, (Join-Path $SH $e.Name), $true); $nfx++ }
    elseif ($e.FullName -like "*/Textures/*") { [System.IO.Compression.ZipFileExtensions]::ExtractToFile($e, (Join-Path $TX $e.Name), $true) }
}
$lz.Dispose()
Verde "LumeniteFX: $nfx shaders + $ninc includes + bluenoise"

# ------------------------------------------------------- verificar por EFECTO
Write-Host "`nVERIFICACION (por efecto, no por 'copie el archivo'):`n"
$ok = $true
$esperado = @{
    (Join-Path $DST "dxgi.dll")                = 5592064
    (Join-Path $DST "dlss5-feed.addon64")      = 164352
    (Join-Path $DST "renodx-dlss5.addon64")    = 1694720
    (Join-Path $DST "nvngx_dlssnr.dll")        = 165840496
    (Join-Path $SH  "DLSS5_Feed.fx")           = 44814
    (Join-Path $SH  "lumenite_Kernel.fx")      = $null
    (Join-Path $TX  "lumenite_bluenoise256.png") = $null
}
foreach ($p in $esperado.Keys) {
    if (-not (Test-Path $p)) { Rojo ("NO existe: " + (Split-Path $p -Leaf)); $ok = $false; continue }
    $len = (Get-Item $p).Length
    if ($esperado[$p] -ne $null -and $len -ne $esperado[$p]) {
        Rojo ((Split-Path $p -Leaf) + ": $len bytes, se esperaban " + $esperado[$p]); $ok = $false
    } else { Verde ((Split-Path $p -Leaf) + "  $len bytes") }
}
$v = (Get-Item (Join-Path $DST "renodx-dlss5.addon64"))
$hh = (Get-FileHash $v.FullName -Algorithm SHA256).Hash
if ($hh -ne $SHA_V455) { Rojo "el renodx instalado NO es v4.55"; $ok = $false } else { Verde "renodx instalado = v4.55 (hash correcto)" }

if ($ok) {
    Write-Host "`nINSTALACION OK.`n" -ForegroundColor Green
    Write-Host "Falta la config en el overlay, que es a mano (ver HANDOFF 8.10):"
    Write-Host "  1. Arrancar PCSX2, Home para el overlay."
    Write-Host "  2. Add-ons -> Generic Depth: tildar la fila del buffer GRANDE (2568x1800,"
    Write-Host "     ~1000 draw calls). Con el default sale violeta plano y parece que no hay depth."
    Write-Host "  3. DLSS5_Feed.fx -> Preprocessor definitions -> DLSS5_MV_PROVIDER = 3 -> reload."
    Write-Host "  4. Habilitar 'LUMENITE: Kernel 2.0' y DEBAJO 'DLSS 5 Feed'."
    Write-Host "  5. Encender neural rendering en el panel 'DLSS 5 Neural Rendering'."
    Write-Host "  6. Leer C:\Program Files\PCSX2\dlss5-feed.log: 'feature ready ... DLAA'"
    Write-Host "     y 'frame N delivered'. Eso es lo que cierra R2.`n"
} else {
    Write-Host "`nQUEDO ALGO MAL. Revertir con:  .\instalar-dlss5.ps1 -Desinstalar`n" -ForegroundColor Red
}
