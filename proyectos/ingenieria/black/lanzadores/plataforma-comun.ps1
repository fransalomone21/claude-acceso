# Lo comun de los lanzadores de la plataforma (BLACK-XBERecomp + black-seamless-coop), sesion (133).
# No se corre solo: lo cargan PROBAR-PLATAFORMA-S1.ps1 y PROBAR-COOP-PC.ps1 con un punto adelante.

$Script:Juego    = 'C:\Games\BLACK\coop'
$Script:Exe      = Join-Path $Juego 'BLACK.exe'
$Script:Toml     = Join-Path $Juego 'black.toml'
$Script:Black    = Split-Path $PSScriptRoot -Parent
$Script:Volcados = Join-Path $Black 'volcados\plataforma'
New-Item -ItemType Directory -Force $Volcados | Out-Null  # en la copia suelta de la PC (sin repo) no existe

# El release del coop que se instalo y probo en (133). Las dos maquinas tienen que tener EL MISMO (lo exige el coop).
$Script:CoopUrl    = 'https://github.com/MuriloDagustin/black-seamless-coop/releases/download/v2026.10.18.2/BLACK-Seamless-Coop-8226900.zip'
$Script:CoopZipSha = '7FABD5C6B107AC5CC368F33EF318BD26CFF3148FD1587E167DD91C629DD99D21'
$Script:ExeSha     = '62CC5819D71058CA34FC7F1DF164BC7BCDAFC9FB7299CD90CBE50EC5B93F73C7'
$Script:IsoZip     = 'C:\Games\BLACK\xbox\iso-redump\Black (USA).zip'

# Instala la plataforma si falta (la otra maquina): el zip del coop (local o bajado, con su sha256) y la ISO USA
# sacada de su zip. Devuelve $true si quedo instalada.
function Install-Plataforma {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    if (-not (Test-Path -LiteralPath $Exe)) {
        $zip = 'C:\Users\frans\herramientas\referencias-black\seamless-coop-release\BLACK-Seamless-Coop-8226900.zip'
        if (-not (Test-Path -LiteralPath $zip)) {
            $zip = Join-Path $env:TEMP 'BLACK-Seamless-Coop-8226900.zip'
            Write-Host "Bajando el coop (6,7 MB) de GitHub..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $CoopUrl -OutFile $zip -UseBasicParsing
        }
        if ((Get-FileHash -LiteralPath $zip -Algorithm SHA256).Hash -ne $CoopZipSha) {
            Write-Host "El zip del coop no es el probado (sha256 distinto). No instalo." -ForegroundColor Red
            return $false
        }
        New-Item -ItemType Directory -Force $Juego | Out-Null
        $z = [IO.Compression.ZipFile]::OpenRead($zip)
        foreach ($e in $z.Entries) {
            $rel = $e.FullName -replace '^BLACK-Seamless-Coop/', ''
            if (-not $rel) { continue }
            $out = Join-Path $Juego $rel
            if ($e.FullName.EndsWith('/')) { New-Item -ItemType Directory -Force $out | Out-Null; continue }
            New-Item -ItemType Directory -Force (Split-Path $out) | Out-Null
            [IO.Compression.ZipFileExtensions]::ExtractToFile($e, $out, $true)
        }
        $z.Dispose()
        Write-Host "Coop instalado en $Juego" -ForegroundColor Green
    }
    $assets = Join-Path $Juego 'assets'
    if (-not (Get-ChildItem -LiteralPath $assets -Filter '*.iso' -ErrorAction SilentlyContinue)) {
        if (-not (Test-Path -LiteralPath $IsoZip)) {
            Write-Host "FALTA el disco: copia 'Black (USA).zip' (6,5 GB) a C:\Games\BLACK\xbox\iso-redump\ desde la otra maquina (pendrive o red) y volve a correr esto." -ForegroundColor Red
            return $false
        }
        Write-Host "Sacando la ISO del zip (7,8 GB, ~1,5 min)..." -ForegroundColor Cyan
        $z = [IO.Compression.ZipFile]::OpenRead($IsoZip)
        $iso = $z.Entries | Where-Object { $_.FullName -match '\.iso$' } | Select-Object -First 1
        [IO.Compression.ZipFileExtensions]::ExtractToFile($iso, (Join-Path $assets ([IO.Path]::GetFileName($iso.FullName))), $true)
        $z.Dispose()
    }
    $sha = (Get-FileHash -LiteralPath $Exe -Algorithm SHA256).Hash
    if ($sha -ne $ExeSha) {
        Write-Host "AVISO: este BLACK.exe no es el probado ($($sha.Substring(0,8))). Las dos maquinas tienen que tener el mismo." -ForegroundColor Yellow
    }
    return $true
}

# Tamano real de cada monitor (DPI-aware: sin eso Windows miente con la escala).
function Get-Monitores {
    if (-not ('Dpi133m' -as [type])) {
        Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public static class Dpi133m { [DllImport("user32.dll")] public static extern bool SetProcessDPIAware(); }'
    }
    [Dpi133m]::SetProcessDPIAware() | Out-Null
    Add-Type -AssemblyName System.Windows.Forms
    return @([System.Windows.Forms.Screen]::AllScreens | Sort-Object { -not $_.Primary })
}

# La calidad grafica de ESTA maquina: la escribe PREPARAR-BLACK.ps1 (segun monitor y placa) en calidad.toml al lado
# del exe, y los lanzadores la vuelven a poner antes de abrir (el black.toml es uno solo y cada lanzador lo toca).
# Codigos del port (BLACK-XBERecomp src/common/menu.cpp): msaa 0/2/4/8, anisotropic_filtering 0/2/4/8/16,
# draw_distance 1/2/4/8/12/16, ambient_occlusion 0 nada/1 SSAO/2 GTAO, fps_cap 1 = la frecuencia del monitor.
$Script:Calidad = Join-Path $Juego 'calidad.toml'

function Get-CalidadSugerida {
    $mon = (Get-Monitores)[0].Bounds
    $gpu = (Get-CimInstance Win32_VideoController | Sort-Object AdapterRAM -Descending | Select-Object -First 1).Name
    $integrada = $gpu -match 'Intel|UHD|Iris|Radeon\(TM\) Graphics|Vega'
    $render = if ($integrada) { 100 } elseif ($mon.Height -le 1080) { 150 } elseif ($mon.Height -le 1440) { 125 } else { 100 }
    return [ordered]@{
        render_percent = $render; msaa = $(if ($integrada) { 0 } else { 4 }); smaa = $true
        anisotropic_filtering = 16; draw_distance = $(if ($integrada) { 2 } else { 8 })
        ambient_occlusion = $(if ($integrada) { 0 } else { 2 }); fps_cap = 1; vsync = $true; skip_intros = $true
    }, "$gpu, monitor $($mon.Width)x$($mon.Height)"
}

function Save-Calidad([System.Collections.IDictionary]$c) {
    $l = foreach ($k in $c.Keys) { $v = $c[$k]; "$k = $(if ($v -is [bool]) { $v.ToString().ToLower() } else { $v })" }
    [IO.File]::WriteAllText($Calidad, (($l -join "`n") + "`n"), (New-Object Text.UTF8Encoding($false)))
}

function Set-Calidad {
    if (-not (Test-Path -LiteralPath $Calidad)) { return }
    $c = @{}
    foreach ($l in [IO.File]::ReadAllLines($Calidad)) {
        if ($l -match '^\s*(\w+)\s*=\s*(\S+)') {
            $c[$Matches[1]] = if ($Matches[2] -in 'true', 'false') { $Matches[2] -eq 'true' } else { [int]$Matches[2] }
        }
    }
    if ($c.Count) { Set-Toml $c }
}

function Test-Instalacion {
    $iso = Get-ChildItem -LiteralPath (Join-Path $Juego 'assets') -Filter '*.iso' -ErrorAction SilentlyContinue
    if (-not (Test-Path -LiteralPath $Exe) -or -not $iso) {
        Write-Host "FALTA la instalacion en $Juego (BLACK.exe y la ISO en assets). Avisale a Claude." -ForegroundColor Red
        return $false
    }
    return $true
}

# Pone claves en black.toml sin tocar las demas. UTF-8 sin BOM: con BOM el port no lee la primera linea.
function Set-Toml([hashtable]$claves) {
    $lineas = @()
    if (Test-Path -LiteralPath $Toml) { $lineas = [IO.File]::ReadAllLines($Toml) }
    foreach ($k in $claves.Keys) {
        $v = $claves[$k]
        $texto = if ($v -is [bool]) { $v.ToString().ToLower() } elseif ($v -is [string]) { "'$v'" } else { "$v" }
        $hecho = $false
        for ($i = 0; $i -lt $lineas.Count; $i++) {
            if ($lineas[$i] -match "^\s*$k\s*=") { $lineas[$i] = "$k = $texto"; $hecho = $true }
        }
        if (-not $hecho) { $lineas += "$k = $texto" }
    }
    [IO.File]::WriteAllText($Toml, (($lineas -join "`n") + "`n"), (New-Object Text.UTF8Encoding($false)))
}

# Foto de pantalla completa, DPI-aware (sin eso sale 1536x864 y parece recortada).
function Save-Captura([string]$ruta) {
    if (-not ('Dpi133' -as [type])) {
        Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public static class Dpi133 { [DllImport("user32.dll")] public static extern bool SetProcessDPIAware(); }'
    }
    [Dpi133]::SetProcessDPIAware() | Out-Null
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    $b = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bmp = New-Object Drawing.Bitmap $b.Width, $b.Height
    $g = [Drawing.Graphics]::FromImage($bmp)
    $g.CopyFromScreen($b.Location, [Drawing.Point]::Empty, $b.Size)
    $bmp.Save($ruta, [Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose(); $bmp.Dispose()
}

function New-CarpetaCorrida([string]$nombre) {
    $d = Join-Path $Volcados ("{0}-{1}" -f (Get-Date -Format 'yyyyMMdd-HHmmss'), $nombre)
    New-Item -ItemType Directory -Force $d | Out-Null
    return $d
}

# Copia los registros del port a la carpeta de la corrida (black.log, black-N.log, los .prev y CrashDumps nuevos).
function Save-Registros([string]$destino, [datetime]$desde) {
    $logs = Join-Path $Juego 'logs'
    if (Test-Path -LiteralPath $logs) { Copy-Item -LiteralPath $logs -Destination (Join-Path $destino 'logs') -Recurse -Force }
    $dumps = Join-Path $Juego 'CrashDumps'
    if (Test-Path -LiteralPath $dumps) {
        Get-ChildItem -LiteralPath $dumps | Where-Object { $_.LastWriteTime -gt $desde } |
            Copy-Item -Destination $destino -Force
    }
    Copy-Item -LiteralPath $Toml -Destination $destino -Force -ErrorAction SilentlyContinue
}
