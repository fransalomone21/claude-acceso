# Manejar la PC desde la notebook por el cable, sin tocar la PC (OpenSSH). Sesion (135), pedido de Fran 2026-10-30.
# Corre EN LA NOTEBOOK. La llave es ~\.ssh\pc-cable; lo que se sabe de la PC (usuario, ultima IP) en ~\.ssh\pc-cable.json.
#
#   ACCESO-PC.ps1 -Preparar                  sirve el instalador por el cable e imprime la UNICA linea para pegar en la PC
#   ACCESO-PC.ps1 -Usuario <u> [-Equipo <nombre>] [-IP <ip>]   anota quien es la PC (lo avisa ella al prepararse)
#   ACCESO-PC.ps1 -Comando "<powershell>"    corre algo en la PC y trae la salida
#   ACCESO-PC.ps1 -Enviar <local> -A <ruta>  copia un archivo o carpeta a la PC
#   ACCESO-PC.ps1 -Traer <ruta> -A <local>   copia de la PC a la notebook
#   ACCESO-PC.ps1 -Quitar                    deshace todo en la PC (QUITAR-ACCESO-PC.ps1)

param([switch]$Preparar, [string]$Usuario, [string]$Equipo, [string]$IP, [string]$Comando, [string]$Enviar, [string]$Traer, [string]$A,
      [switch]$Quitar, [int]$Puerto = 8134)

$llave = "$env:USERPROFILE\.ssh\pc-cable"
$datos = "$env:USERPROFILE\.ssh\pc-cable.json"

function Placa-Cable {
    Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object {
        $_.InterfaceAlias -notmatch 'Wi-?Fi|ZeroTier|Bluetooth|Loopback|vEthernet|\*' -and $_.IPAddress -notlike '127.*'
    } | Select-Object -First 1
}

# la direccion de la notebook en la red de la casa (la de la salida a internet que no es ZeroTier); si no hay, el cable.
# (135) la PC resulto estar en la red de la casa por cable al router, no en el cable directo: 169.254 le era inalcanzable
function Placa-Casa {
    $r = Get-NetRoute -AddressFamily IPv4 -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue |
        Where-Object { $_.InterfaceAlias -notmatch 'ZeroTier|vEthernet' } | Sort-Object RouteMetric | Select-Object -First 1
    if ($r) { Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $r.InterfaceIndex -ErrorAction SilentlyContinue | Select-Object -First 1 }
    else { Placa-Cable }
}

if ($Preparar) {
    $cable = Placa-Casa
    if (-not $cable) { Write-Host "No veo red ni cable con IP. Conecta la notebook a la red de la casa (o el cable a la PC) y volve a correr." -ForegroundColor Red; exit 1 }
    $dir = "$env:USERPROFILE\PC-remoto\servir"
    foreach ($f in 'OpenSSH-Win64.msi', 'notebook.pub') { if (-not (Test-Path "$dir\$f")) { Write-Host "Falta $dir\$f" -ForegroundColor Red; exit 1 } }
    Copy-Item "$PSScriptRoot\PREPARAR-ACCESO-PC.ps1", "$PSScriptRoot\QUITAR-ACCESO-PC.ps1" $dir -Force
    $o = "http://$($cable.IPAddress):$Puerto"
    Write-Host "PEGA ESTO EN LA PC (PowerShell), y cuando pida permiso de administrador: Si" -ForegroundColor Yellow
    Write-Host "    `$o='$o'; curl.exe -sf -o `"`$env:TEMP\PREPARAR-ACCESO-PC.ps1`" `"`$o/PREPARAR-ACCESO-PC.ps1`"; powershell -ExecutionPolicy Bypass -File `"`$env:TEMP\PREPARAR-ACCESO-PC.ps1`" -Origen `$o" -ForegroundColor White
    Write-Host "Cuando la PC diga LISTO, cerra esta ventana (Ctrl+C)." -ForegroundColor Green
    python -m http.server $Puerto --bind $cable.IPAddress --directory $dir
    exit
}

$info = if (Test-Path $datos) { Get-Content $datos -Raw | ConvertFrom-Json } else { New-Object psobject -Property @{ usuario = ''; ip = ''; equipo = '' } }
if ($Usuario) {
    $info.usuario = $Usuario
    if ($Equipo) { $info | Add-Member -NotePropertyName equipo -NotePropertyValue $Equipo -Force }
    if ($IP) { $info.ip = $IP }
    $info | ConvertTo-Json | Set-Content $datos -Encoding ASCII
    if (-not ($Comando -or $Enviar -or $Traer -or $Quitar)) { Write-Host "Anotado: usuario de la PC = $Usuario"; exit }
}
if (-not $info.usuario) { Write-Host "No se el usuario de la PC: ACCESO-PC.ps1 -Usuario <u> (lo avisa la PC al prepararse)" -ForegroundColor Red; exit 1 }

function Abierto($ip) {
    $c = New-Object Net.Sockets.TcpClient
    try { $c.ConnectAsync($ip, 22).Wait(800) -and $c.Connected } catch { $false } finally { $c.Close() }
}

# la IP de la PC puede cambiar (el router la reparte; la del cable directo es de enlace local): se prueba la ultima,
# despues el nombre del equipo (lo resuelve la red local) y por ultimo los vecinos del cable directo
$ip = $info.ip
if (-not ($ip -and (Abierto $ip))) {
    $cand = @()
    if ($info.equipo) {
        try { $cand += [Net.Dns]::GetHostAddresses($info.equipo) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } |
                ForEach-Object { "$_" } | Where-Object { $_ -match '^(192\.168|169\.254|10\.147)\.' } } catch { }
    }
    $cable = Placa-Cable
    if ($cable) {
        $cand += Get-NetNeighbor -InterfaceIndex $cable.InterfaceIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue |
            Where-Object { $_.IPAddress -like '169.254.*' -and $_.IPAddress -ne $cable.IPAddress -and $_.State -ne 'Unreachable' } |
            ForEach-Object { $_.IPAddress }
    }
    $ip = $cand | Where-Object { Abierto $_ } | Select-Object -First 1
    if (-not $ip) { Write-Host "No encuentro la PC (prendida? en la red? preparada?)." -ForegroundColor Red; exit 1 }
    $info.ip = $ip
    $info | ConvertTo-Json | Set-Content $datos -Encoding ASCII
}

$opc = @('-i', $llave, '-o', 'IdentitiesOnly=yes', '-o', 'BatchMode=yes', '-o', 'StrictHostKeyChecking=accept-new', '-o', 'ConnectTimeout=5')
$destino = "$($info.usuario)@$ip"

if ($Quitar) {
    scp @opc "$PSScriptRoot\QUITAR-ACCESO-PC.ps1" "${destino}:QUITAR-ACCESO-PC.ps1"
    ssh @opc $destino 'Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File $HOME\QUITAR-ACCESO-PC.ps1" -WindowStyle Hidden'
    exit $LASTEXITCODE
}
if ($Enviar) { if (-not $A) { Write-Host "Falta -A <ruta en la PC>" -ForegroundColor Red; exit 1 }; scp -r @opc $Enviar "${destino}:$A"; exit $LASTEXITCODE }
if ($Traer)  { if (-not $A) { Write-Host "Falta -A <ruta en la notebook>" -ForegroundColor Red; exit 1 }; scp -r @opc "${destino}:$Traer" $A; exit $LASTEXITCODE }
if ($Comando) { ssh @opc $destino $Comando; exit $LASTEXITCODE }
ssh @opc $destino 'hostname; whoami'
