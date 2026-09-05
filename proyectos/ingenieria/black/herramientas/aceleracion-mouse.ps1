# aceleracion-mouse.ps1 -- ve, apaga y prende la ACELERACION DE PUNTERO de
# Windows ("Mejorar la precision del puntero").
#
# POR QUE LE IMPORTA A BLACK
#   PCSX2 no lee el mouse crudo: toma los eventos de puntero del sistema
#   operativo, que YA vienen pasados por la balistica de Windows. Con la
#   aceleracion prendida, la misma distancia de mouse produce distinto giro
#   segun la VELOCIDAD con que se movio -- que es exactamente lo contrario de
#   lo que se busco toda la fase de jugabilidad. Es la causa clasica de "muevo
#   despacio y no pasa nada, muevo rapido y me paso".
#
#   MouseSpeed = 0 es sin aceleracion (1:1). = 1 es con aceleracion.
#   MouseSensitivity = 10 es la escala base 1:1 del slider (rango 1..20).
#
# ES UN AJUSTE DEL ESCRITORIO ENTERO, no del juego: apagarlo cambia como se
# siente el mouse en todo Windows. Por eso esta como comando aparte y no
# adentro de configurar-controles.ps1, y por eso -Apagar guarda lo que habia
# para que -Restaurar lo devuelva exactamente.
#
#   .\aceleracion-mouse.ps1 -Ver
#   .\aceleracion-mouse.ps1 -Apagar      # guarda el estado previo
#   .\aceleracion-mouse.ps1 -Restaurar   # vuelve a lo que habia
param([switch]$Ver,[switch]$Apagar,[switch]$Restaurar)
$ErrorActionPreference='Stop'
Add-Type @'
using System;
using System.Runtime.InteropServices;
public class MouseAccel {
  [DllImport("user32.dll", SetLastError=true)]
  public static extern bool SystemParametersInfo(uint a, uint b, int[] c, uint d);
  public const uint SPI_GETMOUSE=0x0003, SPI_SETMOUSE=0x0004;
  public const uint SPIF_UPDATEINIFILE=0x01, SPIF_SENDCHANGE=0x02;
  public static int[] Get(){ var v=new int[3]; SystemParametersInfo(SPI_GETMOUSE,0,v,0); return v; }
  public static void Set(int[] v){ SystemParametersInfo(SPI_SETMOUSE,0,v,SPIF_UPDATEINIFILE|SPIF_SENDCHANGE); }
}
'@
$guardado = Join-Path $env:LOCALAPPDATA 'black-mouse-accel.txt'

function Mostrar {
    $v = [MouseAccel]::Get()
    $sens = (Get-ItemProperty 'HKCU:\Control Panel\Mouse').MouseSensitivity
    $estado = if ($v[2] -eq 0) { 'APAGADA (1:1, lo que quiere un shooter)' } else { 'PRENDIDA' }
    Write-Output "  umbral1=$($v[0])  umbral2=$($v[1])  aceleracion=$($v[2])  ->  $estado"
    Write-Output "  MouseSensitivity = $sens   (10 = escala base 1:1)"
}

if ($Restaurar) {
    if (-not (Test-Path -LiteralPath $guardado)) { throw "No hay estado guardado en $guardado" }
    $v = (Get-Content -LiteralPath $guardado) -split ',' | ForEach-Object { [int]$_ }
    [MouseAccel]::Set($v); Write-Output '  restaurado:'; Mostrar; exit 0
}
if ($Apagar) {
    $v = [MouseAccel]::Get()
    Set-Content -LiteralPath $guardado -Value ($v -join ',') -Encoding ascii
    Write-Output "  estado previo guardado en $guardado"
    [MouseAccel]::Set(@(0,0,0))
    Write-Output '  ahora:'; Mostrar
    # VERIFICA POR EFECTO: relee del sistema, no confia en la llamada
    if ([MouseAccel]::Get()[2] -ne 0) { throw 'NO se apago: el sistema sigue reportando aceleracion.' }
    exit 0
}
Mostrar
