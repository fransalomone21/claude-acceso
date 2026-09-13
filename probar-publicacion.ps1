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

function Lista($apuntes) {
    $o = [ordered]@{
        remote = 'fakedrive-apuntes'
        'carpeta-drive' = 'carpeta de prueba'
        apuntes = $apuntes
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

# ---- ROJO 1: el archivo de Drive cambia -> desactualizado -----------------
$victima = Join-Path $fake 'Fisica Espacial\Apunte de Fisica Espacial.pdf'
Set-Content $victima -Value 'sabotaje' -Encoding ASCII
Caso 'ROJO 1: el PDF de Drive quedo viejo' $l 1 'DESACTUALIZADO' $true

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
