# Revierte los cambios de energia aplicados el 25/07/2026
# Ejecutar con: click derecho -> "Ejecutar con PowerShell"
# (No hace falta admin)

Write-Host "Restaurando valores originales del plan 'Alto rendimiento'..." -ForegroundColor Yellow

# Estado minimo del procesador: AC 100% / DC 5%
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 5

# Estado maximo del procesador: AC 95% / DC 90%
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 95
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 90

# Modo de mejora de rendimiento: AC 2 (Agresiva) / DC 4 (Eficiencia agresiva)
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 2
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PERFBOOSTMODE 4

powercfg /setactive SCHEME_CURRENT

# GameDVR de vuelta en 1
Set-ItemProperty "HKCU:\System\GameConfigStore" -Name GameDVR_Enabled -Value 1 -ErrorAction SilentlyContinue

Write-Host "Listo. Valores originales restaurados." -ForegroundColor Green
Read-Host "Enter para cerrar"
