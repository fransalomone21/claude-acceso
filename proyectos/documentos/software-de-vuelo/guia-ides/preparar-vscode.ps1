# preparar-vscode.ps1 -- deja un proyecto de STM32CubeIDE listo para VS Code + Wokwi.
#
# Uso:
#   .\preparar-vscode.ps1 -Proyecto "C:\...\workspace_1.18.1\mi_proyecto"
#   .\preparar-vscode.ps1 -Proyecto ... -Forzar    # pisa wokwi.toml y diagram.json
#
# Escribe, adentro de la carpeta del proyecto:
#   .vscode\tasks.json            Ctrl+Shift+B compila con el make y el gcc de CubeIDE
#   .vscode\c_cpp_properties.json IntelliSense con los -D y -I que usa el compilador
#   wokwi.toml                    que .elf cargar (solo NUCLEO-C031C6)
#   diagram.json                  la placa y el monitor serie en PA2/PA3 (solo C031C6)
#
# Nada se escribe a mano: la placa y el nombre salen del .ioc; las banderas del
# compilador, del Debug\Core\Src\subdir.mk que genera CubeIDE; las rutas del
# compilador y de make, de la instalacion de CubeIDE. wokwi.toml y diagram.json
# NO se pisan si ya existen (el diagrama es trabajo tuyo), salvo con -Forzar.

param(
    [Parameter(Mandatory = $true)][string]$Proyecto,
    [switch]$Forzar
)

function Fallar($msg) { Write-Host "  [FAIL] $msg" -ForegroundColor Red; exit 1 }
function Ok($msg) { Write-Host "  [OK]   $msg" -ForegroundColor Green }
function Aviso($msg) { Write-Host "  [AVISO] $msg" -ForegroundColor Yellow }

$utf8 = New-Object System.Text.UTF8Encoding($false)
function Escribir($ruta, $texto) { [IO.File]::WriteAllText($ruta, $texto, $utf8) }

# --- 1. el proyecto ---
if (-not (Test-Path -LiteralPath $Proyecto -PathType Container)) { Fallar "no existe la carpeta: $Proyecto" }
$Proyecto = (Resolve-Path -LiteralPath $Proyecto).Path
$iocs = @(Get-ChildItem -LiteralPath $Proyecto -Filter '*.ioc' -File)
if ($iocs.Count -ne 1) { Fallar "se esperaba UN .ioc en la carpeta y hay $($iocs.Count): no parece un proyecto de CubeIDE" }
$ioc = @{}
foreach ($l in [IO.File]::ReadAllLines($iocs[0].FullName)) {
    $i = $l.IndexOf('=')
    if ($i -gt 0) { $ioc[$l.Substring(0, $i)] = $l.Substring($i + 1) }
}
$placa = $ioc['board']
$nombre = $ioc['ProjectManager.ProjectName']
if (-not $nombre) { $nombre = [IO.Path]::GetFileNameWithoutExtension($iocs[0].Name) }
$debug = Join-Path $Proyecto 'Debug'
$elfs = @(Get-ChildItem -LiteralPath $debug -Filter '*.elf' -File -ErrorAction SilentlyContinue)
if ($elfs.Count -eq 1) { $nombre = [IO.Path]::GetFileNameWithoutExtension($elfs[0].Name) }
Write-Host "=== preparar-vscode: $nombre (placa: $placa) ==="

# --- 2. el compilador y make de CubeIDE ---
$plugins = @(Get-ChildItem -Path 'C:\ST' -Directory -Filter 'STM32CubeIDE_*' -ErrorAction SilentlyContinue |
    Sort-Object Name -Descending | ForEach-Object { Join-Path $_.FullName 'STM32CubeIDE\plugins' } |
    Where-Object { Test-Path -LiteralPath $_ })
if ($plugins.Count -eq 0) { Fallar 'no encuentro STM32CubeIDE en C:\ST\ (la catedra lo instala en C:\ST\STM32CubeIDE_1.18.1)' }
$gccBin = @(Get-ChildItem -LiteralPath $plugins[0] -Directory -Filter '*gnu-tools-for-stm32*' |
    Sort-Object Name -Descending | ForEach-Object { Join-Path $_.FullName 'tools\bin' } |
    Where-Object { Test-Path -LiteralPath (Join-Path $_ 'arm-none-eabi-gcc.exe') })
$makeBin = @(Get-ChildItem -LiteralPath $plugins[0] -Directory -Filter '*externaltools.make*' |
    Sort-Object Name -Descending | ForEach-Object { Join-Path $_.FullName 'tools\bin' } |
    Where-Object { Test-Path -LiteralPath (Join-Path $_ 'make.exe') })
if ($gccBin.Count -eq 0) { Fallar "no encuentro arm-none-eabi-gcc.exe en $($plugins[0])" }
if ($makeBin.Count -eq 0) { Fallar "no encuentro make.exe en $($plugins[0])" }
$gccBin = $gccBin[0]; $makeBin = $makeBin[0]
Ok "compilador: $gccBin"

# --- 3. .vscode\tasks.json ---
$vs = Join-Path $Proyecto '.vscode'
New-Item -ItemType Directory -Force -Path $vs | Out-Null
$pathTarea = "$gccBin;$makeBin;" + '${env:PATH}'
function Tarea($etiqueta, $argumentos, $esDefault) {
    $t = [ordered]@{
        label          = $etiqueta
        type           = 'process'
        command        = (Join-Path $makeBin 'make.exe')
        args           = $argumentos
        options        = [ordered]@{ cwd = '${workspaceFolder}/Debug'; env = [ordered]@{ PATH = $pathTarea } }
        problemMatcher = [ordered]@{ base = '$gcc'; fileLocation = @('relative', '${workspaceFolder}/Debug') }
    }
    if ($esDefault) { $t.group = [ordered]@{ kind = 'build'; isDefault = $true } }
    return $t
}
$tareas = [ordered]@{
    version = '2.0.0'
    tasks   = @(
        (Tarea 'Compilar (make de CubeIDE)' @('-j8', 'all') $true),
        (Tarea 'Limpiar (make clean)' @('clean') $false)
    )
}
Escribir (Join-Path $vs 'tasks.json') ($tareas | ConvertTo-Json -Depth 8)
Ok '.vscode\tasks.json  (Ctrl+Shift+B compila)'

# --- 4. .vscode\c_cpp_properties.json, con las banderas reales ---
$subdir = Join-Path $debug 'Core\Src\subdir.mk'
$defines = @(); $includes = @(); $banderas = @(); $std = 'gnu11'
if (Test-Path -LiteralPath $subdir) {
    $linea = (Select-String -LiteralPath $subdir -Pattern 'arm-none-eabi-gcc' | Select-Object -First 1).Line
    foreach ($tok in ($linea -split '\s+')) {
        if ($tok -match '^-D(.+)$') { $defines += $Matches[1] }
        elseif ($tok -match '^-I\.\./(.+)$') { $includes += '${workspaceFolder}/' + $Matches[1] }
        elseif ($tok -match '^-std=(.+)$') { $std = $Matches[1] }
        elseif ($tok -match '^-m(cpu|thumb|float-abi|fpu)') { $banderas += $tok }
    }
} else {
    Aviso 'no hay Debug\Core\Src\subdir.mk: IntelliSense queda generico hasta compilar una vez en CubeIDE'
    $includes = @('${workspaceFolder}/**')
}
$cpp = [ordered]@{
    version        = 4
    configurations = @([ordered]@{
            name             = 'STM32'
            compilerPath     = (Join-Path $gccBin 'arm-none-eabi-gcc.exe')
            compilerArgs     = $banderas
            includePath      = $includes
            defines          = $defines
            cStandard        = $std
            intelliSenseMode = 'gcc-arm'
        })
}
Escribir (Join-Path $vs 'c_cpp_properties.json') ($cpp | ConvertTo-Json -Depth 8)
Ok ".vscode\c_cpp_properties.json  ($($defines.Count) defines, $($includes.Count) includes)"

# --- 5. Wokwi: solo la C031C6 ---
if ($placa -ne 'NUCLEO-C031C6') {
    Aviso "Wokwi no simula la ${placa}: la simulacion va con un proyecto para la NUCLEO-C031C6 (mismo codigo HAL)."
} else {
    $toml = Join-Path $Proyecto 'wokwi.toml'
    if ((Test-Path -LiteralPath $toml) -and -not $Forzar) {
        Aviso 'wokwi.toml ya existe: no lo toco (-Forzar para pisarlo)'
    } else {
        Escribir $toml ("[wokwi]`nversion = 1`nfirmware = 'Debug/$nombre.elf'`nelf = 'Debug/$nombre.elf'`n")
        Ok "wokwi.toml -> Debug/$nombre.elf"
    }
    $diag = Join-Path $Proyecto 'diagram.json'
    if ((Test-Path -LiteralPath $diag) -and -not $Forzar) {
        Aviso 'diagram.json ya existe: no lo toco (-Forzar para pisarlo)'
    } else {
        $d = [ordered]@{
            version      = 1
            author       = 'Anonymous maker'
            editor       = 'wokwi'
            parts        = @([ordered]@{ type = 'board-st-nucleo-c031c6'; id = 'nucleo'; top = 0; left = 0; attrs = @{} })
            connections  = @(
                @('$serialMonitor:TX', 'nucleo:PA3', '', @()),
                @('$serialMonitor:RX', 'nucleo:PA2', '', @())
            )
            dependencies = @{}
        }
        Escribir $diag ($d | ConvertTo-Json -Depth 8)
        Ok 'diagram.json  (placa + monitor serie en PA2/PA3)'
    }
}

# --- 6. lo que falta para compilar ---
if (-not (Test-Path -LiteralPath (Join-Path $debug 'makefile'))) {
    Aviso 'todavia no hay Debug\makefile: compila UNA vez en CubeIDE (el martillo) y despues Ctrl+Shift+B anda en VS Code'
}
Write-Host ''
Write-Host "Listo. En VS Code: File > Open Folder > $Proyecto"
