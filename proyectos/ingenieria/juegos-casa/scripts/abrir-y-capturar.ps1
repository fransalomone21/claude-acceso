# Prueba en caliente: abre un juego, espera, saca una captura DPI-aware de la pantalla (para que no salga
# recortada) y lo cierra. Corre en la sesion del usuario (en la PC: tarea interactiva de una vez).
# Uso: .\abrir-y-capturar.ps1 -Exe "C:\Games\RetroArch\retroarch.exe" -Argumentos '-L "..." "..."' -Captura C:\Games\_pruebas\x.png -Espera 15
param(
    [Parameter(Mandatory = $true)][string]$Exe,
    [string]$Argumentos = "",
    [Parameter(Mandatory = $true)][string]$Captura,
    [int]$Espera = 15,
    [switch]$NoCerrar
)
Add-Type -AssemblyName System.Windows.Forms, System.Drawing
Add-Type -TypeDefinition 'using System.Runtime.InteropServices; public static class Dpi { [DllImport("user32.dll")] public static extern bool SetProcessDPIAware(); }'
[Dpi]::SetProcessDPIAware() | Out-Null
New-Item -ItemType Directory -Force (Split-Path $Captura) | Out-Null
$p = Start-Process -FilePath $Exe -ArgumentList $Argumentos -WorkingDirectory (Split-Path $Exe) -PassThru
Start-Sleep -Seconds $Espera
$b = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$img = New-Object System.Drawing.Bitmap $b.Width, $b.Height
$g = [System.Drawing.Graphics]::FromImage($img)
$g.CopyFromScreen($b.Location, [System.Drawing.Point]::Empty, $b.Size)
$chica = New-Object System.Drawing.Bitmap $img, ([int]($b.Width / 3)), ([int]($b.Height / 3))
$chica.Save($Captura, [System.Drawing.Imaging.ImageFormat]::Png)
"{0} | vivo: {1} | pantalla {2}x{3}" -f $Captura, (-not $p.HasExited), $b.Width, $b.Height
if (-not $NoCerrar -and -not $p.HasExited) { Stop-Process -Id $p.Id -Force }
