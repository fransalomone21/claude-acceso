@echo off
rem Server de la tienda: corre lo ultimo que se publico (puerto 25568, un mundo por combinacion).
rem Prende tambien el pack (tienda.py, puerto 8765) si no esta prendido: sin el pack, la PC y Kevin no se
rem actualizan al abrir el juego (sincronizar.ps1 avisa y juega con lo viejo, y el server los rechaza).
rem Para cerrarlo: escribir stop en esta ventana. La ventana minimizada "Tienda (pack)" se cierra aparte.
title Server de la tienda (25568)
powershell -NoProfile -Command "if (Get-NetTCPConnection -LocalPort 8765 -State Listen -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo Prendiendo el pack de la tienda ^(puerto 8765^)...
    start "Tienda (pack)" /min python "%~dp0tienda.py"
)
python "%~dp0armar.py" --server || (echo No se pudo poner al dia el server. & pause & exit /b 1)
cd /d C:\Users\frans\MinecraftServer\tienda\server
set "JAVA=%APPDATA%\PrismLauncher\java\java-runtime-delta\bin\java.exe"
"%JAVA%" @user_jvm_args.txt @libraries/net/neoforged/neoforge/21.1.267/win_args.txt nogui
pause
