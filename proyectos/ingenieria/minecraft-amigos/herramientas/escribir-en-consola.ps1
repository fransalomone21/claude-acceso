# Escribe un comando en la consola de un server de Minecraft que corre en su propia ventana (start.bat), como si
# alguien lo tipeara y apretara Enter. Sirve para apagarlo bien ("stop": guarda el mundo) cuando el server no tiene
# RCON, sin tocarle la ventana a nadie.
#   .\escribir-en-consola.ps1 -Proceso <PID del java del server> [-Texto stop]
# Corre en un powershell propio (Start-Process) porque tiene que soltar su consola para pegarse a la del server.
# Sale 0 si escribio el texto; 1 si no pudo pegarse a la consola o escribir. Que el server haya hecho caso se mide
# aparte, en su logs/latest.log ("Stopping the server") y en que el proceso termine.
param(
    [Parameter(Mandatory = $true)][int]$Proceso,
    [string]$Texto = "stop",
    [switch]$Hijo
)
if (-not $Hijo) {
    $p = Start-Process powershell -WindowStyle Hidden -Wait -PassThru -ArgumentList @(
        "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "`"$PSCommandPath`"", "-Proceso", $Proceso, "-Texto", "`"$Texto`"", "-Hijo")
    exit $p.ExitCode
}
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class Consola {
    [DllImport("kernel32.dll")] public static extern bool FreeConsole();
    [DllImport("kernel32.dll", SetLastError = true)] public static extern bool AttachConsole(uint pid);
    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern IntPtr CreateFileW(string nombre, uint acceso, uint compartir, IntPtr seg, uint crear, uint flags, IntPtr plantilla);
    [StructLayout(LayoutKind.Explicit, CharSet = CharSet.Unicode)]
    public struct Tecla {
        [FieldOffset(0)] public ushort EventType;
        [FieldOffset(4)] public int KeyDown;
        [FieldOffset(8)] public ushort RepeatCount;
        [FieldOffset(10)] public ushort VirtualKeyCode;
        [FieldOffset(12)] public ushort VirtualScanCode;
        [FieldOffset(14)] public char UnicodeChar;
        [FieldOffset(16)] public uint ControlKeyState;
    }
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool WriteConsoleInputW(IntPtr h, Tecla[] buf, uint n, out uint escritos);
}
"@
[Consola]::FreeConsole() | Out-Null
if (-not [Consola]::AttachConsole([uint32]$Proceso)) { exit 1 }
$h = [Consola]::CreateFileW("CONIN$", [uint32]"0xC0000000", 3, [IntPtr]::Zero, 3, 0, [IntPtr]::Zero)
if ($h -eq [IntPtr]::Zero -or $h -eq [IntPtr]-1) { exit 1 }
$teclas = New-Object System.Collections.Generic.List[Consola+Tecla]
foreach ($c in ($Texto + "`r").ToCharArray()) {
    foreach ($abajo in 1, 0) {
        $t = New-Object Consola+Tecla
        $t.EventType = 1; $t.KeyDown = $abajo; $t.RepeatCount = 1; $t.UnicodeChar = $c
        if ($c -eq "`r") { $t.VirtualKeyCode = 0x0D }
        $teclas.Add($t)
    }
}
$n = 0
$ok = [Consola]::WriteConsoleInputW($h, $teclas.ToArray(), [uint32]$teclas.Count, [ref]$n)
if ($ok -and $n -eq $teclas.Count) { exit 0 } else { exit 1 }
