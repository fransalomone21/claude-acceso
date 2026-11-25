# Desde la notebook: corre un script de juegos-casa EN LA PANTALLA de la PC (en la sesion de Fran, donde se ven las
# ventanas) y trae lo que imprimio. Copia los scripts a C:\Games\_scripts\, registra una tarea interactiva de una
# vez, la corre, espera su 'listo' y la borra. Solo con la PC libre: nada mientras juegan.
#   .\en-pantalla-pc.ps1 -Script medir-vista.ps1
#   .\en-pantalla-pc.ps1 -Script caliente-sega.ps1 -Espera 420
#   .\en-pantalla-pc.ps1 -Script caliente-sega.ps1 -Argumentos "-Espera 25 -Lista C:\Games\_scripts\uno.csv"
param([Parameter(Mandatory)][string]$Script, [int]$Espera = 90, [string]$Argumentos = '',
      [string[]]$Copiar = @('medir-vista.ps1', 'caliente-sega.ps1', 'abrir-y-capturar.ps1', 'juegos-de-a-dos.csv'))
$k = "$env:USERPROFILE\.ssh\pc-cable"; $pc = 'Fran@10.147.20.3'
foreach ($f in $Copiar) { scp -q -i $k (Join-Path $PSScriptRoot $f) "${pc}:C:/Games/_scripts/$f"; if ($LASTEXITCODE) { "no se pudo copiar $f a la PC"; exit 1 } }
$cmd = @"
`$d = 'C:\Games\_scripts'; `$log = "`$d\pantalla.log"; `$t = 'juegos-pantalla'
Remove-Item `$log -ErrorAction SilentlyContinue
`$arg = "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -Command ``"& '`$d\$Script' $Argumentos *> '`$log'; 'salida ' + ```$LASTEXITCODE >> '`$log'; 'listo' >> '`$log'``""
`$ac = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument `$arg -WorkingDirectory `$d
`$pr = New-ScheduledTaskPrincipal -UserId 'Fran' -LogonType Interactive -RunLevel Limited
Register-ScheduledTask -TaskName `$t -Action `$ac -Principal `$pr -Force | Out-Null
Start-ScheduledTask -TaskName `$t
for (`$i = 0; `$i -lt ($Espera * 2); `$i++) { Start-Sleep -Milliseconds 500; if ((Test-Path `$log) -and (Select-String -Path `$log -Pattern '^listo' -Quiet)) { break } }
Unregister-ScheduledTask -TaskName `$t -Confirm:`$false
if (Test-Path `$log) { Get-Content `$log } else { 'la tarea no dejo registro' }
"@
$enc = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($cmd))
ssh -o ConnectTimeout=15 -i $k $pc "powershell -NoProfile -EncodedCommand $enc" 2>$null | Where-Object { $_ -notmatch 'CLIXML|<Objs' }
