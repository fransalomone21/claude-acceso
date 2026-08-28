# instalar-hooks.ps1 -- instala las tres capas de frenos de claude-acceso.
#
# GENERA .claude/settings.json con la raiz MEDIDA de esta maquina, en vez de
# depender de que la ruta absoluta commiteada sea la correcta. Mismo patron
# que perfil-global/install.ps1: la ruta se mide, no se copia a mano.
#
# Idempotente: se puede correr las veces que haga falta.
# Lo que instala se desinstala con .claude\desinstalar-hooks.ps1 (regla 6 del
# perfil: lo que se instala solo tiene que poder desinstalarse solo).
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

$ErrorActionPreference = 'Stop'
$claude = $PSScriptRoot
$raiz   = Split-Path -Parent $claude

Write-Output ""
Write-Output "=== instalar los frenos de claude-acceso ==="
Write-Output "  Raiz: $raiz"
Write-Output ""

# ------------------------------------------------------ capa 1: el SO
Write-Output "capa 1 -- atributo ReadOnly sobre los archivos protegidos"
$cfg = Join-Path $claude 'protegidos.json'
if (-not (Test-Path -LiteralPath $cfg)) { throw "falta $cfg" }
$prot = (Get-Content -LiteralPath $cfg -Raw -Encoding UTF8 | ConvertFrom-Json).archivos

foreach ($a in $prot) {
    if ($a.se_puede_escribir -eq $true) { continue }
    if (-not (Test-Path -LiteralPath $a.ruta)) {
        Write-Output ("  [WARN] $($a.nombre): no esta en esta maquina ($($a.ruta)). Se saltea.")
        continue
    }
    $i = Get-Item -LiteralPath $a.ruta
    if ($i.Attributes -band [System.IO.FileAttributes]::ReadOnly) {
        Write-Output "  [OK]   $($a.nombre) ya estaba en ReadOnly"
    } else {
        Set-ItemProperty -LiteralPath $a.ruta -Name IsReadOnly -Value $true
        Write-Output "  [OK]   $($a.nombre) -> ReadOnly"
    }
}

# ------------------------------------------------ capa 2: los hooks
Write-Output ""
Write-Output "capa 2 -- hooks en .claude/settings.json (ruta medida, no copiada)"

$ps = 'powershell -NoProfile -ExecutionPolicy Bypass -File'
$cmdArranque = "$ps `"$(Join-Path $claude 'hooks\arranque-proyecto.ps1')`""
$cmdGuardia  = "$ps `"$(Join-Path $claude 'hooks\guardia-iso.ps1')`""

$settings = Join-Path $claude 'settings.json'
$obj = $null
if (Test-Path -LiteralPath $settings) {
    try { $obj = Get-Content -LiteralPath $settings -Raw -Encoding UTF8 | ConvertFrom-Json } catch { $obj = $null }
}
if ($null -eq $obj) { $obj = New-Object psobject }

$hooks = [ordered]@{
    SessionStart = @(
        @{ hooks = @( [ordered]@{ type = 'command'; command = $cmdArranque; timeout = 20 } ) }
    )
    PreToolUse = @(
        @{ matcher = 'Bash|PowerShell|Write|Edit|NotebookEdit'
           hooks = @( [ordered]@{ type = 'command'; command = $cmdGuardia; timeout = 15; statusMessage = 'guardia de archivos protegidos' } ) }
    )
}

$obj | Add-Member -NotePropertyName hooks -NotePropertyValue $hooks -Force
$json = $obj | ConvertTo-Json -Depth 12
[System.IO.File]::WriteAllText($settings, $json + "`n", [System.Text.UTF8Encoding]::new($false))
Write-Output "  [OK]   settings.json escrito con las rutas de ESTA maquina"

Write-Output ""
Write-Output "Instalado. Ahora hay que PROBARLO, que es lo que hace que valga algo:"
Write-Output "    .\probar-hooks.ps1"
Write-Output ""
Write-Output "Si la sesion de Claude Code ya estaba abierta cuando se creo"
Write-Output ".claude/settings.json por primera vez, los hooks toman recien al"
Write-Output "reiniciarla (el watcher solo mira carpetas que ya existian al arrancar)."
Write-Output "Para deshacer todo: .claude\desinstalar-hooks.ps1"
