# Deja RetroArch portable en C:\Games\RetroArch con el nucleo de Mega Drive y los accesos para jugar de a
# dos en red (cada uno en su pantalla) de cada juego de la lista. Corre igual en la notebook y en la PC.
# Uso: .\instalar-retroarch.ps1 -Nick Fran -Otra 10.147.20.3 -NombreOtra "la PC" -Carpeta "C:\Users\frans\Desktop\Juegos\Juegos de a dos"
# La lista de juegos es juegos-de-a-dos.csv (al lado de este script): Nombre, Rom (archivo en roms\megadrive),
# Modo (red = ser anfitrion / unirse / los dos en esta maquina; uno = un solo acceso).
# Las ROMs las pone Fran (R-01): un juego cuya ROM no esta en roms\megadrive se saltea y se avisa.
param(
    [Parameter(Mandatory = $true)][string]$Nick,
    [Parameter(Mandatory = $true)][string]$Otra,          # IP de la otra maquina (ZeroTier: anda en casa y desde afuera)
    [Parameter(Mandatory = $true)][string]$NombreOtra,
    [Parameter(Mandatory = $true)][string]$Carpeta,       # donde van los accesos (una subcarpeta por juego)
    [string]$Fuente = "C:\Games\_descargas",              # RetroArch.7z y el nucleo, si falta instalarlos
    [string]$Lista = (Join-Path $PSScriptRoot "juegos-de-a-dos.csv")
)
$sz = "C:\Program Files\7-Zip\7z.exe"
$ra = "C:\Games\RetroArch"
$roms = Join-Path $ra "roms\megadrive"
$core = "cores\genesis_plus_gx_libretro.dll"

if (-not (Test-Path (Join-Path $ra "retroarch.exe"))) {
    $tmp = "C:\Games\_ra_tmp"
    & $sz x -y "-o$tmp" (Join-Path $Fuente "RetroArch.7z") | Out-Null
    $exe = Get-ChildItem $tmp -Recurse -Filter retroarch.exe | Select-Object -First 1
    Move-Item -LiteralPath $exe.Directory.FullName -Destination $ra
    Remove-Item -LiteralPath $tmp -Recurse -Force -ErrorAction SilentlyContinue
}
New-Item -ItemType Directory -Force (Join-Path $ra "cores"), $roms, (Join-Path $ra "logs") | Out-Null
if (-not (Test-Path (Join-Path $ra $core))) { & $sz e -y "-o$ra\cores" (Join-Path $Fuente "genesis_plus_gx_libretro.dll.zip") | Out-Null }

# Configuracion: pantalla completa, no pausar sin foco (red), menu con Start+Select, stick como cruz.
# Con RetroArch abierto NO se toca: al salir reescribe retroarch.cfg y pisaria el cambio.
$cfg = Join-Path $ra "retroarch.cfg"
if (Get-Process retroarch -ErrorAction SilentlyContinue) {
    "config: RetroArch esta abierto, retroarch.cfg no se toca (correr de nuevo con RetroArch cerrado)"
} else {
    $claves = [ordered]@{
        video_fullscreen = "true"; pause_nonactive = "false"; netplay_nickname = $Nick; netplay_ip_port = "55435"
        input_menu_toggle_gamepad_combo = "4"; input_player1_analog_dpad_mode = "1"; input_player2_analog_dpad_mode = "1"
        input_autodetect_enable = "true"; log_to_file = "true"; log_to_file_timestamp = "false"; config_save_on_exit = "true"
        menu_show_load_content_animation = "false"; video_shader_enable = "false"
        # Red (2026-11-25, Fran: "se ralentiza y lo que ve el otro diverge y lo teletransporta"): con 0 cuadros
        # de demora cada pico del Wi-Fi fuerza un rollback (el salto); 2 cuadros lo absorben. Y el chequeo de
        # sincronia cada 600 cuadros (10 s) dejaba divergir hasta 10 s: cada 30 cuadros lo corrige al toque.
        netplay_input_latency_frames_min = "2"; netplay_input_latency_frames_range = "2"; netplay_check_frames = "30"
        netplay_ping_show = "true"; netplay_public_announce = "false"
    }
    $lineas = if (Test-Path $cfg) { Get-Content -LiteralPath $cfg } else { @() }
    foreach ($k in $claves.Keys) {
        $nueva = '{0} = "{1}"' -f $k, $claves[$k]
        if ($lineas -match "^$k\s*=") { $lineas = $lineas -replace "^$k\s*=.*$", $nueva } else { $lineas += $nueva }
    }
    Set-Content -LiteralPath $cfg -Value $lineas -Encoding ascii
    "config: escrita"
}

# Accesos directos: una subcarpeta por juego
New-Item -ItemType Directory -Force $Carpeta | Out-Null
$ws = New-Object -ComObject WScript.Shell
function Acceso($dir, $nombre, $argumentos) {
    $l = $ws.CreateShortcut((Join-Path $dir "$nombre.lnk"))
    $l.TargetPath = Join-Path $ra "retroarch.exe"; $l.Arguments = $argumentos; $l.WorkingDirectory = $ra
    $l.IconLocation = (Join-Path $ra "retroarch.exe") + ",0"; $l.Save()
}
$hechos = @(); $faltan = @()
foreach ($j in Import-Csv -LiteralPath $Lista) {
    $rom = Join-Path $roms $j.Rom
    if (-not (Test-Path -LiteralPath $rom)) { $faltan += $j.Nombre; continue }
    $dir = Join-Path $Carpeta $j.Nombre
    New-Item -ItemType Directory -Force $dir | Out-Null
    $base = "-L `"$core`" `"$rom`""
    if ($j.Modo -eq 'red') {
        Acceso $dir "$($j.Nombre) - ser anfitrion" "$base --host --nick=$Nick"
        Acceso $dir "$($j.Nombre) - unirse a $NombreOtra" "$base --connect=$Otra --nick=$Nick"
        Acceso $dir "$($j.Nombre) - los dos en esta maquina" $base
    } else {
        Acceso $dir $j.Nombre $base
    }
    $hechos += $j.Nombre
}

"RetroArch: " + (Test-Path (Join-Path $ra "retroarch.exe")) + " | nucleo: " + (Test-Path (Join-Path $ra $core))
Get-ChildItem $roms -File | ForEach-Object { "{0}  {1}" -f (Get-FileHash $_.FullName -Algorithm MD5).Hash, $_.Name }
"juegos con accesos ({0}): {1}" -f $hechos.Count, ($hechos -join ' | ')
"accesos: " + @(Get-ChildItem $Carpeta -Recurse -Filter *.lnk).Count
if ($faltan) { "SIN ROM (se saltearon): " + ($faltan -join ' | ') }
