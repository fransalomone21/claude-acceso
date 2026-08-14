# verify-install.ps1 — Verifica que perfil-global esta instalado correctamente
#
# Ejecutar desde cualquier lugar:
#   .\perfil-global\verify-install.ps1

$dest      = Join-Path $env:USERPROFILE '.claude'
$skillsDir = Join-Path $dest 'claude-code-skills'
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
        Write-Host "  [FAIL] $label — no encontrado en: $path" -ForegroundColor Red
        $script:pass = $false
    }
}

function CheckDir($path, $label) {
    if (Test-Path $path -PathType Container) {
        Write-Host "  [OK]   $label" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $label — carpeta no encontrada: $path" -ForegroundColor Red
        $script:pass = $false
    }
}

Write-Host ""
Write-Host "=== Verificacion de perfil-global ===" -ForegroundColor Cyan
Write-Host "  Destino: $dest"
Write-Host ""

CheckDir  $dest                                                                         '.claude/'
CheckDir  $skillsDir                                                                    '.claude/claude-code-skills/'
CheckFile (Join-Path $dest 'CLAUDE.md')                                                 'CLAUDE.md'
CheckDir  (Join-Path $skillsDir 'engineering-orchestrator')                             '.claude/claude-code-skills/engineering-orchestrator/'
CheckFile (Join-Path $skillsDir 'engineering-orchestrator\SKILL.md')                   'engineering-orchestrator/SKILL.md'

Write-Host ""
if ($pass) {
    Write-Host "Verificacion OK — el perfil global esta instalado correctamente." -ForegroundColor Green
    Write-Host ""
    Write-Host "Notas:"
    Write-Host "  - CLAUDE.md carga automaticamente en toda sesion de Claude Code."
    Write-Host "  - El skill /engineering-orchestrator esta disponible en sesiones"
    Write-Host "    que soporten skills globales (~/.claude/claude-code-skills/)."
    Write-Host "  - Si Claude Code no lo detecta automaticamente, copiar"
    Write-Host "    engineering-orchestrator/ al .claude/ del proyecto concreto."
} else {
    Write-Host "Verificacion FALLIDA — ejecutar .\perfil-global\install.ps1 primero." -ForegroundColor Red
    exit 1
}
Write-Host ""
