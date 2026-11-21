# Corre en la sesion interactiva de la PC (tarea ps-pc, copiado como ps-args.ps1): devuelve el foco al juego
# (sin foco el juego puede silenciarse) y graba N segundos de lo que sale por los parlantes con oir.py.
# Lee los parametros de C:\Users\Fran\lp-todo\oir-args.txt: "<segundos> <nombre>". Deja ps-out.txt con el resumen.
Add-Type @"
using System; using System.Runtime.InteropServices;
public class W { [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h); }
"@
$arg = (Get-Content C:\Users\Fran\lp-todo\oir-args.txt -Raw).Trim().Split(' ')
$g = Get-Process SparkingZERO-Win64-Shipping -EA SilentlyContinue
if ($g) { [W]::SetForegroundWindow($g.MainWindowHandle) | Out-Null; Start-Sleep -Milliseconds 800 }
$py = 'C:\Users\Fran\AppData\Local\Programs\Python\Python312\python.exe'
$r = & $py C:\Users\Fran\lp-todo\oir.py $arg[0] ("C:\Users\Fran\lp-todo\" + $arg[1]) 2>&1 | Out-String
"juego: " + [bool]$g + "`n" + $r | Set-Content C:\Users\Fran\lp-todo\ps-out.txt
