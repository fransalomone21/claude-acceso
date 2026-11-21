param([string[]]$Teclas = @('SPACE'), [int]$PausaMs = 700, [string]$Captura = '')
# Trae el Sparking ZERO al frente y le manda teclas por SCANCODE (los juegos ignoran SendKeys).
# Opcional: guarda una captura de pantalla completa en $Captura (DPI-aware).
Add-Type @"
using System; using System.Runtime.InteropServices;
public class K {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint f, UIntPtr e);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  [DllImport("user32.dll")] public static extern void mouse_event(uint f, int x, int y, uint d, UIntPtr e);
}
"@
$sc = @{ SPACE = 0x39; ENTER = 0x1C; ESC = 0x01; UP = 0x48; DOWN = 0x50; LEFT = 0x4B; RIGHT = 0x4D; BACK = 0x0E;
  Q = 0x10; E = 0x12; R = 0x13; F = 0x21; TAB = 0x0F; W = 0x11; A = 0x1E; S = 0x1F; D = 0x20; Z = 0x2C; X = 0x2D; C = 0x2E; V = 0x2F; G = 0x22; T = 0x14; Y = 0x15 }
$ext = @('UP', 'DOWN', 'LEFT', 'RIGHT')
$p = Get-Process | Where-Object { $_.ProcessName -like 'SparkingZERO-Win64*' -and $_.MainWindowHandle -ne 0 } | Select-Object -First 1
if (-not $p) { "SIN VENTANA DEL JUEGO"; exit 1 }
# Windows solo deja cambiar el foreground si el proceso "recibio input": un Alt sintetico lo habilita.
[K]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero); [K]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)
[K]::ShowWindow($p.MainWindowHandle, 9) | Out-Null
$ok = [K]::SetForegroundWindow($p.MainWindowHandle)
Add-Type @"
using System; using System.Runtime.InteropServices;
public class F { [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow(); }
"@
"foreground pedido=$ok es-el-juego=" + ([F]::GetForegroundWindow() -eq $p.MainWindowHandle)
Start-Sleep -Milliseconds 400
foreach ($t in $Teclas) {
  if ($t -match '^WAIT(\d+)$') { Start-Sleep -Milliseconds ([int]$Matches[1]); continue }
  if ($t -match '^HOLD_(\w+)_(\d+)$') { $hk=$Matches[1]; $hs=[byte]$sc[$hk]; $hf=0x0008; if ($ext -contains $hk) { $hf = $hf -bor 0x0001 }; [K]::keybd_event(0, $hs, $hf, [UIntPtr]::Zero); Start-Sleep -Milliseconds ([int]$Matches[2]); [K]::keybd_event(0, $hs, $hf -bor 0x0002, [UIntPtr]::Zero); Start-Sleep -Milliseconds $PausaMs; continue }
  $s = [byte]$sc[$t]; $f = 0x0008; if ($ext -contains $t) { $f = $f -bor 0x0001 }
  [K]::keybd_event(0, $s, $f, [UIntPtr]::Zero); Start-Sleep -Milliseconds 80
  [K]::keybd_event(0, $s, $f -bor 0x0002, [UIntPtr]::Zero); Start-Sleep -Milliseconds $PausaMs
}
if ($Captura) {
  [K]::SetProcessDPIAware() | Out-Null
  Add-Type -AssemblyName System.Windows.Forms, System.Drawing
  $b = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
  $bmp = New-Object System.Drawing.Bitmap $b.Width, $b.Height
  $g = [System.Drawing.Graphics]::FromImage($bmp); $g.CopyFromScreen($b.Location, [System.Drawing.Point]::Empty, $b.Size)
  $bmp.Save($Captura, [System.Drawing.Imaging.ImageFormat]::Png); $g.Dispose(); $bmp.Dispose()
  "captura: $Captura"
}
