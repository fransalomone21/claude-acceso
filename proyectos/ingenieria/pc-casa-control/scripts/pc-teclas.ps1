param([string[]]$Teclas, [string]$Nombre = 'cap')
# Desde la notebook: manda teclas al Sparking de la PC (tarea interactiva paso-sz) y trae la captura.
$k = "$env:USERPROFILE\.ssh\pc-cable"
$dst = "C:\Users\frans\herramientas\lp-trabajo\_intermedios\capturas-pc"
New-Item -ItemType Directory -Force $dst | Out-Null
$args64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(($Teclas -join "`n")))
$cmd = "[IO.File]::WriteAllText('C:\Users\Fran\lp-todo\paso-args.txt', [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String('$args64'))); Remove-Item C:\Users\Fran\lp-todo\paso.log -ErrorAction SilentlyContinue; Start-ScheduledTask -TaskName paso-sz; " +
  "for(`$i=0;`$i -lt 120;`$i++){ Start-Sleep -Milliseconds 500; if((Test-Path C:\Users\Fran\lp-todo\paso.log) -and (Select-String -Path C:\Users\Fran\lp-todo\paso.log -Pattern '^listo' -Quiet)){break} }; Get-Content C:\Users\Fran\lp-todo\paso.log"
$enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($cmd))
ssh -i $k Fran@10.147.20.3 "powershell -NoProfile -EncodedCommand $enc" 2>$null | Where-Object { $_ -notmatch 'CLIXML|<Objs' }
$n = (Get-ChildItem $dst -Filter "$Nombre*.png" -ErrorAction SilentlyContinue).Count + 1
$out = "$dst\$Nombre-$n.png"
scp -i $k "Fran@10.147.20.3:C:/Users/Fran/lp-todo/cap.png" $out 2>$null
$out
