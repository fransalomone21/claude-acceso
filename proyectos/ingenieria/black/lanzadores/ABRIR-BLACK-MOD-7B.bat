@echo off
title BLACK - ISO PARCHEADO 7b (arma y modelo de dos personajes de LEVEL_00)
echo.
echo  Abriendo BLACK desde el ISO PARCHEADO 7b.
echo.
echo  Que tiene de distinto: en STLEVEL.BIN de LEVEL_00, el registro de
echo  personaje E_BLACKHD_M0 tiene su arma (+0x78) cambiada a RPG0, y el
echo  registro E_LKISS2_M0 tiene su modelo (+0x18) cambiado a E_BLACKHD_M0.
echo  2 rangos de 7 bytes, TOC intacta.
echo.
echo  Para que el experimento valga: arrancar o seguir un nivel, NUNCA
echo  cargar un savestate viejo (restaura la RAM entera, tapa el parche).
echo  Jugar hasta LEVEL_00 y avisar.
echo.
start "" "C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe" -fastboot -batch -- "C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black-mod-7b.iso"
timeout /t 4 >nul
