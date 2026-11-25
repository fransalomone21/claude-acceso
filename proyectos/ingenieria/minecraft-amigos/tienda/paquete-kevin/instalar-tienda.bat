@echo off
rem Doble clic: instala Prism (si falta) y la instancia "Tienda 1.21.1" que se actualiza sola desde la tienda de Fran.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar-tienda.ps1"
pause
