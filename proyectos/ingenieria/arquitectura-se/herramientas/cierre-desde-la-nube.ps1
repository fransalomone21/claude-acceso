<#
.SYNOPSIS
  Lo que la sesion en la nube no puede hacer, en orden, en la PC. Se frena en el primer rojo.

.DESCRIPTION
  Escrito el 2026-10-02 por la sesion en la nube que termino el apunte de C (v1.0). Es el
  embrion del "pasar-a-nube" de la T7, pero al reves: lo que vuelve de la nube a la PC.

    1. claude-acceso: pull y verificar-estructura (rojo = se frena, NO se publica nada)
    2. perfil-global: commit de lo pendiente, pull y push (la nube lo puede leer)
    3. catedras: si no tiene remote, crea el repo PRIVADO en GitHub y lo sube. Se frena
       antes si hay PDF/PPT/ZIP trackeados (subir material de la catedra es otra decision).
    4. apunte de C: verificador, saboteador, revisar-pdf y su saboteador (el PDF del repo ya
       esta compilado: recompilarlo solo cambia la fecha y ensucia el arbol)
    5. publicar-apuntes y -Verificar (cierra la fase 1 de software-de-vuelo)
    6. medir _Min_Stack_Size en los .ld del workspace de STM32
    Al final lista lo que sigue siendo a mano. Todo queda en $env:TEMP\cierre-desde-la-nube.log
    (para pegarselo a la proxima sesion).

.EXAMPLE
  .\proyectos\ingenieria\arquitectura-se\herramientas\cierre-desde-la-nube.ps1
#>
# 'Continue' a proposito: en Windows PowerShell 5.1, con 'Stop', cualquier texto que un programa
# escriba en stderr (git lo hace siempre) se vuelve un error que corta. Manda $LASTEXITCODE.
$ErrorActionPreference = 'Continue'
$log = Join-Path $env:TEMP 'cierre-desde-la-nube.log'
Start-Transcript -Path $log -Force | Out-Null

function Paso($t) { Write-Host "`n=== $t ===" -ForegroundColor Cyan }
function Frenar($t) {
    Write-Host "`n[ROJO] $t" -ForegroundColor Red
    Write-Host "Se freno aca. Nada de lo que sigue corrio. Log: $log"
    Stop-Transcript | Out-Null
    exit 1
}
function Correr($desc, [scriptblock]$bloque) {
    & $bloque
    if ($LASTEXITCODE -ne 0) { Frenar "$desc (exit $LASTEXITCODE)" }
    Write-Host "[OK] $desc" -ForegroundColor Green
}

$raiz = (git -C $PSScriptRoot rev-parse --show-toplevel).Trim()
Set-Location $raiz

# ---------------------------------------------------------------- 1
Paso '1. claude-acceso: pull y estructura'
Correr 'git pull de claude-acceso' { git pull --no-rebase origin main }
Correr 'verificar-estructura en verde' { & "$raiz\verificar-estructura.ps1" }

# ---------------------------------------------------------------- 2
Paso '2. perfil-global: commit, pull, push'
$perfil = Join-Path $raiz 'perfil-global'
if (-not (Test-Path (Join-Path $perfil '.git'))) { Frenar "no encuentro $perfil como repo" }
Push-Location $perfil
if (git status --porcelain) {
    git add -A
    Correr 'commit de perfil-global' { git commit -m "perfil: estado local antes de pasar a la nube" }
} else { Write-Host '[OK] perfil-global sin cambios locales' -ForegroundColor Green }
Correr 'pull de perfil-global' { git pull --no-rebase }
Correr 'push de perfil-global' { git push }
Pop-Location

# ---------------------------------------------------------------- 3
Paso '3. catedras: repo privado en GitHub'
$catedras = Join-Path $raiz 'proyectos\documentos\catedras'
if (-not (Test-Path (Join-Path $catedras '.git'))) { Frenar "no encuentro $catedras como repo" }
Push-Location $catedras
if (git status --porcelain) {
    git add -A
    Correr 'commit de catedras' { git commit -m "catedras: estado local antes de subirlo a GitHub" }
}
$remotos = @(git remote)
if ($remotos -contains 'origin') {
    Correr 'pull de catedras' { git pull --no-rebase }
    Correr 'push de catedras' { git push }
} else {
    $pesados = @(git ls-files | Where-Object { $_ -match '\.(pdf|pptx?|zip|docx?)$' })
    if ($pesados.Count -gt 0) {
        Write-Host "Archivos de material trackeados en catedras:" -ForegroundColor Yellow
        $pesados | ForEach-Object { Write-Host "  $_" }
        Frenar 'catedras tiene material de la catedra trackeado: decidir si sube a GitHub (privado) antes de seguir'
    }
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        Correr 'crear fransalomone21/catedras PRIVADO y subirlo' {
            gh repo create fransalomone21/catedras --private --source . --remote origin --push
        }
    } else {
        Frenar ("no hay 'gh'. Crear a mano en https://github.com/new el repo 'catedras', PRIVATE, sin README, " +
                "y despues: git -C `"$catedras`" remote add origin https://github.com/fransalomone21/catedras.git ; " +
                "git -C `"$catedras`" push -u origin HEAD ; y volver a correr este script")
    }
}
Pop-Location

# ---------------------------------------------------------------- 4
Paso '4. apunte de C: medir'
Push-Location (Join-Path $raiz 'proyectos\documentos\software-de-vuelo\apunte-c')
Correr 'verificar-ejemplos (49 en verde)' { python verificar-ejemplos.py }
Correr 'probar-verificar-ejemplos (TODO BIEN)' { python probar-verificar-ejemplos.py }
python -c "import pymupdf"
if ($LASTEXITCODE -ne 0) { Correr 'instalar pymupdf' { python -m pip install -q pymupdf } }
Correr 'revisar-pdf (ningun bloque fuera de la pagina)' { python revisar-pdf.py }
Correr 'revisar-pdf --probar (TODO BIEN)' { python revisar-pdf.py --probar }
Pop-Location

# ---------------------------------------------------------------- 5
Paso '5. publicar en Drive'
Correr 'publicar-apuntes' { & "$raiz\publicar-apuntes.ps1" }
Correr 'publicar-apuntes -Verificar (MD5 contra Drive)' { & "$raiz\publicar-apuntes.ps1" -Verificar }

# ---------------------------------------------------------------- 6
Paso '6. medir _Min_Stack_Size (modulo 6 dice "suele ser 0x400")'
$stm = Join-Path $env:USERPROFILE 'Desktop\01 - UNSAM\Software de Vuelo'
if (Test-Path $stm) {
    $hallados = Get-ChildItem -Path $stm -Recurse -Filter *.ld -ErrorAction SilentlyContinue |
        Select-String -Pattern '_Min_Stack_Size\s*=\s*(\S+);' -ErrorAction SilentlyContinue
    if ($hallados) {
        $hallados | ForEach-Object { Write-Host ("  {0}: {1}" -f $_.Path, $_.Matches[0].Groups[1].Value) }
    } else { Write-Host '  [AVISO] ningun .ld con _Min_Stack_Size bajo esa carpeta' -ForegroundColor Yellow }
} else { Write-Host "  [AVISO] no existe $stm" -ForegroundColor Yellow }

# ---------------------------------------------------------------- fin
Paso 'Listo. Sigue siendo a mano (para la proxima sesion local)'
@(
  '- registrar con aprender.py las lecciones de los HANDOFF (software-de-vuelo: 3; arquitectura-se: 1)',
  '- cotejar Practico 1 (ej. 2 y 4 a 9), Practico 2 ej. 1 y Practico 3 (ej. 3 y 4) contra los ejemplos del apunte',
  '- en la placa: leer *(volatile uint32_t *)0 en el depurador (modulo 8)',
  '- comparar docs/CRITERIOS-LEANDRO.md contra catedras/software-de-vuelo/CRITERIOS.md',
  '- si _Min_Stack_Size no es 0x400: corregir el modulo 6'
) | ForEach-Object { Write-Host $_ }
Write-Host "`nLog completo: $log  (pegaselo a la proxima sesion)" -ForegroundColor Cyan
Stop-Transcript | Out-Null
