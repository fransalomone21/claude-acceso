<#
.SYNOPSIS
  Exporta los .pptx de la catedra a PDF CON las diapositivas ocultas, para
  que el numero de pagina del PDF sea el numero de la lamina.

.DESCRIPTION
  Por que existe (2026-10-13): la clase 8 del 12/10 tiene la 39 y la 40
  ocultas, y "Guardar como PDF" las saltea: 95 paginas para 97 laminas, y
  extraer-clases.py numeraba mal todo lo que venia despues. Este script
  trabaja sobre una COPIA (el original no se toca), des-oculta todas las
  laminas y guarda el PDF. Imprime cuantas habia ocultas.

  No cierra PowerPoint si hay otras presentaciones abiertas (puede haber otra
  sesion usandolo).

.EXAMPLE
  .\exportar-pptx.ps1 -Pares "C:\...\IISE Clase 8 - 2026.pptx|C:\...\fuentes\pdf\IISE Clase 8 - 2026.pdf"
  Despues: python extraer-clases.py --figuras
#>
param([Parameter(Mandatory = $true)][string[]]$Pares)

$tmp = Join-Path $env:TEMP "iise-export"
New-Item -ItemType Directory -Force $tmp | Out-Null
$pp = New-Object -ComObject PowerPoint.Application
foreach ($par in $Pares) {
    $o, $d = $par.Split('|')
    $copia = Join-Path $tmp ([IO.Path]::GetFileName($o))
    Copy-Item -LiteralPath $o -Destination $copia -Force
    $pres = $pp.Presentations.Open($copia, $false, $false, $false)
    $ocultas = @()
    foreach ($s in $pres.Slides) {
        if ($s.SlideShowTransition.Hidden -ne 0) { $ocultas += $s.SlideIndex; $s.SlideShowTransition.Hidden = 0 }
    }
    $n = $pres.Slides.Count
    $pres.SaveAs($d, 32)   # 32 = ppSaveAsPDF
    $pres.Close()
    Remove-Item -LiteralPath $copia
    Write-Output ("{0} diapositivas (ocultas: {1}) -> {2}" -f $n, ($ocultas -join ','), $d)
}
if ($pp.Presentations.Count -eq 0) { $pp.Quit() }
