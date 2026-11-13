# Guarda tu clave de ElevenLabs en esta PC (variable de usuario ELEVENLABS_API_KEY).
# La clave no va al repo ni al chat: la pegas aca, oculta, y queda solo en tu usuario de Windows.
# Para borrarla:  [Environment]::SetEnvironmentVariable('ELEVENLABS_API_KEY', $null, 'User')

$segura = Read-Host "Pega la clave de ElevenLabs (no se ve al pegar) y Enter" -AsSecureString
$clave = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($segura)).Trim()
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
