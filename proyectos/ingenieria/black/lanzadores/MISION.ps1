# Ir a cualquier mision de la campana, este o no desbloqueada, con el coop abierto (BLACK (135c)). Lo corre el
# anfitrion, con el juego abierto por JUGAR-COOP-RED.ps1 -Anfitrion; el companero lo sigue solo.
#
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\MISION.ps1" 5
#   ... 5 -Dificultad 3     # 0 facil .. 3 Black Ops; sin esto, la que esta elegida en el juego
#
# Como: el canal de control del coop (black-seamless-coop, --coop-control 45501) tiene "mission <nivel> <dificultad>",
# la carga nativa del juego. No toca la partida guardada: no desbloquea nada en el perfil, carga la mision y listo.
# Mision 1..8 -> nivel interno 0,1,3,4,5,6,7,8 (el 2 no es de la campana; CampaignLevel del mod). El orden de los
# nombres es el de la campana segun docs/20 (probable, sin medir): el script imprime el nivel que quedo cargado.

param([Parameter(Mandatory = $true)][ValidateRange(1, 8)][int]$Mision, [ValidateRange(-1, 3)][int]$Dificultad = -1,
      [int]$Puerto = 45501)

$niveles = 0, 1, 3, 4, 5, 6, 7, 8
$nombres = 'City Streets', 'Wilderness', 'Town', 'Docks', 'Gulag', 'Steelworks', 'Asylum', 'City Bridge'

function Ctl([string]$cmd) {
    $u = New-Object Net.Sockets.UdpClient
    $u.Client.ReceiveTimeout = 3000
    try {
        $b = [Text.Encoding]::ASCII.GetBytes($cmd)
        [void]$u.Send($b, $b.Length, '127.0.0.1', $Puerto)
        $ep = New-Object Net.IPEndPoint([Net.IPAddress]::Any, 0)
        [Text.Encoding]::ASCII.GetString($u.Receive([ref]$ep))
    } catch { $null } finally { $u.Close() }
}

$estado = Ctl 'state'
if (-not $estado) { Write-Host "El juego no contesta en el puerto $Puerto: abrilo con JUGAR-COOP-RED.ps1 -Anfitrion." -ForegroundColor Red; exit 1 }
if ($Dificultad -lt 0) { $Dificultad = if ($estado -match 'difficulty=(\d)') { [int]$Matches[1] } else { 1 } }

$nivel = $niveles[$Mision - 1]
$r = Ctl "mission $nivel $Dificultad"
Write-Host "Mision $Mision ($($nombres[$Mision - 1]), nivel $nivel), dificultad ${Dificultad}: $r" -ForegroundColor $(if ($r -like 'asked*') { 'Green' } else { 'Red' })
if ($r -notlike 'asked*') { exit 1 }
for ($i = 0; $i -lt 40; $i++) {
    Start-Sleep -Seconds 1
    $s = Ctl 'state'
    if ($s -match 'level=(\d+) unit=(\d+) play=1') { Write-Host "Cargada: nivel $($Matches[1]), unidad $($Matches[2])." -ForegroundColor Green; exit 0 }
}
Write-Host "Pedida; todavia cargando (mira la pantalla)." -ForegroundColor Yellow
