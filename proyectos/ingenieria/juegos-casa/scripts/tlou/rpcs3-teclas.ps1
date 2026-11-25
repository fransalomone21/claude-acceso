# Manda teclas por SCANCODE a la ventana de RPCS3 (el juego ignora SendKeys) y guarda una captura de pantalla
# completa (DPI-aware). Una captura por paso: se mira antes de mandar la siguiente (regla de pc-casa-control).
# Uso: rpcs3-teclas.ps1 [-Teclas ENTER,WAIT2000,DOWN] [-Captura C:\...\paso.png] [-PausaMs 500]
param([string[]]$Teclas = @(), [int]$PausaMs = 500, [string]$Captura = '')
Add-Type @"
using System; using System.Runtime.InteropServices;
public class K2 {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint f, UIntPtr e);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
}
"@
[K2]::SetProcessDPIAware() | Out-Null
$sc = @{ SPACE = 0x39; ENTER = 0x1C; ESC = 0x01; UP = 0x48; DOWN = 0x50; LEFT = 0x4B; RIGHT = 0x4D; BACK = 0x0E
  Q = 0x10; E = 0x12; R = 0x13; F = 0x21; TAB = 0x0F; W = 0x11; A = 0x1E; S = 0x1F; D = 0x20; Z = 0x2C; X = 0x2D
  C = 0x2E; V = 0x2F; G = 0x22; T = 0x14; Y = 0x15; U = 0x16; I = 0x17; O = 0x18; P = 0x19; H = 0x23; J = 0x24
  K = 0x25; L = 0x26; B = 0x30; N = 0x31; M = 0x32; N1 = 0x02; N2 = 0x03; N3 = 0x04 }
$ext = @('UP', 'DOWN', 'LEFT', 'RIGHT')
$p = Get-Process rpcs3 -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowTitle -match 'BCUS98174|FPS' } | Select-Object -First 1
if (-not $p) { 'SIN VENTANA DEL JUEGO'; exit 1 }
if ($Teclas.Count) {
  [K2]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero); [K2]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)
  [K2]::ShowWindow($p.MainWindowHandle, 9) | Out-Null
  [K2]::SetForegroundWindow($p.MainWindowHandle) | Out-Null
  Start-Sleep -Milliseconds 300
  "juego al frente: " + ([K2]::GetForegroundWindow() -eq $p.MainWindowHandle)
  foreach ($t in $Teclas) {
    if ($t -match '^WAIT(\d+)$') { Start-Sleep -Milliseconds ([int]$Matches[1]); continue }
    $hold = 90; $k = $t
    if ($t -match '^HOLD_(\w+)_(\d+)$') { $k = $Matches[1]; $hold = [int]$Matches[2] }
    $s = [byte]$sc[$k]; $f = 0x0008; if ($ext -contains $k) { $f = $f -bor 0x0001 }
    [K2]::keybd_event(0, $s, $f, [UIntPtr]::Zero); Start-Sleep -Milliseconds $hold
    [K2]::keybd_event(0, $s, $f -bor 0x0002, [UIntPtr]::Zero); Start-Sleep -Milliseconds $PausaMs
  }
}
"titulo: $($p.MainWindowTitle)"
if ($Captura) {
  Add-Type -AssemblyName System.Windows.Forms, System.Drawing
  $b = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
  $bmp = New-Object System.Drawing.Bitmap $b.Width, $b.Height
  $g = [System.Drawing.Graphics]::FromImage($bmp); $g.CopyFromScreen($b.Location, [System.Drawing.Point]::Empty, $b.Size)
  $chica = New-Object System.Drawing.Bitmap $bmp, ([int]($b.Width / 2)), ([int]($b.Height / 2))
  $chica.Save($Captura, [System.Drawing.Imaging.ImageFormat]::Png); $g.Dispose(); $bmp.Dispose(); $chica.Dispose()
  "captura: $Captura"
}
