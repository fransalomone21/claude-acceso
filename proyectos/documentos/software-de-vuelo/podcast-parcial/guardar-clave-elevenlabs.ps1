# Guarda tu clave de ElevenLabs en esta PC (variable de usuario ELEVENLABS_API_KEY).
# La clave no va al repo ni al chat: la pegas aca, oculta, y queda solo en tu usuario de Windows.
# Para borrarla:  [Environment]::SetEnvironmentVariable('ELEVENLABS_API_KEY', $null, 'User')

# Primero se fija si la clave ya esta copiada (portapapeles): asi no hace falta pegar en la consola,
# que en algunas ventanas no deja con Ctrl+V. Despues de leerla, vacia el portapapeles.
$archivo = Join-Path ([Environment]::GetFolderPath('Desktop')) 'clave.txt'
$clave = "$(Get-Clipboard -Raw)".Trim()
if (Test-Path $archivo) {
    # Tercera via: la clave escrita a mano en el Bloc de notas, guardada como clave.txt en el Escritorio.
    $clave = (Get-Content $archivo -Raw).Trim()
    Remove-Item $archivo -Force
    Write-Host "Tome la clave de clave.txt del Escritorio, y borre el archivo."
} elseif ($clave -match '^sk_\S{20,}$') {
    Write-Host "Tome la clave del portapapeles (empieza con sk_)."
    Set-Clipboard -Value " "
} else {
    Write-Host "No hay una clave copiada. Copiala de ElevenLabs y volve a correr esto," -ForegroundColor Yellow
    Write-Host "o pegala aca con CLIC DERECHO (no se ve nada al pegar) y Enter:" -ForegroundColor Yellow
    $segura = Read-Host "Clave" -AsSecureString
    $clave = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($segura)).Trim()
}
if ($clave.Length -lt 20) { Write-Host "Eso no parece una clave (muy corta). No se guardo nada." -ForegroundColor Red; exit 1 }

# Se prueba antes de guardarla: consultar tu saldo no gasta nada.
try {
    $s = Invoke-RestMethod -Uri "https://api.elevenlabs.io/v1/user/subscription" -Headers @{ "xi-api-key" = $clave } -TimeoutSec 30
    [Environment]::SetEnvironmentVariable('ELEVENLABS_API_KEY', $clave, 'User')
    Write-Host ("LISTO: la clave anda y quedo guardada. Plan {0}: te quedan {1} de {2} creditos este mes." -f `
        $s.tier, ($s.character_limit - $s.character_count), $s.character_limit) -ForegroundColor Green
} catch {
    Write-Host "La clave NO anduvo: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Si dice 401/permiso: al crearla, dale acceso a 'Text to Speech' y a 'User: read'. No se guardo nada." -ForegroundColor Red
    exit 1
}
