<#
.SYNOPSIS
  Mide Mi unidad de Drive contra .claude/estructura-drive.json.

.DESCRIPTION
  El problema que resuelve no es que el Drive este prolijo: es que un archivo
  pueda quedar PUBLICO POR LINK sin que nadie se entere. Eso ya paso y duro 25
  dias (ver el campo _la-falla-que-lo-motivo del JSON).

  Mide el EFECTO sobre el objeto -- que permisos tiene -- y no la precondicion
  -- en que carpeta esta. Esa distincion es la razon de ser del script: los dos
  informes del grupo estaban en la carpeta privada correcta Y publicos al mismo
  tiempo, porque mudar un archivo no le saca el permiso que ya tenia.

  Tres bloques:
    1  la raiz no tiene archivos sueltos, y sus carpetas son las declaradas
    2  ningun objeto con 'anyone' fuera de la carpeta publica declarada  <- ROJO
    3  lo compartido con personas concretas esta declarado               <- amarillo

  El bloque 2 es el unico que sale en ROJO. Compartir con una persona es una
  decision; publicar por link es una decision que se toma una vez y despues se
  olvida, y es la que se paga cara.

.PARAMETER Rapido
  Solo el bloque 1 (la raiz). No recorre el arbol ni pide permisos: ~3 s en vez
  de ~25 s. Es lo que corre en cada arranque.

.PARAMETER DesdeJson
  Lee el arbol de un archivo en vez de consultar Drive. Existe SOLO para que
  probar-verificar-drive.ps1 pueda sabotear sin tocar el Drive real -- una
  alarma que no se puede poner en rojo esta sin verificar. Misma costura que
  -ListaPath en publicar-apuntes.ps1.

.PARAMETER Lista
  JSON de estructura alternativo. Idem: es para el saboteador.

.EXAMPLE
  .\verificar-drive.ps1
  .\verificar-drive.ps1 -Rapido
#>
[CmdletBinding()]
param(
    [switch]$Rapido,
    [string]$DesdeJson,
    [string]$Lista
)

# NO se pone 'Stop': PS 5.1 convierte cualquier linea que un .exe mande a
# stderr en error terminante (NativeCommandError), y rclone escribe por stderr
# el NOTICE del client_id en CADA corrida. El control es por $LASTEXITCODE.
$ErrorActionPreference = 'Continue'
$raiz = Split-Path -Parent $MyInvocation.MyCommand.Path
if ($Lista) { $rutaLista = $Lista } else { $rutaLista = Join-Path $raiz '.claude\estructura-drive.json' }

function Escribir($t, $c) { Write-Host $t -ForegroundColor $c }
$rojos = 0
$amarillos = 0

if (-not (Test-Path $rutaLista)) {
    Escribir "[ROJO] falta $rutaLista -- sin declaracion no se mide nada." Red
    exit 1
}
$decl = Get-Content $rutaLista -Raw -Encoding UTF8 | ConvertFrom-Json

# --- rclone ---------------------------------------------------------------
# La ruta del config va COMPLETA y a proposito: la app corre empaquetada (MSIX)
# y Windows le REDIRIGE %APPDATA%, asi que la sesion y la consola de Fran
# escriben en archivos DISTINTOS creyendo los dos que escriben en el mismo.
# USERPROFILE si se puede usar: la redireccion no alcanza al perfil entero.
$conf = Join-Path $env:USERPROFILE '.config\rclone\rclone.conf'
$rclone = (Get-Command rclone -ErrorAction SilentlyContinue)
if ($null -eq $rclone) {
    $alt = Join-Path $env:LOCALAPPDATA 'Microsoft\WinGet\Links\rclone.exe'
    if (Test-Path $alt) { $rclone = $alt } else {
        Escribir "[ROJO] rclone no esta instalado -- winget install --id Rclone.Rclone" Red
        exit 1
    }
} else { $rclone = $rclone.Source }

$remote = "$($decl.remote):"

Write-Host ""
Escribir "VERIFICAR DRIVE -- Mi unidad contra .claude\estructura-drive.json" Cyan
Write-Host ""

# =========================================================================
# BLOQUE 1 -- la raiz
# =========================================================================
Escribir "1. la raiz: cero archivos sueltos, y las carpetas declaradas" White

$sueltos = & $rclone --config $conf lsf $remote --max-depth 1 --files-only 2>$null
if ($LASTEXITCODE -ne 0) {
    Escribir "   [ROJO] rclone no pudo listar $remote" Red
    exit 1
}
$sueltos = @($sueltos | Where-Object { $_ })
$leeme = $decl.raiz.'archivo-permitido'
if ($leeme) {
    if ($sueltos -contains $leeme) {
        $sueltos = @($sueltos | Where-Object { $_ -ne $leeme })
    } else {
        # La excepcion declarada es OBLIGATORIA, no opcional. Un permiso que
        # tambien se cumple estando ausente no mide nada.
        Escribir "   [ROJO] falta el archivo declarado de la raiz: $leeme" Red
        $rojos++
    }
}
if ($sueltos.Count -gt 0) {
    Escribir "   [ROJO] $($sueltos.Count) archivo(s) suelto(s) en la raiz:" Red
    $sueltos | ForEach-Object { Escribir "          $_" Red }
    $rojos++
} else {
    Escribir "   [OK  ] sin archivos sueltos" Green
}

$enDisco  = @(& $rclone --config $conf lsf $remote --max-depth 1 --dirs-only 2>$null |
              Where-Object { $_ } | ForEach-Object { $_.TrimEnd('/') })
$enPapel  = @($decl.raiz.carpetas | ForEach-Object { $_.nombre })
$deMas    = @($enDisco | Where-Object { $enPapel -notcontains $_ })
$deMenos  = @($enPapel | Where-Object { $enDisco -notcontains $_ })

if ($deMenos.Count -gt 0) {
    Escribir "   [ROJO] declarada(s) y NO estan: $($deMenos -join ', ')" Red
    $rojos++
}
if ($deMas.Count -gt 0) {
    Escribir "   [PEND] en el disco y sin declarar: $($deMas -join ', ')" Yellow
    Escribir "          o se declara en el JSON, o se guarda adentro de una que ya este." Yellow
    $amarillos++
}
if ($deMas.Count -eq 0 -and $deMenos.Count -eq 0) {
    Escribir "   [OK  ] las $($enPapel.Count) carpetas declaradas, y ninguna de mas" Green
}

if ($Rapido) {
    Write-Host ""
    if ($rojos -gt 0) { Escribir "ROJO ($rojos). Corre sin -Rapido para medir los permisos." Red; exit 1 }
    Escribir "OK (capa rapida). Los permisos se miden sin -Rapido." Green
    exit 0
}

# =========================================================================
# BLOQUES 2 y 3 -- los permisos. Es el EFECTO sobre el objeto.
# =========================================================================
Write-Host ""
Escribir "2. permisos: 'anyone' solo adentro de la carpeta publica declarada" White

if ($DesdeJson) {
    if (-not (Test-Path $DesdeJson)) { Escribir "   [ROJO] no existe $DesdeJson" Red; exit 1 }
    $crudo = Get-Content $DesdeJson -Raw -Encoding UTF8
} else {
    $crudo = & $rclone --config $conf lsjson $remote -R --metadata --drive-metadata-permissions read 2>$null
    if ($LASTEXITCODE -ne 0) { Escribir "   [ROJO] rclone no pudo leer los permisos" Red; exit 1 }
    $crudo = $crudo -join "`n"
}
$arbol = $crudo | ConvertFrom-Json

$pub = $decl.'carpeta-publica'.ruta
$fueraDePub = @()
$dentroDePub = 0
$conNombre = @{}

foreach ($e in $arbol) {
    $txt = $e.Metadata.permissions
    if (-not $txt) { continue }
    foreach ($p in ($txt | ConvertFrom-Json)) {
        if ($p.type -eq 'anyone') {
            if ($e.Path -eq $pub -or $e.Path.StartsWith("$pub/")) { $dentroDePub++ }
            else { $fueraDePub += $e.Path }
        } elseif ($p.role -ne 'owner') {
            $mail = $p.emailAddress
            if ($mail) {
                if (-not $conNombre.ContainsKey($mail)) { $conNombre[$mail] = 0 }
                $conNombre[$mail]++
            }
        }
    }
}

if ($fueraDePub.Count -gt 0) {
    Escribir "   [ROJO] $($fueraDePub.Count) objeto(s) PUBLICO(S) POR LINK fuera de la carpeta publica:" Red
    $fueraDePub | Select-Object -Unique | ForEach-Object { Escribir "          $_" Red }
    Escribir "          Mudarlo de carpeta NO le saca el permiso. Hay que sacarselo al OBJETO." Red
    $rojos++
} else {
    Escribir "   [OK  ] 0 publicos fuera. $dentroDePub objeto(s) publico(s), todos adentro de:" Green
    Escribir "          $pub" Green
}

Write-Host ""
Escribir "3. compartido con personas concretas: todo declarado" White

# Se compara por HASH, no por mail. El JSON esta en un repo PUBLICO y estos
# son datos de terceros: la politica de datos-permitidos.json dice que eso no
# se declara como excepcion, se saca. El hash alcanza para lo unico que hace
# falta aca -- decidir si el mail que se acaba de LEER DE DRIVE esta declarado.
function HashMail($m) {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $b = $sha.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($m.Trim().ToLower()))
    return ((($b | ForEach-Object { $_.ToString('x2') }) -join '').Substring(0, 16))
}
$declHash = @()
foreach ($d in $decl.'compartido-con-nombre'.declarado) { $declHash += $d.'quien-sha256' }
$sinDeclarar = @($conNombre.Keys | Where-Object { $declHash -notcontains (HashMail $_) })

foreach ($m in ($conNombre.Keys | Sort-Object)) {
    if ($declHash -contains (HashMail $m)) {
        Escribir ("   [OK  ] {0,-38} {1,4} objeto(s) -- declarado" -f $m, $conNombre[$m]) Green
    } else {
        Escribir ("   [PEND] {0,-38} {1,4} objeto(s) -- SIN DECLARAR" -f $m, $conNombre[$m]) Yellow
        Escribir ("          si es legitimo, su hash es: {0}" -f (HashMail $m)) Yellow
    }
}
if ($conNombre.Count -eq 0) { Escribir "   [OK  ] nada compartido con nadie" Green }
if ($sinDeclarar.Count -gt 0) {
    Escribir "          Si es legitimo, va al JSON con su motivo. Declarar es un acto." Yellow
    $amarillos++
}

# =========================================================================
Write-Host ""
if ($rojos -gt 0) {
    Escribir "ROJO: $rojos bloque(s) en falla." Red
    exit 1
}
if ($amarillos -gt 0) {
    Escribir "OK, con $amarillos pendiente(s) amarillo(s). Nada publicado de mas." Yellow
    exit 0
}
Escribir "OK. Raiz limpia, nada publico fuera de su carpeta, nada compartido sin declarar." Green
exit 0
