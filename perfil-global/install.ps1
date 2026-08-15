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
        $skillDst    = Join-Path $skillDstDir 'SKILL.md'

        New-Item -ItemType Directory -Force -Path $skillDstDir | Out-Null
        Copy-Item $skillSrc $skillDst -Force
        Ok "$skillName/SKILL.md -> $skillDst"
    }
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
