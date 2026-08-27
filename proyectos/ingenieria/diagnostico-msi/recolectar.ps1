# recolectar.ps1 - Vuelca el estado REAL de la maquina a archivos crudos.
# No interpreta nada: guarda la salida verbatim de cada comando.
# Correr desde PowerShell. Con admin captura mas (bcdedit, particion EFI).
# Reversible: solo lee y escribe archivos en .\datos-crudos\

$ErrorActionPreference = 'Continue'
$base = Split-Path -Parent $MyInvocation.MyCommand.Path
$out  = Join-Path $base 'datos-crudos'
if (-not (Test-Path $out)) { New-Item -ItemType Directory -Path $out | Out-Null }

$esAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function Volcar($nombre, $bloque) {
    $ruta = Join-Path $out "$nombre.txt"
    "=== $nombre ===" | Out-File $ruta -Encoding utf8
    "Capturado: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" | Out-File $ruta -Append -Encoding utf8
    "Admin: $esAdmin" | Out-File $ruta -Append -Encoding utf8
    "" | Out-File $ruta -Append -Encoding utf8
    try { & $bloque 2>&1 | Out-String -Width 200 | Out-File $ruta -Append -Encoding utf8 }
    catch { "ERROR: $($_.Exception.Message)" | Out-File $ruta -Append -Encoding utf8 }
    Write-Host "  -> $nombre.txt"
}

Write-Host "Recolectando en $out"
Write-Host "Sesion con privilegios de administrador: $esAdmin"

# --- Identidad del equipo y del firmware -------------------------------------
Volcar '01-bios-y-modelo' {
    Get-CimInstance Win32_BIOS | Format-List *
    Get-CimInstance Win32_BaseBoard | Format-List *
    Get-CimInstance Win32_ComputerSystem | Format-List *
    Get-CimInstance Win32_ComputerSystemProduct | Format-List *
}

Volcar '02-sistema-operativo' {
    Get-CimInstance Win32_OperatingSystem | Format-List *
    "--- registro CurrentVersion ---"
    Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' |
        Select-Object ProductName, DisplayVersion, CurrentBuild, UBR, EditionID,
                      InstallationType, BuildLabEx | Format-List
}

Volcar '03-systeminfo' { systeminfo }

# --- Secure Boot -------------------------------------------------------------
Volcar '04-secureboot-estado' {
    "--- HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot y subclaves ---"
    $k = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot'
    Get-ItemProperty $k -EA SilentlyContinue | Select-Object * -Exclude PS* | Format-List
    Get-ChildItem $k -Recurse -EA SilentlyContinue | ForEach-Object {
        "### $($_.Name)"
        Get-ItemProperty $_.PSPath | Select-Object * -Exclude PS* | Format-List
    }
    "--- Confirm-SecureBootUEFI (requiere admin) ---"
    try { Confirm-SecureBootUEFI -EA Stop } catch { "ERROR: $($_.Exception.Message)" }
    "--- Get-SecureBootPolicy (requiere admin) ---"
    try { Get-SecureBootPolicy -EA Stop | Format-List } catch { "ERROR: $($_.Exception.Message)" }
}

Volcar '05-secureboot-variables-uefi' {
    "--- Variables UEFI de Secure Boot (requiere admin) ---"
    foreach ($v in 'PK','KEK','db','dbx','SetupMode','SecureBoot') {
        "### $v"
        try {
            $b = Get-SecureBootUEFI -Name $v -EA Stop
            "Bytes: $($b.Bytes.Length)"
            "Atributos: $($b.Attributes)"
        } catch { "ERROR: $($_.Exception.Message)" }
    }
}

Volcar '06-boot-manager-firma' {
    foreach ($p in 'C:\Windows\Boot\EFI\bootmgfw.efi',
                   'C:\Windows\Boot\EFI\bootmgr.efi',
                   'C:\Windows\System32\winload.efi') {
        "### $p"
        if (Test-Path $p) {
            $i = Get-Item $p
            "Tamano   : $($i.Length) bytes"
            "Modificado: $($i.LastWriteTime)"
            "Version  : $($i.VersionInfo.ProductVersion)"
            $s = Get-AuthenticodeSignature $p
            "Status   : $($s.Status)"
            "StatusMsg: $($s.StatusMessage)"
            "Signer   : $($s.SignerCertificate.Subject)"
            "Emisor   : $($s.SignerCertificate.Issuer)"
            "NotBefore: $($s.SignerCertificate.NotBefore)"
            "NotAfter : $($s.SignerCertificate.NotAfter)"
            "Huella   : $($s.SignerCertificate.Thumbprint)"
            "--- cadena completa ---"
            $ch = New-Object Security.Cryptography.X509Certificates.X509Chain
            $ch.ChainPolicy.RevocationMode = 'NoCheck'
            [void]$ch.Build($s.SignerCertificate)
            $ch.ChainElements | ForEach-Object {
                "  $($_.Certificate.Subject)  [hasta $($_.Certificate.NotAfter)]"
            }
        } else { "NO EXISTE" }
    }
}

Volcar '07-bcdedit' {
    "--- bcdedit /enum all (requiere admin) ---"
    bcdedit /enum all
    "--- bcdedit /enum firmware ---"
    bcdedit /enum firmware
}

Volcar '08-particion-efi' {
    "--- Particiones del sistema ---"
    Get-Partition -EA SilentlyContinue | Format-Table -AutoSize DiskNumber,PartitionNumber,DriveLetter,Size,Type,IsSystem,IsBoot,GptType
    "--- Contenido de la particion EFI (requiere admin) ---"
    if ($esAdmin) {
        mountvol S: /S 2>&1
        if (Test-Path 'S:\') {
            Get-ChildItem 'S:\' -Recurse -EA SilentlyContinue |
                Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize
            mountvol S: /D 2>&1
        } else { "No se pudo montar S:" }
    } else { "OMITIDO: requiere admin" }
}

# --- Bateria -----------------------------------------------------------------
Volcar '09-bateria-wmi' {
    "--- Win32_Battery ---"
    Get-CimInstance Win32_Battery | Format-List *
    "--- root\wmi BatteryStatus (_BST en vivo) ---"
    Get-CimInstance -Namespace root\wmi -ClassName BatteryStatus | Format-List *
    "--- root\wmi BatteryStaticData (_BIF) ---"
    Get-CimInstance -Namespace root\wmi -ClassName BatteryStaticData | Format-List *
    "--- root\wmi BatteryFullChargedCapacity ---"
    Get-CimInstance -Namespace root\wmi -ClassName BatteryFullChargedCapacity | Format-List *
    "--- root\wmi BatteryCycleCount ---"
    try { Get-CimInstance -Namespace root\wmi -ClassName BatteryCycleCount -EA Stop | Format-List * }
    catch { "ERROR: $($_.Exception.Message)" }
}

Volcar '10-bateria-driver' {
    Get-PnpDevice -Class Battery | Format-Table -AutoSize FriendlyName,Status,Problem,InstanceId
    foreach ($id in (Get-PnpDevice -Class Battery).InstanceId) {
        "### $id"
        Get-PnpDeviceProperty -InstanceId $id |
            Select-Object KeyName, Type, Data | Format-Table -AutoSize -Wrap
    }
    "--- INF del driver de bateria en uso ---"
    $inf = 'C:\Windows\INF\oem96.inf'
    if (Test-Path $inf) { "### $inf"; Get-Content $inf }
}

# --- Energia -----------------------------------------------------------------
Volcar '11-powercfg' {
    "--- powercfg /a (estados de suspension disponibles) ---"
    powercfg /a
    "--- powercfg /devicequery wake_armed ---"
    powercfg /devicequery wake_armed
    "--- powercfg /lastwake ---"
    powercfg /lastwake
    "--- powercfg /getactivescheme ---"
    powercfg /getactivescheme
    "--- Inicio rapido (HiberbootEnabled) ---"
    Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power' -EA SilentlyContinue |
        Select-Object HiberbootEnabled, HibernateEnabled | Format-List
    "--- SUB_SLEEP del esquema activo ---"
    powercfg /query SCHEME_CURRENT SUB_SLEEP
}

Volcar '12-eventos-energia' {
    "--- Eventos Kernel-Power / Kernel-Boot, ultimos 30 dias ---"
    Get-WinEvent -FilterHashtable @{LogName='System'; StartTime=(Get-Date).AddDays(-30)} -EA SilentlyContinue |
        Where-Object { $_.ProviderName -match 'Kernel-Power|Kernel-Boot|Kernel-General|BatteryClass|CmBatt|ACPI' } |
        Select-Object TimeCreated, Id, ProviderName, LevelDisplayName,
                      @{n='Mensaje';e={($_.Message -split "`r?`n")[0]}} |
        Format-Table -AutoSize -Wrap
}

Volcar '13-msi-software' {
    "--- Servicios MSI ---"
    Get-Service | Where-Object { $_.Name -match 'MSI|NBFoundation' } |
        Format-Table -AutoSize Name, DisplayName, Status, StartType
    "--- Apps MSI (Store) ---"
    Get-AppxPackage | Where-Object { $_.Name -match 'MICRO-STAR|MSI' } |
        Select-Object Name, Version, InstallLocation | Format-List
    "--- Registro MSI\MSI Center\NB y MSI\NB ---"
    foreach ($k in 'HKLM:\SOFTWARE\WOW6432Node\MSI\MSI Center\NB',
                   'HKLM:\SOFTWARE\WOW6432Node\MSI\NB',
                   'HKLM:\SOFTWARE\WOW6432Node\MSI\MSI NBFoundation Service') {
        if (Test-Path $k) { "### $k"; Get-ItemProperty $k | Select-Object * -Exclude PS* | Format-List }
    }
}

# --- Informe oficial de bateria de Windows ------------------------------------
Write-Host "  -> batteryreport.html (60 dias)"
powercfg /batteryreport /output (Join-Path $out 'batteryreport.html') /duration 60 | Out-Null

Write-Host ""
Write-Host "LISTO. Archivos en: $out"
if (-not $esAdmin) {
    Write-Host "AVISO: sin admin quedaron incompletos 04, 05, 07 y 08."
    Write-Host "Volve a correrlo desde PowerShell como administrador para completarlos."
}
