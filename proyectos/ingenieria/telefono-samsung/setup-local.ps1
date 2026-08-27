# setup-local.ps1 - Prepara el entorno local completo para el proyecto BLACK
# NOTA: Este archivo debe mantenerse en ASCII puro (sin tildes ni caracteres
#       especiales) para que PowerShell en Windows lo pueda leer sin importar
#       la configuracion de codificacion del sistema.
#
# Ejecutar UNA VEZ desde la raiz del repo despues de clonar o hacer git pull:
#   .\setup-local.ps1

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$ok   = $true

function Ok($msg)   { Write-Host "  [OK]   $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Fail($msg) { Write-Host "  [FAIL] $msg" -ForegroundColor Red; $script:ok = $false }
function Step($msg) { Write-Host ""; Write-Host "--- $msg ---" -ForegroundColor Cyan }

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Setup local - proyecto BLACK / claude-acceso" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# -----------------------------------------------------------------------
Step "1/4  Perfil global de Claude"
# -----------------------------------------------------------------------
$installScript = Join-Path $root 'perfil-global\install.ps1'
if (Test-Path $installScript) {
    & $installScript
    if ($LASTEXITCODE -ne 0) {
        Fail "install.ps1 termino con error $LASTEXITCODE"
    }
} else {
    Fail "No se encontro perfil-global\install.ps1"
    Fail "Verificar que se ejecuta desde la raiz del repo."
}

# -----------------------------------------------------------------------
Step "2/4  Python 3.11+"
# -----------------------------------------------------------------------
$py = $null
foreach ($cmd in @('python', 'python3')) {
    try {
        $ver = & $cmd --version 2>&1
        if ($ver -match '3\.(1[1-9]|[2-9]\d)') {
            Ok "$cmd -> $ver"
            $py = $cmd
            break
        }
    } catch {}
}
if (-not $py) {
    Fail "Python 3.11+ no encontrado. Instalar desde https://python.org y volver a correr este script."
} else {
    $np = & $py -c "import numpy; print('numpy', numpy.__version__)" 2>&1
    if ($LASTEXITCODE -eq 0) {
        Ok $np
    } else {
        Warn "numpy no instalado. Instalando..."
        & $py -m pip install numpy --quiet
        if ($LASTEXITCODE -eq 0) {
            Ok "numpy instalado"
        } else {
            Warn "numpy no se pudo instalar - el primer filtro tendra que ser por valor exacto"
        }
    }
}

# -----------------------------------------------------------------------
Step "3/4  Carpetas locales"
# -----------------------------------------------------------------------
foreach ($d in @('black\volcados', 'black\construido')) {
    $path = Join-Path $root $d
    New-Item -ItemType Directory -Force -Path $path | Out-Null
    Ok "$d/"
}

# -----------------------------------------------------------------------
Step "4/4  Pruebas de herramientas (sin PCSX2)"
# -----------------------------------------------------------------------
if ($py) {
    $testScript = Join-Path $root 'black\pruebas\prueba_herramientas.py'
    if (Test-Path $testScript) {
        Write-Host ""
        Push-Location (Join-Path $root 'black')
        & $py pruebas/prueba_herramientas.py
        $testExit = $LASTEXITCODE
        Pop-Location
        if ($testExit -eq 0) {
            Ok "Pruebas pasaron"
        } else {
            Fail "Pruebas fallaron (ver output arriba)"
        }
    } else {
        Warn "prueba_herramientas.py no encontrado - salteando"
    }
}

# -----------------------------------------------------------------------
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
if ($ok) {
    Write-Host "  Setup OK" -ForegroundColor Green
} else {
    Write-Host "  Setup con errores - resolver los FAIL de arriba" -ForegroundColor Red
}
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "SIGUIENTES PASOS:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  A) Configurar PCSX2 (hacer solo una vez por maquina):"
Write-Host "     cd black\herramientas\windows"
Write-Host "     .\preparar_entorno.ps1"
Write-Host "     (Pide UAC - aceptar. Con ISO: .\preparar_entorno.ps1 -IsoPath 'D:\BLACK.iso')"
Write-Host ""
Write-Host "  B) Retomar el escaneo de la vida del jugador:"
Write-Host "     cd black"
Write-Host "     python herramientas\escanear.py filtrar prueba-auto bajo"
Write-Host "     (Si prueba-auto ya no existe: crear nueva sesion con 'nuevo')"
Write-Host ""
Write-Host "  Abrir Claude Code local en esta carpeta para continuar." -ForegroundColor Cyan
Write-Host ""
