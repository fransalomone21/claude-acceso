@echo off
rem Abre la tienda de mods (y el pack que leen las instancias) y la muestra en el navegador.
rem Mientras esta ventana este abierta, la PC y Kevin se pueden actualizar. Para cerrarla: cerrar la ventana.
title Tienda de mods
cd /d "%~dp0"
start "" http://localhost:8765
python tienda.py
pause
