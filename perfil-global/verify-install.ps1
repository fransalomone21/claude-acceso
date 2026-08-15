# verify-install.ps1 - Verifica que perfil-global esta instalado correctamente
# NOTA: ASCII puro - no usar tildes ni caracteres especiales en este archivo.
#
# Ejecutar desde cualquier lugar:
#   .\perfil-global\verify-install.ps1
#
# O pasando la ruta del repo (para saber que skills deberian estar instaladas):
#   .\perfil-global\verify-install.ps1 -RepoRoot "C:\ruta\al\repo"

param(
    [string]$RepoRoot = (Split-Path $PSScriptRoot -Parent)
)

$source    = Join-Path $RepoRoot 'perfil-global'
$dest      = Join-Path $env:USERPROFILE '.claude'
$skillsDir = Join-Path $dest 'skills'
$pass      = $true

function CheckFile($path, $label) {
    if (Test-Path $path) {
        $size = (Get-Item $path).Length
        if ($size -gt 10) {
            Write-Host "  [OK]   $label ($size bytes)" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] $label existe pero parece vacio ($size bytes)" -ForegroundColor Red
            $script:pass = $false
        }
    } else {
        Write-Host "  [FAIL] $label - no encontrado en: $path" -ForegroundColor Red
        $script:pass = $false
    }
}

function CheckDir($path, $label) {
    if (Test-Path $path -PathType Container) {
        Write-Host "  [OK]   $label" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $label - carpeta no encontrada: $path" -ForegroundColor Red
        $script:pass = $false
    }
}

Write-Host ""
Write-Host "=== Verificacion de perfil-global ===" -ForegroundColor Cyan
Write-Host "  Destino: $dest"
Write-Host ""

CheckDir  $dest                          '.claude/'
CheckDir  $skillsDir                     '.claude/skills/'
CheckFile (Join-Path $dest 'CLAUDE.md')  'CLAUDE.md'

if (Test-Path $source) {
    $skillDirs = Get-ChildItem -Path $source -Directory -ErrorAction SilentlyContinue
    foreach ($dir in $skillDirs) {
        $skillName = $dir.Name
        $skillSrc  = Join-Path $dir.FullName 'SKILL.md'
        if (Test-Path $skillSrc) {
            CheckDir  (Join-Path $skillsDir $skillName)              ".claude/skills/$skillName/"
            CheckFile (Join-Path $skillsDir "$skillName\SKILL.md")   "$skillName/SKILL.md"
        }
    }
} else {
    Write-Host "  [WARN] No se encontro perfil-global en $source - no se puede listar que skills esperar." -ForegroundColor Yellow
}

# --- Hooks: se verifica el EFECTO, no que el archivo exista ---
#
# Este bloque existe porque la version anterior daba OK con los hooks
# completamente rotos. Comprobaba que apertura-proyecto.md estuviera en su
# lugar (cierto) y que el JSON fuera valido (cierto) mientras el comando
# devolvia cero bytes cada vez que lo corria Claude Code. Ver leccion 13.
Write-Host ""
Write-Host "  --- Hooks ---"

CheckFile (Join-Path $dest 'hooks\emitir-contexto.ps1') 'hooks/emitir-contexto.ps1'

$settingsPath = Join-Path $dest 'settings.json'
$comandos = @()

if (-not (Test-Path $settingsPath)) {
    Write-Host "  [FAIL] settings.json no encontrado: $settingsPath" -ForegroundColor Red
    $pass = $false
} else {
    try {
        $st = Get-Content -Raw $settingsPath | ConvertFrom-Json
        foreach ($evento in @('SessionStart', 'UserPromptSubmit')) {
            if (-not $st.hooks -or -not ($st.hooks.PSObject.Properties.Name -contains $evento)) {
                Write-Host "  [FAIL] settings.json no define el hook $evento" -ForegroundColor Red
                $pass = $false
                continue
            }
            foreach ($entrada in @($st.hooks.$evento)) {
                foreach ($hk in @($entrada.hooks)) {
                    $comandos += [PSCustomObject]@{ Evento = $evento; Comando = $hk.command }
                }
            }
        }
    } catch {
        Write-Host "  [FAIL] settings.json no es JSON valido: $($_.Exception.Message)" -ForegroundColor Red
        $pass = $false
    }
}

# Chequeo estatico: un comando de hook no puede traer sintaxis de shell.
# '$env:' o '%VAR%' sobreviven en PowerShell y mueren en bash, en silencio.
foreach ($c in $comandos) {
    if ($c.Comando -match '\$' -or $c.Comando -match '%\w+%') {
        Write-Host "  [FAIL] Hook $($c.Evento): el comando expande variables de shell." -ForegroundColor Red
        Write-Host "         $($c.Comando)" -ForegroundColor Red
        Write-Host "         Se rompe cuando el harness lo corre con bash. Correr install.ps1." -ForegroundColor Red
        $pass = $false
    }
}

# Chequeo de efecto: correr el comando por un shell POSIX y exigir salida.
# Git Bash PRIMERO, y a proposito. 'Get-Command bash.exe' en Windows 11
# resuelve a C:\...\WindowsApps\bash.exe, que es WSL: un Linux de verdad, que
# no ve C:/Users/... y responde "No such file or directory" para cualquier
# ruta de Windows. El harness usa Git Bash (MINGW64), asi que la prueba tiene
# que correr en Git Bash o no prueba nada.
$bash = $null
$cand = @('C:\Program Files\Git\bin\bash.exe',
          'C:\Program Files (x86)\Git\bin\bash.exe',
          (Get-Command bash.exe -ErrorAction SilentlyContinue).Source)
foreach ($p in $cand) {
    if (-not $p -or -not (Test-Path $p)) { continue }
    $uname = (& $p -c 'uname -s' 2>$null | Out-String).Trim()
    if ($uname -like 'Linux*') {
        Write-Host "  [WARN] Ignorando $p (es WSL, no Git Bash)." -ForegroundColor Yellow
        continue
    }
    $bash = $p
    break
}

if (-not $bash) {
    Write-Host "  [WARN] No se encontro bash: no se pudo probar el hook como lo" -ForegroundColor Yellow
    Write-Host "         corre el harness. Este es EL chequeo que importa." -ForegroundColor Yellow
} else {
    # El comando se escribe a un .sh y se corre 'bash archivo.sh' en vez de
    # 'bash -c "..."'. Pasarlo como argumento desde PowerShell 5.1 mangla las
    # comillas y las barras invertidas (C:\Users\... llega como C:Users...),
    # y entonces el verificador falla por su propia culpa y no por el hook.
    # El archivo reproduce fielmente lo que hace el harness: un shell POSIX
    # parseando esa linea. Salto de linea LF a proposito: con CRLF, bash se
    # queja del \r. Ver leccion 8.
    foreach ($c in $comandos) {
        $tmp = Join-Path $env:TEMP ("verif-hook-{0}-{1}.sh" -f $PID, [guid]::NewGuid().ToString('N').Substring(0,8))
        [IO.File]::WriteAllText($tmp, $c.Comando + "`n", [Text.Encoding]::ASCII)
        # Y la ruta se le pasa con barras normales: PowerShell 5.1 tambien
        # mangla las barras invertidas del ARGUMENTO (C:\Temp\x.sh llega como
        # C:Tempx.sh). bash de MSYS acepta C:/Temp/x.sh sin problema.
        $tmpPosix = $tmp -replace '\\', '/'
        try {
            $out = & $bash $tmpPosix
        } finally {
            Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
        }
        $txt = ($out | Out-String).Trim()
        if ($LASTEXITCODE -eq 0 -and $txt.Length -gt 10) {
            Write-Host "  [OK]   Hook $($c.Evento) emite $($txt.Length) chars bajo bash" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] Hook $($c.Evento) no produce salida bajo bash (exit=$LASTEXITCODE)" -ForegroundColor Red
            Write-Host "         $($c.Comando)" -ForegroundColor Red
            $pass = $false
        }
    }
}

Write-Host ""
if ($pass) {
    Write-Host "Verificacion OK - el perfil global esta instalado correctamente." -ForegroundColor Green
    Write-Host ""
    Write-Host "Notas:"
    Write-Host "  - CLAUDE.md carga automaticamente en toda sesion de Claude Code."
    Write-Host "  - Las skills en ~/.claude/skills/<nombre>/ se invocan con /<nombre>"
    Write-Host "    o Claude las usa solas cuando son relevantes."
    Write-Host "  - Si ~/.claude/skills/ no existia al iniciar la sesion de Claude"
    Write-Host "    Code, hay que reiniciarla una vez para que la detecte."
} else {
    Write-Host "Verificacion FALLIDA - ejecutar .\perfil-global\install.ps1 primero." -ForegroundColor Red
    exit 1
}
Write-Host ""
