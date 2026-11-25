# Inventario de juegos de UNA maquina (L1-01, L1-14): lo que hay en el disco, medido, como JSON por stdout.
# Corre igual en la notebook y en la PC (PowerShell 5.1, local o por SSH con -EncodedCommand). Solo lee, salvo su
# cache de MD5 (C:\Games\_indice\md5-cache.json). Las rutas que salen de aca van a un archivo ignorado por git
# (regla 2 del contrato), nunca al catalogo.
#
# Clases de deteccion (el catalogo dice como reconocer cada juego en cada clase):
#   steam    apps instaladas (appmanifest_*.acf de cada biblioteca)
#   epic     manifiestos del Epic Games Launcher
#   carpeta  cada carpeta de C:\Games y de las carpetas de juegos instalados del Escritorio
#   rom      cada archivo de RetroArch\roms\<sistema>\  (con MD5)
#   iso      cada imagen de PS2 (C:\Games\PS2-ISOs y Juegos de emulador\PS2), con MD5 cacheado por tamano+fecha
#   ps3      juegos de RPCS3 (dev_hdd0\game con su PARAM.SFO, y games.yml)
#   acceso   cada .lnk / .url / .bat del Escritorio y de Escritorio\Juegos (lo que ya se usa para arrancar)
param([switch]$SinMd5)
$ErrorActionPreference = 'SilentlyContinue'
$out = New-Object System.Collections.ArrayList
function Add-Item($clase, $nombre, $ruta, $extra) {
    $o = [ordered]@{ clase = $clase; nombre = $nombre; ruta = $ruta }
    if ($extra) { foreach ($k in $extra.Keys) { $o[$k] = $extra[$k] } }
    [void]$out.Add($o)
}
$escr = [Environment]::GetFolderPath('Desktop')
$juegos = Join-Path $escr 'Juegos'

# --- steam
$steam = (Get-ItemProperty 'HKCU:\Software\Valve\Steam').SteamPath
if ($steam) {
    $libs = @($steam.Replace('/', '\'))
    $vdf = Join-Path $libs[0] 'steamapps\libraryfolders.vdf'
    if (Test-Path $vdf) { foreach ($m in [regex]::Matches((Get-Content $vdf -Raw -Encoding UTF8), '"path"\s+"([^"]+)"')) { $libs += $m.Groups[1].Value.Replace('\\', '\') } }
    # la misma biblioteca aparece con mayusculas distintas (registro y .vdf): se deduplica sin distinguir
    foreach ($l in ($libs | ForEach-Object { $_.TrimEnd('\').ToLower() } | Sort-Object -Unique)) {
        foreach ($acf in Get-ChildItem (Join-Path $l 'steamapps') -Filter 'appmanifest_*.acf') {
            $t = Get-Content $acf.FullName -Raw -Encoding UTF8
            $id = [regex]::Match($t, '"appid"\s+"(\d+)"').Groups[1].Value
            $n = [regex]::Match($t, '"name"\s+"([^"]+)"').Groups[1].Value
            $d = [regex]::Match($t, '"installdir"\s+"([^"]+)"').Groups[1].Value
            Add-Item 'steam' $n (Join-Path $l "steamapps\common\$d") @{ appid = $id }
        }
    }
}
# --- epic
foreach ($f in Get-ChildItem 'C:\ProgramData\Epic\EpicGamesLauncher\Data\Manifests' -Filter *.item) {
    $j = Get-Content $f.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    Add-Item 'epic' $j.DisplayName $j.InstallLocation @{ appname = $j.AppName; exe = $j.LaunchExecutable }
}
# --- carpetas (C:\Games y las de juegos instalados del Escritorio)
$raices = @('C:\Games', (Join-Path $juegos 'Juegos de PC'), (Join-Path $juegos 'Juegos instalados'))
foreach ($r in $raices) {
    foreach ($d in Get-ChildItem $r -Directory) {
        $exes = @(Get-ChildItem $d.FullName -Filter *.exe -Recurse -Depth 2 | Select-Object -First 40 | ForEach-Object { $_.FullName.Substring($d.FullName.Length + 1) })
        Add-Item 'carpeta' $d.Name $d.FullName @{ raiz = $r; exes = $exes }
    }
}
# --- MD5 cacheado (las ISO pesan GB)
$cacheDir = 'C:\Games\_indice'; New-Item -ItemType Directory -Force $cacheDir | Out-Null
$cacheF = Join-Path $cacheDir 'md5-cache.json'
$cache = @{}
if (Test-Path $cacheF) { (Get-Content $cacheF -Raw | ConvertFrom-Json).PSObject.Properties | ForEach-Object { $cache[$_.Name] = $_.Value } }
function Get-Md5($f) {
    if ($SinMd5) { return $null }
    $k = "{0}|{1}|{2}" -f $f.FullName, $f.Length, $f.LastWriteTimeUtc.Ticks
    if (-not $cache.ContainsKey($k)) { $cache[$k] = (Get-FileHash -LiteralPath $f.FullName -Algorithm MD5).Hash }
    return $cache[$k]
}
# --- rom
foreach ($sis in Get-ChildItem 'C:\Games\RetroArch\roms' -Directory) {
    foreach ($f in Get-ChildItem $sis.FullName -File) { Add-Item 'rom' $f.BaseName $f.FullName @{ sistema = $sis.Name; md5 = (Get-Md5 $f); bytes = $f.Length } }
}
# --- iso (PS2)
$isoR = @('C:\Games\PS2-ISOs', (Join-Path $juegos 'Juegos de emulador\PS2'))
foreach ($r in $isoR) {
    # mas de 100 MB (L2-INV-02): lo de abajo son archivos sueltos de un ISO extraido (los datos de BLACK en la PC)
    foreach ($f in Get-ChildItem $r -File -Recurse -Include *.iso, *.chd, *.cso, *.bin, *.gz | Where-Object { $_.Length -gt 100MB }) { Add-Item 'iso' $f.BaseName $f.FullName @{ sistema = 'ps2'; md5 = (Get-Md5 $f); bytes = $f.Length } }
}
# --- ps3 (RPCS3): PARAM.SFO de cada juego de dev_hdd0\game y de games.yml
function Get-SfoTitle($p) {
    try {
        $b = [IO.File]::ReadAllBytes($p)
        $kt = [BitConverter]::ToInt32($b, 8); $dt = [BitConverter]::ToInt32($b, 12); $n = [BitConverter]::ToInt32($b, 16)
        $r = @{}
        for ($i = 0; $i -lt $n; $i++) {
            $e = 20 + 16 * $i
            $ko = [BitConverter]::ToUInt16($b, $e); $len = [BitConverter]::ToInt32($b, $e + 4); $do = [BitConverter]::ToInt32($b, $e + 12)
            $k = ''; $j = $kt + $ko; while ($b[$j] -ne 0) { $k += [char]$b[$j]; $j++ }
            $r[$k] = [Text.Encoding]::UTF8.GetString($b, $dt + $do, [Math]::Max(0, $len - 1))
        }
        return $r
    } catch { return @{} }
}
$rpcs = @('C:\Games\RPCS3') + @(Get-ChildItem (Join-Path $juegos 'Juegos instalados'), (Join-Path $juegos 'Emuladores') -Recurse -Depth 2 -Filter rpcs3.exe | Where-Object { $_.DirectoryName -notmatch 'rpcs3_old' } | ForEach-Object { $_.DirectoryName })
foreach ($r in ($rpcs | Sort-Object -Unique)) {
    if (-not (Test-Path (Join-Path $r 'rpcs3.exe'))) { continue }
    foreach ($g in Get-ChildItem (Join-Path $r 'dev_hdd0\game') -Directory) {
        $s = Get-SfoTitle (Join-Path $g.FullName 'PARAM.SFO')
        Add-Item 'ps3' $s['TITLE'] $g.FullName @{ id = $g.Name; categoria = $s['CATEGORY']; rpcs3 = $r }
    }
    $yml = Join-Path $r 'config\games.yml'; if (-not (Test-Path $yml)) { $yml = Join-Path $r 'games.yml' }
    foreach ($ln in Get-Content $yml) { if ($ln -match '^(\w{4}\d{5}):\s*(.+)$') { Add-Item 'ps3' $matches[1] $matches[2].Trim() @{ id = $matches[1]; categoria = 'DISC'; rpcs3 = $r } } }
}
# --- acceso (y los .txt de las carpetas de juegos): Escritorio, Escritorio\Juegos y el almacen de lanzadores del
# indice (C:\Games\_indice\accesos, donde quedan los accesos del indice viejo; 'rel' es la ruta relativa al
# Escritorio que tenian, asi el indice sabe de donde vino cada uno)
$sh = New-Object -ComObject WScript.Shell
$alm = 'C:\Games\_indice\accesos'
$roots = @(@{ p = $escr; d = 0; base = $escr; alm = $false }, @{ p = $juegos; d = 5; base = $escr; alm = $false }, @{ p = $alm; d = 7; base = $alm; alm = $true })
# las carpetas de Juegos que genero el indice (tienen la marca): lo de adentro son copias, no originales
$gen = @(Get-ChildItem $juegos -Directory | Where-Object { Test-Path (Join-Path $_.FullName '.indice-generado') } | ForEach-Object { $_.Name })
foreach ($rt in $roots) {
    foreach ($f in Get-ChildItem $rt.p -File -Recurse -Depth $rt.d -Include *.lnk, *.url, *.bat, *.txt) {
        if ($rt.d -eq 0 -and $f.DirectoryName -ne $escr) { continue }
        if ($f.Extension -eq '.txt' -and $rt.d -eq 0) { continue }
        $rel = $f.FullName.Substring($rt.base.Length + 1)
        $e = @{ carpeta = (Split-Path $rel); rel = $rel; almacen = $rt.alm }
        $partes = $rel -split '\\'
        if (-not $rt.alm -and $partes.Count -gt 2 -and $partes[0] -eq 'Juegos' -and ($gen -contains $partes[1])) { $e.generado = $true }
        if ($f.Extension -eq '.lnk') { $l = $sh.CreateShortcut($f.FullName); $e.destino = $l.TargetPath; $e.args = $l.Arguments; $e.dir = $l.WorkingDirectory }
        elseif ($f.Extension -eq '.url') { $e.destino = ([regex]::Match((Get-Content $f.FullName -Raw), 'URL=(.+)')).Groups[1].Value.Trim() }
        else { $e.destino = $f.FullName }
        $e.ext = $f.Extension
        Add-Item $(if ($f.Extension -eq '.txt') { 'texto' } else { 'acceso' }) $f.BaseName $f.FullName $e
    }
}
if (-not $SinMd5) { $c2 = [ordered]@{}; foreach ($k in $cache.Keys) { $c2[$k] = $cache[$k] }; ($c2 | ConvertTo-Json) | Set-Content $cacheF -Encoding UTF8 }
$json = [ordered]@{ maquina = $env:COMPUTERNAME; usuario = $env:USERNAME; escritorio = $escr; medido = (Get-Date).ToString('s'); items = $out } | ConvertTo-Json -Depth 5 -Compress
# ASCII puro: lo que no es ASCII va como \uXXXX, para que la consola (cp850/cp1252) y el SSH no lo rompan
# (2026-11-25: un "(TM)" de Steam salio por la consola como comillas y el JSON no parseaba)
$sb = New-Object Text.StringBuilder
foreach ($ch in $json.ToCharArray()) { if ([int]$ch -gt 127) { [void]$sb.AppendFormat('\u{0:x4}', [int]$ch) } else { [void]$sb.Append($ch) } }
$sb.ToString()
