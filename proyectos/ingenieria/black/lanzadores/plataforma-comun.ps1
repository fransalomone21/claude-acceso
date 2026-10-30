# Lo comun de los lanzadores de la plataforma (BLACK-XBERecomp + black-seamless-coop), sesion (133).
# No se corre solo: lo cargan PROBAR-PLATAFORMA-S1.ps1 y PROBAR-COOP-PC.ps1 con un punto adelante.

$Script:Juego    = 'C:\Games\BLACK\coop'
$Script:Exe      = Join-Path $Juego 'BLACK.exe'
$Script:Toml     = Join-Path $Juego 'black.toml'
$Script:Black    = Split-Path $PSScriptRoot -Parent
$Script:Volcados = Join-Path $Black 'volcados\plataforma'

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
