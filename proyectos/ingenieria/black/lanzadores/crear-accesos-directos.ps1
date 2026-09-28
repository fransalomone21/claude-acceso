# crear-accesos-directos.ps1 -- deja los accesos de BLACK en su carpeta de juegos:
#   Escritorio\Juegos\Juegos de emulador\PS2\BLACK\
# (los ISO estan en ISOs\ de esa misma carpeta; la ruta la manda kb/ubicaciones.json).
# Se puede volver a correr cuantas veces se quiera: pisa los .lnk existentes.
# Sin acentos a proposito: la consola de Windows lee cp1252.

$ErrorActionPreference = 'Stop'
$lz   = $PSScriptRoot
$raiz = Resolve-Path (Join-Path $lz '..')
$j    = Get-Content -LiteralPath (Join-Path $raiz 'kb\ubicaciones.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$dest = Split-Path (Split-Path $j.rutas.iso_original.ruta)      # ...\PS2\BLACK
$ps   = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$icoP = (Join-Path $env:ProgramFiles 'PCSX2\pcsx2-qt.exe') + ',0'
$w    = New-Object -ComObject WScript.Shell

function Acceso([string]$nombre, [string]$script, [string]$extra, [string]$icono, [string]$desc, [switch]$Min) {
    $a = $w.CreateShortcut((Join-Path $dest "$nombre.lnk"))
    $a.TargetPath       = $ps
    $estilo = if ($Min) { '-WindowStyle Minimized ' } else { '' }
    $a.Arguments        = "-NoProfile -ExecutionPolicy Bypass $estilo-File `"$(Join-Path $lz $script)`" $extra".Trim()
    $a.WorkingDirectory = $lz
    $a.IconLocation     = $icono
    $a.Description      = $desc
    $a.Save()
}

# los viejos (antes vivian en el Escritorio y en Juegos\Mods\BLACK con otro nombre)
foreach ($v in 'BLACK.lnk', 'BLACK - Grabar 20 s.lnk') { $p = Join-Path $dest $v; if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p } }

Acceso 'JUGAR BLACK'                        'JUGAR-BLACK.ps1' ''                $icoP 'BLACK solo, pantalla completa, teclado y mouse (apaga el coop)' -Min
Acceso 'JUGAR BLACK COOP - teclado y mando' 'JUGAR-BLACK.ps1' '-Coop teclado'   $icoP 'Coop en pantalla dividida: J1 teclado+mouse, J2 el mando' -Min
Acceso 'JUGAR BLACK COOP - dos mandos'      'JUGAR-BLACK.ps1' '-Coop 2mandos'   $icoP 'Coop en pantalla dividida: J1 mando 1, J2 mando 2' -Min
Acceso 'BLACK - Grabar 30 s'                'grabar-gameplay.ps1' '-Segundos 30 -Espera 5' ((Join-Path $env:SystemRoot 'System32\shell32.dll') + ',116') 'Graba 30 s de pantalla para Claude (espera 5 s: volve al juego). Mientras se juega: Ctrl+Alt+G' -Min
Acceso 'BLACK - Parches'                    'PARCHES-BLACK.ps1' ''              ((Join-Path $env:SystemRoot 'System32\shell32.dll') + ',21') 'Prender y apagar parches de BLACK (60 FPS, widescreen, mods del proyecto)'

Get-ChildItem -LiteralPath $dest -Filter '*.lnk' | Select-Object Name, LastWriteTime
