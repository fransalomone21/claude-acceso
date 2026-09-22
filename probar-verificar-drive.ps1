<#
.SYNOPSIS
  Rompe verificar-drive.ps1 a proposito y exige verlo en ROJO.

.DESCRIPTION
  verificar-drive.ps1 nacio en verde y nunca dijo otra cosa. Un chequeo asi
  esta SIN VERIFICAR: no se sabe si mide o si siempre contesta que si. Este
  script le rompe cada bloque y falla si alguno se queda callado.

  Cinco sabotajes y un control positivo:

    A  un archivo suelto en la raiz         -- REAL, sube y borra de verdad
    B  un objeto 'anyone' fuera de la publica -- con arbol dopado
    C  una carpeta declarada que no existe  -- con declaracion dopada
    D  un mail compartido sin declarar      -- con arbol dopado
    E  el LEEME declarado de la raiz, ausente -- con declaracion dopada
    +  control positivo: despues de restaurar, tiene que volver al verde

  El control positivo no es decorativo. El 2026-08-29 un saboteador de este
  repo restauro el archivo FUENTE y dejo la copia INSTALADA con el sabotaje
  adentro, y su control daba verde porque miraba el lugar equivocado. El
  sabotaje A es REAL contra el Drive por la misma razon: un saboteador que
  solo dopa un JSON prueba el parser, no el camino.

.EXAMPLE
  .\probar-verificar-drive.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Continue'
$raiz = Split-Path -Parent $MyInvocation.MyCommand.Path
$ver  = Join-Path $raiz 'verificar-drive.ps1'
$decl = Join-Path $raiz '.claude\estructura-drive.json'
$tmp  = Join-Path $env:TEMP ("sab-drive-" + [guid]::NewGuid().ToString('N').Substring(0,8))
New-Item -ItemType Directory -Path $tmp -Force | Out-Null

function Escribir($t, $c) { Write-Host $t -ForegroundColor $c }
$fallas = 0

function Exigir($titulo, $esperado, $salida, $texto) {
    # $esperado: 'ROJO' (exit 1) o 'VERDE' (exit 0)
    $ok = if ($esperado -eq 'ROJO') { $salida -ne 0 } else { $salida -eq 0 }
    if ($ok) {
        Escribir "   [OK  ] $titulo -- salio en $esperado, como tiene que ser" Green
        return 0
    }
    Escribir "   [FALLA] $titulo -- se esperaba $esperado y dio exit $salida" Red
    Escribir "           el chequeo NO discrimina: esta ciego a este caso." Red
    if ($texto) { $texto | Select-Object -Last 12 | ForEach-Object { Escribir "           | $_" DarkGray } }
    return 1
}

# rclone, con la ruta literal del config (ver el comentario en verificar-drive.ps1)
$conf = Join-Path $env:USERPROFILE '.config\rclone\rclone.conf'
$rclone = (Get-Command rclone -ErrorAction SilentlyContinue)
if ($null -eq $rclone) {
    $alt = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\rclone.exe'
    if (Test-Path $alt) { $rclone = $alt } else { Escribir "[ROJO] falta rclone" Red; exit 1 }
} else { $rclone = $rclone.Source }
$remote = ((Get-Content $decl -Raw -Encoding UTF8 | ConvertFrom-Json).remote) + ':'

Write-Host ""
Escribir "SABOTEADOR DE verificar-drive.ps1 -- cada bloque tiene que ponerse en rojo" Cyan
Write-Host ""

# --- el arbol real, una sola vez. Los sabotajes B y D lo dopan. ------------
Escribir "0. leyendo el arbol real de Drive (una vez, se reusa)" White
$arbolReal = & $rclone --config $conf lsjson $remote -R --metadata --drive-metadata-permissions read 2>$null
if ($LASTEXITCODE -ne 0) { Escribir "   [ROJO] no se pudo leer Drive" Red; exit 1 }
$arbolTxt = $arbolReal -join "`n"
$arbolOk  = Join-Path $tmp 'arbol-ok.json'
Set-Content -Path $arbolOk -Value $arbolTxt -Encoding UTF8
Escribir "   [OK  ] arbol leido" Green

# El arbol dopado se arma con CIRUGIA DE TEXTO, no volviendo a serializar los
# objetos de PowerShell. No es preferencia de estilo: el round-trip
# ConvertFrom-Json | ConvertTo-Json le comia el campo Metadata a las 225
# entradas reales, y el sabotaje B pasaba EN VERDE porque el arbol llegaba
# vacio -- o sea, el saboteador probaba el parser y no el chequeo. Lo encontro
# el propio saboteador en su primera corrida, que es para lo que existe.
function DoparArbol($entradaJson, $destino) {
    $t = $arbolTxt.TrimEnd()
    $i = $t.LastIndexOf(']')
    $cuerpo = $t.Substring(0, $i).TrimEnd()
    Set-Content -Path $destino -Value ($cuerpo + ",`n" + $entradaJson + "`n]") -Encoding UTF8
}

# =========================================================================
Write-Host ""
Escribir "A. archivo suelto en la raiz (sabotaje REAL contra el Drive)" White
$carnada = Join-Path $tmp 'BORRAR-sabotaje-de-prueba.txt'
Set-Content -Path $carnada -Value 'Archivo de prueba de probar-verificar-drive.ps1. Si sobrevive, borralo.' -Encoding UTF8
$subido = $false
try {
    & $rclone --config $conf copyto $carnada ($remote + 'BORRAR-sabotaje-de-prueba.txt') 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $subido = $true } else { Escribir "   [FALLA] no se pudo subir la carnada" Red; $fallas++ }
    if ($subido) {
        $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $ver -Rapido 2>&1
        $fallas += Exigir "archivo suelto en la raiz" 'ROJO' $LASTEXITCODE $o
    }
} finally {
    if ($subido) {
        & $rclone --config $conf deletefile ($remote + 'BORRAR-sabotaje-de-prueba.txt') 2>$null | Out-Null
        if ($LASTEXITCODE -ne 0) {
            Escribir "   [FALLA] NO SE PUDO BORRAR la carnada de la raiz de Drive." Red
            Escribir "           Borrala a mano: BORRAR-sabotaje-de-prueba.txt" Red
            $fallas++
        } else { Escribir "   [OK  ] carnada borrada de Drive" DarkGray }
    }
}

# =========================================================================
Write-Host ""
Escribir "B. un objeto 'anyone' FUERA de la carpeta publica" White
$arbolB = Join-Path $tmp 'arbol-b.json'
DoparArbol '{"Path":"00 - PERSONAL - no se comparte con nadie/documentos de identidad/DNI.pdf","Name":"DNI.pdf","Size":1,"MimeType":"application/pdf","IsDir":false,"ID":"FALSO","Metadata":{"permissions":"[{\"id\":\"anyoneWithLink\",\"type\":\"anyone\",\"role\":\"reader\"}]"}}' $arbolB
$o = & powershell -NoProfile -ExecutionPolicy Bypass -File $ver -DesdeJson $arbolB 2>&1
$fallas += Exigir "un DNI publico por link" 'ROJO' $LASTEXITCODE $o
# Idem D: el rojo tiene que salir CON el arbol real adentro, no sobre un
# archivo que quedo vacio. Un rojo por la razon equivocada no prueba nada.
if (($o -join "`n") -notmatch 'santiagofavazza@gmail.com') {
    Escribir "   [FALLA] salio en rojo pero PERDIO el arbol real -- mide sobre nada" Red
    $fallas++
}

# =========================================================================
Write-Host ""
Escribir "C. una carpeta declarada que no existe en el disco" White
$dc = Get-Content $decl -Raw -Encoding UTF8 | ConvertFrom-Json
$dc.raiz.carpetas = @($dc.raiz.carpetas) + [pscustomobject]@{
    nombre = '99 - CARPETA QUE NO EXISTE'; sensibilidad = 'n/a'; 'que-va' = 'sabotaje'
}
$declC = Join-Path $tmp 'decl-c.json'
$dc | ConvertTo-Json -Depth 9 | Set-Content -Path $declC -Encoding UTF8
$o = & powershell -NoProfile -ExecutionPolicy Bypass -File $ver -Rapido -Lista $declC 2>&1
$fallas += Exigir "carpeta declarada y ausente" 'ROJO' $LASTEXITCODE $o

# =========================================================================
Write-Host ""
Escribir "D. un mail compartido SIN declarar (pendiente amarillo, no rojo)" White
$arbolD = Join-Path $tmp 'arbol-d.json'
DoparArbol '{"Path":"00 - PERSONAL - no se comparte con nadie/documentos de identidad/DNI.pdf","Name":"DNI.pdf","Size":1,"MimeType":"application/pdf","IsDir":false,"ID":"FALSO","Metadata":{"permissions":"[{\"id\":\"X\",\"type\":\"user\",\"role\":\"writer\",\"emailAddress\":\"desconocido@ejemplo.com\"}]"}}' $arbolD
$o = & powershell -NoProfile -ExecutionPolicy Bypass -File $ver -DesdeJson $arbolD 2>&1
$txtD = $o -join "`n"
# Las DOS mitades. Que aparezca el mail dopado no alcanza: si el arbol llegara
# vacio, el dopado seria lo unico que hay y el chequeo pareceria funcionar
# midiendo nada. Se exige tambien que los declarados de verdad sigan contados.
if ($txtD -match 'desconocido@ejemplo.com.*SIN DECLARAR' -and $txtD -match 'santiagofavazza@gmail.com') {
    Escribir "   [OK  ] el mail sin declarar salio reportado, y los declarados siguen ahi" Green
} elseif ($txtD -match 'SIN DECLARAR') {
    Escribir "   [FALLA] reporto el dopado pero PERDIO el arbol real -- mide sobre nada" Red
    $fallas++
} else {
    Escribir "   [FALLA] un mail sin declarar paso en silencio" Red
    $fallas++
}

# =========================================================================
Write-Host ""
Escribir "E. el LEEME declarado de la raiz, ausente" White
$de = Get-Content $decl -Raw -Encoding UTF8 | ConvertFrom-Json
$de.raiz.'archivo-permitido' = 'LEEME QUE NO EXISTE.txt'
$declE = Join-Path $tmp 'decl-e.json'
$de | ConvertTo-Json -Depth 9 | Set-Content -Path $declE -Encoding UTF8
$o = & powershell -NoProfile -ExecutionPolicy Bypass -File $ver -Rapido -Lista $declE 2>&1
$fallas += Exigir "LEEME declarado y ausente" 'ROJO' $LASTEXITCODE $o

# =========================================================================
Write-Host ""
Escribir "+ control positivo: sin sabotaje, y con el Drive ya restaurado" White
$o = & powershell -NoProfile -ExecutionPolicy Bypass -File $ver 2>&1
$fallas += Exigir "el Drive real, limpio" 'VERDE' $LASTEXITCODE $o

Remove-Item -Path $tmp -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
if ($fallas -gt 0) {
    Escribir "ROJO: $fallas caso(s) donde el chequeo no discrimina." Red
    exit 1
}
Escribir "OK. verificar-drive.ps1 se pone en rojo en los 5 casos y vuelve al verde." Green
exit 0
