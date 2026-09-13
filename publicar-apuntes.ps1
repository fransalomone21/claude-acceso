<#
.SYNOPSIS
  Publica en Drive los apuntes DECLARADOS en .claude/apuntes-publicos.json.

.DESCRIPTION
  El problema que resuelve no es copiar archivos: es que nadie se acuerde de
  copiarlos. Por eso el modo por defecto de este script en el arranque es
  -Verificar, que MIDE y avisa, y no depende de que alguien lo recuerde.

  Deny-by-default: un PDF no se publica por estar en el repo, se publica por
  estar en la lista. Lo que parece apunte y no esta declarado sale reportado
  como "sin declarar" -- ni se sube ni se ignora en silencio.

.PARAMETER Verificar
  No sube nada. Compara local contra Drive y sale en rojo (exit 1) si algo
  esta desactualizado, sin publicar o sin declarar.

.EXAMPLE
  .\publicar-apuntes.ps1 -Verificar
  .\publicar-apuntes.ps1
#>
[CmdletBinding()]
param(
    [switch]$Verificar,
    # Solo para probar-publicacion.ps1: lista alternativa. Sin esta costura el
    # script no se puede probar sin tocar el Drive real, y una alarma que no se
    # puede poner en rojo esta sin verificar.
    [string]$ListaPath
)

# NO se pone 'Stop': PowerShell 5.1 convierte CUALQUIER linea que un .exe
# escriba en stderr en un error terminante (NativeCommandError), y rclone
# escribe avisos normales ahi. El control de fallas es por $LASTEXITCODE, que
# mide lo que de verdad paso.
$ErrorActionPreference = 'Continue'
$raiz = Split-Path -Parent $MyInvocation.MyCommand.Path
if ($ListaPath) { $rutaLista = $ListaPath } else { $rutaLista = Join-Path $raiz '.claude\apuntes-publicos.json' }

function Escribir($texto, $color) { Write-Host $texto -ForegroundColor $color }

# --- rclone en PATH -------------------------------------------------------
$rclone = (Get-Command rclone -ErrorAction SilentlyContinue)
if ($null -eq $rclone) {
    $alt = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\rclone.exe'
    if (Test-Path $alt) { $rclone = $alt } else {
        Escribir "[ROJO] rclone no esta instalado." Red
        Escribir "       winget install --id Rclone.Rclone" Yellow
        exit 1
    }
} else { $rclone = $rclone.Source }

if (-not (Test-Path $rutaLista)) {
    Escribir "[ROJO] falta $rutaLista -- sin lista no se publica nada." Red
    exit 1
}
# Se llama $decl y no $lista A PROPOSITO: el parametro de arriba se llamaba
# $Lista, PowerShell no distingue mayusculas, y asignarle el objeto a una
# variable declarada [string] lo COERCIONA a texto -- sin error, sin aviso.
# El sintoma era '== remote '' ==' y una hora buscandolo en el JSON.
# El .TrimStart saca el BOM, que si esta se cuela en el nombre de la primera
# propiedad y deja $decl.remote vacio de otra manera distinta.
$decl = ConvertFrom-Json ([System.IO.File]::ReadAllText($rutaLista).TrimStart([char]0xFEFF))
$remote = $decl.remote

# --- el remote tiene token? ----------------------------------------------
Escribir "== remote '$remote' ==" Cyan
$null = & $rclone lsd "${remote}:" --max-depth 1 2>&1
if ($LASTEXITCODE -ne 0) {
    Escribir "[ROJO] el remote '$remote' todavia no esta autorizado contra Google." Red
    Escribir "" White
    Escribir "       Esto lo tiene que hacer Fran UNA sola vez -- abre el navegador" Yellow
    Escribir "       y pide iniciar sesion con la cuenta duena del Drive:" Yellow
    Escribir "" White
    Escribir "           rclone config reconnect ${remote}:" Yellow
    Escribir "" White
    Escribir "       El token queda en $env:APPDATA\rclone\rclone.conf, FUERA del repo." Yellow
    exit 1
}
Escribir "  autorizado" Green

# --- el trabajo -----------------------------------------------------------
$problemas = 0
$declarados = @()

foreach ($a in $decl.apuntes) {
    $local = Join-Path $raiz ($a.local -replace '/', '\')
    $declarados += $local
    $destino = "${remote}:$($a.materia)/$($a.'nombre-en-drive')"

    Escribir "" White
    Escribir "== $($a.materia) ==" Cyan

    if (-not (Test-Path $local)) {
        Escribir "  [ROJO] no existe el PDF local: $($a.local)" Red
        Escribir "         declarado en la lista pero no en el disco -- compilalo o sacalo de la lista." Yellow
        $problemas++
        continue
    }

    $sizeLocal = (Get-Item $local).Length
    $mtimeLocal = (Get-Item $local).LastWriteTimeUtc

    # que hay del otro lado
    $json = & $rclone lsjson "${remote}:$($a.materia)" --files-only 2>$null
    $remoto = $null
    if ($LASTEXITCODE -eq 0 -and $json) {
        $remoto = ($json | ConvertFrom-Json) | Where-Object { $_.Name -eq $a.'nombre-en-drive' }
    }

    if ($null -eq $remoto) {
        Escribir "  SIN PUBLICAR en Drive" Yellow
        if ($Verificar) { $problemas++; continue }
    }
    else {
        $mtimeRemoto = ([datetime]$remoto.ModTime).ToUniversalTime()
        $igual = ($remoto.Size -eq $sizeLocal) -and ([math]::Abs(($mtimeLocal - $mtimeRemoto).TotalSeconds) -lt 5)
        if ($igual) {
            Escribir "  al dia  ($([math]::Round($sizeLocal/1MB,1)) MB)" Green
            continue
        }
        Escribir "  DESACTUALIZADO en Drive" Yellow
        Escribir "    local : $($mtimeLocal.ToString('yyyy-MM-dd HH:mm')) UTC  $([math]::Round($sizeLocal/1MB,1)) MB" White
        Escribir "    drive : $($mtimeRemoto.ToString('yyyy-MM-dd HH:mm')) UTC  $([math]::Round($remoto.Size/1MB,1)) MB" White
        if ($Verificar) { $problemas++; continue }
    }

    Escribir "  subiendo..." White
    & $rclone copyto $local $destino --progress --stats-one-line
    if ($LASTEXITCODE -ne 0) {
        Escribir "  [ROJO] fallo la subida" Red
        $problemas++
    } else {
        Escribir "  publicado" Green
    }
}

# --- lo que parece apunte y NADIE declaro --------------------------------
Escribir "" White
Escribir "== apuntes sin declarar ==" Cyan
$candidatos = Get-ChildItem (Join-Path $raiz 'proyectos\documentos') -Recurse -Filter 'apunte.pdf' -ErrorAction SilentlyContinue
$sinDeclarar = @()
foreach ($c in $candidatos) {
    if ($declarados -notcontains $c.FullName) { $sinDeclarar += $c.FullName }
}
if ($sinDeclarar.Count -eq 0) {
    Escribir "  ninguno -- todo apunte del disco esta decidido" Green
} else {
    foreach ($s in $sinDeclarar) {
        Escribir "  [AMARILLO] $($s.Replace($raiz + '\',''))" Yellow
    }
    Escribir "  Decidilo: agregalo a 'apuntes' o a 'no-se-publican' en" Yellow
    Escribir "  .claude\apuntes-publicos.json. No decidir lo deja invisible." Yellow
    $problemas++
}

Escribir "" White
if ($problemas -gt 0) {
    Escribir "RESULTADO: $problemas cosa(s) sin resolver." Red
    exit 1
}
Escribir "RESULTADO: todo al dia." Green
Escribir "Carpeta: $($decl.'carpeta-drive')" Cyan
exit 0
