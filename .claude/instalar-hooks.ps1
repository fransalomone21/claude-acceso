# instalar-hooks.ps1 -- instala las tres capas de frenos de claude-acceso.
#
# Hasta el 2026-10-02 GENERABA .claude/settings.json con la ruta absoluta de
# esta maquina. Desde la T7 ese archivo va TRACKEADO con "$CLAUDE_PROJECT_DIR"
# (una sola fuente, igual en la PC y en la nube) y aca solo se verifica que
# este y parsee; si un desinstalar le saco los hooks, se restaura del repo.
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
Write-Output "capa 2 -- hooks en .claude/settings.json (trackeado, con `$CLAUDE_PROJECT_DIR)"

# Que hay en settings.json y por que (JSON no lleva comentarios; el porque vive aca):
#  - SessionStart: el texto (arranque-proyecto) y la medicion (arranque-medicion) en hooks
#    separados (2026-09-28, T1): el harness no entrega nada de un hook cortado por timeout.
#  - SessionStart 'compact': la puerta olvida lo leido al compactar (T11).
#  - SessionStart, solo SIN PowerShell (la nube): traer-perfil.sh, el libro primero (regla 16);
#    sale 0 siempre para que su ROJO llegue al contexto en vez de perderse como error.
#  - PreToolUse: guardia-iso (el ISO de BLACK) y la PUERTA de la cascada (T11: 1 de 113
#    entradas leia lo necesario antes de actuar).
#  - PostToolUse: fase_activa (el tipo de la fase abierta) y el registro de la puerta.
# 'command -v powershell || exit 0' es un gate por CAPACIDAD, no por etiqueta: en Windows
# powershell existe siempre (no hay fail-open local); en la nube no hay cascada.ps1 con que
# declarar, asi que la puerta frenaria todo sin salida. Cuando exista cascada.sh (T7 punto 4)
# la puerta deja de llevar el gate. Todo esto lo prueba .claude\probar-settings.py.
$settings = Join-Path $claude 'settings.json'
$obj = $null
try { $obj = Get-Content -LiteralPath $settings -Raw -Encoding UTF8 | ConvertFrom-Json } catch { $obj = $null }
if ($null -eq $obj -or $null -eq $obj.hooks) {
    & git -C $raiz checkout -- .claude/settings.json 2>&1 | Out-Null
    try { $obj = Get-Content -LiteralPath $settings -Raw -Encoding UTF8 | ConvertFrom-Json } catch { $obj = $null }
    if ($null -eq $obj -or $null -eq $obj.hooks) { throw "settings.json sin hooks y no se pudo restaurar del repo" }
    Write-Output "  [OK]   settings.json restaurado del repo (git checkout)"
} else {
    Write-Output "  [OK]   settings.json presente y con hooks (lo trae el repo)"
}

# --------------------------------------------- capa 2b: el hook de git
#
# .git/hooks NO viaja en un clone, asi que este hook desaparece en cada
# maquina nueva. Estaba escrito, versionado en .claude/hooks/ y MEDIDO por
# publicar-apuntes.ps1 -- y no lo instalaba nadie: en la notebook lo habia
# copiado alguien a mano hace meses, y por eso nunca se noto. Medido el
# 2026-09-13, en la PC.
Write-Output ""
Write-Output "capa 2b -- hook post-commit de git (publica el apunte que el commit toco)"
$hookSrc = Join-Path $claude 'hooks\post-commit'
$hookDst = Join-Path $raiz '.git\hooks\post-commit'
if (-not (Test-Path -LiteralPath $hookSrc)) {
    Write-Output "  [WARN] falta la fuente $hookSrc : no se instala nada."
} elseif (-not (Test-Path -LiteralPath (Split-Path -Parent $hookDst))) {
    Write-Output "  [WARN] no hay .git\hooks (no es un repo git?): no se instala nada."
} elseif ((Test-Path -LiteralPath $hookDst) -and
          ((Get-FileHash $hookDst).Hash -eq (Get-FileHash $hookSrc).Hash)) {
    Write-Output "  [OK]   ya estaba instalado e identico a la fuente"
} else {
    Copy-Item -LiteralPath $hookSrc -Destination $hookDst -Force
    Write-Output "  [OK]   post-commit instalado en .git\hooks"
}
Write-Output ""
Write-Output "Instalado. Ahora hay que PROBARLO, que es lo que hace que valga algo:"
Write-Output "    .\probar-hooks.ps1"
Write-Output ""
Write-Output "Si la sesion de Claude Code ya estaba abierta cuando se creo"
Write-Output ".claude/settings.json por primera vez, los hooks toman recien al"
Write-Output "reiniciarla (el watcher solo mira carpetas que ya existian al arrancar)."
Write-Output "Para deshacer todo: .claude\desinstalar-hooks.ps1"
