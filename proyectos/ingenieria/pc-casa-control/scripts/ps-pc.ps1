# Corre en la sesion interactiva (tarea ps-pc): ejecuta ps-args.ps1 y deja la salida en ps-out.txt
Remove-Item C:\Users\Fran\lp-todo\ps-out.txt -ErrorAction SilentlyContinue
& C:\Users\Fran\lp-todo\ps-args.ps1 *> C:\Users\Fran\lp-todo\ps-out.tmp
Move-Item C:\Users\Fran\lp-todo\ps-out.tmp C:\Users\Fran\lp-todo\ps-out.txt -Force
