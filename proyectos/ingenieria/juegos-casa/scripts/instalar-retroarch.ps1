# Deja RetroArch portable en C:\Games\RetroArch con el nucleo de Mega Drive, los juegos y los accesos
# para jugar de a dos en red (cada uno en su pantalla). Corre igual en la notebook y en la PC.
# Uso: .\instalar-retroarch.ps1 -Nick Fran -Otra 10.147.20.3 -Carpeta "C:\Users\frans\Desktop\Juegos\Juegos de a dos" -NombreOtra "la PC"
param(
    [Parameter(Mandatory = $true)][string]$Nick,
    [Parameter(Mandatory = $true)][string]$Otra,          # IP de la otra maquina (ZeroTier: anda en casa y desde afuera)
    [Parameter(Mandatory = $true)][string]$NombreOtra,
    [Parameter(Mandatory = $true)][string]$Carpeta,       # donde van los accesos
    [string]$Fuente = "C:\Games\_descargas"               # RetroArch.7z, el nucleo y los zip de las ROMs
)
$ErrorActionPreference = 'Stop'
$sz = "C:\Program Files\7-Zip\7z.exe"
$ra = "C:\Games\RetroArch"
$roms = Join-Path $ra "roms\megadrive"

if (-not (Test-Path (Join-Path $ra "retroarch.exe"))) {
    $tmp = "C:\Games\_ra_tmp"
    & $sz x -y "-o$tmp" (Join-Path $Fuente "RetroArch.7z") | Out-Null
    $exe = Get-ChildItem $tmp -Recurse -Filter retroarch.exe | Select-Object -First 1
    Move-Item -LiteralPath $exe.Directory.FullName -Destination $ra
    Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Force (Join-Path $ra "cores"), $roms, (Join-Path $ra "logs") | Out-Null
& $sz e -y "-o$ra\cores" (Join-Path $Fuente "genesis_plus_gx_libretro.dll.zip") | Out-Null
foreach ($z in Get-ChildItem $Fuente -Filter *.zip | Where-Object { $_.Name -match 'Double Dragon II|Chase H\.Q\. II' }) {
    & $sz e -y "-o$roms" $z.FullName | Out-Null
}

# Configuracion: pantalla completa, no pausar sin foco (red), menu con Start+Select, stick como cruz, log.
$cfg = Join-Path $ra "retroarch.cfg"
$claves = [ordered]@{
    video_fullscreen = "true"; pause_nonactive = "false"; netplay_nickname = $Nick; netplay_ip_port = "55435"
    input_menu_toggle_gamepad_combo = "4"; input_player1_analog_dpad_mode = "1"; input_player2_analog_dpad_mode = "1"
    input_autodetect_enable = "true"; log_to_file = "true"; log_to_file_timestamp = "false"; config_save_on_exit = "true"
    menu_show_load_content_animation = "false"; video_shader_enable = "false"
}
$lineas = if (Test-Path $cfg) { Get-Content -LiteralPath $cfg } else { @() }
foreach ($k in $claves.Keys) {
    $nueva = '{0} = "{1}"' -f $k, $claves[$k]
    if ($lineas -match "^$k\s*=") { $lineas = $lineas -replace "^$k\s*=.*$", $nueva } else { $lineas += $nueva }
}
Set-Content -LiteralPath $cfg -Value $lineas -Encoding ascii

# Accesos directos
New-Item -ItemType Directory -Force $Carpeta | Out-Null
$ws = New-Object -ComObject WScript.Shell
$core = "cores\genesis_plus_gx_libretro.dll"
$dd = Get-ChildItem $roms -Filter "Double Dragon II*" | Select-Object -First 1
$ch = Get-ChildItem $roms -Filter "Chase H.Q. II*" | Select-Object -First 1
function Acceso($nombre, $argumentos) {
    $l = $ws.CreateShortcut((Join-Path $Carpeta "$nombre.lnk"))
    $l.TargetPath = Join-Path $ra "retroarch.exe"; $l.Arguments = $argumentos; $l.WorkingDirectory = $ra
    $l.IconLocation = (Join-Path $ra "retroarch.exe") + ",0"; $l.Save()
}
if ($dd) {
    Acceso "Double Dragon II - ser anfitrion" ("-L `"$core`" `"$($dd.FullName)`" --host --nick=$Nick")
    Acceso "Double Dragon II - unirse a $NombreOtra" ("-L `"$core`" `"$($dd.FullName)`" --connect=$Otra --nick=$Nick")
    Acceso "Double Dragon II - los dos en esta maquina" ("-L `"$core`" `"$($dd.FullName)`"")
}
if ($ch) { Acceso "Chase H.Q. II" ("-L `"$core`" `"$($ch.FullName)`"") }

$md5 = Get-ChildItem $roms | ForEach-Object { "{0}  {1}" -f (Get-FileHash $_.FullName -Algorithm MD5).Hash, $_.Name }
"RetroArch: " + (Test-Path (Join-Path $ra "retroarch.exe")) + " | nucleo: " + (Test-Path (Join-Path $ra $core))
$md5
"accesos: " + ((Get-ChildItem $Carpeta -Filter "*.lnk" | Where-Object { $_.Name -match 'Double Dragon|Chase' } | ForEach-Object Name) -join ' | ')
