# Pasar una carpeta de la NOTEBOOK a la PC por el cable directo (la PC no tiene Wi-Fi). Sesion (133b), autorizado por
# Fran: "si hacen falta permisos los hacemos ... que se pueda volver un medio util para otras cosas futuras".
#
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\SERVIR-A-LA-PC.ps1"
#       -> BLACK: arma el paquete de la PC (PAQUETE-PC.ps1 -SoloArmar) y sirve C:\Games\BLACK
#   ... -Carpeta "D:\lo que sea"
#       -> cualquier otra carpeta: hace su manifiesto y la sirve; en la PC: TRAER.ps1 -Origen <url> -Raiz <destino> -SoloCopiar
#
# Seguridad: SOLO de lectura, SOLO en la IP de la placa cableada (no en el Wi-Fi ni en ZeroTier) y SOLO mientras esta
# ventana este abierta (Ctrl+C la cierra). La primera vez Windows pregunta por Python en el firewall: Permitir.
# Lo que se baja se verifica por sha256 contra el manifiesto (TRAER.ps1), asi que un corte se nota y se retoma.

param([string]$Carpeta, [int]$Puerto = 8133)

$ErrorActionPreference = 'Stop'
if (-not $Carpeta) {
    & (Join-Path $PSScriptRoot 'PAQUETE-PC.ps1') -SoloArmar
    $Carpeta = 'C:\Games\BLACK'
} else {
    # manifiesto de una carpeta cualquiera, en <carpeta>\paquete-pc\manifiesto.txt (lo que TRAER.ps1 busca)
    $Carpeta = (Resolve-Path $Carpeta).Path.TrimEnd('\')
    New-Item -ItemType Directory -Force "$Carpeta\paquete-pc" | Out-Null
    $lineas = Get-ChildItem $Carpeta -Recurse -File | Where-Object { $_.Name -ne 'manifiesto.txt' } | ForEach-Object {
        "{0}`t{1}`t{2}" -f (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash, $_.Length, $_.FullName.Substring($Carpeta.Length + 1)
    }
    [IO.File]::WriteAllText("$Carpeta\paquete-pc\manifiesto.txt", (($lineas -join "`n") + "`n"), (New-Object Text.UTF8Encoding($false)))
    Copy-Item "$PSScriptRoot\TRAER.ps1" "$Carpeta\paquete-pc\" -Force
}

# la IP de la placa cableada (no Wi-Fi, no ZeroTier, no virtuales)
$cable = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue | Where-Object {
    $_.InterfaceAlias -notmatch 'Wi-?Fi|ZeroTier|Bluetooth|Loopback|vEthernet|\*' -and $_.IPAddress -notlike '127.*'
} | Select-Object -First 1
if (-not $cable) {
    Write-Host "No veo la placa del cable con IP. Enchufa el cable a la PC (las dos prendidas), espera 1 minuto y volve a correr esto." -ForegroundColor Red
    exit 1
}
$o = "http://$($cable.IPAddress):$Puerto"
$traer = if ($Carpeta -eq 'C:\Games\BLACK') { "-Origen `$o" } else { "-Origen `$o -Raiz `"C:\Recibido`" -SoloCopiar" }
Write-Host ""
Write-Host "Sirviendo $Carpeta por el cable ($($cable.InterfaceAlias), $($cable.IPAddress))." -ForegroundColor Green
Write-Host "PEGA ESTO EN LA PC (PowerShell):" -ForegroundColor Yellow
Write-Host "    `$o='$o'; curl.exe -sf -o `"`$env:TEMP\TRAER.ps1`" `"`$o/paquete-pc/TRAER.ps1`"; powershell -ExecutionPolicy Bypass -File `"`$env:TEMP\TRAER.ps1`" $traer" -ForegroundColor White
Write-Host "Cuando la PC diga LISTO, cerra esta ventana (Ctrl+C)." -ForegroundColor Green
python -m http.server $Puerto --bind $cable.IPAddress --directory $Carpeta
