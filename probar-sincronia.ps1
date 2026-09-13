# probar-sincronia.ps1 -- el saboteador de verificar-sincronia.ps1.
#
# Hermano de probar-verificador.ps1 y probar-hooks.ps1. Regla 3 del perfil: un
# medidor que dice OK y nunca dijo otra cosa esta SIN VERIFICAR.
#
# Las dos mitades importan por igual:
#   - SABOTAJE        : arbol atrasado -> se EXIGE ver el rojo.
#   - CONTROL POSITIVO: arbol al dia, y arbol adelantado -> se exige NO ver
#                       rojo. La segunda es la que atrapa el error caro: un
#                       medidor que se pusiera en rojo por tener commits sin
#                       pushear estaria en rojo en toda sesion a mitad de
#                       camino, y una alarma que suena siempre se apaga sola.
#
# No toca ningun repo de verdad: arma repos de juguete en una caja temporal.
#
# Sin acentos a proposito: la consola de Windows lo lee como cp1252.

$ErrorActionPreference = 'Continue'
$raiz = $PSScriptRoot
$medidor = Join-Path $raiz 'verificar-sincronia.ps1'

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

function Correr-Medidor([string]$caja) {
    $out = & powershell -NoProfile -ExecutionPolicy Bypass -File $medidor -Raiz $caja 2>&1 | Out-String
    return @{ salida = $out; code = $LASTEXITCODE }
}

Write-Output ""
Write-Output "=== probar-sincronia: el medidor de atraso, en las dos direcciones ==="

if (-not (Test-Path -LiteralPath $medidor)) {
    Write-Output "  [FAIL] falta $medidor"
    exit 1
}

$caja = Join-Path ([System.IO.Path]::GetTempPath()) ("sincronia-" + [guid]::NewGuid().ToString('N').Substring(0, 8))
$env:GIT_TERMINAL_PROMPT = '0'

try {
    New-Item -ItemType Directory -Force -Path $caja | Out-Null
    $bare  = Join-Path $caja 'origen.git'
    $uno   = Join-Path $caja 'uno'     # el arbol que se mide
    $dos   = Join-Path $caja 'dos'     # "la otra maquina"

    & git init --bare --quiet $bare
    & git init --quiet $uno
    & git -C $uno config user.email 'prueba@local'
    & git -C $uno config user.name  'prueba'
    Set-Content -LiteralPath (Join-Path $uno 'a.txt') -Value 'uno' -Encoding ascii
    & git -C $uno add -A
    & git -C $uno commit --quiet -m 'inicial'
    & git -C $uno remote add origin $bare
    & git -C $uno push --quiet -u origin HEAD:refs/heads/main 2>&1 | Out-Null
    & git -C $uno branch --quiet -M main 2>&1 | Out-Null
    & git -C $uno branch --quiet --set-upstream-to=origin/main main 2>&1 | Out-Null

    # ---------------------------------------------------------------- control
    Write-Output ""
    Write-Output "CONTROL POSITIVO: arbol al dia -> verde"
    $r = Correr-Medidor $uno
    Resultado ($r.code -eq 0 -and $r.salida -match 'al dia con origin') `
        "con el arbol al dia el medidor NO se queja" `
        "exit=$($r.code). Salida: '$($r.salida.Trim())'"

    # ---------------------------------------------------------------- sabotaje
    Write-Output ""
    Write-Output "SABOTAJE: la otra maquina pusheo y este arbol no pulleo"
    & git clone --quiet $bare $dos
    & git -C $dos config user.email 'prueba@local'
    & git -C $dos config user.name  'prueba'
    Set-Content -LiteralPath (Join-Path $dos 'b.txt') -Value 'dos' -Encoding ascii
    & git -C $dos add -A
    & git -C $dos commit --quiet -m 'commit de la otra maquina'
    & git -C $dos push --quiet origin HEAD:main 2>&1 | Out-Null

    $r = Correr-Medidor $uno
    Resultado ($r.code -ne 0) `
        "SABOTAJE: con el arbol ATRASADO el medidor sale en ROJO" `
        "dio exit=$($r.code) con un commit en origin que no esta en el arbol: el medidor esta ciego. Salida: '$($r.salida.Trim())'"
    Resultado ($r.salida -match 'ATRASADO') `
        "el rojo NOMBRA el atraso (no es un rojo generico)" `
        "no dice ATRASADO. Salida: '$($r.salida.Trim())'"

    # ------------------------------------------------- control: no falso rojo
    Write-Output ""
    Write-Output "CONTROL POSITIVO: arbol ADELANTADO (a mitad de sesion) -> amarillo, NO rojo"
    & git -C $uno pull --quiet --ff-only 2>&1 | Out-Null
    Set-Content -LiteralPath (Join-Path $uno 'c.txt') -Value 'local' -Encoding ascii
    & git -C $uno add -A
    & git -C $uno commit --quiet -m 'trabajo sin pushear'

    $r = Correr-Medidor $uno
    Resultado ($r.code -eq 0) `
        "con commits sin pushear NO se pone en rojo" `
        "salio en rojo por el estado normal de una sesion a mitad de camino: la alarma se vuelve ruido. Salida: '$($r.salida.Trim())'"
    Resultado ($r.salida -match 'sin pushear') `
        "pero lo DICE en amarillo (no se lo traga)" `
        "no menciona los commits sin pushear. Salida: '$($r.salida.Trim())'"

    # ------------------------------------------- control: repo sin remote
    Write-Output ""
    Write-Output "CONTROL POSITIVO: un repo sin remote no es un fallo"
    $solo = Join-Path $caja 'solo'
    & git init --quiet $solo
    & git -C $solo config user.email 'prueba@local'
    & git -C $solo config user.name  'prueba'
    Set-Content -LiteralPath (Join-Path $solo 'x.txt') -Value 'x' -Encoding ascii
    & git -C $solo add -A
    & git -C $solo commit --quiet -m 'local'

    $r = Correr-Medidor $solo
    Resultado ($r.code -eq 0 -and $r.salida -match 'sin remote') `
        "un repo sin remote se nombra y no voltea el chequeo" `
        "exit=$($r.code). Salida: '$($r.salida.Trim())'"

} finally {
    # Los .git de Windows quedan con archivos de solo lectura: sin -Force el
    # borrado falla y la caja se acumula en TEMP corrida tras corrida.
    Get-ChildItem -LiteralPath $caja -Recurse -Force -ErrorAction SilentlyContinue |
        ForEach-Object { try { $_.Attributes = 'Normal' } catch {} }
    Remove-Item -LiteralPath $caja -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Output ""
Write-Output "------------------------------------------------------------"
if ($fallas -eq 0) {
    Write-Output "  Medidor de sincronia OK. $corridos comprobaciones, ninguna falla."
    Write-Output "  Se lo vio en ROJO con el arbol atrasado, y en verde con el arbol sano."
    exit 0
} else {
    Write-Output "  $fallas de $corridos comprobaciones FALLARON."
    Write-Output "  Un medidor que no se puede poner en rojo no mide: esta sin verificar."
    exit 1
}
