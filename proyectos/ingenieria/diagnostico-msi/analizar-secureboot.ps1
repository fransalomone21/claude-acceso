# analizar-secureboot.ps1 - Responde UNA pregunta concreta:
#   que certificados confia el firmware (db), que revoca (dbx), y con que
#   esta firmado el bootmgfw.efi que el firmware realmente ejecuta.
#
# SOLO LECTURA. No modifica variables UEFI, ni el BCD, ni la particion EFI.
# Monta la particion EFI en S: temporalmente y la desmonta al terminar.
#
# REQUIERE PowerShell COMO ADMINISTRADOR.

$ErrorActionPreference = 'Continue'
$base = Split-Path -Parent $MyInvocation.MyCommand.Path
$out  = Join-Path $base 'datos-crudos'
if (-not (Test-Path $out)) { New-Item -ItemType Directory -Path $out | Out-Null }
$log  = Join-Path $out '14-secureboot-analisis.txt'

$esAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function W($t) { $t | Out-String -Width 200 | Out-File $log -Append -Encoding utf8 }

"=== 14-secureboot-analisis ===" | Out-File $log -Encoding utf8
W "Capturado: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
W "Admin: $esAdmin"

if (-not $esAdmin) {
    W "ABORTADO: este script necesita privilegios de administrador."
    Write-Host "ERROR: abri PowerShell como administrador y volve a correrlo." -ForegroundColor Red
    exit 1
}

# --- Parser de EFI_SIGNATURE_LIST --------------------------------------------
# Estructura (UEFI spec 32.4.1):
#   SignatureType       GUID   (16 bytes)
#   SignatureListSize   UINT32 (4)
#   SignatureHeaderSize UINT32 (4)
#   SignatureSize       UINT32 (4)
#   SignatureHeader     [SignatureHeaderSize]
#   Signatures          [n * SignatureSize], cada una:
#       SignatureOwner  GUID (16 bytes) + SignatureData
$GUID_X509   = 'a5c059a1-94e4-4aa7-87b5-ab155c2bf072'
$GUID_SHA256 = 'c1c41626-504c-4092-aca9-41f936934328'
$GUID_RSA2048= '3c5766e8-269c-4e34-aa14-ed776e85b3b6'

function Parse-SignatureList($bytesIn, $nombre) {
    # PS 5.1: un slice con .. devuelve Object[], y [Guid]::new() agarra la
    # sobrecarga de string en vez de la de byte[]. Hay que castear siempre.
    [byte[]]$bytes = $bytesIn
    W ""
    W "########## $nombre  ($($bytes.Length) bytes) ##########"
    $i = 0; $lista = 0; $totX509 = 0; $totHash = 0
    while ($i + 28 -le $bytes.Length) {
        $tipo = ([Guid]::new([byte[]]($bytes[$i..($i+15)]))).ToString()
        $listSize = [BitConverter]::ToUInt32($bytes, $i+16)
        $hdrSize  = [BitConverter]::ToUInt32($bytes, $i+20)
        $sigSize  = [BitConverter]::ToUInt32($bytes, $i+24)
        if ($listSize -lt 28 -or $sigSize -lt 16 -or ($i + $listSize) -gt $bytes.Length) {
            W "  [parseo cortado en offset $i - listSize=$listSize sigSize=$sigSize]"
            break
        }
        $lista++
        $nSigs = [Math]::Floor(($listSize - 28 - $hdrSize) / $sigSize)
        $etiqueta = switch ($tipo) {
            $GUID_X509    { 'X509 (certificado)' }
            $GUID_SHA256  { 'SHA256 (hash de binario)' }
            $GUID_RSA2048 { 'RSA2048' }
            default       { "otro ($tipo)" }
        }
        W ""
        W "--- Lista #$lista : $etiqueta -- $nSigs entrada(s) ---"

        $off = $i + 28 + $hdrSize
        for ($s = 0; $s -lt $nSigs; $s++) {
            $sigStart = $off + ($s * $sigSize)
            $datStart = $sigStart + 16
            $datLen   = $sigSize - 16
            if (($datStart + $datLen) -gt $bytes.Length) { break }
            $dat = $bytes[$datStart..($datStart + $datLen - 1)]

            if ($tipo -eq $GUID_X509) {
                $totX509++
                try {
                    $c = New-Object Security.Cryptography.X509Certificates.X509Certificate2 (,[byte[]]$dat)
                    W ("  [{0}] {1}" -f $totX509, $c.Subject)
                    W ("       emisor : {0}" -f $c.Issuer)
                    W ("       validez: {0:yyyy-MM-dd} -> {1:yyyy-MM-dd}" -f $c.NotBefore, $c.NotAfter)
                    W ("       huella : {0}" -f $c.Thumbprint)
                    if ($c.NotAfter -lt (Get-Date)) { W "       *** VENCIDO ***" }
                    $script:hallazgos[$nombre] += ,@{ Subject=$c.Subject; Thumb=$c.Thumbprint; NotAfter=$c.NotAfter }
                } catch {
                    W ("  [{0}] (no se pudo parsear: {1})" -f $totX509, $_.Exception.Message)
                }
            } else {
                $totHash++
                if ($totHash -le 5) {
                    W ("  hash: {0}" -f (($dat | ForEach-Object { $_.ToString('x2') }) -join ''))
                }
            }
        }
        if ($totHash -gt 5 -and $tipo -ne $GUID_X509) { W "  ... ($totHash hashes en total, se muestran los primeros 5)" }
        $i += $listSize
    }
    W ""
    W "RESUMEN $nombre : $lista lista(s), $totX509 certificado(s) X509, $totHash hash(es)."
}

$script:hallazgos = @{ PK=@(); KEK=@(); db=@(); dbx=@() }

foreach ($v in 'PK','KEK','db','dbx') {
    try {
        $u = Get-SecureBootUEFI -Name $v -ErrorAction Stop
        Parse-SignatureList ([byte[]]$u.Bytes) $v
    } catch {
        W ""
        W "########## $v ##########"
        W "ERROR: $($_.Exception.Message)"
    }
}

# --- Veredicto: la pregunta concreta que motivo este script ------------------
W ""
W "################ VEREDICTO ################"
W ""
$pca2011 = 'Microsoft Windows Production PCA 2011'
$uefi2011 = 'Microsoft Corporation UEFI CA 2011'
$ca2023  = '2023'

function Buscar($var, $patron) {
    $script:hallazgos[$var] | Where-Object { $_.Subject -like "*$patron*" }
}

W "1) La 'db' (lo que el firmware ACEPTA) contiene:"
if ($script:hallazgos['db'].Count -eq 0) { W "   (ningun certificado X509 parseado)" }
$script:hallazgos['db'] | ForEach-Object { W "   - $($_.Subject)   [hasta $($_.NotAfter.ToString('yyyy-MM-dd'))]" }

W ""
W "2) La 'dbx' (lo que el firmware RECHAZA) contiene estos certificados:"
if ($script:hallazgos['dbx'].Count -eq 0) { W "   (ninguno - la dbx es solo de hashes)" }
$script:hallazgos['dbx'] | ForEach-Object { W "   - $($_.Subject)   [hasta $($_.NotAfter.ToString('yyyy-MM-dd'))]" }

W ""
W "3) Preguntas concretas:"
$enDb2011  = Buscar 'db'  $pca2011
$enDbx2011 = Buscar 'dbx' $pca2011
$enDbUefi  = Buscar 'db'  $uefi2011
$enDb2023  = Buscar 'db'  $ca2023
W "   Esta el '$pca2011' en db ?  -> $(if($enDb2011){'SI'}else{'NO'})"
W "   Esta el '$pca2011' en dbx?  -> $(if($enDbx2011){'SI  <<< ESTO EXPLICARIA EL ERROR'}else{'NO'})"
W "   Esta el '$uefi2011' en db ? -> $(if($enDbUefi){'SI'}else{'NO'})"
W "   Hay algun certificado 2023 en db? -> $(if($enDb2023){'SI'}else{'NO'})"
W ""
W "   El bootmgfw.efi que corre esta firmado por: $pca2011"
W "   (huella del firmante: BAC13DF18B37E808208A39D3A54CCE975FAC8C1D, medido en la corrida anterior)"

# --- Firma real del bootmgfw.efi que ejecuta el firmware ---------------------
W ""
W "################ BOOTMGFW.EFI: copia de C: vs copia de la particion EFI ################"

$montado = $false
if (-not (Test-Path 'S:\')) {
    mountvol S: /S 2>&1 | Out-Null
    $montado = $true
}

$pares = @(
    @{ n='C:\Windows (fuente)'; p='C:\Windows\Boot\EFI\bootmgfw.efi' },
    @{ n='Particion EFI (la que corre)'; p='S:\EFI\Microsoft\Boot\bootmgfw.efi' }
)

foreach ($x in $pares) {
    W ""
    W "--- $($x.n) : $($x.p) ---"
    if (-not (Test-Path $x.p)) { W "NO EXISTE"; continue }
    $it = Get-Item $x.p
    W "Tamano  : $($it.Length) bytes"
    W "Fecha   : $($it.LastWriteTime)"
    W "Version : $($it.VersionInfo.FileVersion)"
    W "SHA256  : $((Get-FileHash $x.p -Algorithm SHA256).Hash)"
    $s = Get-AuthenticodeSignature $x.p
    W "Status  : $($s.Status)  -- $($s.StatusMessage)"
    if ($s.SignerCertificate) {
        W "Firmante: $($s.SignerCertificate.Subject)"
        W "Emisor  : $($s.SignerCertificate.Issuer)"
        W "Validez : $($s.SignerCertificate.NotBefore) -> $($s.SignerCertificate.NotAfter)"
        W "Huella  : $($s.SignerCertificate.Thumbprint)"
        $ch = New-Object Security.Cryptography.X509Certificates.X509Chain
        $ch.ChainPolicy.RevocationMode = 'NoCheck'
        [void]$ch.Build($s.SignerCertificate)
        W "Cadena  :"
        $ch.ChainElements | ForEach-Object {
            W ("   $($_.Certificate.Subject)  [hasta $($_.Certificate.NotAfter.ToString('yyyy-MM-dd'))]")
        }
    }
    # Todas las firmas del PE, no solo la primaria
    try {
        $sigs = Get-AuthenticodeSignature $x.p -ErrorAction Stop
        $nested = $sigs.SignerCertificate.Extensions | Where-Object { $_.Oid.Value -eq '1.3.6.1.4.1.311.2.4.1' }
        W "Firmas anidadas (OID 1.3.6.1.4.1.311.2.4.1): $(if($nested){'SI - hay mas de una firma'}else{'no detectadas por este metodo'})"
    } catch {}
}

if ($montado -and (Test-Path 'S:\')) { mountvol S: /D 2>&1 | Out-Null }

# --- Estado de la bateria, de paso ------------------------------------------
W ""
W "################ BATERIA (control de seguimiento) ################"
$b = Get-CimInstance -Namespace root\wmi -ClassName BatteryStatus
$w = Get-CimInstance Win32_Battery
$f = Get-CimInstance -Namespace root\wmi -ClassName BatteryFullChargedCapacity
W ("{0}  Volt={1}mV  Rem={2}mWh  Rate={3}  Pct={4}%  FCC={5}mWh  Charging={6}  AC={7}" -f `
    (Get-Date -Format 'HH:mm:ss'), $b.Voltage, $b.RemainingCapacity, $b.ChargeRate,
    $w.EstimatedChargeRemaining, $f.FullChargedCapacity, $b.Charging, $b.PowerOnline)

Write-Host ""
Write-Host "LISTO -> $log" -ForegroundColor Green
Write-Host "Nada fue modificado: solo lectura." -ForegroundColor Green
