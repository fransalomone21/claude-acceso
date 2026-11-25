# Mide el MD5 de la ISO de TLOU de esta maquina, lo compara con el esperado y deja referencia.txt para el lanzador
# (L1-15). Uso: instalar-juego-tlou.ps1 -Md5Esperado <md5 de la otra maquina>. Sale 0 si coincide, 1 si no.
param([Parameter(Mandatory)][string]$Md5Esperado)
$base = 'C:\Games\tlou-factions'
$iso = 'C:\Games\PS3-ISOs\Last of Us, The (USA) (En,Fr,Es,Pt).iso'
$f = Get-Item -LiteralPath $iso
$md5 = (Get-FileHash -LiteralPath $iso -Algorithm MD5).Hash
"$env:COMPUTERNAME $md5 $($f.Length) bytes"
if ($md5 -ne $Md5Esperado.ToUpper()) { "ROJO: distinto del esperado $Md5Esperado"; exit 1 }
@("md5=$md5", "largo=$($f.Length)", "fecha=$($f.LastWriteTimeUtc.ToString('o'))") | Set-Content (Join-Path $base 'referencia.txt') -Encoding ASCII
Copy-Item (Join-Path $PSScriptRoot 'jugar-factions.ps1') $base -Force -ErrorAction SilentlyContinue
'@echo off' , 'powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0jugar-factions.ps1"' | Set-Content (Join-Path $base 'Jugar Facciones de a dos.cmd') -Encoding ASCII
"VERDE: referencia escrita en $base"
