# bootstrap.ps1 -- deja esta maquina lista para trabajar desde claude-acceso.
#
# Idempotente: se puede correr las veces que haga falta.
# Hace tres cosas y nada mas:
#   1. Se asegura de que perfil-global este clonado (es un repo aparte).
#   2. Instala el perfil en ~/.claude y lo verifica.
#   3. Chequea el invariante que ya se rompio una vez: un archivo, un repo dueno.
#
# ASCII puro a proposito: la consola de Windows lee cp1252 y los acentos salen
# mojibake.

$ErrorActionPreference = "Stop"
$raiz = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $raiz

Write-Host ""
Write-Host "=== bootstrap de claude-acceso ===" -ForegroundColor Cyan
Write-Host "  Raiz: $raiz"
Write-Host ""

# --- 1. perfil-global ------------------------------------------------------
$perfil = Join-Path $raiz "perfil-global"
if (-not (Test-Path (Join-Path $perfil ".git"))) {
    if (Test-Path $perfil) {
        Write-Host "  [FAIL] existe perfil-global\ pero SIN .git." -ForegroundColor Red
        Write-Host "         Esa es exactamente la copia huerfana que causo la"
        Write-Host "         divergencia del 2026-08-27 (ver MAPA.md, seccion 4)."
        Write-Host "         Revisar a mano antes de seguir: puede tener trabajo"
        Write-Host "         que no esta en ningun repo."
        exit 1
    }
    Write-Host "  perfil-global no esta. Clonando..." -ForegroundColor Yellow
    git clone https://github.com/fransalomone21/perfil-global.git $perfil
    if ($LASTEXITCODE -ne 0) { Write-Host "  [FAIL] el clone fallo." -ForegroundColor Red; exit 1 }
    Write-Host "  [OK]   perfil-global clonado." -ForegroundColor Green
} else {
    Write-Host "  [OK]   perfil-global presente (repo propio)." -ForegroundColor Green
}

# --- 2. instalar y verificar el perfil -------------------------------------
Write-Host ""
Write-Host "  Instalando el perfil en ~/.claude ..." -ForegroundColor Cyan
& (Join-Path $perfil "install.ps1")
Write-Host ""
Write-Host "  Verificando..." -ForegroundColor Cyan
& (Join-Path $perfil "verify-install.ps1")

# --- 3. el invariante: un archivo, un repo dueno ---------------------------
Write-Host ""
Write-Host "=== invariante: un archivo, un repo dueno ===" -ForegroundColor Cyan
Write-Host "  Una carpeta con su propio .git NO puede estar tracked por claude-acceso."
Write-Host "  Se rompio una vez y costo 23 lecciones perdidas. Ver MAPA.md, seccion 4."
Write-Host ""

$roto = $false
Get-ChildItem -Path $raiz -Directory -Recurse -Depth 3 -Force |
    Where-Object { Test-Path (Join-Path $_.FullName ".git") } |
    ForEach-Object {
        $rel = $_.FullName.Substring($raiz.Length + 1).Replace('\', '/')
        $n = (git ls-files -- "$rel" | Measure-Object -Line).Lines
        if ($n -gt 0) {
            Write-Host "  [FAIL] $rel tiene su propio .git y claude-acceso trackea $n archivo(s)." -ForegroundColor Red
            Write-Host "         Arreglo: git rm -r --cached '$rel'  y agregarlo a .gitignore"
            $roto = $true
        } else {
            Write-Host "  [OK]   $rel : repo propio, 0 archivos tracked aca." -ForegroundColor Green
        }
    }

# Las carpetas ignoradas que no se pueden clonar de ningun lado
$sinRemote = @("proyectos/seguimiento/caso-tio")
foreach ($c in $sinRemote) {
    if (-not (Test-Path (Join-Path $raiz $c))) {
        Write-Host "  [WARN] falta $c y no tiene remote: solo existe en la maquina" -ForegroundColor Yellow
        Write-Host "         donde se creo. Copiarla a mano si hace falta."
    }
}

Write-Host ""
if ($roto) {
    Write-Host "Bootstrap TERMINADO CON PROBLEMAS: ver los [FAIL] de arriba." -ForegroundColor Red
    exit 1
}
Write-Host "Bootstrap OK. Abrir Claude Code en esta carpeta y decir con que proyecto se sigue." -ForegroundColor Green
Write-Host "El enrutador esta en CLAUDE.md; el inventario completo, en MAPA.md."
Write-Host ""
