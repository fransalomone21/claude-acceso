# firmas-pe.ps1 - Enumera TODAS las firmas del array WIN_CERTIFICATE de un PE.
# Get-AuthenticodeSignature muestra solo la primaria; un binario UEFI moderno
# puede llevar dos (2011 y 2023) y el firmware elige por su cuenta.
# SOLO LECTURA. No requiere admin para los archivos de C:\Windows.

param(
    [string[]]$Rutas = @('C:\Windows\Boot\EFI\bootmgfw.efi',
                         'C:\Windows\Boot\EFI\bootmgr.efi')
)

Add-Type -AssemblyName System.Security   # necesario para SignedCms en PS 5.1

$base = Split-Path -Parent $MyInvocation.MyCommand.Path
$out  = Join-Path $base 'datos-crudos'
if (-not (Test-Path $out)) { New-Item -ItemType Directory -Path $out | Out-Null }
$log  = Join-Path $out '15-firmas-pe.txt'

function W($t) { $t | Out-String -Width 200 | Out-File $log -Append -Encoding utf8 }

"=== 15-firmas-pe ===" | Out-File $log -Encoding utf8
W "Capturado: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"

foreach ($ruta in $Rutas) {
    W ""
    W "################ $ruta ################"
    if (-not (Test-Path $ruta)) { W "NO EXISTE"; continue }

    [byte[]]$b = [IO.File]::ReadAllBytes($ruta)
    W "Tamano: $($b.Length) bytes"

    # --- Localizar la Certificate Table (data directory #4) ---
    $pe = [BitConverter]::ToInt32($b, 0x3C)
    if ([BitConverter]::ToUInt32($b, $pe) -ne 0x00004550) { W "No es un PE valido"; continue }
    $magic = [BitConverter]::ToUInt16($b, $pe + 24)
    $esPE32Plus = ($magic -eq 0x20B)
    W "Formato: $(if($esPE32Plus){'PE32+ (64 bits)'}else{'PE32'})"

    # Data directories: PE32+ -> pe+24+112 ; PE32 -> pe+24+96
    $ddBase  = $pe + 24 + $(if ($esPE32Plus) { 112 } else { 96 })
    $certDir = $ddBase + (4 * 8)          # indice 4 = Certificate Table
    $certOff = [BitConverter]::ToUInt32($b, $certDir)
    $certLen = [BitConverter]::ToUInt32($b, $certDir + 4)
    W "Certificate Table: offset=$certOff  size=$certLen bytes"

    if ($certOff -eq 0 -or $certLen -eq 0) { W "SIN FIRMA EMBEBIDA"; continue }

    # --- Recorrer el array de WIN_CERTIFICATE ---
    # WIN_CERTIFICATE: dwLength(4) wRevision(2) wCertificateType(2) bCertificate[]
    # Cada entrada alineada a 8 bytes.
    $p = [int]$certOff
    $fin = [int]($certOff + $certLen)
    $n = 0
    while ($p + 8 -le $fin -and $p + 8 -le $b.Length) {
        $len  = [BitConverter]::ToUInt32($b, $p)
        $rev  = [BitConverter]::ToUInt16($b, $p + 4)
        $tipo = [BitConverter]::ToUInt16($b, $p + 6)
        if ($len -lt 8 -or ($p + $len) -gt $b.Length) { W "  [entrada invalida en $p, len=$len]"; break }
        $n++
        W ""
        W "--- FIRMA #$n ---"
        W ("  longitud : {0} bytes" -f $len)
        W ("  revision : 0x{0:X4}" -f $rev)
        W ("  tipo     : 0x{0:X4} {1}" -f $tipo, $(if($tipo -eq 2){'(PKCS#7 SignedData)'}else{'(otro)'}))

        if ($tipo -eq 2) {
            $der = New-Object byte[] ($len - 8)
            [Array]::Copy($b, $p + 8, $der, 0, $len - 8)
            try {
                $cms = New-Object Security.Cryptography.Pkcs.SignedCms
                $cms.Decode($der)
                W ("  certificados en el PKCS#7: {0}" -f $cms.Certificates.Count)
                foreach ($si in $cms.SignerInfos) {
                    $c = $si.Certificate
                    W ("  FIRMANTE : {0}" -f $c.Subject)
                    W ("     emisor : {0}" -f $c.Issuer)
                    W ("     validez: {0:yyyy-MM-dd} -> {1:yyyy-MM-dd}" -f $c.NotBefore, $c.NotAfter)
                    W ("     huella : {0}" -f $c.Thumbprint)
                }
                W "  --- cadena incluida en el PKCS#7 ---"
                foreach ($c in $cms.Certificates) {
                    W ("     {0}   [hasta {1:yyyy-MM-dd}]" -f $c.Subject, $c.NotAfter)
                }
                # Firma ANIDADA: va como atributo no autenticado 1.3.6.1.4.1.311.2.4.1
                # dentro del PKCS#7, no como un segundo WIN_CERTIFICATE.
                foreach ($si in $cms.SignerInfos) {
                    $nested = $si.UnsignedAttributes | Where-Object { $_.Oid.Value -eq '1.3.6.1.4.1.311.2.4.1' }
                    if ($nested) {
                        W "  >>> TIENE FIRMA ANIDADA (OID 1.3.6.1.4.1.311.2.4.1)"
                        foreach ($nv in $nested.Values) {
                            try {
                                $ncms = New-Object Security.Cryptography.Pkcs.SignedCms
                                $ncms.Decode($nv.RawData)
                                foreach ($nsi in $ncms.SignerInfos) {
                                    W ("      FIRMANTE ANIDADO: {0}" -f $nsi.Certificate.Subject)
                                    W ("         emisor : {0}" -f $nsi.Certificate.Issuer)
                                    W ("         validez: {0:yyyy-MM-dd} -> {1:yyyy-MM-dd}" -f $nsi.Certificate.NotBefore, $nsi.Certificate.NotAfter)
                                    W ("         huella : {0}" -f $nsi.Certificate.Thumbprint)
                                }
                            } catch { W "      ERROR en firma anidada: $($_.Exception.Message)" }
                        }
                    } else {
                        W "  (sin firma anidada en este firmante)"
                    }
                }
            } catch {
                W "  ERROR al decodificar PKCS#7: $($_.Exception.Message)"
            }
        }
        # avanzar con alineacion a 8
        $p += [int]([Math]::Ceiling($len / 8.0) * 8)
    }
    W ""
    W "TOTAL DE FIRMAS EN $([IO.Path]::GetFileName($ruta)): $n"
    if ($n -gt 1) {
        W ">>> Tiene MAS DE UNA firma. El firmware elige cual validar, y"
        W ">>> Get-AuthenticodeSignature solo muestra la primera."
    }
}

Write-Host "LISTO -> $log" -ForegroundColor Green
Get-Content $log | Where-Object { $_ -ne '' }
