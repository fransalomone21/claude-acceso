# Elimina la tarea del undervolt de GPU creada el 25/07/2026
Unregister-ScheduledTask -TaskName "AB-undervolt-perfil1" -Confirm:$false
Write-Host "Tarea eliminada. El undervolt ya no se aplicara solo al arrancar." -ForegroundColor Green
Read-Host "Enter para cerrar"
