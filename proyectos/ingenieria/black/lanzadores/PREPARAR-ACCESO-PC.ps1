# Abrir la PC a la notebook por el cable, UNA sola vez (OpenSSH de Microsoft). Sesion (135), pedido de Fran 2026-10-30:
# "quiero enviar cosas y editar cosas de la pc sin tener que hacer nada en la pc".
#
# Corre EN LA PC, con la linea que imprime ACCESO-PC.ps1 -Preparar en la notebook. Pide administrador (UAC: Si).
# Deja: el servicio sshd (arranca solo con Windows), entrada SOLO con la llave de la notebook (sin contrasena) y SOLO
# desde el cable (169.254.0.0/16). Se deshace con QUITAR-ACCESO-PC.ps1 (que la notebook puede correr sola).

param([Parameter(Mandatory = $true)][string]$Origen, [string]$Usuario = $env:USERNAME)

# sha256 del OpenSSH-Win64-v10.0.0.0.msi (10.0.0.0p2) que sirve la notebook; si no coincide, no se instala nada
$SHA_MSI = 'DDEC9C53864280759CF9F74791CEFD387100E3946AA849A1C138A4ED1B96B7D9'

$admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $admin) {
    # el usuario se pasa ANTES de elevar: si la cuenta no es admin, la ventana elevada es de otra cuenta
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -NoExit -File `"$PSCommandPath`" -Origen $Origen -Usuario `"$Usuario`""
    exit
}

function Fallar($m) { Write-Host "NO QUEDO: $m" -ForegroundColor Red; exit 1 }

$tmp = "$env:TEMP\acceso-pc"
New-Item -ItemType Directory -Force $tmp | Out-Null
curl.exe -sf -o "$tmp\OpenSSH-Win64.msi" "$Origen/OpenSSH-Win64.msi"; if ($LASTEXITCODE) { Fallar "no pude bajar el instalador de $Origen" }
curl.exe -sf -o "$tmp\notebook.pub" "$Origen/notebook.pub"; if ($LASTEXITCODE) { Fallar "no pude bajar la llave de $Origen" }

$msi = "$tmp\OpenSSH-Win64.msi"
if ((Get-FileHash $msi -Algorithm SHA256).Hash -ne $SHA_MSI) { Fallar "el instalador no es el esperado (sha256 distinto)" }
$firma = Get-AuthenticodeSignature $msi
if ($firma.Status -ne 'Valid' -or $firma.SignerCertificate.Subject -notmatch 'O=Microsoft Corporation') { Fallar "la firma del instalador no es de Microsoft" }
$llave = (Get-Content "$tmp\notebook.pub" -Raw).Trim()
if ($llave -notmatch '^ssh-ed25519 ') { Fallar "la llave de la notebook no tiene forma de llave" }

Write-Host "Instalando OpenSSH..." -ForegroundColor Yellow
$p = Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /qn /norestart" -Wait -PassThru
if ($p.ExitCode -ne 0 -and $p.ExitCode -ne 3010) { Fallar "msiexec salio con $($p.ExitCode)" }
if (-not (Get-Service sshd -ErrorAction SilentlyContinue)) { Fallar "no aparecio el servicio sshd" }

# el primer arranque crea C:\ProgramData\ssh (config y llaves del equipo)
Start-Service sshd; Start-Sleep 2; Stop-Service sshd
$cfg = "$env:ProgramData\ssh\sshd_config"
if (-not (Test-Path $cfg)) { Fallar "no aparecio $cfg" }

# la llave: el archivo de administradores (lo que usa la config por defecto si la cuenta es admin) y el del usuario
function Escribir-Llave($ruta, $dueno) {
    New-Item -ItemType Directory -Force (Split-Path $ruta) | Out-Null
    [IO.File]::WriteAllText($ruta, "$llave`n", (New-Object Text.UTF8Encoding($false)))
    icacls $ruta /inheritance:r /grant "SYSTEM:F" /grant "*S-1-5-32-544:F" /grant "${dueno}:F" | Out-Null
}
Escribir-Llave "$env:ProgramData\ssh\administrators_authorized_keys" 'SYSTEM'
$perfil = (Get-CimInstance Win32_UserProfile | Where-Object { $_.LocalPath -match "\\$([regex]::Escape($Usuario))$" } | Select-Object -First 1).LocalPath
if ($perfil) { Escribir-Llave "$perfil\.ssh\authorized_keys" $Usuario }

# sin contrasena: solo llave (va arriba de todo; en sshd gana la primera aparicion)
$lineas = Get-Content $cfg | Where-Object { $_ -notmatch '^\s*#?\s*(PasswordAuthentication|PubkeyAuthentication|KbdInteractiveAuthentication)\b' }
$nuevo = @('PasswordAuthentication no', 'KbdInteractiveAuthentication no', 'PubkeyAuthentication yes') + $lineas
[IO.File]::WriteAllText($cfg, (($nuevo -join "`r`n") + "`r`n"), (New-Object Text.UTF8Encoding($false)))

# que la notebook llegue a PowerShell y no a cmd
New-Item -Path 'HKLM:\SOFTWARE\OpenSSH' -Force | Out-Null
New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -PropertyType String -Force `
    -Value "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" | Out-Null

# firewall: solo el cable. Se saca la regla abierta que pueda haber puesto el instalador
Get-NetFirewallRule -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'OpenSSH|sshd' -or $_.DisplayName -match 'OpenSSH|sshd' } |
    Remove-NetFirewallRule -ErrorAction SilentlyContinue
Remove-NetFirewallRule -Name 'SSH-por-cable' -ErrorAction SilentlyContinue
New-NetFirewallRule -Name 'SSH-por-cable' -DisplayName 'SSH por el cable (notebook)' -Direction Inbound -Protocol TCP `
    -LocalPort 22 -RemoteAddress '169.254.0.0/16' -Action Allow -Profile Any | Out-Null

Set-Service sshd -StartupType Automatic
Start-Service sshd
if ((Get-Service sshd).Status -ne 'Running') { Fallar "sshd no quedo andando" }

# avisarle a la notebook quien soy (queda en el registro de su servidor; ella guarda usuario y equipo)
$q = "usuario=$([uri]::EscapeDataString($Usuario))&equipo=$([uri]::EscapeDataString($env:COMPUTERNAME))"
curl.exe -s -o NUL "$Origen/hola?$q"

Write-Host ""
Write-Host "LISTO. La notebook ya puede entrar a esta PC por el cable. Podes cerrar esta ventana." -ForegroundColor Green
