# probar-nuevo-proyecto.ps1 -- saboteador de la fila que nuevo-proyecto.ps1 escribe en .claude/cascada.json.
#
# Por que (2026-10-02, regla 15): carrera nacio sin fila en el catalogo y la puerta de la cascada no
# sabia que exigirle. nuevo-proyecto.ps1 ahora la escribe; esto prueba que la escriba BIEN y que no
# rompa el catalogo cuando no puede. Todo corre en una carpeta temporal con una COPIA del catalogo
# real (el control positivo se parece al artefacto, no es el minimo que pasa): no toca el repo.
#
# Casos: cada naturaleza con su default, -Necesidades explicito, la diferencia contra el original
# es UNA linea nueva y UNA coma (sin reformatear), y dos sabotajes que exigen exit 1 con el
# catalogo intacto (necesidad inexistente, catalogo sin bloque "proyectos"), mas el que ya tenia fila.
#
# ASCII puro a proposito: la consola de Windows lee cp1252.

$raiz   = $PSScriptRoot
$script = if ($env:PROBAR_NP_SCRIPT) { $env:PROBAR_NP_SCRIPT } else { Join-Path $raiz 'nuevo-proyecto.ps1' }  # otra version, para verla en rojo
$real   = Join-Path $raiz '.claude\cascada.json'
$malos = 0; $corridos = 0

function Resultado([bool]$ok, [string]$etiqueta, [string]$detalle) {
    $script:corridos++
    if ($ok) { Write-Output "  [OK]   $etiqueta" } else { $script:malos++; Write-Output "  [FAIL] $etiqueta"; Write-Output "         $detalle" }
}

function Banco([string]$catalogo) {
    $t = Join-Path ([System.IO.Path]::GetTempPath()) ('probar-np-' + [guid]::NewGuid().ToString('N').Substring(0, 8))
    New-Item -ItemType Directory -Force (Join-Path $t '.claude') | Out-Null
    Copy-Item -Recurse (Join-Path $raiz 'plantillas') (Join-Path $t 'plantillas')
    [System.IO.File]::WriteAllText((Join-Path $t '.claude\cascada.json'), $catalogo, [System.Text.UTF8Encoding]::new($false))
    Set-Content -LiteralPath (Join-Path $t '.gitignore') -Value '# prueba' -Encoding ASCII
    return $t
}

function Correr([string]$t, [string[]]$argumentos) {
    $o = & powershell -NoProfile -ExecutionPolicy Bypass -File $script @argumentos -Raiz $t 2>&1 | Out-String
    return @{ rc = $LASTEXITCODE; out = $o; cat = [System.IO.File]::ReadAllText((Join-Path $t '.claude\cascada.json')) }
}

function Necesidades([string]$cat, [string]$nombre) {
    $tmp = [System.IO.Path]::GetTempFileName()
    [System.IO.File]::WriteAllText($tmp, $cat, [System.Text.UTF8Encoding]::new($false))
    $r = & python -c "import json,sys; d=json.load(open(sys.argv[1],encoding='utf-8')); print(json.dumps(d['proyectos'].get(sys.argv[2],{}).get('necesidades','SIN-FILA')))" $tmp $nombre 2>&1 | Out-String
    Remove-Item -LiteralPath $tmp -Force
    return $r.Trim()
}

Write-Output ""
Write-Output "=== probar-nuevo-proyecto: la fila del catalogo de la cascada ==="
$orig = [System.IO.File]::ReadAllText($real, [System.Text.UTF8Encoding]::new($false))
$lineasOrig = $orig -split "\r?\n"

# --- controles positivos: cada naturaleza, y la forma del cambio ----------------------------------
$casos = @(
    @{ n = 'prueba-doc'; a = @('-Naturaleza', 'documentos');                           esp = '["materia"]' },
    @{ n = 'prueba-ing'; a = @('-Naturaleza', 'ingenieria');                           esp = '["ingenieria-inversa"]' },
    @{ n = 'prueba-seg'; a = @('-Naturaleza', 'seguimiento');                          esp = '[]' },
    @{ n = 'prueba-met'; a = @('-Naturaleza', 'ingenieria', '-Necesidades', 'metodo'); esp = '["metodo"]' }
)
foreach ($c in $casos) {
    $t = Banco $orig
    try {
        $r = Correr $t (@($c.n) + $c.a)
        $nec = Necesidades $r.cat $c.n
        Resultado ($r.rc -eq 0 -and $nec -eq $c.esp) "$($c.n) $($c.a -join ' ') -> fila con $($c.esp)" "rc=$($r.rc) necesidades=$nec"
        # sin reformatear: una linea mas, y de las viejas cambio a lo sumo una (la coma)
        $nuevas = $r.cat -split "\r?\n"
        $cambiadas = @(Compare-Object $lineasOrig $nuevas -SyncWindow 2 | Where-Object { $_.SideIndicator -eq '<=' })
        Resultado ($nuevas.Count -eq $lineasOrig.Count + 1 -and $cambiadas.Count -le 1 -and
                   ($cambiadas.Count -eq 0 -or ($cambiadas[0].InputObject.TrimEnd() + ',') -in $nuevas)) `
            "  $($c.n): una linea nueva y a lo sumo una coma, el resto intacto" `
            "lineas $($lineasOrig.Count) -> $($nuevas.Count); viejas cambiadas: $($cambiadas.Count)"
    } finally { Remove-Item -Recurse -Force $t -ErrorAction SilentlyContinue }
}

# --- sabotajes: no puede escribir -> exit 1 y el catalogo intacto ---------------------------------
$t = Banco $orig
try {
    $r = Correr $t @('prueba-mal', '-Naturaleza', 'documentos', '-Necesidades', 'no-existe')
    Resultado ($r.rc -eq 1 -and $r.cat -eq $orig -and $r.out -match 'NO se escribio') `
        "SABOTAJE: necesidad inexistente -> exit 1, catalogo intacto" "rc=$($r.rc) intacto=$($r.cat -eq $orig)"
} finally { Remove-Item -Recurse -Force $t -ErrorAction SilentlyContinue }

$roto = $orig -replace '"proyectos"\s*:\s*\{', '"proyectos_otro": {'
$t = Banco $roto
try {
    $r = Correr $t @('prueba-sin', '-Naturaleza', 'documentos')
    Resultado ($r.rc -eq 1 -and $r.cat -eq $roto -and $r.out -match 'no encontre el bloque') `
        "SABOTAJE: catalogo sin bloque proyectos -> exit 1, sin tocarlo" "rc=$($r.rc) intacto=$($r.cat -eq $roto)"
} finally { Remove-Item -Recurse -Force $t -ErrorAction SilentlyContinue }

# --- un nombre que ya tiene fila (adoptar algo que el catalogo ya conoce) -------------------------
$conocido = ([regex]::Match($orig, '"proyectos"\s*:\s*\{\s*"([^"]+)"')).Groups[1].Value  # derivado, no literal
$t = Banco $orig
try {
    $r = Correr $t @($conocido, '-Naturaleza', 'documentos')
    Resultado ($r.rc -eq 0 -and $r.cat -eq $orig -and $r.out -match 'ya tenia la fila') `
        "'$conocido' ya tenia fila -> no se duplica ni se toca" "rc=$($r.rc) intacto=$($r.cat -eq $orig)"
} finally { Remove-Item -Recurse -Force $t -ErrorAction SilentlyContinue }

Write-Output ""
if ($corridos -lt 11) { Write-Output "  [FAIL] corrieron $corridos casos, el piso es 11"; exit 1 }
if ($malos -eq 0) { Write-Output "TODO BIEN ($corridos casos)"; exit 0 }
Write-Output "$malos de $corridos casos FALLARON"; exit 1
