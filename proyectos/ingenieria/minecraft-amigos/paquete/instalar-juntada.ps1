# instalar-juntada.ps1 -- deja la instancia "Juntada 1.21.4" lista en el Prism de esta PC,
# con graficos y RAM elegidos segun la maquina. Lo llama instalar-juntada.bat (doble clic).
# Se puede correr de nuevo: pisa la instancia (los mundos locales en saves/ se conservan).
param([ValidateSet('auto','alto','medio','bajo')][string]$Preset = 'auto')

$ErrorActionPreference = 'Continue'
$aqui     = Split-Path -Parent $MyInvocation.MyCommand.Path
$zip      = Join-Path $aqui 'juntada-1.21.4.zip'
$servidor = '10.147.20.2'
$nombre   = 'Juntada 1.21.4'

function Paso($m) { Write-Host "`n>> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "   [OK] $m" -ForegroundColor Green }
function Mal($m)  { Write-Host "   [X]  $m" -ForegroundColor Red }

if (-not (Test-Path $zip)) { Mal "falta juntada-1.21.4.zip al lado de este archivo"; exit 1 }

# 1. Prism ----------------------------------------------------------------
Paso 'Prism Launcher'
$prismData = Join-Path $env:APPDATA 'PrismLauncher'
$prismExe  = @("$env:LOCALAPPDATA\Programs\PrismLauncher\prismlauncher.exe",
               "$env:ProgramFiles\PrismLauncher\prismlauncher.exe") | ? { Test-Path $_ } | select -First 1
if (-not $prismExe -and -not (Test-Path $prismData)) {
    Write-Host '   no esta instalado: lo instalo con winget...'
    winget install -e --id PrismLauncher.PrismLauncher --accept-package-agreements --accept-source-agreements
    $prismExe = "$env:LOCALAPPDATA\Programs\PrismLauncher\prismlauncher.exe"
}
if (Get-Process prismlauncher -ErrorAction SilentlyContinue) {
    Write-Host '   cierro Prism para instalar la instancia...'
    Get-Process prismlauncher | Stop-Process -Force; Start-Sleep 2
}
New-Item -ItemType Directory -Force (Join-Path $prismData 'instances') | Out-Null
Ok 'Prism presente'

# 2. Instancia ------------------------------------------------------------
Paso 'Instancia'
$inst  = Join-Path $prismData "instances\$nombre"
$saves = Join-Path $inst '.minecraft\saves'
$tmpSaves = $null
if (Test-Path $saves) { $tmpSaves = Join-Path $env:TEMP 'juntada-saves'; Remove-Item $tmpSaves -Recurse -Force -EA SilentlyContinue; Move-Item $saves $tmpSaves }
if (Test-Path $inst) { Remove-Item $inst -Recurse -Force }
Expand-Archive $zip -DestinationPath $inst -Force
if ($tmpSaves) { Move-Item $tmpSaves $saves }
Ok "instalada en $inst ($((Get-ChildItem "$inst\.minecraft\mods" -Filter *.jar).Count) mods)"

# 3. La maquina -----------------------------------------------------------
Paso 'Midiendo esta PC'
$gpus  = (Get-CimInstance Win32_VideoController).Name
$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$dedicada = $gpus | ? { $_ -match 'NVIDIA|Radeon RX|Radeon Pro|Arc A' } | select -First 1
Write-Host "   GPU: $($gpus -join ' + ')"
Write-Host "   RAM: $ramGB GB"
if ($Preset -eq 'auto') {
    if ($dedicada -and $ramGB -ge 16) { $Preset = 'alto' }
    elseif ($ramGB -ge 12)            { $Preset = 'medio' }
    else                              { $Preset = 'bajo' }
}
#            RAM-MB render sim  graf part ent   nubes   shaders fps
$tabla = @{
  alto  = @(6144, 12, 8, 1, 0, '1.0',  '"fast"',  $true,  0)
  medio = @(4096,  8, 6, 0, 1, '0.75', '"false"', $false, 75)
  bajo  = @(3072,  6, 5, 0, 2, '0.5',  '"false"', $false, 60)
}
$t = $tabla[$Preset]
Ok "perfil: $($Preset.ToUpper())  (RAM $($t[0]) MB, distancia $($t[1]), shaders $($t[7]))"

# 4. instance.cfg: RAM, Java automatico, entrar directo al server ---------
$cfgPath = Join-Path $inst 'instance.cfg'
$cfg = Get-Content $cfgPath
$poner = [ordered]@{
  name = $nombre; OverrideMemory = 'true'; MaxMemAlloc = "$($t[0])"; MinMemAlloc = '1024'
  OverrideJavaLocation = 'false'; JavaPath = ''; AutomaticJava = 'true'
  JoinServerOnLaunch = 'true'; JoinServerOnLaunchAddress = $servidor
}
foreach ($k in $poner.Keys) {
  if ($cfg -match "^$k=") { $cfg = $cfg -replace "^$k=.*", "$k=$($poner[$k])" } else { $cfg += "$k=$($poner[$k])" }
}
Set-Content $cfgPath $cfg -Encoding ascii

# 5. options.txt: graficos ------------------------------------------------
$optPath = Join-Path $inst '.minecraft\options.txt'
$opt = Get-Content $optPath
$g = [ordered]@{
  renderDistance = $t[1]; simulationDistance = $t[2]; graphicsMode = $t[3]; particles = $t[4]
  entityDistanceScaling = $t[5]; renderClouds = $t[6]; maxFps = $t[8]; enableVsync = 'false'
  biomeBlendRadius = $(if ($Preset -eq 'alto') { 2 } else { 0 }); mipmapLevels = $(if ($Preset -eq 'bajo') { 0 } else { 2 })
}
foreach ($k in $g.Keys) {
  if ($opt -match "^${k}:") { $opt = $opt -replace "^${k}:.*", "${k}:$($g[$k])" } else { $opt += "${k}:$($g[$k])" }
}
# sin BOM: con BOM Minecraft no reconoce la primera linea (version:) y resetea las opciones
[IO.File]::WriteAllLines($optPath, [string[]]$opt, (New-Object Text.UTF8Encoding $false))

# 6. Iris: shaders solo en placa dedicada ---------------------------------
$irisPath = Join-Path $inst '.minecraft\config\iris.properties'
$iris = (Get-Content $irisPath) -replace '^enableShaders=.*', "enableShaders=$($t[7].ToString().ToLower())" `
                                -replace '^shaderPack=.*', 'shaderPack=ComplementaryReimagined_r5.8.1.zip'
Set-Content $irisPath $iris -Encoding ascii

# 7. Notebooks con dos placas: que Java use la dedicada -------------------
if ($dedicada) {
  $reg = 'HKCU:\Software\Microsoft\DirectX\UserGpuPreferences'
  New-Item $reg -Force | Out-Null
  $javas = Get-ChildItem (Join-Path $prismData 'java') -Recurse -Filter javaw.exe -EA SilentlyContinue | % FullName
  $javas += Join-Path $prismData 'java\java-runtime-delta\bin\javaw.exe'
  foreach ($j in ($javas | select -Unique)) { New-ItemProperty $reg -Name $j -Value 'GpuPreference=2;' -PropertyType String -Force | Out-Null }
  Ok "Java va a usar la placa dedicada ($dedicada)"
}

# 8. ZeroTier --------------------------------------------------------------
Paso 'ZeroTier'
$zt = Get-Command zerotier-cli.bat -EA SilentlyContinue
if ($zt) {
  $red = & zerotier-cli.bat listnetworks 2>$null | Select-String 'bb720a5aae15d3a9'
  if ($red -match ' OK ') { Ok "conectado a la red de franquiito: $(($red -split ' ')[-1])" }
  else { Mal 'ZeroTier esta, pero esta PC no esta en la red de franquiito (o falta que Fran la autorice)' }
} else { Mal 'ZeroTier no esta instalado (si estan en el mismo wifi, igual pueden entrar)' }

Write-Host "`n=== LISTO ===" -ForegroundColor Green
Write-Host "  Abri Prism, elegi '$nombre' y Launch: entra solo al server ($servidor)."
Write-Host "  Graficos: perfil $($Preset.ToUpper()). Para cambiarlo: instalar-juntada.bat alto | medio | bajo"
Write-Host "  En el juego, F3+T no hace falta; Opciones > Video para ajustar fino (Sodium)."
if ($prismExe) { Start-Process $prismExe }
