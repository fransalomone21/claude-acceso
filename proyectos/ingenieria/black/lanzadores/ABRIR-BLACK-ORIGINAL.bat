@echo off
title BLACK - ISO ORIGINAL (sin tocar)
echo.
echo  Abriendo BLACK desde el ISO ORIGINAL, sin modificar.
echo  Es el mismo emulador parcheado de siempre (DebugServer + PINE).
echo.
start "" "C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe" -fastboot -batch -- "C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso"
timeout /t 4 >nul
