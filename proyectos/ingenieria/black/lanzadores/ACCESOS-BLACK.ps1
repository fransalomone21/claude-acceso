# Los accesos directos de BLACK, ordenados por como se juega (BLACK (138)). Lo llama PREPARAR-BLACK.ps1, y se puede
# correr solo para rehacerlos sin reinstalar nada:
#
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\ACCESOS-BLACK.ps1"
#
# Escritorio\Juegos\BLACK\
#   BLACK solo
#   Elegir mision                      (la anfitriona la carga; la otra copia la sigue sola)
#   Coop en la tele\                   (una sola maquina, un mando por jugador)
#     Tele - arriba y abajo (recomendado)
#     Tele - lado a lado
#     Notebook y tele (una pantalla cada uno)
#   Coop por red (dos computadoras)\
#     Hostear
#     Unirse
#
# Los accesos de antes (todos sueltos en Juegos\BLACK) se borran por NOMBRE, uno por uno: nada mas que eso se toca.

. (Join-Path $PSScriptRoot 'plataforma-comun.ps1')

$raiz = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Juegos\BLACK'
$tele = Join-Path $raiz 'Coop en la tele'
$red = Join-Path $raiz 'Coop por red (dos computadoras)'
foreach ($d in $raiz, $tele, $red) { New-Item -ItemType Directory -Force $d | Out-Null }

foreach ($viejo in 'BLACK coop - dos pantallas', 'BLACK coop - elegir mision', 'BLACK coop - hostear', 'BLACK coop - misma maquina',
                   'BLACK coop - tele', 'BLACK coop - unirse') {
    $p = Join-Path $raiz "$viejo.lnk"
    if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p }
}

$ps = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$w = New-Object -ComObject WScript.Shell
function Acceso([string]$carpeta, [string]$nombre, [string]$script, [string]$extra, [string]$desc) {
    $a = $w.CreateShortcut((Join-Path $carpeta "$nombre.lnk"))
    $a.TargetPath = $ps
    $a.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$(Join-Path $PSScriptRoot $script)`" $extra".Trim()
    $a.WorkingDirectory = $PSScriptRoot
    $a.IconLocation = "$Exe,0"
    $a.Description = $desc
    $a.Save()
}
Acceso $raiz 'BLACK solo'    'JUGAR-COOP-RED.ps1' '-Solo' 'BLACK de un jugador, con el mando en los botones de PS2'
Acceso $raiz 'Elegir mision' 'MISION.ps1'         ''      'Con el coop abierto: carga cualquier mision de la campana en la anfitriona; la otra copia la sigue'
Acceso $tele 'Tele - arriba y abajo (recomendado)'     'PROBAR-COOP-PC.ps1' '-ArribaAbajo'  'Dos copias: jugador 1 arriba, jugador 2 abajo, sin bordes'
Acceso $tele 'Tele - lado a lado'                      'PROBAR-COOP-PC.ps1' ''              'Dos copias: jugador 1 a la izquierda, jugador 2 a la derecha, sin bordes'
Acceso $tele 'Notebook y tele (una pantalla cada uno)' 'PROBAR-COOP-PC.ps1' '-DosMonitores' 'Dos copias: una en la notebook y otra en la tele (Windows en Extender)'
Acceso $red  'Hostear' 'JUGAR-COOP-RED.ps1' '-Anfitrion' 'Coop por red: esta maquina hostea; muestra la IP para la otra'
Acceso $red  'Unirse'  'JUGAR-COOP-RED.ps1' '-Preguntar' 'Coop por red: pide la IP de la que hostea (recuerda la ultima)'
Write-Host "[ok] accesos directos en $raiz" -ForegroundColor Green
