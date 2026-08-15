# emitir-contexto.ps1 - lo invocan los hooks de Claude Code.
# NOTA: ASCII puro - no usar tildes ni caracteres especiales en este archivo.
#
# POR QUE EXISTE ESTE ARCHIVO
#
# La version anterior metia el comando entero adentro de settings.json:
#
#   powershell -NoProfile -Command "Get-Content -Raw -ErrorAction
#   SilentlyContinue ((Join-Path $env:USERPROFILE '.claude\archivo.md'))"
#
# Eso funciona si lo corres a mano en PowerShell y falla en silencio cuando lo
# corre el harness, que usa un shell POSIX:
#
#   $env:USERPROFILE  bajo bash  ->  ":USERPROFILE"   (bash se come $env)
#   resultado: exit 1, stdout vacio, stderr vacio
#
# El -ErrorAction SilentlyContinue remataba el asunto: sin salida y sin error.
# El hook figuraba instalado en settings.json y no aportaba nada, durante dias.
#
# La regla que sale de ahi: el comando de un hook no puede depender de la
# sintaxis de NINGUN shell. Este script se invoca por ruta absoluta y toda la
# logica vive adentro, donde $PSScriptRoot resuelve sin que nadie lo toque.

param(
    [Parameter(Mandatory = $true)]
    [string]$Archivo
)

# ~/.claude/hooks/ -> ~/.claude/
$base = Split-Path -Parent $PSScriptRoot
$md   = Join-Path $base $Archivo
$log  = Join-Path $PSScriptRoot 'disparos.log'

$sello = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# El log es la UNICA prueba de efecto que tenemos: un hook que no dispara se
# ve identico a uno que dispara y no dice nada. Sin esto, verificar el hook
# obliga a adivinar. Ver leccion 7 y leccion 12 de lecciones-aprendidas.
function Registrar($linea) {
    try {
        Add-Content -LiteralPath $log -Value "$sello  $linea" -Encoding utf8 -ErrorAction Stop
        # Poda barata: UserPromptSubmit escribe una linea por prompt.
        $lineas = @(Get-Content -LiteralPath $log -ErrorAction Stop)
        if ($lineas.Count -gt 2000) {
            Set-Content -LiteralPath $log -Value $lineas[-1000..-1] -Encoding utf8 -ErrorAction Stop
        }
    } catch {
        # Que no se pueda escribir el log NUNCA debe impedir que salga el texto.
    }
}

if (-not (Test-Path -LiteralPath $md)) {
    Registrar "FALTA  $Archivo"
    [Console]::Error.WriteLine("perfil-global: falta $md - correr perfil-global\install.ps1")
    exit 1
}

$texto = Get-Content -Raw -LiteralPath $md
Registrar ("OK     {0}  ({1} chars)" -f $Archivo, $texto.Length)
Write-Output $texto
