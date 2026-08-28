# probar-hooks.ps1 -- el saboteador de los frenos de claude-acceso.
#
# Hermano de probar-verificador.ps1. Existe por la regla 3 del perfil: un hook
# que dice OK y nunca dijo otra cosa esta SIN VERIFICAR. Aca cada freno se
# prueba en las dos direcciones:
#   - SABOTAJE       : se provoca el caso malo y se EXIGE ver el rojo.
#   - CONTROL POSITIVO: se corre el caso bueno y se exige ver el verde.
# Sin la segunda mitad, un guardia que dice "deny" a todo pasaria la prueba.
#
# No toca el repo ni el disco: los casos del guardia son payloads sinteticos
# por stdin, y el del ISO solo abre el archivo para ver si el SO lo rechaza.
# Se puede correr con cambios sin commitear (a diferencia de
# probar-verificador.ps1, que restaura con git checkout).
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

$ErrorActionPreference = 'Stop'
$raiz = $PSScriptRoot
$guardia = Join-Path $raiz '.claude\hooks\guardia-iso.ps1'
$arranque = Join-Path $raiz '.claude\hooks\arranque-proyecto.ps1'
$cfg = Join-Path $raiz '.claude\protegidos.json'

$fallas = 0
$corridos = 0

function Resultado([bool]$ok, [string]$etiqueta, [string]$detalle) {
    $script:corridos++
    if ($ok) {
        Write-Output ("  [OK]   {0}" -f $etiqueta)
    } else {
        $script:fallas++
        Write-Output ("  [FAIL] {0}" -f $etiqueta)
        Write-Output ("         {0}" -f $detalle)
    }
}

function Correr-Guardia([string]$json) {
    $tmp = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($tmp, $json, [System.Text.UTF8Encoding]::new($false))
        $salida = & cmd /c "type `"$tmp`" | powershell -NoProfile -ExecutionPolicy Bypass -File `"$guardia`"" 2>&1
        return ($salida | Out-String)
    } finally { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
}

function Caso-Guardia([string]$etiqueta, [string]$json, [bool]$esperaDeny) {
    $out = Correr-Guardia $json
    $denego = $out -match '"permissionDecision"\s*:\s*"deny"'
    if ($esperaDeny) {
        Resultado $denego $etiqueta "esperaba DENY y el guardia dejo pasar. Salida: '$($out.Trim())'"
    } else {
        Resultado (-not $denego) $etiqueta "esperaba PASAR y el guardia bloqueo. Salida: '$($out.Trim())'"
    }
}

Write-Output ""
Write-Output "=== probar-hooks: los frenos de claude-acceso, en las dos direcciones ==="
Write-Output "  Raiz: $raiz"
Write-Output ""

# ---------------------------------------------------------------- precondicion
Write-Output "precondicion: los archivos del sistema de frenos existen"
foreach ($f in @($guardia, $arranque, $cfg, (Join-Path $raiz '.claude\arranque.md'), (Join-Path $raiz '.claude\settings.json'))) {
    Resultado (Test-Path -LiteralPath $f) ("existe " + (Split-Path -Leaf $f)) "falta $f"
}

$prot = (Get-Content -LiteralPath $cfg -Raw -Encoding UTF8 | ConvertFrom-Json).archivos
$iso  = $prot | Where-Object { $_.clave -eq 'iso_original_black' }
$ruta = $iso.ruta
$nom  = $iso.nombre

Write-Output ""
Write-Output "capa 1 -- el sistema operativo (atributo ReadOnly)"

if (-not (Test-Path -LiteralPath $ruta)) {
    Resultado $false "el ISO protegido existe" "no esta en $ruta"
} else {
    $i = Get-Item -LiteralPath $ruta
    Resultado ($i.Attributes -band [System.IO.FileAttributes]::ReadOnly) `
        "$nom tiene el atributo ReadOnly" `
        "attrs=$($i.Attributes). Correr .claude\instalar-hooks.ps1"

    # SABOTAJE: abrirlo para escritura tiene que fallar.
    $rechazado = $false
    try { $fs = [System.IO.File]::Open($ruta, 'Open', 'Write'); $fs.Close() }
    catch { $rechazado = $true }
    Resultado $rechazado "SABOTAJE: abrir $nom en escritura -> rechazado por el SO" `
        "se pudo abrir para escritura: el freno de capa 1 NO sirve"

    # CONTROL POSITIVO: leerlo tiene que seguir andando.
    $leible = $false
    try { $fs = [System.IO.File]::Open($ruta, 'Open', 'Read'); $fs.Close(); $leible = $true } catch {}
    Resultado $leible "CONTROL POSITIVO: leer $nom sigue permitido" `
        "el freno se paso de rosca: bloqueo tambien la lectura, que es el 90% del trabajo"

    # CONTROL POSITIVO: un mod NO protegido sigue escribible.
    $mod = Join-Path (Split-Path -Parent $ruta) 'Black-mod-armas.iso'
    if (Test-Path -LiteralPath $mod) {
        $escribible = $false
        try { $fs = [System.IO.File]::Open($mod, 'Open', 'Write'); $fs.Close(); $escribible = $true } catch {}
        Resultado $escribible "CONTROL POSITIVO: Black-mod-armas.iso sigue escribible" `
            "se protegio de mas: los mods son artefactos reproducibles y se tienen que poder escribir"
    }
}

Write-Output ""
Write-Output "capa 2 -- el guardia PreToolUse (sabotajes)"

# Los payloads se ARMAN con ConvertTo-Json, no se escriben a mano. La primera
# version los escribia a mano, un escape salio mal, y el caso de open('r+b')
# dio verde porque el JSON no parseaba -- no porque el patron anduviera. Un
# test que se rompe solo y da PASS es peor que no tener el test.
function Json-Cmd([string]$tool, [string]$cmd) {
    @{ tool_name = $tool; tool_input = @{ command = $cmd } } | ConvertTo-Json -Depth 5 -Compress
}
function Json-Ruta([string]$tool, [string]$p) {
    @{ tool_name = $tool; tool_input = @{ file_path = $p } } | ConvertTo-Json -Depth 5 -Compress
}

Caso-Guardia "SABOTAJE: Write sobre el ISO original" `
    (Json-Ruta 'Write' $ruta) $true

Caso-Guardia "SABOTAJE: Edit sobre el ISO original" `
    (Json-Ruta 'Edit' $ruta) $true

Caso-Guardia "SABOTAJE: redireccion > al ISO original" `
    (Json-Cmd 'Bash' "echo x > '$ruta'") $true

Caso-Guardia "SABOTAJE: Copy-Item -Destination al ISO original" `
    (Json-Cmd 'PowerShell' "Copy-Item a.iso -Destination '$ruta'") $true

Caso-Guardia "SABOTAJE: Remove-Item del ISO original" `
    (Json-Cmd 'PowerShell' "Remove-Item -LiteralPath '$ruta' -Force") $true

Caso-Guardia "SABOTAJE: python open(...,'r+b') sobre el ISO original" `
    (Json-Cmd 'Bash' "python -c `"f=open('$ruta','r+b'); f.write(b'x')`"") $true

Caso-Guardia "SABOTAJE: python open(...,'wb') sobre el ISO original" `
    (Json-Cmd 'Bash' "python -c `"open('$ruta','wb')`"") $true

Caso-Guardia "SABOTAJE: attrib sobre el ISO original" `
    (Json-Cmd 'PowerShell' "attrib -R '$ruta'") $true

Caso-Guardia "SABOTAJE: dd of= al ISO original" `
    (Json-Cmd 'Bash' "dd if=/dev/zero of='$ruta' bs=1M count=1") $true

Caso-Guardia "SABOTAJE: rm en posicion de comando, despues de ;" `
    (Json-Cmd 'Bash' "cd /tmp; rm -f '$ruta'") $true

Caso-Guardia "SABOTAJE: del al inicio (cmd.exe)" `
    (Json-Cmd 'Bash' "del `"$ruta`"") $true

Write-Output ""
Write-Output "capa 2 -- FALLA CERRADO: si el JSON no parsea, no se desactiva en silencio"

Caso-Guardia "SABOTAJE: JSON roto que igual pide escribir el ISO -> deny" `
    "{esto no es json valido: open('$ruta','wb')" $true

Caso-Guardia "CONTROL: JSON roto que no toca nada protegido -> deja pasar" `
    "{esto tampoco es json: rm -rf /tmp/cualquiera" $false

Write-Output ""
Write-Output "capa 2 -- el guardia PreToolUse (CONTROLES POSITIVOS: lo legitimo tiene que pasar)"

Caso-Guardia "CONTROL: leer la tabla de LBAs del ISO original" `
    (Json-Cmd 'PowerShell' "python herramientas/lbas.py tabla '$ruta'") $false

Caso-Guardia "CONTROL: parche_iso.py preparar (el original es ORIGEN, no destino)" `
    (Json-Cmd 'PowerShell' "python herramientas/parche_iso.py preparar '$ruta' 'D:/copia.iso'") $false

Caso-Guardia "CONTROL: parche_iso.py verificar contra el original" `
    (Json-Cmd 'PowerShell' "python herramientas/parche_iso.py verificar '$ruta' 'D:/mod.iso'") $false

Caso-Guardia "CONTROL: open(...,'rb') sobre el ISO original" `
    (Json-Cmd 'Bash' "python -c `"f=open('$ruta','rb'); f.read(16)`"") $false

Caso-Guardia "CONTROL: el script de medicion que se uso en 7e (seek + read)" `
    (Json-Cmd 'Bash' "python -c `"f=open('$ruta','rb'); f.seek(1056910*2048); d=f.read(326432)`"") $false

Caso-Guardia "CONTROL: escribir un ISO de mod (no protegido)" `
    (Json-Cmd 'PowerShell' "Copy-Item a.iso -Destination 'C:/x/Black-mod-armas.iso'") $false

Caso-Guardia "CONTROL: Write sobre un archivo cualquiera del repo" `
    (Json-Ruta 'Write' "C:/Users/frans/Desktop/claude-acceso/README.md") $false

Caso-Guardia "CONTROL: una herramienta que el guardia no mira (Read)" `
    (Json-Ruta 'Read' $ruta) $false

# Este caso NO es hipotetico: es el comando exacto que el guardia bloqueo mal
# la primera vez que corrio en produccion. "del" es una palabra del espanol y
# el patron no estaba anclado a posicion de comando.
Caso-Guardia "CONTROL: la palabra 'del' en un texto, con el ISO mencionado" `
    (Json-Cmd 'PowerShell' "Write-Output '=== PRUEBA DEL DESINSTALADOR ==='; `$iso = '$ruta'; Get-Item -LiteralPath `$iso") $false

Caso-Guardia "CONTROL: 'move' y 'ren' como palabras sueltas, no como comando" `
    (Json-Cmd 'PowerShell' "Write-Output 'el move de camara y el render usan $ruta como fuente'") $false

Write-Output ""
Write-Output "capa 2 -- el guardia no se cae con entrada rara"

Caso-Guardia "entrada vacia -> deja pasar, no explota" "" $false
Caso-Guardia "JSON sin tool_input -> deja pasar" (@{ tool_name = 'Bash' } | ConvertTo-Json -Compress) $false

Write-Output ""
Write-Output "hook SessionStart -- emite, y AVISA si no puede"

$out = & powershell -NoProfile -ExecutionPolicy Bypass -File $arranque 2>&1 | Out-String
Resultado ($out -match 'AUTORIZACIONES PERMANENTES') `
    "el hook de arranque emite el contenido de arranque.md" `
    "emitio: '$($out.Trim())'"

# SABOTAJE: si falta el .md, tiene que DECIRLO, no callarse.
$md = Join-Path $raiz '.claude\arranque.md'
$bak = "$md.probando"
Move-Item -LiteralPath $md -Destination $bak -Force
try {
    $out2 = & powershell -NoProfile -ExecutionPolicy Bypass -File $arranque 2>&1 | Out-String
    Resultado ($out2 -match 'falta') `
        "SABOTAJE: sin arranque.md el hook lo DICE en vez de callarse" `
        "emitio en silencio: '$($out2.Trim())'"
} finally { Move-Item -LiteralPath $bak -Destination $md -Force }

Write-Output ""
Write-Output "capa 3 -- integridad medida (la que no tiene agujeros)"

$abrir = Join-Path $raiz 'proyectos\ingenieria\black\abrir-sesion.ps1'
if (Test-Path -LiteralPath $abrir) {
    $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $abrir -SoloIntegridad 2>&1 | Out-String
    Resultado ($LASTEXITCODE -eq 0 -and $o -match 'integridad OK') `
        "abrir-sesion.ps1 -SoloIntegridad da verde con el ISO sano" `
        "salida: '$($o.Trim())'"

    # SABOTAJE: pedirle la integridad de una huella que no puede cumplirse.
    $o2 = & powershell -NoProfile -ExecutionPolicy Bypass -File $abrir -SoloIntegridad -TamEsperadoDePrueba 1 2>&1 | Out-String
    Resultado ($LASTEXITCODE -ne 0) `
        "SABOTAJE: con la huella cambiada, la integridad se pone en ROJO" `
        "dio verde con un tamano esperado falso: el chequeo esta ciego. Salida: '$($o2.Trim())'"
} else {
    Resultado $false "existe abrir-sesion.ps1" "falta $abrir"
}

Write-Output ""
Write-Output "------------------------------------------------------------"
if ($fallas -eq 0) {
    Write-Output "  Frenos OK. $corridos comprobaciones, ninguna falla."
    Write-Output "  Cada freno se vio en ROJO al menos una vez, y lo legitimo sigue pasando."
    exit 0
} else {
    Write-Output "  $fallas de $corridos comprobaciones FALLARON."
    Write-Output "  Un freno que no se puede poner en rojo no protege: esta sin verificar."
    exit 1
}
