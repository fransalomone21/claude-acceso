# pcsx2_ventanas.ps1 -- enumera TODAS las ventanas top-level de pcsx2-qt.
# PCSX2-Qt tiene al menos dos: la ventana de registro y la del juego. El
# .MainWindowHandle de .NET devuelve la primera que encuentra, que puede ser
# la equivocada -- y los hotkeys solo los procesa la del juego.
$ErrorActionPreference = 'Stop'
Add-Type @'
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public class WEnum {
    public delegate bool EnumProc(IntPtr h, IntPtr l);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll", CharSet=CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll", CharSet=CharSet.Auto)] public static extern int GetClassName(IntPtr h, StringBuilder s, int n);
    [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RECT r);
    [StructLayout(LayoutKind.Sequential)] public struct RECT { public int L,T,R,B; }
    public static List<string> Todas(uint target) {
        var outp = new List<string>();
        EnumWindows(delegate(IntPtr h, IntPtr l) {
            uint pid; GetWindowThreadProcessId(h, out pid);
            if (pid == target) {
                var t = new StringBuilder(512); GetWindowText(h, t, 512);
                var c = new StringBuilder(256); GetClassName(h, c, 256);
                RECT r; GetWindowRect(h, out r);
                outp.Add(string.Format("hwnd={0}\tvisible={1}\t{2}x{3}\tclase={4}\ttitulo=[{5}]",
                    h, IsWindowVisible(h), r.R-r.L, r.B-r.T, c, t));
            }
            return true;
        }, IntPtr.Zero);
        return outp;
    }
}
'@
$p = Get-Process pcsx2-qt
[WEnum]::Todas([uint32]$p.Id) | ForEach-Object { Write-Output $_ }
