# bootstrap.ps1 -- deja esta maquina lista para trabajar desde claude-acceso.
#
# Idempotente: se puede correr las veces que haga falta.
# Hace tres cosas y nada mas:
#   1. Se asegura de que perfil-global este clonado (es un repo aparte).
#   2. Instala el perfil en ~/.claude y lo verifica.
#   3. Corre verificar-estructura.ps1: las cuatro reglas del CLAUDE.md,
#      ejecutables, incluida la del invariante que ya se rompio una vez.
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

# --- 0. lo que la maquina tiene que tener antes de nada ---------------------
#
# Este bloque no estaba, y en la notebook nunca hizo falta: todo estaba
# instalado de antes. En una maquina nueva, faltar python hace que el medidor
# de triage salga en rojo hablando de lecciones, y faltar rclone hace que el
# de Drive hable de MD5 -- dos mensajes que no nombran la causa real. El
# sintoma se parece a un problema del sistema y es una dependencia ausente.
#
# MIDE Y REPORTA, no instala: instalar en una maquina que no es la que uno
# esta mirando es una accion que no se deshace sola (regla 6 del perfil).
Write-Host "  Dependencias de la maquina:" -ForegroundColor Cyan
$deps = @(
    @{ cmd = 'git';    que = 'todo';                          winget = 'Git.Git';         critica = $true  },
    @{ cmd = 'python'; que = 'aprender.py (medidor de triage)'; winget = 'Python.Python.3.12'; critica = $true  },
    @{ cmd = 'rclone'; que = 'publicar-apuntes.ps1 (medidor de Drive)'; winget = 'Rclone.Rclone'; critica = $false },
    @{ cmd = 'typst';  que = 'compilar apuntes e informes';    winget = 'Typst.Typst';     critica = $false }
)
$faltaCritica = $false
foreach ($d in $deps) {
    if (Get-Command $d.cmd -ErrorAction SilentlyContinue) {
        Write-Host "  [OK]   $($d.cmd)" -ForegroundColor Green
    } elseif ($d.critica) {
        Write-Host "  [FAIL] falta $($d.cmd) -- lo necesita: $($d.que)" -ForegroundColor Red
        Write-Host "         winget install --id $($d.winget)"
        $faltaCritica = $true
    } else {
        Write-Host "  [WARN] falta $($d.cmd) -- lo necesita: $($d.que)" -ForegroundColor Yellow
        Write-Host "         winget install --id $($d.winget)"
    }
}
if ($faltaCritica) {
    Write-Host ""
    Write-Host "  Se corta aca: sin eso el resto del bootstrap reporta sintomas que no" -ForegroundColor Red
    Write-Host "  nombran la causa. Instalar y volver a correr." -ForegroundColor Red
    exit 1
}
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

# --- 3. la estructura entera, no solo el invariante ------------------------
#
# El chequeo del invariante (un archivo, un repo dueno) vivia aca adentro y se
# mudo a verificar-estructura.ps1 el 2026-08-28, junto con las otras tres
# reglas del CLAUDE.md, que hasta ese dia no las chequeaba nadie. El motivo es
# el de siempre: una regla que nadie mide se corre sola, y se corrio -- los
# documentos declaraban dos repos propios cuando el disco ya tenia tres.
#
# Los seis bloques de ese script estan probados por sabotaje, y el saboteador
# quedo commiteado al lado: .\probar-verificador.ps1 los vuelve a probar
# cuando haga falta, en vez de una sola vez el dia que se escribieron.
$verificador = Join-Path $raiz "verificar-estructura.ps1"
$roto = $false

if (-not (Test-Path $verificador)) {
    Write-Host ""
    Write-Host "  [FAIL] falta verificar-estructura.ps1 en la raiz." -ForegroundColor Red
    $roto = $true
} else {
    & $verificador -Raiz $raiz
    if ($LASTEXITCODE -ne 0) { $roto = $true }
}

# Las carpetas ignoradas que no se pueden clonar de ningun lado
$sinRemote = @("proyectos/seguimiento/caso-tio", "proyectos/seguimiento/coaching")
foreach ($c in $sinRemote) {
    if (-not (Test-Path (Join-Path $raiz $c))) {
        Write-Host "  [WARN] falta $c y no tiene remote: solo existe en la maquina" -ForegroundColor Yellow
        Write-Host "         donde se creo. Copiarla a mano si hace falta."
    }
}

# --- 4. los frenos: se instalan Y se prueban ------------------------------
#
# Sin este bloque los hooks no existirian en ninguna maquina que no sea esta,
# que es justamente el fallo de arquitectura que venian a arreglar. El
# instalador GENERA .claude/settings.json con la ruta medida de la maquina en
# la que corre, asi que no depende de que la ruta absoluta commiteada sirva.
#
# Y se corre el saboteador, no solo el instalador: un freno recien instalado
# que nunca se vio en rojo esta sin verificar. En su primer dia probar-hooks
# encontro tres agujeros -- fallo abierto en silencio con JSON invalido, "\s"
# que cortaba en "Program Files", y "\bdel\b" matcheando el "DEL" de una frase
# en espanol.
Write-Host ""
Write-Host "  Instalando y probando los frenos ..." -ForegroundColor Cyan
$inst = Join-Path $raiz ".claude\instalar-hooks.ps1"
$prue = Join-Path $raiz "probar-hooks.ps1"
if ((Test-Path $inst) -and (Test-Path $prue)) {
    & $inst | Out-Null
    & $prue
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  [FAIL] probar-hooks.ps1 en rojo: los frenos NO estan verificados." -ForegroundColor Red
        $roto = $true
    }
} else {
    Write-Host "  [FAIL] faltan .claude\instalar-hooks.ps1 o probar-hooks.ps1" -ForegroundColor Red
    $roto = $true
}

Write-Host ""
if ($roto) {
    Write-Host "Bootstrap TERMINADO CON PROBLEMAS: ver los [FAIL] de arriba." -ForegroundColor Red
    exit 1
}
Write-Host "Bootstrap OK. Abrir Claude Code en esta carpeta y decir con que proyecto se sigue." -ForegroundColor Green
Write-Host "El enrutador esta en CLAUDE.md; el inventario completo, en MAPA.md."
Write-Host ""
