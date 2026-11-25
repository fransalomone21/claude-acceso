@echo off
rem Server de la tienda: corre lo ultimo que se publico (puerto 25568, un mundo por combinacion).
rem Para cerrarlo: escribir stop en esta ventana.
title Server de la tienda (25568)
python "%~dp0armar.py" --server || (echo No se pudo poner al dia el server. & pause & exit /b 1)
cd /d C:\Users\frans\MinecraftServer\tienda\server
set "JAVA=%APPDATA%\PrismLauncher\java\java-runtime-delta\bin\java.exe"
"%JAVA%" @user_jvm_args.txt @libraries/net/neoforged/neoforge/21.1.267/win_args.txt nogui
pause
