# chequeo-completo.ps1 -- TODA la bateria de verificadores del sistema, en un comando.
#
# POR QUE EXISTE
#   Hasta el 2026-08-29 la bateria eran siete scripts sueltos, cada uno
#   nombrado en una linea distinta de CLAUDE.md, y correrlos dependia de que
#   alguien se acordara. Eso no es una regla: es una intencion (la misma
#   razon por la que existe cascada.ps1). Peor todavia, la unica capa que
#   avisaba era el HANDOFF de la sesion anterior -- o sea, el estado del
#   sistema dependia de un texto escrito por otra sesion en vez de medirse.
#
#   Una regla que se incumple no se escribe mas fuerte: se le agrega el flujo
#   de informacion que falta (Meadows). El flujo que faltaba es este comando,
#   y el hook SessionStart que corre su mitad rapida y EMITE EL RESULTADO.
#
# LAS DOS CAPAS, Y POR QUE ESTAN SEPARADAS  (medido el 2026-08-29)
#   medidores    7,0 s   miden el estado. No escriben nada. Corren en CADA
#                        arranque, por el hook: entran en el timeout.
#   saboteadores 96,2 s  rompen cada alarma a proposito y exigen el rojo.
#                        Escriben y restauran archivos reales. NO entran en
#                        un arranque: van por ANTIGUEDAD, y el hook avisa
#                        cuando se pasaron de viejos.
#
#   Los saboteadores son los que hacen que los medidores valgan algo: un
#   chequeo que nunca fallo esta sin verificar. Por eso no alcanza con
#   correr la capa rapida y darse por servido.
#
# USO
#   .\chequeo-completo.ps1                  las dos capas (~103 s)
#   .\chequeo-completo.ps1 -SoloMedidores   la capa rapida (~7 s)
#   .\chequeo-completo.ps1 -Compacto        una linea por chequeo, sin cuerpo
#
# Sale con codigo 1 si algo esta en rojo.
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

[CmdletBinding()]
param(
    [switch]$SoloMedidores,
    [switch]$SoloSaboteadores,
    [switch]$Compacto,
    [int]$DiasSaboteadores = 7
)

$ErrorActionPreference = 'Stop'
$raiz  = $PSScriptRoot
$sello = Join-Path $raiz '.claude\ultimo-chequeo.json'

$medidores = @(
    @{ nombre = 'estructura del repo';      cmd = '.\verificar-estructura.ps1' }
    @{ nombre = 'perfil global instalado';  cmd = '.\perfil-global\verify-install.ps1' }
    @{ nombre = 'triage de lecciones';      cmd = 'python perfil-global\herramientas\aprender.py sin-triage' }
)

$saboteadores = @(
    @{ nombre = 'saboteador de la estructura';   cmd = '.\probar-verificador.ps1' }
    @{ nombre = 'saboteador de los frenos';      cmd = '.\probar-hooks.ps1' }
    @{ nombre = 'saboteador del guardia fanout'; cmd = '.\perfil-global\probar-guardia-fanout.ps1' }
    @{ nombre = 'saboteador del triage';         cmd = '.\perfil-global\probar-chequeo-lecciones.ps1' }
)

function Correr($lista, $titulo) {
    if (-not $Compacto) { Write-Host ""; Write-Host $titulo }
    $rojos = 0
    foreach ($c in $lista) {
        $sw = [Diagnostics.Stopwatch]::StartNew()
        $salida = & powershell -NoProfile -ExecutionPolicy Bypass -Command `
                    "Set-Location '$raiz'; $($c.cmd); exit `$LASTEXITCODE" 2>&1 | Out-String
        $code = $LASTEXITCODE
        $sw.Stop()

        # El codigo de salida es la senal; la salida de texto es el detalle.
        # No se lee el texto para decidir: eso ata el chequeo a la redaccion
        # de cada script y se rompe cuando alguien cambia una palabra.
        if ($code -eq 0) {
            Write-Host ("  [OK  ] {0,-32} {1,5:N1} s" -f $c.nombre, $sw.Elapsed.TotalSeconds) -ForegroundColor Green
        } else {
            Write-Host ("  [FAIL] {0,-32} {1,5:N1} s   exit={2}" -f $c.nombre, $sw.Elapsed.TotalSeconds, $code) -ForegroundColor Red
            Write-Host ("         {0}" -f $c.cmd) -ForegroundColor Red
            if (-not $Compacto) {
                foreach ($l in ($salida -split "`r?`n" | Where-Object { $_ -match '\[FAIL\]|FALLIDA|FALLA|no discrimin' })) {
                    Write-Host ("         {0}" -f $l.Trim()) -ForegroundColor Red
                }
            }
            $rojos++
        }
    }
    return $rojos
}

function LeerSello {
    if (-not (Test-Path -LiteralPath $sello)) { return $null }
    try { return (Get-Content -LiteralPath $sello -Raw -Encoding UTF8 | ConvertFrom-Json) }
    catch { return $null }   # sello ilegible se trata como ausente: falla CERRADO
}

function EscribirSello($capa, $verde) {
    $s = LeerSello
    $o = [ordered]@{}
    if ($s) { foreach ($p in $s.PSObject.Properties) { $o[$p.Name] = $p.Value } }
    $o[$capa] = [ordered]@{ fecha = (Get-Date -Format 'yyyy-MM-dd'); verde = [bool]$verde }
    $o | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $sello -Encoding UTF8
}

# Antiguedad de la capa lenta. Un sello ausente o ilegible cuenta como
# "nunca se corrio": se avisa, no se calla.
function EstadoSaboteadores {
    $s = LeerSello
    if (-not $s -or -not $s.saboteadores) {
        return @{ texto = 'NUNCA se corrieron (o el sello no se puede leer)'; viejo = $true }
    }
    $d = (New-TimeSpan -Start ([datetime]$s.saboteadores.fecha) -End (Get-Date)).Days
    if (-not $s.saboteadores.verde) {
        return @{ texto = ("la ultima corrida ({0}, hace {1} dia(s)) quedo EN ROJO" -f $s.saboteadores.fecha, $d); viejo = $true }
    }
    if ($d -gt $DiasSaboteadores) {
        return @{ texto = ("corridos hace {0} dia(s) -- pasaron los {1} de tolerancia" -f $d, $DiasSaboteadores); viejo = $true }
    }
    return @{ texto = ("corridos hace {0} dia(s), en verde -- al dia" -f $d); viejo = $false }
}

# ---------------------------------------------------------------------------

if (-not $Compacto) {
    Write-Host "=== chequeo completo del sistema ==="
    Write-Host "  Raiz: $raiz"
}

$rojos = 0

if (-not $SoloSaboteadores) {
    $r = Correr $medidores "MEDIDORES -- que mide el estado (rapido, no escribe nada)"
    $rojos += $r
    EscribirSello 'medidores' ($r -eq 0)
}

if (-not $SoloMedidores) {
    $r = Correr $saboteadores "SABOTEADORES -- rompen cada alarma y exigen el rojo (lento, escribe y restaura)"
    $rojos += $r
    EscribirSello 'saboteadores' ($r -eq 0)

    # Los medidores otra vez, DESPUES de sabotear. Un saboteador que restaura
    # el archivo fuente pero deja sucio el efecto (la copia instalada, un
    # atributo, un settings.json) da verde en su propio control positivo y
    # ensucia la maquina en silencio. Eso paso de verdad el 2026-08-29:
    # probar-chequeo-lecciones dejaba "las 76 lecciones" en ~/.claude.
    # Con este segundo pase la clase entera de suciedad se ve, no solo la
    # que ya conocemos.
    # Sin guardia por -SoloSaboteadores: esa es JUSTO la corrida en la que
    # mas importa mirar si la maquina quedo limpia.
    if ($true) {
        $r2 = Correr $medidores "LIMPIEZA -- los mismos medidores, ya saboteado y restaurado"
        if ($r2 -gt 0) {
            Write-Host "  >>> Un saboteador restauro la FUENTE y no el EFECTO: la maquina quedo sucia." -ForegroundColor Red
        }
        $rojos += $r2
        EscribirSello 'medidores' ($r2 -eq 0)
    }
} else {
    $e = EstadoSaboteadores
    $color = if ($e.viejo) { 'Yellow' } else { 'DarkGray' }
    Write-Host ("  saboteadores: {0}" -f $e.texto) -ForegroundColor $color
    if ($e.viejo) {
        Write-Host "                los medidores no valen si nadie probo que discriminan:" -ForegroundColor Yellow
        Write-Host "                .\chequeo-completo.ps1 -SoloSaboteadores   (~96 s)" -ForegroundColor Yellow
    }
}

Write-Host ""
if ($rojos -gt 0) {
    Write-Host "CHEQUEO CON $rojos ROJO(S). Corregir antes de seguir con la tarea." -ForegroundColor Red
    exit 1
}
Write-Host "Chequeo OK. Ningun rojo." -ForegroundColor Green
exit 0
