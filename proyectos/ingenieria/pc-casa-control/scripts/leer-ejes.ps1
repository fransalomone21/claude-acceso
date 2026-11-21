# Corre en la PC. Lee los mandos por winmm (joyGetPosEx, igual que mide Windows) y anota en ejes.log
# CADA cambio de L2 (eje U / boton 7), R2 (eje V / boton 8) y los demas botones, por mando, con la hora.
# Solo lee: no manda nada al juego ni toca el guardado. Uso: leer-ejes.ps1 -Segundos 600
param([int]$Segundos = 600, [string]$Log = 'C:\Users\Fran\lp-todo\ejes.log')
Add-Type @'
using System;
using System.Runtime.InteropServices;
public class Joy {
  [StructLayout(LayoutKind.Sequential)] public struct JOYINFOEX { public int dwSize, dwFlags, dwXpos, dwYpos, dwZpos, dwRpos, dwUpos, dwVpos, dwButtons, dwButtonNumber, dwPOV, dwReserved1, dwReserved2; }
  [DllImport("winmm.dll")] public static extern int joyGetPosEx(int id, ref JOYINFOEX p);
  public static int[] Leer(int id) {
    JOYINFOEX j = new JOYINFOEX(); j.dwSize = Marshal.SizeOf(typeof(JOYINFOEX)); j.dwFlags = 255;
    if (joyGetPosEx(id, ref j) != 0) return null;
    return new int[] { j.dwXpos, j.dwYpos, j.dwZpos, j.dwRpos, j.dwUpos, j.dwVpos, j.dwButtons, j.dwPOV };
  }
}
'@
$nombres = 'X', 'Y', 'Z', 'R', 'U(L2)', 'V(R2)', 'botones', 'pov'
"inicio $(Get-Date -Format 'HH:mm:ss') por $Segundos s" | Set-Content $Log
$ant = @{}
$fin = (Get-Date).AddSeconds($Segundos)
$ultimoLatido = Get-Date
while ((Get-Date) -lt $fin) {
  foreach ($id in 0..3) {
    $v = [Joy]::Leer($id)
    if (-not $v) { continue }
    $a = $ant[$id]
    if (-not $a) { "[{0}] joy{1} presente: {2}" -f (Get-Date -Format HH:mm:ss.fff), $id, ($v -join ',') | Add-Content $Log; $ant[$id] = $v; continue }
    $cambios = @()
    for ($i = 0; $i -lt 8; $i++) {
      $umbral = if ($i -eq 6 -or $i -eq 7) { 0 } else { 3000 }
      if ([Math]::Abs($v[$i] - $a[$i]) -gt $umbral) { $cambios += ('{0}:{1}->{2}' -f $nombres[$i], $a[$i], $v[$i]) }
    }
    if ($cambios) { "[{0}] joy{1} {2}" -f (Get-Date -Format HH:mm:ss.fff), $id, ($cambios -join ' ') | Add-Content $Log; $ant[$id] = $v }
  }
  if (((Get-Date) - $ultimoLatido).TotalSeconds -ge 30) { "[{0}] latido (sigue leyendo)" -f (Get-Date -Format HH:mm:ss) | Add-Content $Log; $ultimoLatido = Get-Date }
  Start-Sleep -Milliseconds 40
}
"fin $(Get-Date -Format 'HH:mm:ss')" | Add-Content $Log
