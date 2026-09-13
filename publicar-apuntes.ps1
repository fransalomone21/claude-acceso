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
    [string]$ListaPath,
    # Idem: config de rclone alternativo, para que el saboteador no tenga
    # que meter remotes de prueba en el config de verdad.
    [string]$ConfRclone,
    # Convierte en ROJO lo que por defecto es un PENDIENTE amarillo.
    [switch]$Estricto
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

# El config vive en una RUTA LITERAL, no bajo %APPDATA%, y no es mania: la
# app de Claude corre empaquetada (MSIX) y Windows le REDIRIGE %APPDATA% a
#   AppData\Local\Packages\Claude_*\LocalCache\Roaming\
# aunque la variable siga diciendo C:\Users\frans\AppData\Roaming. O sea que la
# sesion y la consola de Fran escriben en ARCHIVOS DISTINTOS creyendo los dos
# que escriben en el mismo. Sintoma: rclone dijo 'not found' sobre un archivo
# que existia y que la otra ventana listaba sin drama. Medido: habia dos
# rclone.conf en el disco. La carpeta .config del perfil NO se redirige.
#
# USERPROFILE, en cambio, SI se puede usar: la redireccion de MSIX alcanza a
# AppData\Roaming, no al perfil entero. Medido el 2026-09-13 desde adentro de
# la app empaquetada: $env:USERPROFILE dio C:\Users\frans y el archivo que
# resuelve por ahi es el MISMO que el de la ruta literal. Se cambia porque la
# ruta literal ataba el publicador a que el usuario de Windows se llame
# 'frans', y desde que hay una segunda maquina eso deja de ser cierto solo.
if ($ConfRclone) { $conf = $ConfRclone } else { $conf = Join-Path $env:USERPROFILE '.config\rclone\rclone.conf' }

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

$problemas = 0

# --- el hook que hace que esto corra SOLO -------------------------------
# Este medidor corre en cada arranque, asi que es el lugar donde mirar si el
# disparador automatico sigue puesto. Un hook de git no se versiona: si Fran
# vuelve a clonar el repo, desaparece sin avisar y la publicacion vuelve a
# depender de que alguien se acuerde -- que es justo lo que se vino a sacar.
Escribir "" White
Escribir "== hook post-commit ==" Cyan
$hookInst = Join-Path $raiz ".git" | Join-Path -ChildPath "hooks" | Join-Path -ChildPath "post-commit"
$hookSrc  = Join-Path $raiz ".claude" | Join-Path -ChildPath "hooks" | Join-Path -ChildPath "post-commit"
if (-not (Test-Path $hookInst)) {
    Escribir "  [ROJO] no esta instalado -- los apuntes no se publican solos." Red
    Escribir "         copy .claude\hooks\post-commit .git\hooks\post-commit" Yellow
    $problemas++
} elseif ((Get-FileHash $hookInst).Hash -ne (Get-FileHash $hookSrc).Hash) {
    Escribir "  [ROJO] el instalado difiere de la fuente versionada." Red
    Escribir "         copy .claude\hooks\post-commit .git\hooks\post-commit" Yellow
    $problemas++
} else {
    Escribir "  instalado e identico a la fuente" Green
}

# --- el remote tiene token? ----------------------------------------------
Escribir "== remote '$remote' ==" Cyan
$null = & $rclone --config $conf lsd "${remote}:" --max-depth 1 2>&1
if ($LASTEXITCODE -ne 0) {
    Escribir "[PENDIENTE] el remote '$remote' todavia no esta autorizado contra Google." Yellow
    Escribir "" White
    Escribir "       Esto lo tiene que hacer Fran UNA sola vez -- abre el navegador" Yellow
    Escribir "       y pide iniciar sesion con la cuenta duena del Drive:" Yellow
    Escribir "" White
    $cmdAuth = 'rclone --config "' + $conf + '" config reconnect ' + $remote + ':'
    Escribir "           $cmdAuth" Yellow
    Escribir "" White
    Escribir "       El token queda en $conf, FUERA del repo." Yellow
    Escribir "       El --config va a proposito: sin el, dos consolas de la misma" Yellow
    Escribir "       maquina resuelven archivos distintos. Ya paso." Yellow
    Escribir "       Hasta que lo corras NO se sube nada: hay que subir a mano." Yellow
    Escribir "" White
    # AMARILLO y exit 0, no rojo, y la diferencia importa: esto no es una falla
    # del sistema, es un paso de instalacion que le falta a una persona. Un
    # medidor rojo para siempre por algo que no esta roto entrena a ignorar el
    # tablero entero -- y ya lo hizo: puso en rojo el control positivo de
    # probar-hooks ("con todo sano, el arranque NO grita"), que no tiene nada
    # que ver con Drive. Con -Estricto si es rojo, para cuando ya este hecho.
    if ($Estricto) { exit 1 }
    # ...pero PENDIENTE no borra lo que YA salio mal. Hasta el 2026-09-13 este
    # 'exit 0' se tragaba $problemas: en la PC el hook post-commit no estaba
    # instalado --un rojo de verdad-- y el medidor abria la sesion en verde,
    # porque el remote sin autorizar cortaba antes. Un camino de salida
    # temprana es un fail-open hasta que se pruebe.
    if ($problemas -gt 0) {
        Escribir "[ROJO] ademas del remote pendiente, hay $problemas problema(s) REALES arriba." Red
        exit 1
    }
    exit 0
}
Escribir "  autorizado" Green

# --- el trabajo -----------------------------------------------------------
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
    $json = & $rclone --config $conf lsjson "${remote}:$($a.materia)" --files-only --hash 2>$null
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
        # Se compara el MD5, no el par (tamano, fecha). La fecha del lado de
        # Drive no es la del archivo local --depende de como se subio-- asi que
        # comparar fechas da rojos falsos (molestos pero inocuos) y, si ademas
        # coincide el tamano, VERDES falsos, que son silenciosos. El hash lo da
        # rclone gratis con --hash y saca la clase entera. Si Drive no devuelve
        # hash, se cae a la comparacion vieja y se DICE que se cayo.
        $md5Remoto = $remoto.Hashes.md5
        if ($md5Remoto) {
            $md5Local = (Get-FileHash $local -Algorithm MD5).Hash.ToLower()
            $igual = ($md5Local -eq $md5Remoto)
            $porQue = "md5"
        } else {
            $igual = ($remoto.Size -eq $sizeLocal) -and ([math]::Abs(($mtimeLocal - $mtimeRemoto).TotalSeconds) -lt 5)
            $porQue = "tamano+fecha (Drive no dio hash)"
        }
        if ($igual) {
            Escribir "  al dia  ($([math]::Round($sizeLocal/1MB,1)) MB, verificado por $porQue)" Green
            continue
        }
        Escribir "  DESACTUALIZADO en Drive" Yellow
        Escribir "    local : $($mtimeLocal.ToString('yyyy-MM-dd HH:mm')) UTC  $([math]::Round($sizeLocal/1MB,1)) MB" White
        Escribir "    drive : $($mtimeRemoto.ToString('yyyy-MM-dd HH:mm')) UTC  $([math]::Round($remoto.Size/1MB,1)) MB" White
        if ($Verificar) { $problemas++; continue }
    }

    Escribir "  subiendo..." White
    & $rclone --config $conf copyto $local $destino --progress --stats-one-line
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
