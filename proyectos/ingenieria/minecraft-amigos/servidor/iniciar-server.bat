@echo off
rem Server de la juntada. Doble clic. Para cerrarlo: escribir "stop" en esta ventana (NO cerrar con la X: se pierde lo no guardado).
cd /d "%~dp0"
title Server Juntada 1.21.4
set "JAVA=%APPDATA%\PrismLauncher\java\java-runtime-delta\bin\java.exe"
if not exist "%JAVA%" set "JAVA=java"
echo.
echo  Tus amigos se conectan a:  10.147.20.2   (ZeroTier, red de franquiito)
echo.
"%JAVA%" -Xms4G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -jar fabric-server-launch.jar nogui
pause
