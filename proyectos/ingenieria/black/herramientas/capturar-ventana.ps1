param([string]$Salida, [string]$Proceso = "pcsx2-qt")
Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class W {
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint f);
  [DllImport("user32.dll")] public static extern bool GetClientRect(IntPtr h, out RECT r);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  public struct RECT { public int L, T, R, B; }
}
"@
[W]::SetProcessDPIAware() | Out-Null
$p = Get-Process $Proceso | Where-Object { $_.MainWindowTitle } | Select-Object -First 1
if (-not $p) { throw "no hay ventana de $Proceso" }
$r = New-Object W+RECT
[W]::GetClientRect($p.MainWindowHandle, [ref]$r) | Out-Null
$w = $r.R - $r.L; $h = $r.B - $r.T
$bmp = New-Object System.Drawing.Bitmap $w, $h
$g = [System.Drawing.Graphics]::FromImage($bmp)
$hdc = $g.GetHdc()
$ok = [W]::PrintWindow($p.MainWindowHandle, $hdc, 3)   # PW_CLIENTONLY | PW_RENDERFULLCONTENT
$g.ReleaseHdc($hdc)
$bmp.Save($Salida, [System.Drawing.Imaging.ImageFormat]::Png)
"ok=$ok ${w}x${h} -> $Salida"
