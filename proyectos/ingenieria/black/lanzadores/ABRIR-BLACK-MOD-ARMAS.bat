@echo off
title BLACK - ISO PARCHEADO (enemigos hacen 5 de dano)
echo.
echo  Abriendo BLACK desde el ISO PARCHEADO.
echo.
echo  Que tiene de distinto: el Power del bloque de IA de las 17 armas
echo  esta en 5.0 en vez de 26/13/70/100/133/200. Los enemigos te hacen
echo  mucho menos dano. El bloque del jugador quedo intacto.
echo.
echo  OJO: NO cargues un savestate viejo para probarlo. Un savestate
echo  restaura la RAM ENTERA, tabla de armas incluida, con los valores
echo  de antes del parche. Para sentir el mod hay que empezar o seguir
echo  un nivel, no cargar un estado guardado previo al parche.
echo.
start "" "C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe" -fastboot -batch -- "C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black-mod-armas.iso"
timeout /t 4 >nul
