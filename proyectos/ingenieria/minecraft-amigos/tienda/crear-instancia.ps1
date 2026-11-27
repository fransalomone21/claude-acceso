# Crea (o pone al dia) la instancia "Tienda 1.21.1" (o "Tienda 1.21.4" con -Version 1.21.4: Fabric, el mundo con
# Agus) de Prism Launcher: Minecraft + el cargador de la tienda (L1-01, L1-20),
# memoria segun la maquina, entra directo al server de la tienda, y el comando previo que la iguala al pack
# publicado cada vez que se abre el juego (L1-04). Los mundos de la instancia no se tocan.
# Uso: .\crear-instancia.ps1                       (Prism instalado normal)
#      .\crear-instancia.ps1 -Prism "D:\Prism"     (Prism portable: la carpeta de datos de Prism)
#      .\crear-instancia.ps1 -Version 1.21.4       (la tienda del mundo con Agus: pack en :8766, server en :25569)
param(
    [string]$Prism = (Join-Path $env:APPDATA "PrismLauncher"),
    [string]$Notebook = "10.147.20.2",
    [ValidateSet("1.21.1", "1.21.4")][string]$Version = "1.21.1",
    [string]$NeoForge = "21.1.267",
    [string]$FabricLoader = "0.19.3",
    [int]$MemoriaMB = 0
)
$PuertoWeb = if ($Version -eq "1.21.4") { 8766 } else { 8765 }
$PuertoServer = if ($Version -eq "1.21.4") { 25569 } else { 25568 }
$Nombre = "Tienda $Version"
$Pack = "http://${Notebook}:${PuertoWeb}/pack/lista.json"
if ($MemoriaMB -le 0) {
    $ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    $MemoriaMB = if ($ramGB -ge 15) { 8192 } elseif ($ramGB -ge 11) { 6144 } else { 4096 }
}
$inst = Join-Path $Prism "instances\$Nombre"
New-Item -ItemType Directory -Force (Join-Path $inst ".minecraft\mods") | Out-Null
Copy-Item -LiteralPath (Join-Path $PSScriptRoot "sincronizar.ps1") -Destination (Join-Path $inst "sincronizar.ps1") -Force
$cfg = @"
[General]
ConfigVersion=1.2
InstanceType=OneSix
iconKey=default
name=$Nombre
OverrideMemory=true
MinMemAlloc=2048
MaxMemAlloc=$MemoriaMB
OverrideCommands=true
PreLaunchCommand=powershell -NoProfile -ExecutionPolicy Bypass -File "`$INST_DIR/sincronizar.ps1" -Pack $Pack -Mods "`$INST_MC_DIR/mods"
JoinServerOnLaunch=true
JoinServerOnLaunchAddress=${Notebook}:${PuertoServer}
"@
[IO.File]::WriteAllText((Join-Path $inst "instance.cfg"), $cfg.Replace("`r`n", "`n"), (New-Object Text.UTF8Encoding $false))
$mmc = if ($Version -eq "1.21.4") {
    '{"components":[{"important":true,"uid":"net.minecraft","version":"1.21.4"},{"uid":"net.fabricmc.intermediary","version":"1.21.4"},{"uid":"net.fabricmc.fabric-loader","version":"' + $FabricLoader + '"}],"formatVersion":1}'
} else {
    '{"components":[{"important":true,"uid":"net.minecraft","version":"1.21.1"},{"uid":"net.neoforged","version":"' + $NeoForge + '"}],"formatVersion":1}'
}
[IO.File]::WriteAllText((Join-Path $inst "mmc-pack.json"), $mmc, (New-Object Text.UTF8Encoding $false))
# primera sincronizacion ya, para que el primer arranque no espere la bajada
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $inst "sincronizar.ps1") -Pack $Pack -Mods (Join-Path $inst ".minecraft\mods")
"instancia: $inst (memoria $MemoriaMB MB, entra a ${Notebook}:${PuertoServer})"
