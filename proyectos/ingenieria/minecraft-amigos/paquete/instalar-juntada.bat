@echo off
rem Doble clic. Opcional: instalar-juntada.bat alto | medio | bajo  (por defecto lo elige solo)
set "P=%~1"
if "%P%"=="" set "P=auto"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar-juntada.ps1" -Preset %P%
pause
