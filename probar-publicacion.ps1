<#
.SYNOPSIS
  Rompe publicar-apuntes.ps1 a proposito y exige verlo en rojo.

.DESCRIPTION
  Un chequeo que nunca fallo esta sin verificar (regla 3 del perfil). Este
  script provoca cada falla y comprueba el EFECTO -- el exit code y el texto --
  no la precondicion.

  No toca el Drive real: monta un remote 'alias' de rclone contra una carpeta
  temporal. Por eso corre sin que nadie se haya logueado en Google, que es
  justo la mitad del sistema que de otra forma quedaria sin probar hasta que
  alguien la usara en serio.
#>
# NO se pone 'Stop': PowerShell 5.1 convierte CUALQUIER linea que un .exe
# escriba en stderr en un error terminante (NativeCommandError), y rclone
# escribe avisos normales ahi. El control de fallas es por $LASTEXITCODE, que
# mide lo que de verdad paso.
$ErrorActionPreference = 'Continue'
$raiz = Split-Path -Parent $MyInvocation.MyCommand.Path

$rclone = (Get-Command rclone -ErrorAction SilentlyContinue)
if ($null -eq $rclone) {
    $alt = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\rclone.exe'
    if (Test-Path $alt) { $rclone = $alt } else { Write-Host "[ROJO] falta rclone" -ForegroundColor Red; exit 1 }
} else { $rclone = $rclone.Source }

$tmp = Join-Path $env:TEMP 'probar-publicacion'
$fake = Join-Path $tmp 'drive'
if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
$null = New-Item -ItemType Directory -Path $fake -Force

# Config PROPIO: el saboteador no ensucia el rclone.conf de verdad.
$confTest = Join-Path $tmp 'rclone-test.conf'
Set-Content $confTest -Value '' -Encoding ASCII
# remote falso, sin Google de por medio
& $rclone --config $confTest config create fakedrive-apuntes alias remote=$fake --non-interactive | Out-Null

$fisica = 'proyectos/documentos/fisica-espacial/apunte/apunte.pdf'
$electro = 'proyectos/documentos/electronica-analogica/apunte/apunte.pdf'

# Los proyectos que el JSON REAL declara como no publicables. Se leen de ahi y
# no se copian a mano, porque si no este saboteador se pone en rojo solo cada
# vez que nace un apunte nuevo en el disco -- que es justo lo que paso el
# 2026-09-20 con apunte-iise, y lo que hace que un saboteador se termine
# apagando. La lista vive en un solo lado.
$noPublicarReal = [ordered]@{}
try {
    $jr = Get-Content -Raw (Join-Path $raiz '.claude\apuntes-publicos.json') | ConvertFrom-Json
    foreach ($prop in $jr.'no-se-publican'.PSObject.Properties) {
        $noPublicarReal[$prop.Name] = $prop.Value
    }
} catch { }

function Lista($apuntes, $noPublicar = $null) {
    if ($null -eq $noPublicar) { $noPublicar = $noPublicarReal }
    $o = [ordered]@{
        remote = 'fakedrive-apuntes'
        'carpeta-drive' = 'carpeta de prueba'
        apuntes = $apuntes
        'no-se-publican' = $noPublicar
    }
    $p = Join-Path $tmp ('lista-' + [guid]::NewGuid().ToString('N').Substring(0,6) + '.json')
    $o | ConvertTo-Json -Depth 5 | Set-Content $p -Encoding UTF8
    return $p
}

$fallas = 0
function Caso($nombre, $listaPath, $esperaExit, $esperaTexto, $conVerificar, $conEstricto) {
    Write-Host ""
    Write-Host "-- $nombre" -ForegroundColor Cyan
    $script = Join-Path $raiz 'publicar-apuntes.ps1'
    $argumentos = @('-NoProfile','-ExecutionPolicy','Bypass','-File',$script,'-ListaPath',$listaPath,'-ConfRclone',$confTest)
    if ($conVerificar) { $argumentos += '-Verificar' }
    if ($conEstricto)  { $argumentos += '-Estricto' }
    $salida = & powershell.exe $argumentos 2>&1 | Out-String
    $code = $LASTEXITCODE
    $okCode = ($code -eq $esperaExit)
    $okTexto = ($esperaTexto -eq '' -or $salida -match [regex]::Escape($esperaTexto))
    if ($okCode -and $okTexto) {
        Write-Host "   OK  (exit $code, dijo '$esperaTexto')" -ForegroundColor Green
    } else {
        Write-Host "   FALLO: esperaba exit $esperaExit y el texto '$esperaTexto'; dio exit $code" -ForegroundColor Red
        Write-Host $salida
        $script:fallas++
    }
}

$ambos = @(
    @{ materia='Fisica Espacial'; local=$fisica; 'nombre-en-drive'='Apunte de Fisica Espacial.pdf' },
    @{ materia='Electronica Analogica'; local=$electro; 'nombre-en-drive'='Apunte de Electronica Analogica.pdf' }
)

# ---- primero se publica de verdad contra el drive falso -------------------
$l = Lista $ambos
Caso 'CONTROL POSITIVO 1/2: publica sin errores' $l 0 'todo al dia' $false

# ---- y ahora tiene que decir que esta al dia -----------------------------
Caso 'CONTROL POSITIVO 2/2: -Verificar da verde con todo al dia' $l 0 'al dia' $true

# ---- CONTROL POSITIVO 3/3: la OTRA mitad de "decidilo" --------------------
# El mensaje del publicador ofrece dos salidas --'apuntes' o 'no-se-publican'--
# y hasta el 2026-09-20 solo miraba la primera: un PDF declarado como que NO se
# publica seguia en amarillo para siempre, sin forma de bajarlo. Nadie lo habia
# notado porque ninguno de los tres proyectos de esa lista tenia un apunte.pdf;
# el primero que lo tuvo fue apunte-iise, el dia que se compilo.
# Se declara la CARPETA de electronica y se la deja fuera de 'apuntes': si la
# declaracion se respeta, no queda nada sin decidir.
# VA ACA, ANTES DE LOS ROJOS, y no es cosmetica: los casos de abajo ensucian el
# drive falso a proposito, asi que un verde corrido despues de ellos falla por
# la suciedad y no por lo que mide.
$l3b = Lista @( @{ materia='Fisica Espacial'; local=$fisica; 'nombre-en-drive'='Apunte de Fisica Espacial.pdf' } ) `
             ($noPublicarReal + @{ 'proyectos/documentos/electronica-analogica' = 'declarado en la prueba' })
Caso 'CONTROL POSITIVO 3/3: lo declarado en no-se-publican NO sale en amarillo' $l3b 0 'todo apunte del disco esta decidido' $true

# ---- ROJO 1: el archivo de Drive cambia -> desactualizado -----------------
$victima = Join-Path $fake 'Fisica Espacial\Apunte de Fisica Espacial.pdf'
Set-Content $victima -Value 'sabotaje' -Encoding ASCII
Caso 'ROJO 1: el PDF de Drive quedo viejo' $l 1 'DESACTUALIZADO' $true

# ---- ROJO 1b: MISMO TAMANO Y MISMA FECHA, distinto contenido -------------
# Este es el caso que el medidor viejo NO veia: comparaba (tamano, fecha) y
# daba VERDE. Un verde falso es silencioso, que es peor que un rojo falso.
# Se fabrica a mano: se copia el PDF bueno, se le cambia UN byte del medio y
# se le restaura la fecha original.
& $rclone --config $confTest copyto $fisica $victima | Out-Null
$bytes = [System.IO.File]::ReadAllBytes($victima)
$medio = [int]($bytes.Length / 2)
$bytes[$medio] = $bytes[$medio] -bxor 0xFF
$fechaOriginal = (Get-Item $victima).LastWriteTimeUtc
[System.IO.File]::WriteAllBytes($victima, $bytes)
(Get-Item $victima).LastWriteTimeUtc = $fechaOriginal
Caso 'ROJO 1b: mismo tamano y fecha, UN byte distinto' $l 1 'DESACTUALIZADO' $true $false

# ---- ROJO 2: un apunte declarado que no existe en el disco ---------------
$l2 = Lista @( @{ materia='Materia Fantasma'; local='proyectos/documentos/no-existe/apunte.pdf'; 'nombre-en-drive'='x.pdf' } )
Caso 'ROJO 2: declarado en la lista, ausente del disco' $l2 1 'no existe el PDF local' $true

# ---- ROJO 3: un apunte del disco que nadie declaro -----------------------
$l3 = Lista @( @{ materia='Fisica Espacial'; local=$fisica; 'nombre-en-drive'='Apunte de Fisica Espacial.pdf' } )
Caso 'ROJO 3: apunte en el disco sin declarar' $l3 1 'sin declarar' $true

# ---- el remote SIN AUTORIZAR: amarillo por defecto, rojo con -Estricto ----
# Sin estos dos casos la rama -Estricto seria codigo que nunca corrio, y la
# distincion entre 'pendiente' y 'roto' seria una intencion, no un mecanismo.
& $rclone --config $confTest config create sinauth drive --non-interactive | Out-Null
$lSA = Lista @( @{ materia='Fisica Espacial'; local=$fisica; 'nombre-en-drive'='x.pdf' },
                @{ materia='Electronica Analogica'; local=$electro; 'nombre-en-drive'='y.pdf' } )
$j = Get-Content $lSA -Raw | ConvertFrom-Json
$j.remote = 'sinauth'
$j | ConvertTo-Json -Depth 5 | Set-Content $lSA -Encoding UTF8
Caso 'AMARILLO: remote sin autorizar NO es un rojo' $lSA 0 'PENDIENTE' $true $false
Caso 'ROJO 4: el mismo caso con -Estricto si es rojo' $lSA 1 'PENDIENTE' $true $true

# ---- limpieza ------------------------------------------------------------
Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
if ($fallas -gt 0) {
    Write-Host "RESULTADO: $fallas caso(s) no se comportaron como se esperaba." -ForegroundColor Red
    Write-Host "El publicador esta ciego en esos casos: NO confiar en su verde." -ForegroundColor Red
    exit 1
}
Write-Host "RESULTADO: el publicador discrimina -- verde cuando toca y rojo cuando toca." -ForegroundColor Green
exit 0
