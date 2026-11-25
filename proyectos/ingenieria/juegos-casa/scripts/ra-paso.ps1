# Corre en la PC, en la sesion de Fran (tarea interactiva 'juegos-paso'). Lee C:\Games\_scripts\ra-args.txt:
#   linea 1 (opcional): LANZAR <ruta del .lnk>  -> cierra el RetroArch abierto y abre ese acceso
#   resto: teclas (ENTER ESC UP DOWN LEFT RIGHT X Z A S RSHIFT WAIT<ms>) mandadas por scancode a RetroArch
# Deja C:\Games\_scripts\ra-cap.png y ra-paso.log ('listo' al final).
$dir = "C:\Games\_scripts"; $log = "$dir\ra-paso.log"; "inicio $(Get-Date -Format HH:mm:ss)" | Set-Content $log
Add-Type @"
using System; using System.Runtime.InteropServices;
public class K2 {
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int c);
  [DllImport("user32.dll")] public static extern void keybd_event(byte vk, byte scan, uint f, UIntPtr e);
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
}
"@
$sc = @{ ENTER = 0x1C; ESC = 0x01; UP = 0x48; DOWN = 0x50; LEFT = 0x4B; RIGHT = 0x4D; X = 0x2D; Z = 0x2C; A = 0x1E; S = 0x1F; RSHIFT = 0x36 }
$ext = @('UP', 'DOWN', 'LEFT', 'RIGHT')
$lineas = @(Get-Content "$dir\ra-args.txt" | Where-Object { $_ -ne '' })
if ($lineas.Count -and $lineas[0] -match '^LANZAR (.+)$') {
    $lnk = $Matches[1]; $lineas = $lineas | Select-Object -Skip 1
    Get-Process retroarch -ErrorAction SilentlyContinue | ForEach-Object { "cierro retroarch $($_.Id)" | Add-Content $log; Stop-Process -Id $_.Id -Force }
    Start-Sleep -Seconds 2
    Start-Process -FilePath $lnk; "abro $lnk" | Add-Content $log
    Start-Sleep -Seconds 8
}
$p = Get-Process retroarch -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
if (-not $p) { "SIN VENTANA DE RETROARCH" | Add-Content $log } else {
    [K2]::keybd_event(0x12, 0, 0, [UIntPtr]::Zero); [K2]::keybd_event(0x12, 0, 2, [UIntPtr]::Zero)
    [K2]::ShowWindow($p.MainWindowHandle, 9) | Out-Null; [K2]::SetForegroundWindow($p.MainWindowHandle) | Out-Null
    Start-Sleep -Milliseconds 400
    foreach ($t in $lineas) {
        if ($t -match '^WAIT(\d+)$') { Start-Sleep -Milliseconds ([int]$Matches[1]); continue }
        $s = [byte]$sc[$t]; $f = 0x0008; if ($ext -contains $t) { $f = $f -bor 0x0001 }
        [K2]::keybd_event(0, $s, $f, [UIntPtr]::Zero); Start-Sleep -Milliseconds 100
        [K2]::keybd_event(0, $s, $f -bor 0x0002, [UIntPtr]::Zero); Start-Sleep -Milliseconds 600
        "tecla $t" | Add-Content $log
    }
}
[K2]::SetProcessDPIAware() | Out-Null
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
$b = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bmp = New-Object System.Drawing.Bitmap $b.Width, $b.Height
$g = [System.Drawing.Graphics]::FromImage($bmp); $g.CopyFromScreen($b.Location, [System.Drawing.Point]::Empty, $b.Size)
$chica = New-Object System.Drawing.Bitmap $bmp, ([int]($b.Width / 2)), ([int]($b.Height / 2))
$chica.Save("$dir\ra-cap.png", [System.Drawing.Imaging.ImageFormat]::Png)
"vivo: " + [bool](Get-Process retroarch -ErrorAction SilentlyContinue) | Add-Content $log
"listo" | Add-Content $log
