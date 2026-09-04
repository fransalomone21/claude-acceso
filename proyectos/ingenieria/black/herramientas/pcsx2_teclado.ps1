# pcsx2_teclado.ps1 -- trae la ventana de PCSX2 al frente y le manda teclas.
#
# Por que existe: el test de un paso de docs/09 §7.6 (apretar Insert y mirar)
# necesitaba "alguien frente al juego". Con Fran ausente la sesion PUEDE tomar
# el foco, y PCSX2 sabe escribir sus propias capturas (hotkey Screenshot = F8,
# van a Documents\PCSX2\snaps\). Eso cierra el loop de verificacion POR EFECTO
# sin depender del ojo de nadie: las capturas se leen despues.
#
# Verifica el EFECTO de tomar el foco (GetForegroundWindow despues), no solo
# que la llamada no tire error: SetForegroundWindow devuelve false en silencio
# si la sesion esta bloqueada o si otra app tiene el lock del foco.
#
# Uso:
#   .\pcsx2_teclado.ps1 -Teclas '{F8}'
#   .\pcsx2_teclado.ps1 -Teclas '{INSERT}' -EsperaPost 1.5
#   .\pcsx2_teclado.ps1 -SoloFoco          # solo mide si se puede tomar el foco

param(
    [string]$Teclas = '',
    [double]$EsperaPre = 0.35,
    [double]$EsperaPost = 1.0,
    [switch]$SoloFoco,
    # PCSX2-Qt tiene DOS ventanas top-level visibles: la de registro y la del
    # juego (titulo = [Black], clase Qt6111QWindowIcon). .MainWindowHandle de
    # .NET devuelve la de REGISTRO, que no procesa hotkeys. Por defecto se
    # busca la del juego por titulo; -Hwnd la fuerza. Ver pcsx2_ventanas.ps1.
    [string]$TituloJuego = 'Black',
    [int]$Hwnd = 0
)

$ErrorActionPreference = 'Stop'

Add-Type @'
using System;
using System.Runtime.InteropServices;
public class W32 {
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern bool IsIconic(IntPtr hWnd);
    [DllImport("user32.dll")] public static extern bool BringWindowToTop(IntPtr hWnd);
    [DllImport("user32.dll", CharSet=CharSet.Auto)] public static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder s, int n);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint pid);
    [DllImport("user32.dll")] public static extern IntPtr GetDesktopWindow();
    public delegate bool EnumProc(IntPtr h, IntPtr l);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll", CharSet=CharSet.Auto)] public static extern int GetClassName(IntPtr h, System.Text.StringBuilder s, int n);
    public static string Title(IntPtr h) {
        var sb = new System.Text.StringBuilder(512);
        GetWindowText(h, sb, 512);
        return sb.ToString();
    }
    public static IntPtr Buscar(uint target, string titulo) {
        IntPtr found = IntPtr.Zero;
        EnumWindows(delegate(IntPtr h, IntPtr l) {
            uint pid; GetWindowThreadProcessId(h, out pid);
            if (pid != target || !IsWindowVisible(h)) return true;
            var c = new System.Text.StringBuilder(256); GetClassName(h, c, 256);
            if (c.ToString().IndexOf("QWindowIcon") < 0) return true;
            if (Title(h) == titulo) { found = h; return false; }
            return true;
        }, IntPtr.Zero);
        return found;
    }
}
'@

Add-Type -AssemblyName System.Windows.Forms

$proc = Get-Process pcsx2-qt -ErrorAction SilentlyContinue
if (-not $proc) { Write-Output 'ERROR: pcsx2-qt no esta corriendo'; exit 2 }

Write-Output ("proceso   : PID {0}, responde={1}" -f $proc.Id, $proc.Responding)

if ($Hwnd -ne 0) {
    $hwnd = [IntPtr]$Hwnd
} else {
    $hwnd = [W32]::Buscar([uint32]$proc.Id, $TituloJuego)
}
if ($hwnd -eq [IntPtr]::Zero) {
    Write-Output ("ERROR: no se encontro la ventana del juego (titulo=[{0}]). Corre pcsx2_ventanas.ps1" -f $TituloJuego)
    exit 3
}
Write-Output ("ventana   : hwnd={0} titulo=[{1}]" -f $hwnd, [W32]::Title($hwnd))

if ([W32]::IsIconic($hwnd)) { [void][W32]::ShowWindow($hwnd, 9) }  # SW_RESTORE
[void][W32]::BringWindowToTop($hwnd)
[void][W32]::SetForegroundWindow($hwnd)
Start-Sleep -Milliseconds ([int]($EsperaPre * 1000))

# EFECTO, no precondicion: quien quedo realmente al frente
$fg = [W32]::GetForegroundWindow()
$fgPid = 0
[void][W32]::GetWindowThreadProcessId($fg, [ref]$fgPid)
# Se compara el HWND EXACTO, no el PID: la ventana de registro es del mismo
# proceso y NO procesa hotkeys, asi que "es de PCSX2" no alcanza como efecto.
$ok = ($fg -eq $hwnd)
Write-Output ("foco real : hwnd={0} pid={1} titulo=[{2}]" -f $fg, $fgPid, [W32]::Title($fg))
Write-Output ("FOCO      : {0}" -f $(if ($ok) { 'OK - ventana del JUEGO al frente' } else { 'FALLO - el foco no quedo en la ventana del juego' }))

if ($SoloFoco) { exit $(if ($ok) { 0 } else { 1 }) }
if (-not $ok)  { Write-Output 'ABORTA: no se mandan teclas a ciegas'; exit 1 }
if ($Teclas -eq '') { exit 0 }

[System.Windows.Forms.SendKeys]::SendWait($Teclas)
Write-Output ("teclas    : enviadas [{0}]" -f $Teclas)
Start-Sleep -Milliseconds ([int]($EsperaPost * 1000))
exit 0
