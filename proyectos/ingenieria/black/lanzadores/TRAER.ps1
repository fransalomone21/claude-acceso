# Se corre en la PC: trae TODO lo de BLACK desde la notebook (por el cable) o desde el pendrive, sin internet. (133b)
# No depende del repo de la PC: anda suelto. Lo arma y lo sirve PAQUETE-PC.ps1 en la notebook, que imprime el comando.
#
#   -Origen http://169.254.x.y:8133      (por el cable)
#   -Origen E:\BLACK-para-la-PC          (por el pendrive)
#
# Pasos: 1) cada archivo del manifiesto a C:\Games\BLACK, verificado por sha256 (lo que ya esta igual no se vuelve a
# traer); 2) Python si falta, y pygame sin internet; 3) el repo claude-acceso al dia desde el bundle (si se puede);
# 4) PREPARAR-BLACK.ps1 (calidad grafica de ESTA maquina y accesos en el Escritorio); 5) deja anotada la IP de la
# notebook para "BLACK coop - unirse".

param([Parameter(Mandatory = $true)][string]$Origen, [string]$Raiz = 'C:\Games\BLACK', [switch]$SoloCopiar)
# -Raiz y -SoloCopiar son para probarlo en otra carpeta sin tocar la instalacion (lo uso la sesion (133b)).

$ProgressPreference = 'SilentlyContinue'
$raiz = $Raiz
$http = $Origen -match '^https?://'
$Origen = $Origen.TrimEnd('/', '\')
New-Item -ItemType Directory -Force "$raiz\paquete-pc" | Out-Null

function Traer([string]$rel, [string]$dest) {
    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    if ($http) {
        $url = $Origen + '/' + (($rel -split '\\' | ForEach-Object { [uri]::EscapeDataString($_) }) -join '/')
        curl.exe -sf -o $dest $url
        return $LASTEXITCODE -eq 0
    }
    Copy-Item -LiteralPath (Join-Path $Origen $rel) -Destination $dest -Force -ErrorAction SilentlyContinue
    return $?
}

Write-Host "== BLACK: trayendo todo desde $Origen ==" -ForegroundColor Cyan
if (-not (Traer 'paquete-pc\manifiesto.txt' "$raiz\paquete-pc\manifiesto.txt")) {
    Write-Host "No llego el manifiesto: la notebook no esta sirviendo (o el cable no conecta). Revisa y volve a correr." -ForegroundColor Red
    exit 1
}
$malos = 0
$entradas = Get-Content "$raiz\paquete-pc\manifiesto.txt" | Where-Object { $_ } | ForEach-Object { $c = $_ -split "`t"; [pscustomobject]@{ Sha = $c[0]; Tam = [long]$c[1]; Rel = $c[2] } }
$i = 0
foreach ($e in $entradas) {
    $i++
    $dest = Join-Path $raiz $e.Rel
    if ((Test-Path -LiteralPath $dest) -and (Get-Item -LiteralPath $dest).Length -eq $e.Tam -and (Get-FileHash -LiteralPath $dest).Hash -eq $e.Sha) { continue }
    Write-Host ("[{0}/{1}] {2} ({3:N1} MB)" -f $i, $entradas.Count, $e.Rel, ($e.Tam / 1MB))
    $ok = $false
    for ($k = 0; $k -lt 2 -and -not $ok; $k++) {
        $ok = (Traer $e.Rel $dest) -and (Get-FileHash -LiteralPath $dest).Hash -eq $e.Sha
    }
    if (-not $ok) { Write-Host "    FALLO (no llego o llego distinto)" -ForegroundColor Red; $malos++ }
}
if ($malos) { Write-Host "$malos archivo(s) fallaron. Volve a correr el mismo comando: retoma donde quedo." -ForegroundColor Red; exit 1 }
Write-Host "[ok] los $($entradas.Count) archivos, verificados" -ForegroundColor Green
if ($SoloCopiar) { exit 0 }

# Python y pygame
if (-not (Get-Command python -ErrorAction SilentlyContinue) -or ((python --version 2>&1) -notmatch 'Python 3')) {
    Write-Host "Instalando Python 3.11..." -ForegroundColor Cyan
    Start-Process "$raiz\paquete-pc\python-3.11.9-amd64.exe" -ArgumentList '/quiet', 'InstallAllUsers=0', 'PrependPath=1', 'Include_launcher=1' -Wait
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'User') + ';' + [Environment]::GetEnvironmentVariable('Path', 'Machine')
}
python -m pip install --no-index --find-links "$raiz\paquete-pc\wheels" pygame==2.6.1 -q 2>&1 | Out-Null
python -c "import pygame" 2>$null
if ($LASTEXITCODE -eq 0) { Write-Host "[ok] Python y pygame" -ForegroundColor Green } else { Write-Host "[!!] pygame no quedo: el mando va a andar con los botones de Xbox" -ForegroundColor Yellow }

# el repo al dia desde el bundle; si no se puede, los lanzadores sueltos del paquete
$repo = Join-Path $env:USERPROFILE 'Desktop\claude-acceso'
$bundle = "$raiz\paquete-pc\claude-acceso.bundle"
$lanz = "$raiz\paquete-pc\scripts\lanzadores"
if (Get-Command git -ErrorAction SilentlyContinue) {
    if (Test-Path "$repo\.git") {
        git -C $repo pull --ff-only $bundle main 2>&1 | Select-Object -Last 1
        if ($LASTEXITCODE -eq 0) { $lanz = "$repo\proyectos\ingenieria\black\lanzadores"; Write-Host "[ok] repo claude-acceso al dia" -ForegroundColor Green }
        else { Write-Host "[..] el repo de la PC tiene cambios propios: no lo toco; uso los lanzadores del paquete" -ForegroundColor Yellow }
    } else {
        git clone -b main $bundle $repo 2>&1 | Select-Object -Last 1
        if ($LASTEXITCODE -eq 0) { $lanz = "$repo\proyectos\ingenieria\black\lanzadores"; Write-Host "[ok] repo claude-acceso clonado" -ForegroundColor Green }
    }
}

# la IP de la notebook, para "BLACK coop - unirse"
if ($http) {
    $ipNotebook = ([uri]$Origen).Host
    [IO.File]::WriteAllText("$raiz\coop\ultima-ip.txt", $ipNotebook)
}

powershell -NoProfile -ExecutionPolicy Bypass -File "$lanz\PREPARAR-BLACK.ps1"
Write-Host ""
Write-Host "LISTO. Para jugar: en la notebook 'BLACK coop - hostear'; en esta PC 'BLACK coop - unirse'$(if ($http) { " (IP $ipNotebook ya anotada: Enter)" })." -ForegroundColor Green
