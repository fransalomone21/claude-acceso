# Compilar BLACK (port BLACK-XBERecomp + black-seamless-coop) desde el codigo, con nuestros arreglos encima. Sesion (135).
# Lo corre Fran (codigo de terceros: lo abre el, no la sesion). La primera vez tarda 30-90 min (recompila el juego entero).
#
#   powershell -ExecutionPolicy Bypass -File "C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\lanzadores\COMPILAR-COOP.ps1"
#   ... -SinArreglos   # el control: el coop tal cual el release v2026.10.18.2, sin nada nuestro
#
# Que hace: setup.bat del mod (clona el port y el SDK en sus commits fijos, aplica el coop y extrae la ISO), aplica
# nuestros parches (black\parches-coop\*.patch, si hay y sin -SinArreglos) y corre build.bat. NO toca C:\Games\BLACK\coop:
# el BLACK.exe nuevo queda en C:\Games\BLACK\src\black-recomp\out\build\release\ hasta probarlo.
# Requiere Visual Studio 2022 (Build Tools) con C++, Clang y CMake: lo instalo la sesion (135) con winget.

param([switch]$SinArreglos)

$Mod     = 'C:\Games\BLACK\src\black-seamless-coop'
$Port    = 'C:\Games\BLACK\src\black-recomp'
$Iso     = 'C:\Games\BLACK\coop\assets\Black (USA).iso'
$Tag     = 'v2026.10.18.2'
$Parches = Join-Path (Split-Path $PSScriptRoot -Parent) 'parches-coop'
$Log     = Join-Path (Split-Path $PSScriptRoot -Parent) ("volcados\plataforma\compilar-{0:yyyyMMdd-HHmm}.log" -f (Get-Date))
New-Item -ItemType Directory -Force (Split-Path $Log) | Out-Null

function Paso($t) { Write-Host ""; Write-Host "== $t" -ForegroundColor Cyan; Add-Content -LiteralPath $Log "== $t" }
function Falla($t) { Write-Host $t -ForegroundColor Red; Add-Content -LiteralPath $Log "FALLA: $t"; Read-Host "Enter para cerrar"; exit 1 }

Paso "El codigo del coop ($Tag)"
if (-not (Test-Path "$Mod\.git")) { git clone --quiet https://github.com/MuriloDagustin/black-seamless-coop.git $Mod }
git -C $Mod fetch --quiet --tags
git -C $Mod checkout --quiet $Tag
if ($LASTEXITCODE -ne 0) { Falla "No pude poner el coop en $Tag." }

Paso "El port, el SDK, el coop y el juego (setup.bat del mod)"
# los arreglos de una corrida anterior se sacan antes: setup.bat vuelve a copiar los coop*.cpp originales
if (Test-Path "$Port\.git") { git -C $Port checkout --quiet -- . 2>$null }
cmd /c "`"$Mod\setup.bat`" `"$Port`" `"$Iso`"" 2>&1 | Tee-Object -FilePath $Log -Append
if ($LASTEXITCODE -ne 0) { Falla "setup.bat fallo: lee lo de arriba." }

if (-not $SinArreglos -and (Test-Path $Parches)) {
    foreach ($p in Get-ChildItem $Parches -Filter *.patch | Sort-Object Name) {
        Paso "Arreglo: $($p.Name)"
        git -C $Port apply --ignore-whitespace $p.FullName 2>&1 | Tee-Object -FilePath $Log -Append
        if ($LASTEXITCODE -ne 0) { Falla "No entro el arreglo $($p.Name)." }
    }
} else {
    Paso "Sin arreglos: el coop tal cual el release (control)"
}

Paso "Compilar (build.bat; la primera vez 30-90 min)"
$t0 = Get-Date
Push-Location $Port
# sin Tee a proposito: build.bat puede preguntar (Y/N, "apreta una tecla") y un pipe se come la pregunta
cmd /c "build.bat"
$rc = $LASTEXITCODE
Pop-Location
$exe = "$Port\out\build\release\BLACK.exe"
if ($rc -ne 0 -or -not (Test-Path $exe)) { Falla "La compilacion fallo (codigo $rc). El registro: $Log" }

$sha = (Get-FileHash -LiteralPath $exe -Algorithm SHA256).Hash
Add-Content -LiteralPath $Log ("OK {0} sha256={1} minutos={2:N0} arreglos={3}" -f $exe, $sha, ((Get-Date) - $t0).TotalMinutes, (-not $SinArreglos))
Write-Host ""
Write-Host "LISTO: $exe" -ForegroundColor Green
Write-Host "sha256 $sha  ($([math]::Round(((Get-Date) - $t0).TotalMinutes)) min). Avisale a Claude: lo prueba antes de instalarlo." -ForegroundColor Green
Read-Host "Enter para cerrar"
