# Lo corre instalar-tienda.bat (doble clic) en la compu de Kevin: deja Prism Launcher con la instancia
# "Tienda 1.21.1", que se pone igual a lo que Fran eligio en la tienda cada vez que se abre el juego.
$ErrorActionPreference = 'Continue'
$aqui = Split-Path -Parent $MyInvocation.MyCommand.Path
function Paso($m) { Write-Host "`n>> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "   [OK] $m" -ForegroundColor Green }
function Mal($m)  { Write-Host "   [X]  $m" -ForegroundColor Red }

Paso 'ZeroTier (la red de Fran)'
$zt = Get-Command zerotier-cli.bat -ErrorAction SilentlyContinue
if ($zt) { Ok 'ZeroTier instalado' } else { Mal 'ZeroTier no esta: instalalo de zerotier.com y uni la red que te pasa Fran (sin eso no llega a la note)' }
try { Invoke-WebRequest -UseBasicParsing -TimeoutSec 8 http://10.147.20.2:8765/pack/lista.json | Out-Null; Ok 'la tienda de Fran contesta' }
catch { Mal 'la tienda de Fran no contesta: que Fran abra la tienda en su note y que ZeroTier este conectado; despues volve a correr esto' }

Paso 'Prism Launcher'
$prismData = Join-Path $env:APPDATA 'PrismLauncher'
$prismExe = @("$env:LOCALAPPDATA\Programs\PrismLauncher\prismlauncher.exe", "$env:ProgramFiles\PrismLauncher\prismlauncher.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $prismExe) {
    Write-Host '   no esta instalado: lo instalo con winget...'
    winget install -e --id PrismLauncher.PrismLauncher --accept-package-agreements --accept-source-agreements
    $prismExe = "$env:LOCALAPPDATA\Programs\PrismLauncher\prismlauncher.exe"
}
if (Get-Process prismlauncher -ErrorAction SilentlyContinue) { Get-Process prismlauncher | Stop-Process -Force; Start-Sleep 2 }
New-Item -ItemType Directory -Force (Join-Path $prismData 'instances') | Out-Null
Ok 'Prism presente'

Paso 'Instancia Tienda 1.21.1'
& (Join-Path $aqui 'crear-instancia.ps1') -Prism $prismData

Write-Host "`n=== LISTO ===" -ForegroundColor Green
Write-Host "  1. Abri Prism. Si es la primera vez, agrega tu cuenta (eso lo resolves vos)."
Write-Host "  2. Elegi 'Tienda 1.21.1' y Launch: se pone al dia sola y entra directo al server de Fran."
Write-Host "  Si Fran cambia los mods en la tienda, no tenes que hacer nada: al abrir se actualiza."
if (Test-Path $prismExe) { Start-Process $prismExe }
