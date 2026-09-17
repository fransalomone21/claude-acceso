# =============================================================
#  Hace persistente el undervolt de la RTX 4060
#  MSI Sword 15 A12VF - 25/07/2026
#
#  PROBLEMA: la seccion [Startup] de Afterburner contiene una
#  curva DISTINTA a la del [Profile1]. Al arrancar aplicaba esa
#  version vieja, y la GPU quedaba a 2505 MHz en vez de 2400.
#  Verificado bajo carga real.
#
#  SOLUCION: tarea al inicio de sesion que ejecuta
#  MSIAfterburner.exe -profile1  (45 s de retardo, para que
#  Afterburner ya este levantado).
#
#  REQUIERE ELEVACION.
# =============================================================

$ErrorActionPreference = 'Continue'
$ab   = "C:\Program Files (x86)\MSI Afterburner\MSIAfterburner.exe"
$wd   = "C:\Program Files (x86)\MSI Afterburner"
$name = "AB-undervolt-perfil1"
$rev  = "C:\Users\frans\OneDrive\Desktop\Programas\REVERTIR-tarea-undervolt.ps1"

function Say($m,$c='White'){ Write-Host $m -ForegroundColor $c }

Say "=== Persistencia del undervolt de GPU ===" Cyan
Say ""

if (-not (Test-Path $ab)) { Say "ERROR: no existe $ab" Red; Read-Host "Enter"; exit 1 }

Say "[1/2] Registrando la tarea al inicio de sesion..." Yellow
$ac = New-ScheduledTaskAction -Execute $ab -Argument "-profile1" -WorkingDirectory $wd
$tr = New-ScheduledTaskTrigger -AtLogOn
$tr.Delay = "PT45S"
$pr = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest
$st = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
        -ExecutionTimeLimit ([TimeSpan]::Zero) -StartWhenAvailable -MultipleInstances IgnoreNew

try {
    Register-ScheduledTask -TaskName $name -Action $ac -Trigger $tr -Principal $pr -Settings $st -Force `
      -Description "Aplica el perfil 1 de MSI Afterburner (undervolt RTX 4060: curva plana 2400 MHz @ 925 mV) 45 s despues del inicio de sesion. Necesario porque la seccion [Startup] del perfil de Afterburner contiene una curva distinta y desactualizada." -ErrorAction Stop | Out-Null
    Say "      creada." Green
} catch { Say ("      ERROR: " + $_.Exception.Message) Red; Read-Host "Enter"; exit 1 }

Say "[2/2] Verificando..." Yellow
$t = Get-ScheduledTask -TaskName $name -ErrorAction SilentlyContinue
if ($t) {
    Say ("      Estado   : " + $t.State) Green
    Say ("      Ejecuta  : " + $t.Actions[0].Execute + " " + $t.Actions[0].Arguments) DarkGray
    Say ("      Retardo  : " + $t.Triggers[0].Delay) DarkGray
    Say ("      RunLevel : " + $t.Principal.RunLevel) DarkGray
} else { Say "      no se encontro" Red }

# script de reversion
@(
  '# Elimina la tarea del undervolt de GPU creada el 25/07/2026'
  ('Unregister-ScheduledTask -TaskName "{0}" -Confirm:$false' -f $name)
  'Write-Host "Tarea eliminada. El undervolt ya no se aplicara solo al arrancar." -ForegroundColor Green'
  'Read-Host "Enter para cerrar"'
) | Set-Content -Path $rev -Encoding UTF8

Say ""
Say "LISTO." Green
Say "Reversion: $rev" DarkGray
Say ""
Say "Para comprobar que funciona: reinicia, espera 1 minuto, y bajo carga" White
Say "de GPU el reloj tiene que quedarse en 2400 MHz (no 2505)." White
Say ""
Read-Host "Enter para cerrar"
