# capturar-pantalla.ps1 -- captura la pantalla completa a PNG.
#
# POR QUE ESTE Y NO EL HOTKEY DE CAPTURA DE PCSX2: F8 guarda el FRAME del
# juego, sin el OSD. Y el OSD es justo lo que hay que leer para medir FPS,
# CPU% y GPU%. Una captura de la PANTALLA si lo trae.
#
# Trae la ventana del juego al frente y VERIFICA que la tomo (por efecto:
# GetForegroundWindow despues), porque una captura sin foco fotografia el
# escritorio y se lee como "el juego no muestra nada".
#
#   .\capturar-pantalla.ps1 -Salida C:\ruta\foto.png
#   .\capturar-pantalla.ps1 -Salida foto.png -Espera 20   # deja estabilizar
param(
    [Parameter(Mandatory=$true)][string]$Salida,
    [double]$Espera = 0,
    [string]$TituloJuego = 'Black',
    [switch]$SinFoco
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public class Foco {
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n);
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
  [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll", CharSet=CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
  public static IntPtr Buscar(uint pid, string titulo) {
    IntPtr f = IntPtr.Zero;
    EnumWindows(delegate(IntPtr h, IntPtr l) {
      uint p; GetWindowThreadProcessId(h, out p);
      if (p == pid && IsWindowVisible(h)) {
        var t = new StringBuilder(512); GetWindowText(h, t, 512);
        if (t.ToString().Trim() == titulo) { f = h; return false; }
      }
      return true;
    }, IntPtr.Zero);
    return f;
  }
}
'@
if (-not $SinFoco) {
    $p = Get-Process pcsx2-qt -ErrorAction Stop
    $h = [Foco]::Buscar([uint32]$p.Id, $TituloJuego)
    if ($h -eq [IntPtr]::Zero) { throw "No se encontro la ventana del juego (titulo '$TituloJuego')." }
    [void][Foco]::ShowWindow($h, 9)
    [void][Foco]::SetForegroundWindow($h)
    Start-Sleep -Milliseconds 600
    if ([Foco]::GetForegroundWindow() -ne $h) { throw 'NO se tomo el foco: la captura saldria del escritorio.' }
}
if ($Espera -gt 0) { Start-Sleep -Seconds $Espera }
$b = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bmp = New-Object System.Drawing.Bitmap $b.Width, $b.Height
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.CopyFromScreen($b.X, $b.Y, 0, 0, $bmp.Size)
$dirSal = Split-Path -Parent $Salida
if ($dirSal -and -not (Test-Path -LiteralPath $dirSal)) { New-Item -ItemType Directory -Force -Path $dirSal | Out-Null }
$bmp.Save($Salida, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output ("capturado {0}x{1} -> {2}" -f $b.Width, $b.Height, $Salida)
