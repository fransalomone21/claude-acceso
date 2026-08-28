# probar-verificador.ps1 -- el saboteador de verificar-estructura.ps1.
#
# Rompe cada regla A PROPOSITO y exige ver el rojo. Un chequeo que nunca fallo
# esta sin verificar: puede estar mirando la precondicion en vez del efecto, o
# puede decir OK siempre. Esto lo prueba en 20 segundos, cuando haga falta y no
# una sola vez el dia que se escribio.
#
# Correrlo SIEMPRE que se agregue o se toque un bloque de verificar-estructura.ps1.
#
# Es destructivo y se restaura solo:
#   - los archivos de texto se restauran con 'git checkout', no reescribiendolos.
#     Reescribirlos con Set-Content normaliza los fines de linea y deja el repo
#     con 135 lineas cambiadas que no cambio nadie. Ya paso.
#   - los renombrados se deshacen en el finally de cada caso.
# Al final corre un CONTROL POSITIVO: con todo restaurado tiene que volver a
# verde. Sin ese control, un saboteador que rompe y no restaura se ve igual que
# uno que anda bien.
#
# ASCII puro a proposito: la consola de Windows lee cp1252.

param(
    [string]$Raiz = $PSScriptRoot
)

Set-Location $Raiz
$resultados = @()

function Correr {
    $salida = & powershell -NoProfile -ExecutionPolicy Bypass -File "$Raiz\verificar-estructura.ps1" 2>&1
    return ($salida | Out-String)
}

function GitRestaurar($rel) {
    & git -C $Raiz checkout -- $rel 2>&1 | Out-Null
}

function Probar($nombre, $esperado, $romper, $restaurar) {
    $rojo = $null
    try {
        & $romper
        $out = Correr
        $lineas = $out -split "`r?`n" |
                  Where-Object { $_ -match '\[FAIL\]' -and $_ -match [regex]::Escape($esperado) }
        $rojo = ($lineas -join ' | ').Trim()
    } finally {
        & $restaurar
    }
    if ($rojo) {
        Write-Host "  [ROJO OK] $nombre" -ForegroundColor Green
        Write-Host "            $rojo" -ForegroundColor DarkGray
        $script:resultados += $true
    } else {
        Write-Host "  [CIEGO!!] $nombre -- el chequeo NO se puso en rojo" -ForegroundColor Red
        $script:resultados += $false
    }
}

Write-Host ""
Write-Host "=== saboteador de verificar-estructura.ps1 ===" -ForegroundColor Cyan
Write-Host "  Rompe cada regla y exige el rojo. Restaura al terminar cada caso."
Write-Host ""

# --- El freno: restaurar con 'git checkout' descarta lo que no este commiteado.
#
# Este script se come cualquier cambio sin commitear de los archivos que
# sabotea. Paso el 2026-08-28, la primera vez que se corrio: borro las
# ediciones de CLAUDE.md y de MAPA.md que estaban a medio escribir, sin avisar
# y sin que se notara hasta mirar el git status del final.
#
# La restauracion por 'git checkout' es la correcta -- reescribir los archivos
# normaliza los fines de linea y ensucia el repo entero. Lo que faltaba era el
# freno: no arrancar si hay algo que perder.
$archivosEnRiesgo = @('.gitignore', 'CLAUDE.md', 'MAPA.md')
$sucios = @()
foreach ($a in $archivosEnRiesgo) {
    $st = & git -C $Raiz status --porcelain -- $a
    if ($st) { $sucios += $a }
}
if ($sucios.Count -gt 0) {
    Write-Host "  [ABORTA] estos archivos tienen cambios sin commitear y este script" -ForegroundColor Red
    Write-Host "           los restaura con 'git checkout', o sea que los BORRARIA:" -ForegroundColor Red
    foreach ($a in $sucios) { Write-Host "             $a" -ForegroundColor Red }
    Write-Host ""
    Write-Host "           Commitealos (o 'git stash') y volve a correr." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

# --- regla 1: un proyecto tracked que se quedo sin contrato ---
$tel = "$Raiz\proyectos\ingenieria\telescopio"
Probar "regla 1 - proyecto tracked sin CLAUDE.md" "telescopio" `
    { Rename-Item "$tel\CLAUDE.md" "CLAUDE.md.saboteado" } `
    { if (Test-Path "$tel\CLAUDE.md.saboteado") { Rename-Item "$tel\CLAUDE.md.saboteado" "CLAUDE.md" } }

# --- regla 2: repo propio que se cayo del .gitignore ---
# Es el caso que costo 23 lecciones en 2026-08-27, en su version temprana:
# todavia con 0 archivos tracked, pero con la puerta abierta para el proximo
# 'git add -A'.
Probar "regla 2 - repo propio sin linea en .gitignore" "coaching" `
    { (Get-Content -LiteralPath "$Raiz\.gitignore") |
        Where-Object { $_ -ne 'proyectos/seguimiento/coaching/' } |
        Set-Content -LiteralPath "$Raiz\.gitignore" -Encoding utf8 } `
    { GitRestaurar '.gitignore' }

# --- regla 3a: proyecto en el disco que el enrutador no conoce ---
$fant = "$Raiz\proyectos\ingenieria\fantasma"
Probar "regla 3a - proyecto que el enrutador no conoce" "fantasma" `
    { New-Item -ItemType Directory -Force -Path $fant | Out-Null
      Set-Content -LiteralPath "$fant\CLAUDE.md" -Value "contrato de prueba" -Encoding utf8 } `
    { Remove-Item -Recurse -Force $fant -ErrorAction SilentlyContinue }

# --- regla 3b: el enrutador apunta a algo que no existe ---
Probar "regla 3b - enlace roto en CLAUDE.md" "no-existe.md" `
    { Add-Content -LiteralPath "$Raiz\CLAUDE.md" -Value "`n[roto](plantillas/no-existe.md)" -Encoding utf8 } `
    { GitRestaurar 'CLAUDE.md' }

# --- regla 3c: la tabla de duenos se atrasa respecto del disco ---
# Este es EXACTAMENTE el defecto que se encontro el 2026-08-28: el disco tenia
# tres repos propios y los documentos hablaban de dos.
Probar "regla 3c - MAPA.md no declara un repo propio del disco" "coaching" `
    { (Get-Content -LiteralPath "$Raiz\MAPA.md") |
        Where-Object { $_ -notmatch '`proyectos/seguimiento/coaching/`' } |
        Set-Content -LiteralPath "$Raiz\MAPA.md" -Encoding utf8 } `
    { GitRestaurar 'MAPA.md' }

# --- regla 4: proyecto ACTIVO sin punto de retome ---
$blk = "$Raiz\proyectos\ingenieria\black"
Probar "regla 4 - proyecto ACTIVO sin ESTADO_ACTUAL.md" "black" `
    { Rename-Item "$blk\ESTADO_ACTUAL.md" "ESTADO_ACTUAL.md.saboteado" } `
    { if (Test-Path "$blk\ESTADO_ACTUAL.md.saboteado") { Rename-Item "$blk\ESTADO_ACTUAL.md.saboteado" "ESTADO_ACTUAL.md" } }

Write-Host ""
$ciegos = @($resultados | Where-Object { -not $_ }).Count
if ($ciegos -gt 0) {
    Write-Host "$ciegos chequeo(s) CIEGO(S): dicen OK y no discriminan." -ForegroundColor Red
    exit 1
}
Write-Host "Los $($resultados.Count) chequeos discriminan: rojo ante el caso roto." -ForegroundColor Green

# --- control positivo: sin esto, no se distingue un saboteador que anda de
#     uno que dejo el arbol roto ---
$out = Correr
if ($out -match 'Estructura OK') {
    Write-Host "Control positivo: con todo restaurado, vuelve a verde." -ForegroundColor Green
} else {
    Write-Host "ALARMA: quedo algo roto despues de restaurar. Revisar a mano." -ForegroundColor Red
    Write-Host $out
    exit 1
}

$sucio = & git -C $Raiz status --porcelain
if ($sucio) {
    Write-Host ""
    Write-Host "Nota: el arbol quedo con cambios sin commitear. Si no son tuyos," -ForegroundColor Yellow
    Write-Host "el saboteador no restauro bien:" -ForegroundColor Yellow
    Write-Host $sucio
}
Write-Host ""
