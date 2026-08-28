# guardia-iso.ps1 -- hook PreToolUse. Capa 2 de 3.
#
# NO es la capa que garantiza nada, y eso es a proposito: una lista negra de
# comandos tiene agujeros por construccion. Es la ALARMA TEMPRANA, la que
# explica por que en vez de dejar que el SO devuelva "acceso denegado" a secas.
# La que garantiza es la capa 3 (integridad medida en abrir-sesion.ps1), porque
# mide el EFECTO sobre el objeto y no adivina la intencion de un comando.
#
# FALLA CERRADO A PROPOSITO. Si el JSON del hook no parsea, NO deja pasar en
# silencio: corre los mismos patrones sobre el texto crudo. Un guardia que se
# desactiva solo cuando no entiende la entrada es peor que no tenerlo, porque
# nadie se entera de que dejo de proteger. Lo encontro probar-hooks.ps1 con un
# payload mal escapado, que es justo la forma en que esto aparece en la vida
# real: no como un ataque, como un formato que cambio.
#
# Lee el JSON del hook por stdin. Silencio + exit 0 = dejar pasar.
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

$ErrorActionPreference = 'Stop'

function Salir-Permitiendo { exit 0 }

function Denegar([string]$razon) {
    $o = @{
        hookSpecificOutput = @{
            hookEventName            = 'PreToolUse'
            permissionDecision       = 'deny'
            permissionDecisionReason = $razon
        }
    }
    Write-Output ($o | ConvertTo-Json -Depth 6 -Compress)
    exit 0
}

# Los patrones donde el archivo protegido esta INEQUIVOCAMENTE de destino.
# Leerlo es legitimo y constante (lbas.py, parche_iso.py verificar/preparar,
# los scripts de medicion), asi que mencionarlo NO alcanza para bloquear.
function Patrones-De-Escritura([string]$nombre) {
    @(
        @{ re = ">>?\s*[`"']?[^`"'|;]*$nombre";                                  que = 'redireccion de salida' }
        @{ re = "-Destination\s+[`"']?[^`"']*$nombre";                           que = '-Destination' }
        @{ re = "(Set-Content|Add-Content|Out-File|Clear-Content)[^;|]*$nombre"; que = 'cmdlet de escritura' }
        @{ re = "(Remove-Item|Rename-Item|Move-Item)[^;|]*$nombre";              que = 'cmdlet destructivo' }
        # Los verbos CORTOS van anclados a posicion de comando (inicio de linea
        # o despues de ; | &), no sueltos en el texto. Sin el ancla, "\bdel\b"
        # matcheaba el "DEL" de "PRUEBA DEL DESINSTALADOR" y bloqueaba un
        # comando legitimo: "del" es una palabra del espanol. Paso de verdad,
        # en el primer uso del guardia en produccion. Un freno que molesta sin
        # comprar nada es el que despues hace que se saquen todos.
        @{ re = "(^|[;|&`n(])\s*(rm|del|erase|mv|ren|move)\s+[^;|]{0,300}$nombre"; que = 'borrado o movida' }
        # OJO con \s en las clases negadas: la ruta real tiene espacios
        # ("Program Files", "Black [NTSC]"), asi que [^\s]* corta antes de
        # llegar al nombre y el patron da falso negativo. Lo encontro
        # probar-hooks.ps1; se acota con [^;|] para no cruzar comandos.
        @{ re = "\bof=\s*[`"']?[^;|]{0,300}$nombre";                             que = 'dd of=' }
        @{ re = "\battrib\b[^;|]*$nombre";                                       que = 'cambio de atributos' }
        # open() en modo escritura, en cualquiera de los dos ordenes, y sin
        # exigir que no haya parentesis en el medio: la ruta puede tenerlos.
        @{ re = "open[^;|]{0,200}$nombre[^;|]{0,80}[`"'](wb|r\+b|ab|w\+b|a\+b|xb)[`"']"; que = "open() en modo escritura" }
        @{ re = "[`"'](wb|r\+b|ab|w\+b|a\+b|xb)[`"'][^;|]{0,200}$nombre";        que = "open() en modo escritura" }
        @{ re = "\.(write|writelines|truncate)\s*\([^;|]{0,200}$nombre";         que = 'escritura explicita' }
        @{ re = "$nombre[^;|]{0,200}\.(write|writelines|truncate)\s*\(";         que = 'escritura explicita' }
    )
}

function Buscar-Violacion([string]$texto, $protegidos, [bool]$soloRuta) {
    foreach ($a in $protegidos) {
        if ($a.se_puede_escribir -eq $true) { continue }
        $nombre = [regex]::Escape([string]$a.nombre)
        if ($texto -inotmatch $nombre) { continue }

        if ($soloRuta) {
            # Nadie edita 3,9 GB con Write/Edit: cualquier coincidencia es un error.
            return @{ archivo = $a; que = 'escritura directa con Write/Edit' }
        }
        foreach ($p in (Patrones-De-Escritura $nombre)) {
            if ($texto -imatch $p.re) { return @{ archivo = $a; que = $p.que } }
        }
    }
    return $null
}

function Denegar-Por($v, [string]$extra) {
    $a = $v.archivo
    Denegar ("BLOQUEADO ($($v.que)): '$($a.nombre)' es intocable. $($a.por_que) " +
             "LEERLO si esta permitido: el guardia solo frena cuando el archivo aparece en posicion de DESTINO. " +
             "Para modificarlo se trabaja sobre una COPIA: python herramientas/parche_iso.py preparar <original> <copia>. " +
             "Si este comando era legitimo, NO se saca el guardia: se corrige el patron en .claude/hooks/guardia-iso.ps1 " +
             "y se corre .\probar-hooks.ps1, que exige ver el rojo y tambien los controles positivos.$extra")
}

# ------------------------------------------------------------------- entrada
$raw = ''
try { $raw = [Console]::In.ReadToEnd() } catch { Salir-Permitiendo }
if ([string]::IsNullOrWhiteSpace($raw)) { Salir-Permitiendo }

$raiz = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$cfg  = Join-Path $raiz '.claude\protegidos.json'
if (-not (Test-Path -LiteralPath $cfg)) { Salir-Permitiendo }
try { $prot = (Get-Content -LiteralPath $cfg -Raw -Encoding UTF8 | ConvertFrom-Json).archivos }
catch { Salir-Permitiendo }
if (-not $prot) { Salir-Permitiendo }

$ev = $null
try { $ev = $raw | ConvertFrom-Json } catch { $ev = $null }

# --- el JSON no parseo: FALLA CERRADO sobre el texto crudo ---
if ($null -eq $ev) {
    $v = Buscar-Violacion $raw $prot $false
    if ($v) {
        Denegar-Por $v ("  NOTA: el JSON del hook no se pudo parsear, asi que el guardia " +
                        "aplico los patrones sobre el texto crudo. Falla CERRADO a proposito.")
    }
    Salir-Permitiendo
}

# --- camino normal ---
$herramienta = [string]$ev.tool_name
switch -Regex ($herramienta) {
    '^(Write|Edit|NotebookEdit)$' {
        $t = [string]$ev.tool_input.file_path
        if ([string]::IsNullOrWhiteSpace($t)) { Salir-Permitiendo }
        $v = Buscar-Violacion $t $prot $true
        if ($v) { Denegar-Por $v '' }
        Salir-Permitiendo
    }
    '^(Bash|PowerShell)$' {
        $t = [string]$ev.tool_input.command
        if ([string]::IsNullOrWhiteSpace($t)) { Salir-Permitiendo }
        $v = Buscar-Violacion $t $prot $false
        if ($v) { Denegar-Por $v '' }
        Salir-Permitiendo
    }
    default { Salir-Permitiendo }
}

Salir-Permitiendo
