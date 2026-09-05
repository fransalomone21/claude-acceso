# pcsx2_mouse.ps1 -- inyecta movimiento RELATIVO de mouse en la ventana del juego.
#
# POR QUE EXISTE
#   La mira de BLACK se ajusta con tres numeros del emulador (Speed, DeadZone,
#   Inertia) y una curva del juego. Elegirlos por formula ya fallo una vez: la
#   sesion 55 entrego media receta (Inertia=100 sin ajustar Speed) y produjo el
#   sintoma OPUESTO al que venia a arreglar. Lo que falta para no repetirlo es
#   medir la funcion de transferencia REAL: cuantas cuentas de mouse hacen
#   girar cuanto la camara.
#
#   Este script es la mitad de entrada de ese lazo. La mitad de salida es
#   pine.py leyendo el angulo de camara en RAM.
#
# COMO INYECTA, Y POR QUE ASI
#   SendInput con MOUSEEVENTF_MOVE (relativo). NO mouse_event: esta deprecado y
#   se mezcla mal con la cola de entrada de otro proceso. NO SetCursorPos: es
#   absoluto y no genera delta relativo -- PCSX2 acumula deltas, no posiciones.
#
#   Se manda en PASOS chicos y no un salto unico: un salto grande de una sola
#   vez llega a PCSX2 como UN delta y satura el eje en un solo sondeo, que es
#   justo la parte de la curva que no se quiere medir. Con pasos de <=40 cuentas
#   separados por una pausa, cada sondeo ve un delta chico.
#
# VERIFICA EL FOCO POR EFECTO, no por que la llamada no tire error:
#   SetForegroundWindow devuelve false en silencio si otra app tiene el lock.
#
# Uso:
#   .\pcsx2_mouse.ps1 -DX 2000                    # 2000 cuentas a la derecha
#   .\pcsx2_mouse.ps1 -DX -2000
#   .\pcsx2_mouse.ps1 -DX 600 -Paso 10 -PausaMs 16   # lento: ~10 cuentas/sondeo
#   .\pcsx2_mouse.ps1 -DY 500
param(
    [int]$DX = 0,
    [int]$DY = 0,
    [int]$Paso = 40,
    [int]$PausaMs = 16,
    [string]$TituloJuego = 'Black',
    [switch]$SinFoco
)
$ErrorActionPreference = 'Stop'

Add-Type @'
using System;
using System.Text;
using System.Runtime.InteropServices;
public class MouseInj {
    [StructLayout(LayoutKind.Sequential)] public struct MOUSEINPUT {
        public int dx; public int dy; public uint mouseData; public uint dwFlags;
        public uint time; public IntPtr dwExtraInfo;
    }
    [StructLayout(LayoutKind.Sequential)] public struct INPUT {
        public uint type; public MOUSEINPUT mi;
        // el union real es mas grande (KEYBDINPUT/HARDWAREINPUT); MOUSEINPUT es
        // el miembro mas grande en x64, asi que el tamano cierra igual.
    }
    [DllImport("user32.dll", SetLastError=true)]
    public static extern uint SendInput(uint n, INPUT[] p, int cb);
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int n);
    public delegate bool EnumProc(IntPtr h, IntPtr l);
    [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
    [DllImport("user32.dll")] public static extern uint GetWindowThreadProcessId(IntPtr h, out uint pid);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll", CharSet=CharSet.Auto)] public static extern int GetWindowText(IntPtr h, StringBuilder s, int n);

    public const uint MOUSEEVENTF_MOVE = 0x0001;

    public static IntPtr BuscarVentana(uint pid, string titulo) {
        IntPtr found = IntPtr.Zero;
        EnumWindows(delegate(IntPtr h, IntPtr l) {
            uint p; GetWindowThreadProcessId(h, out p);
            if (p == pid && IsWindowVisible(h)) {
                var t = new StringBuilder(512); GetWindowText(h, t, 512);
                if (t.ToString().Trim() == titulo) { found = h; return false; }
            }
            return true;
        }, IntPtr.Zero);
        return found;
    }

    public static uint Mover(int dx, int dy) {
        var inp = new INPUT[1];
        inp[0].type = 0; // INPUT_MOUSE
        inp[0].mi.dx = dx; inp[0].mi.dy = dy;
        inp[0].mi.dwFlags = MOUSEEVENTF_MOVE;
        return SendInput(1, inp, Marshal.SizeOf(typeof(INPUT)));
    }
}
'@

if (-not $SinFoco) {
    $p = Get-Process pcsx2-qt -ErrorAction Stop
    $h = [MouseInj]::BuscarVentana([uint32]$p.Id, $TituloJuego)
    if ($h -eq [IntPtr]::Zero) { throw "No se encontro la ventana del juego (titulo '$TituloJuego')." }
    [void][MouseInj]::ShowWindow($h, 9)   # SW_RESTORE
    [void][MouseInj]::SetForegroundWindow($h)
    Start-Sleep -Milliseconds 400
    $fg = [MouseInj]::GetForegroundWindow()
    if ($fg -ne $h) { throw "NO se tomo el foco (foreground=$fg, buscado=$h). Sin foco la inyeccion no llega." }
    Write-Output "foco OK  hwnd=$h"
}

# reparte el total en pasos, manteniendo el signo
function Repartir([int]$total, [int]$paso) {
    $s = [math]::Sign($total); $r = [math]::Abs($total); $l = @()
    while ($r -gt 0) { $q = [math]::Min($paso, $r); $l += ($q * $s); $r -= $q }
    return ,$l
}
$px = Repartir $DX $Paso
$py = Repartir $DY $Paso
$n  = [math]::Max($px.Count, $py.Count)

$sw = [System.Diagnostics.Stopwatch]::StartNew()
for ($i = 0; $i -lt $n; $i++) {
    $ax = if ($i -lt $px.Count) { $px[$i] } else { 0 }
    $ay = if ($i -lt $py.Count) { $py[$i] } else { 0 }
    [void][MouseInj]::Mover($ax, $ay)
    if ($PausaMs -gt 0) { Start-Sleep -Milliseconds $PausaMs }
}
$sw.Stop()
Write-Output "inyectado DX=$DX DY=$DY en $n pasos de <=$Paso  ($([math]::Round($sw.Elapsed.TotalSeconds,2)) s)"
