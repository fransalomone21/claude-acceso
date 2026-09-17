# =============================================================
#  Aplica la configuracion optimizada de ThrottleStop
#  MSI Sword 15 A12VF / i7-12650H   -   25/07/2026
#
#  Valores derivados de la prueba termica real del equipo:
#    39.8 W sostenidos -> 80.0 C   (pendiente ~0.82 C/W)
#
#    PL1 = 45 W   -> ~84-87 C sostenido
#    PL2 = 56 W   -> ~90-92 C en picos cortos
#    Turbo Time Limit = 16 s
#    Ratios de turbo restaurados a fabrica (47/47/44/44 P, 35 E)
#
#  REQUIERE ELEVACION.
# =============================================================

$ErrorActionPreference = 'Continue'
$dir  = "C:\Users\frans\OneDrive\Desktop\Programas\ThrottleStop_9.7"
$ini  = Join-Path $dir "ThrottleStop.ini"
$exe  = Join-Path $dir "ThrottleStop.exe"
$bk   = Join-Path $dir "ThrottleStop.ini.backup-2026-07-25"

function Say($m, $c = 'White') { Write-Host $m -ForegroundColor $c }

Say "=== Optimizacion ThrottleStop ===" Cyan
Say ""

# --- 0) Respaldo (por si se corrio suelto) ---
if (-not (Test-Path $bk)) { Copy-Item $ini $bk -Force }
Say "Respaldo en: $bk" DarkGray

# --- 1) Cerrar ThrottleStop ---
Say "[1/5] Cerrando ThrottleStop..." Yellow
$p = Get-Process ThrottleStop -ErrorAction SilentlyContinue
if ($p) {
    $p.CloseMainWindow() | Out-Null
    Start-Sleep -Seconds 3
    $p = Get-Process ThrottleStop -ErrorAction SilentlyContinue
    if ($p) { Stop-Process -Id $p.Id -Force; Start-Sleep -Seconds 2 }
}
if (Get-Process ThrottleStop -ErrorAction SilentlyContinue) {
    Say "      ERROR: no se pudo cerrar. Abortando." Red
    Read-Host "Enter para salir"; exit 1
}
Say "      cerrado." Green

# --- 2) Editar el .ini ---
Say "[2/5] Escribiendo nuevos limites en ThrottleStop.ini..." Yellow

# PL1 = 45 W  -> 45*8 = 360 = 0x168 | bit15 enable = 0x8168
#                tau 16 s -> Y=14 -> byte 0x1C
# PL2 = 56 W  -> 56*8 = 448 = 0x1C0 | bit15 enable = 0x81C0
#                ventana 2.44 ms -> byte 0x42 (sin cambios)
$edits = [ordered]@{
    'PowerLimitEAX0' = '0x001C8168'   # PL1 45 W, tau 16 s
    'PowerLimitEDX0' = '0x004281C0'   # PL2 56 W
    'OneAD_EAX0'     = '0x2C2C2F2F'   # P-cores 1-4: 47 47 44 44
    'OneAD_EDX0'     = '0x29292929'   # P-cores 5-8: 41 41 41 41
    'Six50_EAX0'     = '0x23232323'   # E-cores: 35
    'Six50_EDX0'     = '0x23232323'   # E-cores: 35
}

$lines = Get-Content $ini
$applied = @()
for ($i = 0; $i -lt $lines.Count; $i++) {
    foreach ($k in $edits.Keys) {
        if ($lines[$i] -match "^$k=") {
            $old = $lines[$i]
            $lines[$i] = "$k=$($edits[$k])"
            $applied += "      $old  ->  $($edits[$k])"
        }
    }
}
Set-Content -Path $ini -Value $lines -Encoding ASCII
$applied | ForEach-Object { Say $_ DarkGray }
Say "      .ini actualizado." Green

# --- 3) Arreglar la tarea programada (privilegios maximos) ---
Say "[3/5] Corrigiendo la tarea programada 'throttle'..." Yellow
try {
    $task = Get-ScheduledTask -TaskName "throttle" -ErrorAction Stop
    Say ("      RunLevel actual: " + $task.Principal.RunLevel) DarkGray

    $me  = "$env:USERDOMAIN\$env:USERNAME"
    $pr  = New-ScheduledTaskPrincipal -UserId $me -LogonType Interactive -RunLevel Highest
    $st  = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
             -ExecutionTimeLimit ([TimeSpan]::Zero) -MultipleInstances IgnoreNew -StartWhenAvailable

    Set-ScheduledTask -TaskName "throttle" -Principal $pr -Settings $st -ErrorAction Stop | Out-Null

    $task = Get-ScheduledTask -TaskName "throttle"
    Say ("      RunLevel nuevo:  " + $task.Principal.RunLevel) Green
} catch {
    Say ("      ERROR en la tarea: " + $_.Exception.Message) Red
}

# --- 4) Relanzar ThrottleStop ---
Say "[4/5] Iniciando ThrottleStop..." Yellow
Start-Process -FilePath $exe -WorkingDirectory $dir
Start-Sleep -Seconds 5
if (Get-Process ThrottleStop -ErrorAction SilentlyContinue) {
    Say "      corriendo." Green
} else {
    Say "      no arranco. Abrilo a mano." Red
}

# --- 5) Verificacion: releer el .ini ---
Say "[5/5] Verificacion (valores en disco):" Yellow
Select-String -Path $ini -Pattern "^(PowerLimitEAX0|PowerLimitEDX0|OneAD_EAX0|OneAD_EDX0|Six50_EAX0|Six50_EDX0|CheckSum)=" |
    ForEach-Object { Say ("      " + $_.Line) DarkGray }

Say ""
Say "LISTO." Green
Say ""
Say "AHORA, EN LA VENTANA DE THROTTLESTOP (2 clics):" Cyan
Say "  1. Marca la casilla C1E   (esta desmarcada; baja mucho el consumo en reposo)" White
Say "  2. Clic en Save           (SaveOnExit=0, si no guardas se pierde)" White
Say ""
Say "Comproba en la ventana TPL que diga PL1=45  PL2=56  Time=16." White
Say "Si ves 40/42/32, el .ini fue rechazado -> avisame y restauro el respaldo." Yellow
Say ""
Read-Host "Enter para cerrar"
