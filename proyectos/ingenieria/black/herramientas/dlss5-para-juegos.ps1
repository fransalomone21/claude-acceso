# dlss5-para-juegos.ps1 -- instala el pipeline DLSS 5 (ReShade + DLSS5-Feeder +
# RenoDX + LumeniteFX) en CUALQUIER juego, no solo en PCSX2.
#
# POR QUE EXISTE
#   Armar este pipeline la primera vez costo cinco sesiones y tres conclusiones
#   FALSAS en el camino ("es un techo de la GPU", "la firma del dlssnr esta
#   rota", "los dos addon64 son v4.6"). Nada de eso esta publicado en ningun
#   lado: hubo que sacarlo de READMEs primarios y de un Discord. Repetirlo a
#   mano para el segundo juego seria pagar el mismo precio dos veces.
#
#   La base de este script NO es el README de nadie: es la instalacion que YA
#   FUNCIONA en C:\Program Files\PCSX2, medida archivo por archivo. -ArmarKit
#   la congela con sus hashes, y -Juego la reproduce en otra carpeta.
#
# LO QUE NO VA AL REPO, Y POR QUE
#   Los binarios (nvngx_dlssnr.dll son 165 MB de NVIDIA, mas dos addon de
#   terceros sin licencia clara) NO se commitean: claude-acceso es publico.
#   El kit vive fuera del repo y aca queda el PROCEDIMIENTO mas el manifiesto
#   con los hashes, que es lo que permite verificar que el kit es el bueno.
#
# LO QUE SE APRENDIO Y ESTA METIDO ACA COMO REGLA
#   1. `nvngx_dlss.dll` NO ES OPCIONAL. Su ausencia da
#      `SuperSampling.Available=0` y el feeder se rinde antes de crear la
#      feature. Costo tres corridas identicas creyendo que era la GPU.
#   2. `renodx-dlss5.addon64` tiene que ser **v4.55**. Las posteriores arman su
#      propio contrato y chocan con el feeder released. Se verifica POR HASH,
#      no por FileVersion: el recurso de version del PE dice 0.2026.0828.0517
#      en las dos, o sea que NO distingue.
#   3. La firma invalida de `nvngx_dlssnr.dll` NO es un defecto: en RTX 20/30/40
#      el DLL correcto es uno PARCHEADO, y un binario parcheado tiene la firma
#      rota por diseno. "Repararla" rompe el pipeline en Ada.
#   4. El nombre del proxy depende de la API grafica del juego. dxgi.dll sirve
#      para D3D10/11/12; d3d9.dll para D3D9; opengl32.dll para OpenGL.
#
# USO
#   .\dlss5-para-juegos.ps1 -ArmarKit
#   .\dlss5-para-juegos.ps1 -Juego "C:\Games\Loquesea\juego.exe" -Ver
#   .\dlss5-para-juegos.ps1 -Juego "C:\Games\Loquesea\juego.exe"
#   .\dlss5-para-juegos.ps1 -Juego "C:\Games\Loquesea\juego.exe" -Desinstalar
#
# Sin acentos a proposito: la consola de Windows lee cp1252.

[CmdletBinding()]
param(
    [string]$Juego,
    [switch]$ArmarKit,
    [switch]$Ver,
    [switch]$Desinstalar,
    [ValidateSet('auto','dxgi','d3d9','d3d11','d3d12','opengl32')]
    [string]$Proxy = 'auto',
    [string]$Kit = "$env:USERPROFILE\herramientas\dlss5-kit",
    [string]$Referencia = 'C:\Program Files\PCSX2'
)
$ErrorActionPreference = 'Stop'

function OK   ($m) { Write-Host "  [OK]    $m" -ForegroundColor Green }
function MAL  ($m) { Write-Host "  [FALLA] $m" -ForegroundColor Red }
function NOTA ($m) { Write-Host "  [ ]     $m" -ForegroundColor DarkGray }

# El v4.55 confirmado: adjunto del mensaje de Krish en #DLSS5 del 30/8/26 7:31.
$SHA_RENODX_V455 = '9150097CDEE2953CDC9894D2E5606EA5100E6C8F95FC7BB1B407328B4391A07A'

# Los archivos del pipeline. 'critico' = sin el, no arranca.
$PIEZAS = @(
    @{ kit='ReShade64.dll';         destino='<PROXY>';               critico=$true;  que='ReShade 6.8 con soporte de add-ons' }
    @{ kit='dlss5-feed.addon64';    destino='dlss5-feed.addon64';    critico=$true;  que='DLSS5-Feeder: arma el contrato color+depth+MV' }
    @{ kit='renodx-dlss5.addon64';  destino='renodx-dlss5.addon64';  critico=$true;  que='RenoDX v4.55: neural rendering' }
    @{ kit='nvngx_dlssnr.dll';      destino='nvngx_dlssnr.dll';      critico=$true;  que='runtime DLSS Ray Reconstruction (165 MB)' }
    @{ kit='nvngx_dlss.dll';        destino='nvngx_dlss.dll';        critico=$true;  que='runtime DLSS Super Resolution. SIN ESTO: Available=0' }
)

# ---------------------------------------------------------------- armar el kit
if ($ArmarKit) {
    Write-Host ''
    Write-Host 'ARMANDO EL KIT desde la instalacion que YA FUNCIONA'
    Write-Host "  origen: $Referencia"
    Write-Host "  kit   : $Kit"
    Write-Host ''
    if (-not (Test-Path -LiteralPath $Referencia)) { throw "No existe la referencia: $Referencia" }
    New-Item -ItemType Directory -Force -Path $Kit | Out-Null

    # dxgi.dll de la referencia ES ReShade64.dll renombrado: vuelve a su nombre
    $mapa = [ordered]@{
        'dxgi.dll'             = 'ReShade64.dll'
        'dlss5-feed.addon64'   = 'dlss5-feed.addon64'
        'renodx-dlss5.addon64' = 'renodx-dlss5.addon64'
        'nvngx_dlssnr.dll'     = 'nvngx_dlssnr.dll'
        'nvngx_dlss.dll'       = 'nvngx_dlss.dll'
    }
    $manifiesto = @()
    foreach ($k in $mapa.Keys) {
        $src = Join-Path $Referencia $k
        if (-not (Test-Path -LiteralPath $src)) { MAL "falta en la referencia: $k"; continue }
        $dst = Join-Path $Kit $mapa[$k]
        Copy-Item -LiteralPath $src -Destination $dst -Force
        $h = (Get-FileHash -LiteralPath $dst -Algorithm SHA256).Hash
        $b = (Get-Item -LiteralPath $dst).Length
        $manifiesto += [pscustomobject]@{ archivo=$mapa[$k]; bytes=$b; sha256=$h }
        OK ("{0,-22} {1,12:N0} B  {2}" -f $mapa[$k], $b, $h.Substring(0,12))
    }
    foreach ($sub in @('Shaders','Textures')) {
        $o = Join-Path $Referencia "reshade-shaders\$sub"
        if (Test-Path -LiteralPath $o) {
            Copy-Item -LiteralPath $o -Destination $Kit -Recurse -Force
            OK "shaders/texturas: $sub"
        }
    }
    foreach ($ini in @('ReShade.ini','ReShadePreset.ini','dlss5-feed.cfg')) {
        $o = Join-Path $Referencia $ini
        if (Test-Path -LiteralPath $o) { Copy-Item -LiteralPath $o (Join-Path $Kit "plantilla-$ini") -Force; OK "plantilla: $ini" }
    }
    $manifiesto | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $Kit 'manifiesto.json') -Encoding ascii

    $renodx = Join-Path $Kit 'renodx-dlss5.addon64'
    if (Test-Path -LiteralPath $renodx) {
        $h = (Get-FileHash -LiteralPath $renodx -Algorithm SHA256).Hash
        if ($h -eq $SHA_RENODX_V455) { OK 'renodx-dlss5.addon64 ES el v4.55 (verificado por hash)' }
        else { MAL "renodx-dlss5.addon64 NO es v4.55. hash=$h"; MAL 'Las posteriores chocan con el feeder released. Conseguir el v4.55.' }
    }
    $mb = [math]::Round(((Get-ChildItem $Kit -Recurse -File | Measure-Object Length -Sum).Sum/1MB),1)
    Write-Host ''
    Write-Host "Kit armado. Total: $mb MB"
    Write-Host ''
    exit 0
}

if (-not $Juego) { throw 'Falta -Juego <ruta al .exe>  (o -ArmarKit).' }
if (-not (Test-Path -LiteralPath $Juego)) { throw "No existe: $Juego" }
$dir = Split-Path -Parent (Resolve-Path -LiteralPath $Juego)

# ------------------------------------------------- diagnostico del ejecutable
# 64 bits? Se lee la MAQUINA del header PE, no se adivina por la carpeta.
$fs = [IO.File]::OpenRead($Juego)
$br = New-Object IO.BinaryReader($fs)
$fs.Position = 0x3C
$peOff = $br.ReadInt32()
$fs.Position = $peOff + 4
$maquina = $br.ReadUInt16()
$br.Close(); $fs.Close()
$bits = switch ($maquina) { 0x8664 {64} 0x014c {32} 0xAA64 {64} default {0} }

# Que API grafica usa: se busca el nombre de la DLL en el binario. No es
# infalible (un launcher puede cargar el motor aparte), por eso -Proxy lo pisa.
$bytes = [IO.File]::ReadAllBytes($Juego)
$txt = [Text.Encoding]::ASCII.GetString($bytes)
$apis = [ordered]@{}
foreach ($a in 'd3d12.dll','d3d11.dll','dxgi.dll','d3d9.dll','opengl32.dll','vulkan-1.dll') {
    $apis[$a] = ([regex]::Matches($txt, [regex]::Escape($a))).Count
}
if ($apis['d3d12.dll'] -gt 0 -or $apis['d3d11.dll'] -gt 0 -or $apis['dxgi.dll'] -gt 0) { $proxyAuto = 'dxgi' }
elseif ($apis['d3d9.dll'] -gt 0)     { $proxyAuto = 'd3d9' }
elseif ($apis['opengl32.dll'] -gt 0) { $proxyAuto = 'opengl32' }
else { $proxyAuto = '' }
if ($Proxy -ne 'auto') { $proxyFinal = $Proxy } else { $proxyFinal = $proxyAuto }

$vistas = ($apis.GetEnumerator() | Where-Object { $_.Value -gt 0 } | ForEach-Object { "$($_.Key) x$($_.Value)" }) -join ', '
$modo = 'auto'
if ($Proxy -ne 'auto') { $modo = 'forzado' }
Write-Host ''
Write-Host "JUEGO  : $Juego"
Write-Host "carpeta: $dir"
Write-Host ("  arquitectura : {0} bits (PE machine 0x{1:X4})" -f $bits, $maquina)
Write-Host "  APIs vistas  : $vistas"
Write-Host "  proxy        : $proxyFinal.dll ($modo)"

if ($bits -ne 64) {
    MAL 'Este script cubre SOLO juegos de 64 bits.'
    NOTA 'Un juego de 32 bits necesita ademas dlss5-feed.addon32 y dlss5-feed-host64.exe,'
    NOTA 'que es un camino distinto y no esta probado en esta maquina.'
    if (-not $Ver) { exit 1 }
}
if (-not $proxyFinal) {
    MAL 'No se pudo determinar la API grafica. Pasa -Proxy dxgi|d3d9|opengl32 a mano.'
    if (-not $Ver) { exit 1 }
}
if ($apis['vulkan-1.dll'] -gt 0 -and $apis['d3d12.dll'] -eq 0) {
    NOTA 'Parece VULKAN: ReShade se instala como capa, no como proxy. Camino distinto, no cubierto.'
}

$destinos = @()
foreach ($p in $PIEZAS) {
    if ($p.destino -eq '<PROXY>') { $n = "$proxyFinal.dll" } else { $n = $p.destino }
    $destinos += @{ kit=(Join-Path $Kit $p.kit); dst=(Join-Path $dir $n); nombre=$n; que=$p.que; critico=$p.critico }
}

# --------------------------------------------------------------- desinstalar
if ($Desinstalar) {
    Write-Host ''
    Write-Host "DESINSTALANDO de $dir"
    Write-Host ''
    foreach ($d in $destinos) {
        $bk = ($d.dst) + '.antes-de-dlss5'
        if (Test-Path -LiteralPath $d.dst) { Remove-Item -LiteralPath $d.dst -Force; OK "borrado: $($d.nombre)" }
        if (Test-Path -LiteralPath $bk) { Move-Item -LiteralPath $bk -Destination $d.dst -Force; OK "restaurado el original de $($d.nombre)" }
    }
    foreach ($f in 'ReShade.ini','ReShadePreset.ini','dlss5-feed.cfg','dlss5-feed.log','ReShade.log') {
        $p = Join-Path $dir $f
        if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force; OK "borrado: $f" }
    }
    $sh = Join-Path $dir 'reshade-shaders'
    if (Test-Path -LiteralPath $sh) { Remove-Item -LiteralPath $sh -Recurse -Force; OK 'borrado: reshade-shaders' }
    Write-Host ''
    Write-Host 'Listo. No se toco ningun archivo del juego.'
    Write-Host ''
    exit 0
}

# ------------------------------------------------------- estado actual / -Ver
Write-Host ''
Write-Host 'ESTADO EN LA CARPETA DEL JUEGO'
foreach ($d in $destinos) {
    if (Test-Path -LiteralPath $d.dst) {
        OK ("{0,-22} ya esta ({1:N0} B)" -f $d.nombre, (Get-Item -LiteralPath $d.dst).Length)
    } else { NOTA ("{0,-22} falta -- {1}" -f $d.nombre, $d.que) }
}
if ($Ver) { Write-Host ''; exit 0 }

# ------------------------------------------------------------------ instalar
Write-Host ''
Write-Host 'INSTALANDO'
$falta = $false
foreach ($d in $destinos) {
    if (-not (Test-Path -LiteralPath $d.kit)) { MAL "falta en el kit: $($d.kit)"; if ($d.critico) { $falta = $true } }
}
if ($falta) { MAL 'Corre primero: .\dlss5-para-juegos.ps1 -ArmarKit'; exit 1 }

# el renodx se verifica POR HASH antes de copiar nada. Es el unico chequeo que
# de verdad importa, y el FileVersion del PE no sirve para distinguirlo.
$hr = (Get-FileHash -LiteralPath (Join-Path $Kit 'renodx-dlss5.addon64') -Algorithm SHA256).Hash
if ($hr -ne $SHA_RENODX_V455) {
    MAL "El renodx del kit NO es v4.55 (hash $($hr.Substring(0,12))). Abortado sin tocar nada."
    exit 1
}
OK 'renodx-dlss5.addon64 verificado por hash: es el v4.55'

$mismaUnidad = (Split-Path -Qualifier $Kit) -eq (Split-Path -Qualifier $dir)
foreach ($d in $destinos) {
    if (-not (Test-Path -LiteralPath $d.kit)) { continue }
    # si habia un archivo propio del juego con ese nombre, se guarda
    $bk = ($d.dst) + '.antes-de-dlss5'
    if ((Test-Path -LiteralPath $d.dst) -and -not (Test-Path -LiteralPath $bk)) {
        if ((Get-Item -LiteralPath $d.dst).Length -ne (Get-Item -LiteralPath $d.kit).Length) {
            Move-Item -LiteralPath $d.dst -Destination $bk -Force
            NOTA "habia un $($d.nombre) propio del juego: guardado como .antes-de-dlss5"
        }
    }
    # los dos runtimes suman 214 MB por juego: con hardlink no ocupan de nuevo
    $grande = (Get-Item -LiteralPath $d.kit).Length -gt 20MB
    $hecho = $false
    if ($grande -and $mismaUnidad) {
        try { New-Item -ItemType HardLink -Path $d.dst -Target $d.kit -Force | Out-Null; $hecho = $true } catch { }
    }
    if (-not $hecho) { Copy-Item -LiteralPath $d.kit -Destination $d.dst -Force }
    if ($hecho) { $como = 'enlazado (no duplica los MB)' } else { $como = 'copiado' }
    OK ("{0,-22} {1}" -f $d.nombre, $como)
}

# shaders, texturas y las plantillas de configuracion que ya funcionan
New-Item -ItemType Directory -Force -Path (Join-Path $dir 'reshade-shaders') | Out-Null
foreach ($sub in 'Shaders','Textures') {
    $o = Join-Path $Kit $sub
    if (Test-Path -LiteralPath $o) { Copy-Item -LiteralPath $o -Destination (Join-Path $dir 'reshade-shaders') -Recurse -Force; OK "reshade-shaders\$sub" }
}
foreach ($ini in 'ReShade.ini','ReShadePreset.ini','dlss5-feed.cfg') {
    $o = Join-Path $Kit "plantilla-$ini"
    $t = Join-Path $dir $ini
    if ((Test-Path -LiteralPath $o) -and -not (Test-Path -LiteralPath $t)) { Copy-Item -LiteralPath $o $t -Force; OK "$ini (plantilla del que ya anda)" }
    elseif (Test-Path -LiteralPath $t) { NOTA "$ini ya existia: NO se piso" }
}

# ------------------------------------------------- verificacion POR EFECTO
Write-Host ''
Write-Host 'VERIFICACION -- tamano contra el kit, archivo por archivo'
$mal = 0
foreach ($d in $destinos) {
    if (-not (Test-Path -LiteralPath $d.kit)) { continue }
    $a = (Get-Item -LiteralPath $d.kit).Length
    if (-not (Test-Path -LiteralPath $d.dst)) { MAL "$($d.nombre): NO quedo"; $mal++; continue }
    $b = (Get-Item -LiteralPath $d.dst).Length
    if ($a -ne $b) { MAL "$($d.nombre): $b B, se esperaban $a"; $mal++ } else { OK "$($d.nombre): $b B" }
}
$hd = (Get-FileHash -LiteralPath (Join-Path $dir 'renodx-dlss5.addon64') -Algorithm SHA256).Hash
if ($hd -eq $SHA_RENODX_V455) { OK 'renodx instalado: hash v4.55 correcto' } else { MAL 'renodx instalado con hash EQUIVOCADO'; $mal++ }

Write-Host ''
if ($mal) { MAL "$mal problema(s). El pipeline NO esta listo."; exit 1 }
OK 'Todo instalado y verificado.'
Write-Host ''
Write-Host 'LO QUE FALTA, Y ES A MANO EN EL OVERLAY (Home abre ReShade dentro del juego):'
Write-Host '  1. Add-ons -> Generic Depth: tildar la fila del buffer GRANDE (el de muchas'
Write-Host '     draw calls). El default elige uno de 128x64 que son sombras, y con eso'
Write-Host '     todo el pipeline queda mudo SIN dar ningun error.'
Write-Host '     Hay que rehacerlo cada vez que cambia el renderer o la resolucion.'
Write-Host '  2. Home -> lista de tecnicas: Lumenite_Kernel ARRIBA de DLSS5_Feed, y las dos'
Write-Host '     TILDADAS. El propio feed avisa por log cuando estan al reves.'
Write-Host '  3. Add-ons -> DLSS 5 Feed: DLSS5_MV_PROVIDER = 3 (LumeniteFX Kernel).'
Write-Host '  4. Add-ons -> DLSS 5 Neural Rendering: encender.'
Write-Host "  5. Leer '$dir\dlss5-feed.log' y buscar:"
Write-Host '        SuperSampling.Available=1     <- si dice 0, falta nvngx_dlss.dll'
Write-Host '        feature ready ... DLAA'
Write-Host '        frame N delivered'
