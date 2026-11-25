# Corre PowerShell en la PC desde la notebook, sin pelear con las comillas: SIEMPRE codificado (-EncodedCommand) o
# como archivo copiado por scp. El SSH de la PC abre PowerShell, no cmd: un 'if not exist ... mkdir' de cmd falla en
# silencio, y un comando con comillas o variables sin codificar llega roto (2026-11-25, dos veces en una sesion:
# biblioteca.py no copio nada y instalar-retroarch.ps1 salio en 1 sin decir por que).
# Uso (desde cualquier carpeta, con la ruta absoluta de este script):
#   en-pc.ps1 -Comando 'Get-ChildItem C:\Games | % Name'
#   en-pc.ps1 -Archivo .\algo.ps1 -Argumentos '-Nick Kheven -Carpeta "C:\x y"'
# Sale 0 si el comando remoto salio 0, y 1 si no: el SSH de la PC (que abre PowerShell) aplana cualquier codigo
# distinto de 0 a 1 (medido: 'exit 3' llega como 1). Filtra el ruido CLIXML de la primera carga de modulos.
param(
    [string]$Comando,
    [string]$Archivo,
    [string]$Argumentos = "",
    [string]$Destino = "Fran@10.147.20.3",
    [string]$Llave = (Join-Path $env:USERPROFILE ".ssh\pc-cable")
)
if (-not $Comando -and -not $Archivo) { "uso: -Comando '<powershell>' | -Archivo <script.ps1> [-Argumentos '...']"; exit 2 }
if ($Archivo) {
    $remoto = "C:/Games/_scripts/" + (Split-Path $Archivo -Leaf)
    scp -q -i $Llave $Archivo "${Destino}:$remoto"
    if ($LASTEXITCODE -ne 0) { "no se pudo copiar $Archivo a la PC (scp $LASTEXITCODE)"; exit 1 }
    $Comando = "& '$($remoto.Replace('/', '\'))' $Argumentos"
}
$b64 = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Comando))
ssh -o ConnectTimeout=15 -i $Llave $Destino "powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand $b64" 2>&1 |
    Where-Object { "$_" -notmatch '^#< CLIXML|^<Objs Version' }
exit $LASTEXITCODE
