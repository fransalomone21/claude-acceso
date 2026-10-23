# =====================================================================
#  compilar.ps1 -- la guia completa (con y sin resultados) y los modelos
#  de parcial, en un comando. Frena en el primer rojo: si un recorte parte
#  un renglon o un numero no coincide con su cuenta, NO se genera ningun
#  PDF que se pueda publicar por error.
#
#     .\compilar.ps1              recortes + validacion + los 4 PDFs
#     .\compilar.ps1 -Publicar    ademas los sube (publicar-apuntes.ps1)
#
#  Necesita la guia de la catedra en Downloads (PROBLEMAS FISICA
#  ESPACIAL*.pdf): los recortes salen de ahi y no se commitean.
# =====================================================================
param([switch]$Publicar)
$ErrorActionPreference = 'Stop'
$aqui = Split-Path -Parent $MyInvocation.MyCommand.Path
$env:PYTHONIOENCODING = 'utf-8'
Push-Location $aqui
try {
    python recortar.py
    if ($LASTEXITCODE -ne 0) { throw 'recortar.py en rojo' }
    python validar.py
    if ($LASTEXITCODE -ne 0) { throw 'validar.py en rojo' }
    python figuras-cr.py
    if ($LASTEXITCODE -ne 0) { throw 'figuras-cr.py fallo' }
    New-Item -ItemType Directory -Force salida | Out-Null
    $trabajos = @(
        @('guia.typ', 'salida\guia-con-resultados.pdf', 'resultados=si'),
        @('guia.typ', 'salida\guia-sin-resultados.pdf', 'resultados=no'),
        @('parcialito-momento-angular.typ', 'salida\parcialito-momento-angular.pdf', $null),
        @('modelo-parcial-integrador.typ', 'salida\modelo-parcial-integrador.pdf', $null),
        @('modelo-parcial-1.typ', 'salida\modelo-parcial-1.pdf', $null),
        @('modelo-parcial-2.typ', 'salida\modelo-parcial-2.pdf', $null),
        @('modelo-parcial-3.typ', 'salida\modelo-parcial-3.pdf', $null),
        @('modelo-parcial-4.typ', 'salida\modelo-parcial-4.pdf', $null),
        @('modelo-parcial-5.typ', 'salida\modelo-parcial-5.pdf', $null),
        @('parcialito-4-momento-angular.typ', 'salida\parcialito-4-momento-angular.pdf', $null),
        @('resumen-momento-angular.typ', 'salida\resumen-momento-angular.pdf', $null),
        @('resueltos-cr-1-a-4.typ', 'salida\resueltos-cr-1-a-4.pdf', $null),
        @('hoja-formulas.typ', 'salida\hoja-formulas.pdf', $null),
        @('hoja-formulas.typ', 'salida\hoja-formulas-parcial.pdf', 'version=parcial')
    )
    # Fecha de creacion FIJA: sin esto Typst estampa la hora de compilacion,
    # todos los PDF salen "modificados" con el texto identico y el hook los
    # vuelve a subir a Drive (pendiente del HANDOFF, cerrado el 2026-10-13).
    $fecha = '--creation-timestamp=1767225600'   # 2026-01-01 00:00 UTC
    # La llave fija de Typst (DA-079): las trampas que compilan sin error, medidas en el fuente antes.
    $entradas = @($trabajos | ForEach-Object { $_[0] } | Select-Object -Unique)
    python (Join-Path $env:USERPROFILE '.claude\herramientas\lint-typst.py') @entradas --root ..
    if ($LASTEXITCODE -ne 0) { throw 'lint-typst en rojo: una trampa de Typst en el fuente (lista arriba)' }
    foreach ($t in $trabajos) {
        if ($t[2]) { typst compile $fecha --root .. $t[0] $t[1] --input $t[2] }
        else { typst compile $fecha --root .. $t[0] $t[1] }
        if ($LASTEXITCODE -ne 0) { throw "typst fallo en $($t[0])" }
        Write-Host "  listo: $($t[1])" -ForegroundColor Green
    }
    # la hoja de formulas: ningun renglon fuera de su columna, y la del
    # parcial en UNA carilla (la definitiva en dos)
    python verificar-hoja.py salida\hoja-formulas-parcial.pdf:1 salida\hoja-formulas.pdf:2
    if ($LASTEXITCODE -ne 0) { throw 'verificar-hoja.py en rojo: un renglon fuera de su columna o una carilla de mas' }
    # Regla propia 10: ninguna consigna partida entre dos paginas
    python verificar-consignas.py
    if ($LASTEXITCODE -ne 0) { throw 'verificar-consignas.py en rojo: una consigna partida, o un ejercicio sin #consigna' }
}
finally { Pop-Location }
if ($Publicar) {
    & (Join-Path $aqui '..\..\..\..\publicar-apuntes.ps1')
}
