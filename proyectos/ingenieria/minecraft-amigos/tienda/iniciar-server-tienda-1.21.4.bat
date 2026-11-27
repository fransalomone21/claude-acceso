@echo off
rem Server de la tienda 1.21.4 (Fabric, el mundo con Agus): corre lo ultimo que se publico en esa version,
rem puerto 25569, un mundo por combinacion. El mundo de Fran y Agus (agus-1.21.4, puerto 25566) NO es este.
rem Prende tambien el pack 1.21.4 (tienda.py, puerto 8766) si no esta prendido.
rem Para cerrarlo: escribir stop en esta ventana.
title Server de la tienda 1.21.4 (25569)
set TIENDA_VERSION=1.21.4
powershell -NoProfile -Command "if (Get-NetTCPConnection -LocalPort 8766 -State Listen -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo Prendiendo el pack de la tienda 1.21.4 ^(puerto 8766^)...
    start "Tienda 1.21.4 (pack)" /min python "%~dp0tienda.py"
)
python "%~dp0armar.py" --server --arrancar || (echo El server no arranco o no se pudo poner al dia. & pause & exit /b 1)
pause
