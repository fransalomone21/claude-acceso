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
        @('modelo-parcial-5.typ', 'salida\modelo-parcial-5.pdf', $null)
    )
    foreach ($t in $trabajos) {
        if ($t[2]) { typst compile --root .. $t[0] $t[1] --input $t[2] }
        else { typst compile --root .. $t[0] $t[1] }
        if ($LASTEXITCODE -ne 0) { throw "typst fallo en $($t[0])" }
        Write-Host "  listo: $($t[1])" -ForegroundColor Green
    }
}
finally { Pop-Location }
if ($Publicar) {
    & (Join-Path $aqui '..\..\..\..\publicar-apuntes.ps1')
}
