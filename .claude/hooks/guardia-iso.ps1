# guardia-iso.ps1 -- hook PreToolUse. Capa 2 de 3.
#
# NO es la capa que garantiza nada, y eso es a proposito: una lista negra de
# comandos tiene agujeros por construccion. Es la ALARMA TEMPRANA, la que
# explica por que en vez de dejar que el SO devuelva "acceso denegado" a secas.
# La que garantiza es la capa 3 (integridad medida en abrir-sesion.ps1), porque
# mide el EFECTO sobre el objeto y no adivina la intencion de un comando.
#
# NUNCA SE DESACTIVA EN SILENCIO. Tiene TRES entradas y las tres estan
# cubiertas -- enumerar las entradas antes de contar los casos es lo que hizo
# falta para encontrar la segunda, que sobrevivio una sesion entera dedicada a
# sabotear este mismo archivo:
#
#   1. el PAYLOAD del evento. Si el JSON no parsea, corre los mismos patrones
#      sobre el texto crudo (leccion 70). Lo encontro probar-hooks.ps1 con un
#      payload mal escapado -- que es como esto aparece en la vida real: no
#      como un ataque, como un formato que cambio.
#   2. el CONFIG (protegidos.json). Ausente, corrupto o vacio -> 'ask', no
#      'permitir'. Era fail-open silencioso hasta el 2026-08-28; ver
#      Preguntar-Config para por que 'ask' y no 'deny'.
#   3. el ENTORNO. stdin ilegible o vacio -> deja pasar, y es correcto: un
#      hook sin entrada no es una llamada a una herramienta. Es la unica
#      salida temprana que queda abierta a proposito, y esta declarada aca
#      para que no vuelva a ser un hallazgo dentro de seis meses.
#
# Un caso tapa un agujero; un PRINCIPIO hace un barrido. El principio es
# Saltzer y Schroeder (1975): todo camino de salida temprana de un mecanismo
# de EXCLUSION es un fail-open hasta que se demuestre lo contrario, y falla en
# silencio -- que es lo que lo hace durar.
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

# 'ask' = ni permitir ni denegar: se lo pregunta al humano. Es lo que
# corresponde cuando el guardia no puede decidir porque perdio su config, no
# cuando detecto una violacion. Ver Preguntar-Config.
function Preguntar([string]$razon) {
    $o = @{
        hookSpecificOutput = @{
            hookEventName            = 'PreToolUse'
            permissionDecision       = 'ask'
            permissionDecisionReason = $razon
        }
    }
    Write-Output ($o | ConvertTo-Json -Depth 6 -Compress)
    exit 0
}

# El config es la SEGUNDA entrada del guardia, y hasta el 2026-08-28 fue su
# agujero: si protegidos.json no estaba, no parseaba o traia la lista vacia, el
# guardia dejaba pasar TODO en silencio. Tres caminos de salida temprana, los
# tres fail-open (Saltzer y Schroeder, 1975: un mecanismo de EXCLUSION falla
# permitiendo, "a failure which may go unnoticed in normal use").
#
# Ahora los tres FALLAN CERRADO. La objecion que lo habia dejado sin arreglar
# --"deny cuando falta el config rompe cualquier repo donde el hook este
# instalado y el archivo no exista"-- se MIDIO y no aplica: el hook se registra
# UNICAMENTE en .claude/settings.json de claude-acceso, y protegidos.json esta
# trackeado en ese mismo repo (git ls-files lo confirma). Ahi "no esta" no
# significa "este repo no lo configuro": significa que el archivo del repo
# desaparecio, que es exactamente el modo de falla peligroso.
#
# QUE decision, y por que NO es 'deny'. Se probaron las dos:
#
#   deny  -> brickea la salida. El arreglo es 'git checkout -- .claude/
#            protegidos.json', que es un comando Bash, y este mismo guardia
#            matchea Bash: se bloquearia a si mismo el unico camino de vuelta.
#            Un freno del que no se sabe salir es el que despues se saca entero.
#   ask   -> le pasa la decision al humano, que es lo correcto cuando el
#            guardia YA NO SABE que proteger. No deja pasar por su cuenta y no
#            brickea nada.
#
# Y ademas: la capa 2 NO es la que garantiza --lo dice protegidos.json y lo
# dice el Nivel 0-- porque una lista negra tiene agujeros por construccion. La
# que garantiza es la capa 1 (ReadOnly del SO) y la capa 3 (integridad medida
# sobre el objeto). Que la capa 2 se caiga es sobrevivible; que se caiga EN
# SILENCIO no lo es. El defecto nunca fue "deja pasar": fue "nadie se entera".
function Preguntar-Config([string]$estado, [string]$cfg) {
    # ${estado}, no $estado: dentro de un string de PowerShell, una variable
    # seguida de ':' se parsea como calificador de espacio de nombres --el
    # mismo mecanismo de $env:VAR-- y el archivo entero deja de parsear. El
    # sintoma no apunta aca: cmd.exe escupe un NativeCommandError desde el
    # script que lo invoca, y la linea que senala es la del invocador.
    Preguntar ("El config del guardia esta ${estado}: '$cfg' es la lista de archivos intocables " +
               "y el guardia NO la puede leer, asi que la capa 2 esta CIEGA -- no sabe que proteger. " +
               "Siguen en pie la capa 1 (ReadOnly del SO) y la capa 3 (integridad al abrir sesion), " +
               "pero la alarma temprana no esta. NO se aprueba esto a ciegas. " +
               "SALIDA, un comando: git checkout -- .claude/protegidos.json  (esta trackeado en este repo). " +
               "Si de verdad se quiere sacar el freno: .claude\desinstalar-hooks.ps1 -- lo que se instala " +
               "solo tiene que poder desinstalarse solo. Despues de cualquiera de las dos: .\probar-hooks.ps1")
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
# Las TRES salidas tempranas del config -- ausente, no parsea, lista vacia --
# eran fail-open silencioso hasta el 2026-08-28. Ninguna de las tres se puede
# distinguir desde afuera de "el guardia anda bien y no vio nada".
if (-not (Test-Path -LiteralPath $cfg)) { Preguntar-Config 'AUSENTE' $cfg }
try   { $prot = (Get-Content -LiteralPath $cfg -Raw -Encoding UTF8 | ConvertFrom-Json).archivos }
catch { Preguntar-Config 'CORRUPTO (no parsea como JSON)' $cfg }
if (-not $prot -or @($prot).Count -eq 0) { Preguntar-Config 'VACIO (no declara ningun archivo)' $cfg }

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
