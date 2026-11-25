# Abre carpetas en Explorer, lee con que vista abren (el efecto del desktop.ini del indice) y cierra SOLO las
# ventanas que abrio: las que ya estaban abiertas se anotan antes (HWND) y no se tocan.
#   powershell -File medir-vista.ps1                      Juegos, Juegos\Sega y la carpeta mas honda de Clasificados
#   powershell -File medir-vista.ps1 -Carpetas 'C:\x','C:\y'
# Iconos grandes = vista 1 e icono 96 (Detalles = vista 4, icono 16). Sale 0 si todas abren en iconos grandes.
# Corre en la sesion de quien mira la pantalla: en la PC, como tarea interactiva de una vez y solo si nadie la usa.
param([string[]]$Carpetas)
$j = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Juegos'
if (-not $Carpetas) {
    $honda = Get-ChildItem (Join-Path $j 'Clasificados') -Recurse -Directory -ErrorAction SilentlyContinue |
        Sort-Object { $_.FullName.Length } -Descending | Select-Object -First 1
    $Carpetas = @($j, (Join-Path $j 'Sega')) + @($honda.FullName | Where-Object { $_ })
}
$sh = New-Object -ComObject Shell.Application
$antes = @($sh.Windows() | ForEach-Object { $_.HWND })
foreach ($c in $Carpetas) { Start-Process explorer.exe $c }
Start-Sleep -Seconds 6
$mal = 0; $vistas = @{}
foreach ($w in @($sh.Windows())) {
    if ($antes -contains $w.HWND) { continue }
    try { $p = $w.Document.Folder.Self.Path } catch { continue }
    if ($Carpetas -notcontains $p) { continue }
    $ok = ($w.Document.CurrentViewMode -eq 1 -and $w.Document.IconSize -ge 96)
    if (-not $ok) { $mal++ }
    $vistas[$p] = $true
    "{0}  {1}  vista={2} icono={3}" -f $(if ($ok) { 'OK  ' } else { 'MAL ' }), $p, $w.Document.CurrentViewMode, $w.Document.IconSize
    $w.Quit()
}
foreach ($c in $Carpetas) { if (-not $vistas[$c]) { "NO SE ABRIO  $c"; $mal++ } }
"ventanas que ya estaban abiertas y no se tocaron: $($antes.Count)"
exit $(if ($mal) { 1 } else { 0 })
