@echo off
rem Abre la tienda de mods de la version 1.21.4 (Fabric, el mundo con Agus) y la muestra en el navegador.
rem La de 1.21.1 es abrir-tienda.bat (puerto 8765); desde cualquiera de las dos paginas se pasa a la otra.
title Tienda de mods 1.21.4
cd /d "%~dp0"
set TIENDA_VERSION=1.21.4
start "" http://localhost:8766
python tienda.py
pause
