# Crea (o pone al dia) la instancia "Tienda 1.21.1" de Prism Launcher: Minecraft 1.21.1 + NeoForge de la tienda,
# memoria segun la maquina, entra directo al server de la tienda, y el comando previo que la iguala al pack
# publicado cada vez que se abre el juego (L1-04). Los mundos de la instancia no se tocan.
# Uso: .\crear-instancia.ps1                       (Prism instalado normal)
#      .\crear-instancia.ps1 -Prism "D:\Prism"     (Prism portable: la carpeta de datos de Prism)
param(
    [string]$Prism = (Join-Path $env:APPDATA "PrismLauncher"),
    [string]$Notebook = "10.147.20.2",
    [string]$NeoForge = "21.1.267",
    [int]$MemoriaMB = 0
)
$Pack = "http://${Notebook}:8765/pack/lista.json"
if ($MemoriaMB -le 0) {
    $ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $MemoriaMB = if ($ramGB -ge 15) { 8192 } elseif ($ramGB -ge 11) { 6144 } else { 4096 }
}
$inst = Join-Path $Prism "instances\Tienda 1.21.1"
New-Item -ItemType Directory -Force (Join-Path $inst ".minecraft\mods") | Out-Null
Copy-Item -LiteralPath (Join-Path $PSScriptRoot "sincronizar.ps1") -Destination (Join-Path $inst "sincronizar.ps1") -Force
$cfg = @"
[General]
ConfigVersion=1.2
InstanceType=OneSix
iconKey=default
name=Tienda 1.21.1
OverrideMemory=true
MinMemAlloc=2048
MaxMemAlloc=$MemoriaMB
OverrideCommands=true
PreLaunchCommand=powershell -NoProfile -ExecutionPolicy Bypass -File "`$INST_DIR/sincronizar.ps1" -Pack $Pack -Mods "`$INST_MC_DIR/mods"
JoinServerOnLaunch=true
JoinServerOnLaunchAddress=${Notebook}:25568
"@
[IO.File]::WriteAllText((Join-Path $inst "instance.cfg"), $cfg.Replace("`r`n", "`n"), (New-Object Text.UTF8Encoding $false))
$mmc = '{"components":[{"important":true,"uid":"net.minecraft","version":"1.21.1"},{"uid":"net.neoforged","version":"' + $NeoForge + '"}],"formatVersion":1}'
[IO.File]::WriteAllText((Join-Path $inst "mmc-pack.json"), $mmc, (New-Object Text.UTF8Encoding $false))
# primera sincronizacion ya, para que el primer arranque no espere la bajada
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $inst "sincronizar.ps1") -Pack $Pack -Mods (Join-Path $inst ".minecraft\mods")
"instancia: $inst (memoria $MemoriaMB MB, entra a ${Notebook}:25568)"
