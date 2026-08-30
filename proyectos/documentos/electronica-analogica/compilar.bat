@echo off
setlocal
chcp 65001 >nul
REM ====================================================================
REM  compilar.bat - genera el PDF del apunte sin necesidad de una sesion
REM
REM  Doble clic, o desde la consola:
REM      compilar.bat            el apunte completo
REM      compilar.bat galeria    solo la galeria de figuras (segundos)
REM
REM  El fuente es Typst y vive en apunte\. Este .bat no compila nada por
REM  su cuenta: llama al mismo comando que corre la sesion, para que el
REM  resultado sea identico y no haya dos maneras de generar el PDF.
REM ====================================================================

cd /d "%~dp0apunte"

where typst >nul 2>nul
if errorlevel 1 (
  echo.
  echo   [ERROR] No se encuentra 'typst' en el PATH.
  echo.
  echo   Instalarlo con:   winget install Typst.Typst
  echo   y volver a abrir la consola para que tome el PATH nuevo.
  echo.
  pause
  exit /b 1
)

if /i "%~1"=="galeria" goto :galeria

echo.
echo   Compilando el apunte completo (123 paginas, unos 20 segundos)...
echo.
typst compile apunte.typ apunte.pdf
if errorlevel 1 goto :fallo

echo.
echo   LISTO -^> apunte\apunte.pdf
echo.
start "" "apunte.pdf"
goto :fin

:galeria
echo.
echo   Compilando solo la galeria de figuras...
echo.
typst compile biblioteca\galeria.typ biblioteca\galeria.pdf
if errorlevel 1 goto :fallo

echo.
echo   LISTO -^> apunte\biblioteca\galeria.pdf
echo.
start "" "biblioteca\galeria.pdf"
goto :fin

:fallo
echo.
echo   [ERROR] Typst no pudo compilar. El mensaje de arriba dice en que
echo   linea y en que archivo esta el problema.
echo.
pause
exit /b 1

:fin
endlocal
