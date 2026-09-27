# subir-datos-nube.ps1 -- sube a un repo PRIVADO lo minimo para trabajar BLACK en frio desde la nube.
#
#   powershell -ExecutionPolicy Bypass -File herramientas\windows\subir-datos-nube.ps1
#
# NUNCA a claude-acceso: es publico y el ELF es material del juego.
# Sube: el ELF, tres volcados de RAM y dos archivos del ISO (no el ISO entero: no entra en GitHub).
# Se puede correr de nuevo: si el repo ya existe, solo agrega lo que cambio.
# Todo en ASCII a proposito: PowerShell 5.1 lee los .ps1 sin BOM como ANSI.

$ErrorActionPreference = 'Stop'
$Usuario = 'fransalomone21'
$Repo    = 'black-datos'
$Destino = 'C:\Users\frans\black-datos'
$Acceso  = 'C:\Users\frans\Desktop\claude-acceso'
$Black   = Join-Path $Acceso 'proyectos\ingenieria\black'
$Iso     = 'C:\Program Files\PCSX2\PCSX2\games\Black [NTSC]\Black.iso'
$Limite  = 95MB   # GitHub rechaza archivos de mas de 100 MB

function Paso($t) { Write-Host "`n== $t" -ForegroundColor Cyan }

Paso '1. claude-acceso al dia (trae lo de la sesion en la nube)'
git -C $Acceso pull --ff-only origin main
if ($LASTEXITCODE -ne 0) { throw 'git pull de claude-acceso fallo: revisar antes de seguir' }

Paso '2. el repo privado en GitHub'
$url = "https://github.com/$Usuario/$Repo.git"
# en PowerShell 5.1, redirigir el stderr de un comando nativo con 'Stop' lo convierte en excepcion
$ErrorActionPreference = 'Continue'
git ls-remote $url 2>$null | Out-Null
$existe = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = 'Stop'
if ($existe) {
    Write-Host "ya existe: $url"
} elseif (Get-Command gh -ErrorAction SilentlyContinue) {
    gh repo create "$Usuario/$Repo" --private --description 'BLACK: ELF y volcados para las sesiones en la nube. PRIVADO.'
    if ($LASTEXITCODE -ne 0) { throw 'gh repo create fallo' }
} else {
    Start-Process "https://github.com/new?name=$Repo&visibility=private"
    Write-Host 'Se abrio GitHub en el navegador. Crealo PRIVADO, vacio (sin README), y volve aca.' -ForegroundColor Yellow
    Read-Host 'Enter cuando este creado'
}

Paso '3. juntar los archivos'
New-Item -ItemType Directory -Force -Path $Destino | Out-Null
$archivos = @(
    'C:\Users\frans\herramientas\SLUS_213.76',
    (Join-Path $Black 'volcados\ee-e4.bin'),
    (Join-Path $Black 'volcados\ee-nivel-mod0.bin'),
    (Join-Path $Black 'volcados\ee-03.bin')
)

# los del ISO: si no esta montado, se monta (solo lectura) y se desmonta al final
$letra = $null; $montado = $false
foreach ($d in Get-PSDrive -PSProvider FileSystem) {
    if (Test-Path -LiteralPath "$($d.Root)EXPORT\FRONTEND\WPNSCOPE.BIN") { $letra = $d.Root; break }
}
if (-not $letra -and (Test-Path -LiteralPath $Iso)) {
    $img = Mount-DiskImage -ImagePath $Iso -Access ReadOnly -PassThru
    $letra = ($img | Get-Volume).DriveLetter + ':\'
    $montado = $true
}
if ($letra) {
    $archivos += (Join-Path $letra 'EXPORT\FRONTEND\WPNSCOPE.BIN')
    $archivos += (Join-Path $letra 'GLOBDATA.BIN')
} else {
    Write-Host 'AVISO: no encontre el ISO; sigo sin WPNSCOPE ni GLOBDATA' -ForegroundColor Yellow
}

$copiados = @()
foreach ($f in $archivos) {
    if (-not (Test-Path -LiteralPath $f)) { Write-Host "FALTA   $f" -ForegroundColor Yellow; continue }
    $tam = (Get-Item -LiteralPath $f).Length
    if ($tam -gt $Limite) { Write-Host ("GRANDE  {0} ({1:N0} MB): no entra en GitHub, queda afuera" -f $f, ($tam / 1MB)) -ForegroundColor Yellow; continue }
    Copy-Item -LiteralPath $f -Destination $Destino -Force
    Write-Host ("OK      {0} ({1:N1} MB)" -f (Split-Path $f -Leaf), ($tam / 1MB))
    $copiados += Split-Path $f -Leaf
}
if ($montado) { Dismount-DiskImage -ImagePath $Iso | Out-Null }
if ($copiados -notcontains 'SLUS_213.76') { throw 'sin el ELF no tiene sentido subir nada: revisar la ruta' }

Paso '4. manifiesto (la nube verifica contra esto que llego lo mismo)'
Push-Location $Destino
try {
    $lineas = Get-ChildItem -File | Where-Object { $_.Name -ne 'MANIFIESTO.txt' } | Sort-Object Name | ForEach-Object {
        '{0}  {1}  {2}' -f (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash.ToLower(), $_.Length, $_.Name
    }
    $lineas | Set-Content -Encoding ascii MANIFIESTO.txt
    $lineas | ForEach-Object { Write-Host $_ }

    Paso '5. commit y push'
    if (-not (Test-Path .git)) {
        git init -b main | Out-Null
        git remote add origin $url
    }
    git add -A
    git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) { git commit -m "datos de BLACK para la nube ($(Get-Date -Format yyyy-MM-dd))" | Out-Null }
    git push -u origin main
    if ($LASTEXITCODE -ne 0) { throw 'git push fallo' }
    Write-Host "`nLISTO: $($copiados.Count) archivos en $url (privado). Decile a la sesion: listo." -ForegroundColor Green
} finally { Pop-Location }
