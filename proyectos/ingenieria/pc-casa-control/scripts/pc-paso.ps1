# Corre en la PC DENTRO de la sesion interactiva (por la tarea programada 'paso-sz').
# Lee las teclas de paso-args.txt (una por linea; WAITnnnn = pausa) y deja captura + log.
$d = 'C:\Users\Fran\lp-todo'
$teclas = @(Get-Content "$d\paso-args.txt" | Where-Object { $_.Trim() } | ForEach-Object { $_.Trim() })
& "$d\tecla-juego.ps1" -Teclas $teclas -Captura "$d\cap.png" *> "$d\paso.log"
"listo $(Get-Date -Format HH:mm:ss)" | Add-Content "$d\paso.log"
