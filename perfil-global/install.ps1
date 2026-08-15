# install.ps1 - Instala perfil-global en %USERPROFILE%\.claude\
# NOTA: ASCII puro - no usar tildes ni caracteres especiales en este archivo.
#
# Ejecutar desde la RAIZ del repositorio:
#   .\perfil-global\install.ps1
#
# O desde cualquier lugar pasando la ruta del repo:
#   .\perfil-global\install.ps1 -RepoRoot "C:\ruta\al\repo"

param(
    [string]$RepoRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = 'Stop'

$source    = Join-Path $RepoRoot 'perfil-global'
$dest      = Join-Path $env:USERPROFILE '.claude'
# NOTA: la carpeta correcta que Claude Code detecta para skills personales
# es ~/.claude/skills/ (NO claude-code-skills/). Ver docs oficiales:
# https://code.claude.com/docs/en/skills#where-skills-live
$skillsDir = Join-Path $dest 'skills'
$now       = Get-Date -Format 'yyyyMMdd-HHmmss'
$ok        = $true

function Info($msg)  { Write-Host "  $msg" }
function Ok($msg)    { Write-Host "  [OK]   $msg" -ForegroundColor Green }
function Warn($msg)  { Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Fail($msg)  { Write-Host "  [FAIL] $msg" -ForegroundColor Red; $script:ok = $false }

Write-Host ""
Write-Host "=== Instalacion de perfil-global ===" -ForegroundColor Cyan
Write-Host "  Fuente : $source"
Write-Host "  Destino: $dest"
Write-Host ""

if (-not (Test-Path $source)) {
    Fail "No se encontro 'perfil-global' en: $source"
    Fail "Verificar que se ejecuta desde la raiz del repositorio."
    exit 1
}

New-Item -ItemType Directory -Force -Path $dest      | Out-Null
New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null
Info "Carpetas destino verificadas."

# --- 1. CLAUDE.md global ---
$claudeSrc = Join-Path $source 'CLAUDE.md'
$claudeDst = Join-Path $dest 'CLAUDE.md'

if (-not (Test-Path $claudeSrc)) {
    Fail "Falta fuente: $claudeSrc"
} else {
    if (Test-Path $claudeDst) {
        $backup = "$claudeDst.bak-$now"
        Copy-Item $claudeDst $backup
        Warn "Respaldo del CLAUDE.md anterior: $backup"
    }
    Copy-Item $claudeSrc $claudeDst -Force
    Ok "CLAUDE.md -> $claudeDst"
}

# --- 2. Todas las skills de perfil-global/<nombre>/SKILL.md ---
# Cualquier carpeta nueva con SKILL.md que se agregue a perfil-global/ se
# instala automaticamente, sin tener que tocar este script.
#
# Se copia la CARPETA ENTERA, no solo el SKILL.md: una skill puede traer
# subcarpetas (por ejemplo referencias/) que se leen bajo demanda. Copiar
# solo el SKILL.md dejaba esos archivos sin instalar y los enlaces internos
# apuntaban a la nada. Ver leccion 7 de lecciones-aprendidas.
$skillDirs = Get-ChildItem -Path $source -Directory -ErrorAction SilentlyContinue

if (-not $skillDirs -or $skillDirs.Count -eq 0) {
    Warn "No se encontraron subcarpetas de skills en: $source"
} else {
    foreach ($dir in $skillDirs) {
        $skillName = $dir.Name
        $skillSrc  = Join-Path $dir.FullName 'SKILL.md'

        if (-not (Test-Path $skillSrc)) {
            continue
        }

        $skillDstDir = Join-Path $skillsDir $skillName

        New-Item -ItemType Directory -Force -Path $skillDstDir | Out-Null
        Copy-Item -Path (Join-Path $dir.FullName '*') -Destination $skillDstDir -Recurse -Force

        $extra = Get-ChildItem -Path $skillDstDir -Recurse -File |
                 Where-Object { $_.Name -ne 'SKILL.md' }
        if ($extra) {
            Ok "$skillName -> $skillDstDir  (SKILL.md + $($extra.Count) archivo(s) de apoyo)"
        } else {
            Ok "$skillName/SKILL.md -> $skillDstDir"
        }
    }
}

# --- 3. Archivos que lee cada hook, y su evento ---
# Los hooks son el unico mecanismo que corre SIEMPRE, sin depender de que
# alguien invoque una skill. Ver leccion 11 de lecciones-aprendidas.
#
#   SessionStart      dispara UNA vez por sesion  -> puede ser largo
#   UserPromptSubmit  dispara en CADA prompt      -> tiene que ser corto
#
# Los .md van en ASCII a proposito: la consola de Windows los lee como cp1252
# y los acentos salen mojibake.
$ganchos = @(
    @{ Evento = 'SessionStart';     Archivo = 'apertura-proyecto.md' },
    @{ Evento = 'UserPromptSubmit'; Archivo = 'recordatorio-transversal.md' }
)

foreach ($g in $ganchos) {
    $src = Join-Path $source $g.Archivo
    if (Test-Path $src) {
        Copy-Item $src (Join-Path $dest $g.Archivo) -Force
        Ok "$($g.Archivo) -> $dest"
    } else {
        Warn "No se encontro $($g.Archivo) en $source"
    }
}

# --- 4. Registrar los hooks en settings.json ---
$settingsPath = Join-Path $dest 'settings.json'

try {
    if (Test-Path $settingsPath) {
        Copy-Item $settingsPath "$settingsPath.bak-$now" -Force
        $settings = Get-Content -Raw $settingsPath | ConvertFrom-Json
    } else {
        $settings = New-Object PSObject
    }

    if (-not ($settings.PSObject.Properties.Name -contains 'hooks')) {
        $settings | Add-Member -NotePropertyName 'hooks' -NotePropertyValue (New-Object PSObject)
    }
    $h = $settings.hooks
    $cambio = $false

    foreach ($g in $ganchos) {
        $evento  = $g.Evento
        $archivo = $g.Archivo
        $hookCmd = 'powershell -NoProfile -Command "Get-Content -Raw -ErrorAction SilentlyContinue ((Join-Path $env:USERPROFILE ''.claude\' + $archivo + '''))"'

        # Marcador de deduplicacion: el nombre del archivo dentro del comando.
        $marcador = [regex]::Escape($archivo)
        $yaEsta = $false
        if ($h.PSObject.Properties.Name -contains $evento) {
            $json = $h.$evento | ConvertTo-Json -Depth 10
            if ($json -match $marcador) { $yaEsta = $true }
        }

        if ($yaEsta) {
            Info "Hook $evento ($archivo) ya estaba configurado."
            continue
        }

        $entrada = [PSCustomObject]@{
            hooks = @([PSCustomObject]@{ type = 'command'; command = $hookCmd })
        }
        if ($h.PSObject.Properties.Name -contains $evento) {
            $h.$evento = @($h.$evento) + $entrada
        } else {
            $h | Add-Member -NotePropertyName $evento -NotePropertyValue @($entrada)
        }
        Ok "Hook $evento agregado ($archivo)"
        $cambio = $true
    }

    if ($cambio) {
        $settings | ConvertTo-Json -Depth 10 | Out-File $settingsPath -Encoding utf8
        Ok "settings.json actualizado: $settingsPath"
    }

    # skipWorkflowUsageWarning silencia el aviso de costo de los workflows.
    # Es un freno del sistema: si esta apagado, se avisa.
    if ($settings.PSObject.Properties.Name -contains 'skipWorkflowUsageWarning' -and
        $settings.skipWorkflowUsageWarning -eq $true) {
        Warn "skipWorkflowUsageWarning esta en true: el aviso de costo de los"
        Warn "workflows esta silenciado. Conviene sacarlo de settings.json."
    }
} catch {
    Warn "No se pudo actualizar settings.json automaticamente: $($_.Exception.Message)"
    Warn "Agregar el hook UserPromptSubmit a mano. Hay respaldo en $settingsPath.bak-$now"
}

Write-Host ""
if ($ok) {
    Write-Host "Instalacion completada." -ForegroundColor Green
    Write-Host "Verificar con: .\perfil-global\verify-install.ps1"
    Write-Host ""
    Write-Host "IMPORTANTE: si ~/.claude/skills/ no existia antes de esta" -ForegroundColor Yellow
    Write-Host "instalacion, reiniciar Claude Code para que detecte la" -ForegroundColor Yellow
    Write-Host "carpeta nueva (solo hace falta la primera vez)." -ForegroundColor Yellow
} else {
    Write-Host "Instalacion con errores - revisar los mensajes FAIL de arriba." -ForegroundColor Red
    exit 1
}
Write-Host ""
