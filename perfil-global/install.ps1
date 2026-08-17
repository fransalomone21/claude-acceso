# install.ps1 - Instala perfil-global en %USERPROFILE%\.claude\
# NOTA: ASCII puro - no usar tildes ni caracteres especiales en este archivo.
#
# Ejecutar desde la RAIZ del repositorio:
#   .\perfil-global\install.ps1
#
# O desde cualquier lugar pasando la ruta del repo:
#   .\perfil-global\install.ps1 -RepoRoot "C:\ruta\al\repo"

param(
    [string]$RepoRoot = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = 'Stop'

$source    = Join-Path $RepoRoot 'perfil-global'
$dest      = Join-Path $env:USERPROFILE '.claude'
# NOTA: la carpeta correcta que Claude Code detecta para skills personales
# es ~/.claude/skills/ (NO claude-code-skills/). Ver docs oficiales:
# https://code.claude.com/docs/en/skills#where-skills-live
$skillsDir = Join-Path $dest 'skills'
$hooksDir  = Join-Path $dest 'hooks'
$herrDir   = Join-Path $dest 'herramientas'
$aprDir    = Join-Path $dest 'aprendizaje'
$now       = Get-Date -Format 'yyyyMMdd-HHmmss'
$ok        = $true

function Info($msg)  { Write-Host "  $msg" }
function Ok($msg)    { Write-Host "  [OK]   $msg" -ForegroundColor Green }
function Warn($msg)  { Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Fail($msg)  { Write-Host "  [FAIL] $msg" -ForegroundColor Red; $script:ok = $false }

Write-Host ""
Write-Host "=== Instalacion de perfil-global ===" -ForegroundColor Cyan
Write-Host "  Fuente : $source"
Write-Host "  Destino: $dest"
Write-Host ""

if (-not (Test-Path $source)) {
    Fail "No se encontro 'perfil-global' en: $source"
    Fail "Verificar que se ejecuta desde la raiz del repositorio."
    exit 1
}

New-Item -ItemType Directory -Force -Path $dest      | Out-Null
New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null
New-Item -ItemType Directory -Force -Path $hooksDir  | Out-Null
New-Item -ItemType Directory -Force -Path $herrDir   | Out-Null
New-Item -ItemType Directory -Force -Path $aprDir    | Out-Null
Info "Carpetas destino verificadas."

# --- 1. CLAUDE.md global ---
$claudeSrc = Join-Path $source 'CLAUDE.md'
$claudeDst = Join-Path $dest 'CLAUDE.md'

if (-not (Test-Path $claudeSrc)) {
    Fail "Falta fuente: $claudeSrc"
} else {
    if (Test-Path $claudeDst) {
        $backup = "$claudeDst.bak-$now"
        Copy-Item $claudeDst $backup
        Warn "Respaldo del CLAUDE.md anterior: $backup"
    }
    Copy-Item $claudeSrc $claudeDst -Force
    Ok "CLAUDE.md -> $claudeDst"
}

# --- 2. Todas las skills de perfil-global/<nombre>/SKILL.md ---
# Cualquier carpeta nueva con SKILL.md que se agregue a perfil-global/ se
# instala automaticamente, sin tener que tocar este script.
#
# Se copia la CARPETA ENTERA, no solo el SKILL.md: una skill puede traer
# subcarpetas (por ejemplo referencias/) que se leen bajo demanda. Copiar
# solo el SKILL.md dejaba esos archivos sin instalar y los enlaces internos
# apuntaban a la nada. Ver leccion 7 de lecciones-aprendidas.
$skillDirs = Get-ChildItem -Path $source -Directory -ErrorAction SilentlyContinue

if (-not $skillDirs -or $skillDirs.Count -eq 0) {
    Warn "No se encontraron subcarpetas de skills en: $source"
} else {
    foreach ($dir in $skillDirs) {
        $skillName = $dir.Name
        $skillSrc  = Join-Path $dir.FullName 'SKILL.md'

        if (-not (Test-Path $skillSrc)) {
            continue
        }

        $skillDstDir = Join-Path $skillsDir $skillName

        New-Item -ItemType Directory -Force -Path $skillDstDir | Out-Null
        Copy-Item -Path (Join-Path $dir.FullName '*') -Destination $skillDstDir -Recurse -Force

        $extra = Get-ChildItem -Path $skillDstDir -Recurse -File |
                 Where-Object { $_.Name -ne 'SKILL.md' }
        if ($extra) {
            Ok "$skillName -> $skillDstDir  (SKILL.md + $($extra.Count) archivo(s) de apoyo)"
        } else {
            Ok "$skillName/SKILL.md -> $skillDstDir"
        }
    }
}

# --- 3. Archivos que lee cada hook, y su evento ---
# Los hooks son el unico mecanismo que corre SIEMPRE, sin depender de que
# alguien invoque una skill. Ver leccion 11 de lecciones-aprendidas.
#
#   SessionStart      dispara UNA vez por sesion  -> puede ser largo
#   UserPromptSubmit  dispara en CADA prompt      -> tiene que ser corto
#
# Los .md van en ASCII a proposito: la consola de Windows los lee como cp1252
# y los acentos salen mojibake.
# El orden del array es el orden de inyeccion en una instalacion desde cero:
# Nivel 0 (fundamentos) antes que el protocolo de apertura y que el chequeo.
# En una instalacion incremental el gancho nuevo queda al final igual, y no se
# corrige a proposito: el orden de inyeccion es un parametro, y gastar
# ingenieria en un parametro es exactamente lo que pilares.md dice que no.
$ganchos = @(
    @{ Evento = 'SessionStart';     Archivo = 'pilares.md' },
    @{ Evento = 'SessionStart';     Archivo = 'apertura-proyecto.md' },
    @{ Evento = 'SessionStart';     Archivo = 'chequeo-de-trabajo.md' },
    @{ Evento = 'UserPromptSubmit'; Archivo = 'recordatorio-transversal.md' }
)

foreach ($g in $ganchos) {
    $src = Join-Path $source $g.Archivo
    if (Test-Path $src) {
        Copy-Item $src (Join-Path $dest $g.Archivo) -Force
        Ok "$($g.Archivo) -> $dest"
    } else {
        Warn "No se encontro $($g.Archivo) en $source"
    }
}

# El lanzador que invocan TODOS los hooks. Ver el encabezado de ese archivo
# para el detalle de por que el comando no puede vivir en settings.json.
$lanzadorSrc = Join-Path $source 'hooks\emitir-contexto.ps1'
$lanzador    = Join-Path $hooksDir 'emitir-contexto.ps1'

if (-not (Test-Path $lanzadorSrc)) {
    Fail "Falta el lanzador de hooks: $lanzadorSrc"
} else {
    Copy-Item $lanzadorSrc $lanzador -Force
    Ok "hooks\emitir-contexto.ps1 -> $hooksDir"
}

# --- 3b. Herramientas del perfil, y como vuelven al repo ---
#
# aprender.py se copia a ~/.claude/herramientas/ para poder invocarlo desde
# CUALQUIER carpeta de la maquina, no solo desde este repo. Pero el registro
# de lecciones NO vive en ~/.claude: vive en el repo, que es lo que se
# commitea. origen.txt es como la copia instalada encuentra el camino de
# vuelta. Sin el, una leccion aprendida en otro proyecto se escribiria en un
# archivo local que nadie respalda -- que es exactamente el error que esta
# herramienta existe para no repetir.
$herrSrc = Join-Path $source 'herramientas'
if (Test-Path $herrSrc) {
    Copy-Item -Path (Join-Path $herrSrc '*') -Destination $herrDir -Recurse -Force
    $n = @(Get-ChildItem -Path $herrDir -File).Count
    Ok "herramientas\ -> $herrDir  ($n archivo(s))"
} else {
    Warn "No se encontro la carpeta herramientas\ en $source"
}

$origen = Join-Path $aprDir 'origen.txt'
Set-Content -LiteralPath $origen -Value $RepoRoot -Encoding ascii
Ok "origen.txt -> $origen  ($RepoRoot)"

# --- 4. Registrar los hooks en settings.json ---
$settingsPath = Join-Path $dest 'settings.json'

try {
    if (Test-Path $settingsPath) {
        Copy-Item $settingsPath "$settingsPath.bak-$now" -Force
        $settings = Get-Content -Raw $settingsPath | ConvertFrom-Json
    } else {
        $settings = New-Object PSObject
    }

    if (-not ($settings.PSObject.Properties.Name -contains 'hooks')) {
        $settings | Add-Member -NotePropertyName 'hooks' -NotePropertyValue (New-Object PSObject)
    }
    $h = $settings.hooks
    $cambio = $false

    foreach ($g in $ganchos) {
        $evento  = $g.Evento
        $archivo = $g.Archivo

        # El comando NO puede contener sintaxis de ningun shell. Solo una ruta
        # absoluta entre comillas y un argumento. Nada de $env:, %VAR% ni
        # comillas anidadas: el harness lo pasa por un shell POSIX y cualquiera
        # de esas cosas se rompe en silencio.
        $hookCmd = 'powershell -NoProfile -ExecutionPolicy Bypass -File "' +
                   $lanzador + '" ' + $archivo

        $existentes = @()
        if ($h.PSObject.Properties.Name -contains $evento) {
            $existentes = @($h.$evento)
        }

        # Separar lo que habla de ESTE archivo de lo que no. Las entradas
        # ajenas se respetan; las propias se reemplazan aunque ya existan,
        # porque una entrada vieja y rota tambien "ya esta configurada".
        $ajenas  = @()
        $propias = @()
        foreach ($e in $existentes) {
            $txt = $e | ConvertTo-Json -Depth 10 -Compress
            if ($txt -match [regex]::Escape($archivo)) { $propias += $e }
            else { $ajenas += $e }
        }

        $correcta = $false
        if ($propias.Count -eq 1) {
            $hs = @($propias[0].hooks)
            if ($hs.Count -eq 1 -and $hs[0].command -eq $hookCmd) { $correcta = $true }
        }

        if ($correcta) {
            Info "Hook $evento ($archivo) ya estaba correcto."
            continue
        }

        if ($propias.Count -gt 0) {
            Warn "Hook $evento ($archivo): habia una definicion vieja, se reemplaza."
        }

        $entrada = [PSCustomObject]@{
            hooks = @([PSCustomObject]@{ type = 'command'; command = $hookCmd })
        }
        $nuevo = @($ajenas) + @($entrada)

        if ($h.PSObject.Properties.Name -contains $evento) {
            $h.$evento = $nuevo
        } else {
            $h | Add-Member -NotePropertyName $evento -NotePropertyValue $nuevo
        }
        Ok "Hook $evento configurado ($archivo)"
        $cambio = $true
    }

    if ($cambio) {
        $settings | ConvertTo-Json -Depth 10 | Out-File $settingsPath -Encoding utf8
        Ok "settings.json actualizado: $settingsPath"
    }

    # skipWorkflowUsageWarning silencia el aviso de costo de los workflows.
    # Es un freno del sistema: si esta apagado, se avisa.
    if ($settings.PSObject.Properties.Name -contains 'skipWorkflowUsageWarning' -and
        $settings.skipWorkflowUsageWarning -eq $true) {
        Warn "skipWorkflowUsageWarning esta en true: el aviso de costo de los"
        Warn "workflows esta silenciado. Conviene sacarlo de settings.json."
    }
} catch {
    Warn "No se pudo actualizar settings.json automaticamente: $($_.Exception.Message)"
    Warn "Agregar el hook UserPromptSubmit a mano. Hay respaldo en $settingsPath.bak-$now"
}

# --- 5. El chequeo que se puede chequear ---
#
# chequeo-de-trabajo.md es la sintesis CURADA de las lecciones: sintetizar
# requiere criterio, asi que no se genera sola. El riesgo obvio es que se
# atrase -- que se registren lecciones nuevas y la unica capa que se lee sola
# siga hablando de las viejas. Eso no se resuelve con disciplina: se resuelve
# comparando el numero que declara el chequeo contra el registro real.
# (Power of Ten #8 / leccion 11: mejor una regla que una herramienta pueda
# chequear que una que dependa de acordarse.)
$jsonl   = Join-Path $source 'aprendizaje\lecciones.jsonl'
$chequeo = Join-Path $source 'chequeo-de-trabajo.md'

if ((Test-Path $jsonl) -and (Test-Path $chequeo)) {
    $reales = @(Get-Content -LiteralPath $jsonl |
                Where-Object { $_.Trim().Length -gt 0 }).Count
    $texto  = Get-Content -Raw -LiteralPath $chequeo
    $m      = [regex]::Match($texto, '(\d+)\s+lecciones')

    if (-not $m.Success) {
        Warn "chequeo-de-trabajo.md no declara cuantas lecciones sintetiza."
        Warn "Agregar 'las N lecciones' en la primera linea para poder chequearlo."
    } elseif ([int]$m.Groups[1].Value -ne $reales) {
        Warn "chequeo-de-trabajo.md dice $($m.Groups[1].Value) lecciones y el registro tiene $reales."
        Warn "Hay lecciones sin foldear en la unica capa que se lee sola."
        Warn "Revisar: python perfil-global\herramientas\aprender.py digesto"
    } else {
        Ok "chequeo-de-trabajo.md al dia ($reales lecciones)"
    }
}

Write-Host ""
if ($ok) {
    Write-Host "Instalacion completada." -ForegroundColor Green
    Write-Host "Verificar con: .\perfil-global\verify-install.ps1"
    Write-Host ""
    Write-Host "IMPORTANTE: si ~/.claude/skills/ no existia antes de esta" -ForegroundColor Yellow
    Write-Host "instalacion, reiniciar Claude Code para que detecte la" -ForegroundColor Yellow
    Write-Host "carpeta nueva (solo hace falta la primera vez)." -ForegroundColor Yellow
} else {
    Write-Host "Instalacion con errores - revisar los mensajes FAIL de arriba." -ForegroundColor Red
    exit 1
}
Write-Host ""
