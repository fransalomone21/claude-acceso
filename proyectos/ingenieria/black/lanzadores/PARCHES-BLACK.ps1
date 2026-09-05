# PARCHES-BLACK.ps1 -- menu para prender y apagar parches de BLACK.
#
# Junta en UNA sola lista:
#   - los parches oficiales de PCSX2 para BLACK (60 FPS, Widescreen, etc.),
#     que viven comprimidos en resources\patches.zip
#   - los mods propios del proyecto (black\construido\*.pnach)
#   - el overclock del EE, que el autor del parche de 60 FPS recomienda
#
# Los escribe juntos en Documents\PCSX2\patches\SLUS-21376_5C891FF1.pnach para
# que PCSX2 los muestre en la misma lista, y prende/apaga por nombre en
# Documents\PCSX2\gamesettings\SLUS-21376_5C891FF1.ini.
#
# Los tres ISO (Black.iso, Black-mod-armas.iso, Black-mod-7b.iso) arrancan con
# el MISMO CRC 5C891FF1 -- medido en emulog.txt, no supuesto -- asi que estos
# parches valen para los tres.
#
# Sin acentos a proposito: la consola de Windows lee cp1252.

[CmdletBinding()]
param([switch]$Listar)   # -Listar: imprime el estado y sale, sin menu (para verificar)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$CRC      = '5C891FF1'
$NOMBRE   = "SLUS-21376_$CRC"
$docs     = Join-Path $env:USERPROFILE 'Documents\PCSX2'
$zip      = 'C:\Program Files\PCSX2\resources\patches.zip'
$destPnach= Join-Path $docs "patches\$NOMBRE.pnach"
$iniJuego = Join-Path $docs "gamesettings\$NOMBRE.ini"
$iniGlobal= Join-Path $docs 'inis\PCSX2.ini'
$repoMods = Join-Path $PSScriptRoot '..\construido'

# Set-Content -Encoding UTF8 en PowerShell 5.1 escribe BOM, y un ini que
# empieza con BOM le llega a PCSX2 con la primera seccion corrupta. Se escribe
# siempre por esta funcion, nunca con Set-Content.
function Escribir-Sin-BOM([string]$ruta, [string[]]$lineas) {
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($ruta, (($lineas -join "`r`n") + "`r`n"), $enc)
}


# --- 1. armar el pnach unico: oficiales + mods del proyecto ----------------
$texto = ''
if (Test-Path -LiteralPath $zip) {
    $z = [System.IO.Compression.ZipFile]::OpenRead($zip)
    $e = $z.Entries | Where-Object { $_.Name -eq "$NOMBRE.pnach" }
    if ($e) { $r = New-Object System.IO.StreamReader($e.Open()); $texto = $r.ReadToEnd(); $r.Dispose() }
    $z.Dispose()
}
if (-not $texto) { throw "No se encontro $NOMBRE.pnach dentro de $zip" }

$propios = @()
if (Test-Path -LiteralPath $repoMods) {
    foreach ($f in Get-ChildItem -LiteralPath $repoMods -Filter '*.pnach') {
        $cont = Get-Content -LiteralPath $f.FullName -Raw
        # la primera linea gametitle= ya la puso el oficial; se saca
        $cont = ($cont -split "`r?`n" | Where-Object { $_ -notmatch '^\s*gametitle=' }) -join "`r`n"
        $texto += "`r`n" + $cont
        $propios += ([regex]::Matches($cont, '(?m)^\[(.+?)\]\s*$') | ForEach-Object { $_.Groups[1].Value })
    }
}

New-Item -ItemType Directory -Force -Path (Split-Path $destPnach) | Out-Null
Escribir-Sin-BOM $destPnach @($texto)

# --- 2. leer que parches hay y cuales estan prendidos ----------------------
$secciones = [regex]::Matches($texto, '(?m)^\[(.+?)\]\s*$') | ForEach-Object { $_.Groups[1].Value }
$secciones = $secciones | Select-Object -Unique

function Leer-Ini {
    if (-not (Test-Path -LiteralPath $iniJuego)) { return @() }
    return Get-Content -LiteralPath $iniJuego
}
function Prendidos {
    (Leer-Ini) | Where-Object { $_ -match '^\s*Enable\s*=\s*(.+)$' } |
        ForEach-Object { ($_ -replace '^\s*Enable\s*=\s*','').Trim() }
}
function EE-Rate {
    $l = (Get-Content -LiteralPath $iniGlobal) | Where-Object { $_ -match '^EECycleRate\s*=' }
    if ($l) { [int](($l -split '=')[1].Trim()) } else { 0 }
}
function Set-EE-Rate([int]$v) {
    if (Get-Process -Name 'pcsx2-qt' -ErrorAction SilentlyContinue) {
        Write-Output '  >> PCSX2 esta abierto: al salir pisa el ini. Cerralo y volve a intentar.'
        return
    }
    $l = Get-Content -LiteralPath $iniGlobal
    $l = $l | ForEach-Object { if ($_ -match '^EECycleRate\s*=') { "EECycleRate = $v" } else { $_ } }
    Escribir-Sin-BOM $iniGlobal $l
}
function Guardar-Prendidos($lista) {
    $l = Leer-Ini
    $out = New-Object System.Collections.Generic.List[string]
    $i = 0; $tienePatches = $false
    while ($i -lt $l.Count) {
        if ($l[$i].Trim() -eq '[Patches]') {
            $tienePatches = $true
            $out.Add('[Patches]')
            foreach ($n in $lista) { $out.Add("Enable = $n") }
            $i++
            while ($i -lt $l.Count -and $l[$i] -notmatch '^\[') { $i++ }
            $out.Add('')
        } else { $out.Add($l[$i]); $i++ }
    }
    if (-not $tienePatches) {
        $out.Insert(0, '')
        foreach ($n in ($lista | Sort-Object -Descending)) { $out.Insert(0, "Enable = $n") }
        $out.Insert(0, '[Patches]')
    }
    $txt = $out -join "`r`n"
    if ($txt -notmatch 'ShowPatchesForAllCRCs') { $txt += "`r`n[EmuCore]`r`nShowPatchesForAllCRCs = true`r`nEnableCheats = true`r`n" }
    New-Item -ItemType Directory -Force -Path (Split-Path $iniJuego) | Out-Null
    Escribir-Sin-BOM $iniJuego @($txt)
}

# --- 3. el menu -----------------------------------------------------------
if ($Listar) {
    $on = @(Prendidos)
    Write-Output "pnach unificado: $destPnach"
    foreach ($s in $secciones) {
        $marca = if ($on -contains $s) { '[X]' } else { '[ ]' }
        $tag   = if ($propios -contains $s) { '  <- mod del proyecto' } else { '' }
        Write-Output ("  {0} {1}{2}" -f $marca, $s, $tag)
    }
    Write-Output ("  EECycleRate = {0}" -f (EE-Rate))
    exit 0
}

while ($true) {
    $on = @(Prendidos)
    Clear-Host
    Write-Output ''
    Write-Output '  PARCHES DE BLACK   (SLUS-21376 / CRC 5C891FF1)'
    Write-Output '  ----------------------------------------------------------'
    for ($i = 0; $i -lt $secciones.Count; $i++) {
        $s = $secciones[$i]
        $marca = if ($on -contains $s) { '[X]' } else { '[ ]' }
        $tag   = if ($propios -contains $s) { '  <- mod del proyecto' } else { '' }
        Write-Output ("   {0,2}. {1} {2}{3}" -f ($i + 1), $marca, $s, $tag)
    }
    $ee = EE-Rate
    $eeTxt = switch ($ee) { 0 {'100% (normal)'} 1 {'130%'} 2 {'180%'} 3 {'300%'} default {"$ee"} }
    Write-Output '  ----------------------------------------------------------'
    Write-Output ("    E. Overclock del EE: $eeTxt   (el parche de 60 FPS dice que puede hacer falta 180%)")
    Write-Output ''
    Write-Output '   numero = prender/apagar    E = ciclar overclock    J = guardar y jugar    Q = guardar y salir'
    Write-Output ''
    $k = (Read-Host '  >').Trim()

    if ($k -match '^[Qq]$') { Guardar-Prendidos $on; Write-Output '  Guardado.'; break }
    if ($k -match '^[Jj]$') {
        Guardar-Prendidos $on
        & (Join-Path $PSScriptRoot 'JUGAR-BLACK.ps1')
        break
    }
    if ($k -match '^[Ee]$') { Set-EE-Rate ((@(0,1,2,3)[(([array]::IndexOf(@(0,1,2,3), (EE-Rate)) + 1) % 4)])); continue }
    if ($k -match '^\d+$') {
        $idx = [int]$k - 1
        if ($idx -ge 0 -and $idx -lt $secciones.Count) {
            $s = $secciones[$idx]
            if ($on -contains $s) { $on = @($on | Where-Object { $_ -ne $s }) } else { $on = @($on) + $s }
            Guardar-Prendidos $on
        }
    }
}
