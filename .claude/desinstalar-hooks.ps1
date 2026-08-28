# desinstalar-hooks.ps1 -- saca las tres capas de frenos, enteras.
#
# Existe por la regla 6 del perfil: el costo de deshacer es un eje de riesgo
# aparte del apalancamiento, y lo que se instala solo tiene que poder
# desinstalarse solo. Un freno del que no se sabe salir no se instala.
#
# ANTES DE CORRERLO, la pregunta que manda (pilar: el freno que nunca salta):
# contra QUE IMPACTO fue disenado, no cuantas veces salto. Este fue disenado
# contra perder Black.iso -- 3,9 GB, irreemplazable sin rehacer el checkpoint 0,
# y la referencia contra la que se verifica todo parche.
# Si lo que molesta es UN comando legitimo bloqueado, eso NO se arregla
# desinstalando: se corrige el patron en .claude\hooks\guardia-iso.ps1 y se
# corre .\probar-hooks.ps1.
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

[CmdletBinding()]
param([switch]$DejarReadOnly)

$ErrorActionPreference = 'Stop'
$claude = $PSScriptRoot

Write-Output ""
Write-Output "=== desinstalar los frenos de claude-acceso ==="
Write-Output ""

# capa 2: los hooks
$settings = Join-Path $claude 'settings.json'
if (Test-Path -LiteralPath $settings) {
    $obj = Get-Content -LiteralPath $settings -Raw -Encoding UTF8 | ConvertFrom-Json
    $obj.PSObject.Properties.Remove('hooks')
    $resto = @($obj.PSObject.Properties).Count
    if ($resto -eq 0) {
        Remove-Item -LiteralPath $settings -Force
        Write-Output "  [OK]   settings.json borrado (no le quedaba nada mas)"
    } else {
        $json = $obj | ConvertTo-Json -Depth 12
        [System.IO.File]::WriteAllText($settings, $json + "`n", [System.Text.UTF8Encoding]::new($false))
        Write-Output "  [OK]   hooks quitados de settings.json ($resto clave(s) conservadas)"
    }
} else {
    Write-Output "  [ok]   no habia settings.json"
}

# capa 1: el atributo
if ($DejarReadOnly) {
    Write-Output "  [SKIP] el atributo ReadOnly queda puesto (-DejarReadOnly)"
} else {
    $cfg = Join-Path $claude 'protegidos.json'
    if (Test-Path -LiteralPath $cfg) {
        $prot = (Get-Content -LiteralPath $cfg -Raw -Encoding UTF8 | ConvertFrom-Json).archivos
        foreach ($a in $prot) {
            if (-not (Test-Path -LiteralPath $a.ruta)) { continue }
            Set-ItemProperty -LiteralPath $a.ruta -Name IsReadOnly -Value $false
            Write-Output "  [OK]   $($a.nombre) -> escribible de nuevo"
        }
    }
}

Write-Output ""
Write-Output "Desinstalado. Los archivos .ps1 y .json siguen en .claude/ por si"
Write-Output "se quiere volver: .claude\instalar-hooks.ps1"
Write-Output ""
Write-Output "OJO: la capa 3 (integridad medida en abrir-sesion.ps1) sigue viva y"
Write-Output "no molesta -- solo mide. Esa no hay razon para sacarla."
