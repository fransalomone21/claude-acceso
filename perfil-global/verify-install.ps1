# verify-install.ps1 - Verifica que perfil-global esta instalado correctamente
# NOTA: ASCII puro - no usar tildes ni caracteres especiales en este archivo.
#
# Ejecutar desde cualquier lugar:
#   .\perfil-global\verify-install.ps1
#
# O pasando la ruta del repo (para saber que skills deberian estar instaladas):
#   .\perfil-global\verify-install.ps1 -RepoRoot "C:\ruta\al\repo"

param(
    [string]$RepoRoot = (Split-Path $PSScriptRoot -Parent)
)

$source    = Join-Path $RepoRoot 'perfil-global'
$dest      = Join-Path $env:USERPROFILE '.claude'
$skillsDir = Join-Path $dest 'skills'
$pass      = $true

function CheckFile($path, $label) {
    if (Test-Path $path) {
        $size = (Get-Item $path).Length
        if ($size -gt 10) {
            Write-Host "  [OK]   $label ($size bytes)" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] $label existe pero parece vacio ($size bytes)" -ForegroundColor Red
            $script:pass = $false
        }
    } else {
        Write-Host "  [FAIL] $label - no encontrado en: $path" -ForegroundColor Red
        $script:pass = $false
    }
}

function CheckDir($path, $label) {
    if (Test-Path $path -PathType Container) {
        Write-Host "  [OK]   $label" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $label - carpeta no encontrada: $path" -ForegroundColor Red
        $script:pass = $false
    }
}

Write-Host ""
Write-Host "=== Verificacion de perfil-global ===" -ForegroundColor Cyan
Write-Host "  Destino: $dest"
Write-Host ""

CheckDir  $dest                          '.claude/'
CheckDir  $skillsDir                     '.claude/skills/'
CheckFile (Join-Path $dest 'CLAUDE.md')  'CLAUDE.md'

if (Test-Path $source) {
    $skillDirs = Get-ChildItem -Path $source -Directory -ErrorAction SilentlyContinue
    foreach ($dir in $skillDirs) {
        $skillName = $dir.Name
        $skillSrc  = Join-Path $dir.FullName 'SKILL.md'
        if (Test-Path $skillSrc) {
            CheckDir  (Join-Path $skillsDir $skillName)              ".claude/skills/$skillName/"
            CheckFile (Join-Path $skillsDir "$skillName\SKILL.md")   "$skillName/SKILL.md"
        }
    }
} else {
    Write-Host "  [WARN] No se encontro perfil-global en $source - no se puede listar que skills esperar." -ForegroundColor Yellow
}

Write-Host ""
if ($pass) {
    Write-Host "Verificacion OK - el perfil global esta instalado correctamente." -ForegroundColor Green
    Write-Host ""
    Write-Host "Notas:"
    Write-Host "  - CLAUDE.md carga automaticamente en toda sesion de Claude Code."
    Write-Host "  - Las skills en ~/.claude/skills/<nombre>/ se invocan con /<nombre>"
    Write-Host "    o Claude las usa solas cuando son relevantes."
    Write-Host "  - Si ~/.claude/skills/ no existia al iniciar la sesion de Claude"
    Write-Host "    Code, hay que reiniciarla una vez para que la detecte."
} else {
    Write-Host "Verificacion FALLIDA - ejecutar .\perfil-global\install.ps1 primero." -ForegroundColor Red
    exit 1
}
Write-Host ""
