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

# --- 3. Archivos sueltos que van a ~/.claude/ ---
# recordatorio-transversal.md lo lee el hook UserPromptSubmit en cada prompt.
$sueltos = @('recordatorio-transversal.md')
foreach ($nombre in $sueltos) {
    $src = Join-Path $source $nombre
    if (Test-Path $src) {
        Copy-Item $src (Join-Path $dest $nombre) -Force
        Ok "$nombre -> $dest"
    } else {
        Warn "No se encontro $nombre en $source"
    }
}

# --- 4. Hook UserPromptSubmit en settings.json ---
# Es el unico mecanismo que corre SIEMPRE, sin depender de que alguien
# invoque una skill. Ver leccion 11 de lecciones-aprendidas.
$settingsPath = Join-Path $dest 'settings.json'
$hookCmd = 'powershell -NoProfile -Command "Get-Content -Raw -ErrorAction SilentlyContinue ((Join-Path $env:USERPROFILE ''.claude\recordatorio-transversal.md''))"'

try {
    if (Test-Path $settingsPath) {
        Copy-Item $settingsPath "$settingsPath.bak-$now" -Force
        $settings = Get-Content -Raw $settingsPath | ConvertFrom-Json
    } else {
        $settings = New-Object PSObject
    }

    $yaEsta = $false
    if ($settings.PSObject.Properties.Name -contains 'hooks') {
        $json = $settings.hooks | ConvertTo-Json -Depth 10
        if ($json -match 'recordatorio-transversal') { $yaEsta = $true }
    }

    if ($yaEsta) {
        Info "El hook del recordatorio ya estaba configurado."
    } else {
        $entrada = [PSCustomObject]@{
            hooks = @([PSCustomObject]@{ type = 'command'; command = $hookCmd })
        }
        if ($settings.PSObject.Properties.Name -contains 'hooks') {
            $h = $settings.hooks
            if ($h.PSObject.Properties.Name -contains 'UserPromptSubmit') {
                $h.UserPromptSubmit = @($h.UserPromptSubmit) + $entrada
            } else {
                $h | Add-Member -NotePropertyName 'UserPromptSubmit' -NotePropertyValue @($entrada)
            }
        } else {
            $nuevo = [PSCustomObject]@{ UserPromptSubmit = @($entrada) }
            $settings | Add-Member -NotePropertyName 'hooks' -NotePropertyValue $nuevo
        }
        $settings | ConvertTo-Json -Depth 10 | Out-File $settingsPath -Encoding utf8
        Ok "Hook UserPromptSubmit agregado en $settingsPath"
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
