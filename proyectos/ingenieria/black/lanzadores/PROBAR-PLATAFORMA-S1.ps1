# Spike S1 de (133): BLACK-XBERecomp (con el coop instalado, pero apagado) corre la primera mision en esta PC.
# Lo corre Fran. Abre el juego en pantalla completa con el contador de cuadros prendido, saca una foto de la pantalla
# cada 60 s mientras jugas, y al cerrar el juego guarda fotos y registros en volcados\plataforma\ para que Claude los lea.
#
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\PROBAR-PLATAFORMA-S1.ps1"
#
# Que hacer: la PRIMERA vez el juego compila su codigo (unos minutos, con una barra): esperar. Despues, entrar a la
# primera mision y jugar unos 10 minutos. Cerrar el juego normal (desde el menu o Alt+F4). Nada mas.

. (Join-Path $PSScriptRoot 'plataforma-comun.ps1')
if (-not (Test-Instalacion)) { exit 1 }

Set-Toml @{ fps_counter = $true; display_mode = 'borderless'; width = 1920; height = 1080; pause_on_focus_loss = $true }
$corrida = New-CarpetaCorrida 's1'
$inicio = Get-Date
Write-Host "S1: abriendo BLACK. Juga la primera mision ~10 min y cerralo. Fotos y registro en:" -ForegroundColor Cyan
Write-Host "    $corrida"

$p = Start-Process -FilePath $Exe -WorkingDirectory $Juego -PassThru
$n = 0
while (-not $p.HasExited) {
    Start-Sleep -Seconds 60
    if ($p.HasExited) { break }
    $n++
    try { Save-Captura (Join-Path $corrida ("foto-{0:D2}.png" -f $n)) } catch { Write-Host "  foto $n fallo: $_" -ForegroundColor Yellow }
}
Save-Registros $corrida $inicio
$min = [math]::Round(((Get-Date) - $inicio).TotalMinutes, 1)
"{0}`tS1`tcodigo de salida={1}`tminutos={2}`tfotos={3}" -f (Get-Date -Format s), $p.ExitCode, $min, $n |
    Out-File -Append -Encoding utf8 (Join-Path $Volcados 'corridas.txt')
Write-Host ("S1 listo: {0} min, {1} fotos, codigo de salida {2}. Avisale a Claude." -f $min, $n, $p.ExitCode) -ForegroundColor Green
