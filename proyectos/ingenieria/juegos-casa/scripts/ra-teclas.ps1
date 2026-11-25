# Desde la notebook: manda un paso a RetroArch de la PC (tarea interactiva 'juegos-paso', la crea si falta) y
# trae la captura. Uso: .\ra-teclas.ps1 -Lineas 'LANZAR C:\...\x.lnk','WAIT3000','ENTER' -Nombre dd2
param([string[]]$Lineas, [string]$Nombre = 'ra')
$k = "$env:USERPROFILE\.ssh\pc-cable"
$dst = "C:\Games\_pruebas"; New-Item -ItemType Directory -Force $dst | Out-Null
$a64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(($Lineas -join "`n")))
$cmd = @"
`$d='C:\Games\_scripts'
if (-not (Get-ScheduledTask -TaskName juegos-paso -ErrorAction SilentlyContinue)) {
  `$ac = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\Games\_scripts\ra-paso.ps1'
  `$pr = New-ScheduledTaskPrincipal -UserId 'Fran' -LogonType Interactive -RunLevel Limited
  Register-ScheduledTask -TaskName juegos-paso -Action `$ac -Principal `$pr -Force | Out-Null }
[IO.File]::WriteAllText("`$d\ra-args.txt", [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('$a64')))
Remove-Item "`$d\ra-paso.log" -ErrorAction SilentlyContinue; Start-ScheduledTask -TaskName juegos-paso
for(`$i=0;`$i -lt 120;`$i++){ Start-Sleep -Milliseconds 500; if((Test-Path "`$d\ra-paso.log") -and (Select-String -Path "`$d\ra-paso.log" -Pattern '^listo' -Quiet)){break} }
Get-Content "`$d\ra-paso.log"
"@
$enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($cmd))
ssh -i $k Fran@10.147.20.3 "powershell -NoProfile -EncodedCommand $enc" 2>$null | Where-Object { $_ -notmatch 'CLIXML|<Objs' }
$n = (Get-ChildItem $dst -Filter "$Nombre-*.png" -ErrorAction SilentlyContinue).Count + 1
$out = "$dst\$Nombre-$n.png"
scp -i $k -q "Fran@10.147.20.3:C:/Games/_scripts/ra-cap.png" $out 2>$null
$out
