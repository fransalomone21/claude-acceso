# =============================================================
#  Saca ThrottleStop de OneDrive + limpieza de arranque HKLM
#  MSI Sword 15 A12VF - 25/07/2026
#
#  QUE HACE:
#   1. Copia ThrottleStop de OneDrive a C:\ThrottleStop
#   2. Corrige LogFileDirectory dentro del .ini
#   3. Repunta la tarea programada 'throttle' a la ruta nueva
#   4. Repunta el acceso directo del escritorio
#   5. Arranca ThrottleStop desde la ubicacion nueva y verifica
#   6. Renombra la carpeta vieja a .old (NO la borra)
#   7. Quita Autodesk Access del arranque (HKLM)
#   8. Deja un script de reversion
#
#  NO toca: Memory Integrity, servicios de Intel, ni la config
#  de potencia ya validada (PL 45/56 siguen en el .ini).
#
#  REQUIERE ELEVACION.
# =============================================================

$ErrorActionPreference = 'Continue'
$src = "C:\Users\frans\OneDrive\Desktop\Programas\ThrottleStop_9.7"
$dst = "C:\ThrottleStop"
$lnk = "C:\Users\frans\OneDrive\Desktop\ThrottleStop - Acceso directo.lnk"
$rev = "C:\Users\frans\OneDrive\Desktop\Programas\REVERTIR-mudanza-2026-07-25.ps1"

function Say($m,$c='White'){ Write-Host $m -ForegroundColor $c }
$fallos = 0

Say "=== Mudanza de ThrottleStop + limpieza ===" Cyan
Say ""

# ---------- Comprobaciones previas ----------
if (-not (Test-Path "$src\ThrottleStop.exe")) { Say "ERROR: no existe $src\ThrottleStop.exe" Red; Read-Host "Enter"; exit 1 }
if (Test-Path "$dst\ThrottleStop.exe")        { Say "AVISO: $dst ya existe, se sobrescribe" Yellow }

# ---------- 1. Cerrar ThrottleStop ----------
Say "[1/8] Cerrando ThrottleStop..." Yellow
$p = Get-Process ThrottleStop -ErrorAction SilentlyContinue
if ($p) { $p.CloseMainWindow() | Out-Null; Start-Sleep 3
          $p = Get-Process ThrottleStop -ErrorAction SilentlyContinue
          if ($p) { Stop-Process -Id $p.Id -Force; Start-Sleep 2 } }
if (Get-Process ThrottleStop -ErrorAction SilentlyContinue) {
    Say "      ERROR: sigue abierto. Abortando." Red; Read-Host "Enter"; exit 1 }
Say "      cerrado." Green

# ---------- 2. Copiar ----------
Say "[2/8] Copiando a $dst ..." Yellow
New-Item -ItemType Directory -Path $dst -Force | Out-Null
Copy-Item -Path "$src\*" -Destination $dst -Recurse -Force
$nSrc = (Get-ChildItem $src -Recurse -File).Count
$nDst = (Get-ChildItem $dst -Recurse -File).Count
Say "      archivos: origen $nSrc  ->  destino $nDst" DarkGray
if ($nDst -lt $nSrc) { Say "      ERROR: faltan archivos. Abortando." Red; Read-Host "Enter"; exit 1 }

# comparar hash del exe y del ini
foreach ($f in @('ThrottleStop.exe','ThrottleStop.ini')) {
    $h1 = (Get-FileHash "$src\$f").Hash; $h2 = (Get-FileHash "$dst\$f").Hash
    if ($h1 -eq $h2) { Say "      OK  $f" Green } else { Say "      FALLO hash $f" Red; $fallos++ }
}

# ---------- 3. Corregir LogFileDirectory ----------
Say "[3/8] Corrigiendo rutas internas del .ini..." Yellow
$ini = "$dst\ThrottleStop.ini"
$txt = Get-Content $ini
$txt = $txt -replace [regex]::Escape($src), $dst
Set-Content -Path $ini -Value $txt -Encoding ASCII
Select-String -Path $ini -Pattern "^LogFileDirectory=" | ForEach-Object { Say ("      " + $_.Line) DarkGray }
Say "      PL preservados:" DarkGray
Select-String -Path $ini -Pattern "^(PowerLimitEAX0|PowerLimitEDX0)=" | ForEach-Object { Say ("      " + $_.Line) DarkGray }

# ---------- 4. Repuntar la tarea programada ----------
Say "[4/8] Repuntando la tarea 'throttle'..." Yellow
try {
    $t  = Get-ScheduledTask -TaskName "throttle" -ErrorAction Stop
    Say ("      antes: " + $t.Actions[0].Execute) DarkGray
    $ac = New-ScheduledTaskAction -Execute "$dst\ThrottleStop.exe" -WorkingDirectory $dst
    $pr = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest
    $st = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
            -ExecutionTimeLimit ([TimeSpan]::Zero) -MultipleInstances IgnoreNew -StartWhenAvailable
    Set-ScheduledTask -TaskName "throttle" -Action $ac -Principal $pr -Settings $st -ErrorAction Stop | Out-Null
    $t = Get-ScheduledTask -TaskName "throttle"
    Say ("      ahora: " + $t.Actions[0].Execute) Green
    Say ("      RunLevel: " + $t.Principal.RunLevel) Green
} catch { Say ("      ERROR: " + $_.Exception.Message) Red; $fallos++ }

# ---------- 5. Acceso directo ----------
Say "[5/8] Repuntando el acceso directo del escritorio..." Yellow
if (Test-Path $lnk) {
    try {
        $ws = New-Object -ComObject WScript.Shell
        $sc = $ws.CreateShortcut($lnk)
        $sc.TargetPath = "$dst\ThrottleStop.exe"
        $sc.WorkingDirectory = $dst
        $sc.Save()
        Say "      OK -> $dst\ThrottleStop.exe" Green
    } catch { Say ("      no se pudo: " + $_.Exception.Message) Yellow }
} else { Say "      no existe, se omite" DarkGray }

# ---------- 6. Arrancar y verificar ----------
Say "[6/8] Arrancando ThrottleStop desde la ubicacion nueva..." Yellow
Start-Process -FilePath "$dst\ThrottleStop.exe" -WorkingDirectory $dst
Start-Sleep 6
$p = Get-Process ThrottleStop -ErrorAction SilentlyContinue
if ($p) {
    $ruta = try { $p.Path } catch { "(no legible)" }
    Say ("      corriendo desde: " + $ruta) Green
    if ($ruta -like "$dst*") { Say "      VERIFICADO: ya no depende de OneDrive" Green }
} else { Say "      ERROR: no arranco" Red; $fallos++ }

# ---------- 7. Renombrar la carpeta vieja (no borrar) ----------
Say "[7/8] Renombrando la carpeta vieja..." Yellow
if ($fallos -eq 0) {
    try {
        Rename-Item -Path $src -NewName "ThrottleStop_9.7.old" -ErrorAction Stop
        Say "      -> ThrottleStop_9.7.old  (podes borrarla cuando quieras)" Green
    } catch { Say ("      no se pudo renombrar: " + $_.Exception.Message) Yellow }
} else { Say "      OMITIDO: hubo fallos, se conserva el original intacto" Yellow }

# ---------- 8. Autodesk Access fuera del arranque ----------
Say "[8/8] Quitando Autodesk Access del arranque..." Yellow
$hklm = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$quitar = @('Autodesk Access Service','Autodesk Access')
$restore = @("# Revierte la mudanza y la limpieza del 25/07/2026","")
$props = Get-ItemProperty $hklm
foreach ($n in $quitar) {
    if ($props.PSObject.Properties.Name -contains $n) {
        $v = $props.$n
        $restore += ('Set-ItemProperty "{0}" -Name "{1}" -Value ''{2}''' -f $hklm,$n,$v)
        Remove-ItemProperty -Path $hklm -Name $n -ErrorAction SilentlyContinue
        Say "      quitado: $n" Green
    }
}
Say "      (el servicio de licencias de AutoCAD NO se toco)" DarkGray

# ---------- Script de reversion ----------
$restore += ''
$restore += '$ac = New-ScheduledTaskAction -Execute "{0}\ThrottleStop.exe" -WorkingDirectory "{0}"' -f $src
$restore += '$pr = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest'
$restore += 'if (Test-Path "{0}.old") {{ Rename-Item "{0}.old" "ThrottleStop_9.7" }}' -f $src
$restore += 'Set-ScheduledTask -TaskName "throttle" -Action $ac -Principal $pr | Out-Null'
$restore += 'Write-Host "Revertido. La carpeta C:\ThrottleStop sigue ahi, borrala a mano si queres." -ForegroundColor Green'
$restore += 'Read-Host "Enter para cerrar"'
Set-Content -Path $rev -Value $restore -Encoding UTF8

Say ""
if ($fallos -eq 0) { Say "LISTO - sin fallos." Green } else { Say "TERMINADO CON $fallos FALLO(S) - revisa arriba." Red }
Say "Reversion: $rev" DarkGray
Say ""
Read-Host "Enter para cerrar"
