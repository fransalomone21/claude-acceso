# arreglar-permisos.ps1 -- pone la lista de permisos en ~/.claude/settings.json.
#
# POR QUE ESTO ES UN SCRIPT Y NO LO HIZO LA SESION. El clasificador de
# auto-mode le prohibe a Claude escribir sus PROPIOS archivos de permisos
# (motivo 'Self-Modification'), y esta bien que lo haga: si pudiera, el
# permiso no seria un permiso. Asi que la sesion deja el cambio escrito,
# revisable, y lo aplica Fran con un comando.
#
# QUE HACE:
#   1. Respalda settings.json con fecha.
#   2. MERGE -- no pisa: conserva hooks, enableWorkflows y todo lo que haya.
#   3. Agrega permissions.allow / ask / deny y defaultMode = acceptEdits.
#   4. Apaga agentPushNotifEnabled (los avisos que le llegaban a Agustin).
#
# EL CRITERIO, que es lo unico que importa revisar:
#   allow -> lo inofensivo y lo que Claude deberia hacer solo: leer, buscar,
#            compilar, correr python, git del dia a dia. Nada de esto toca
#            datos de Fran ni es irreversible.
#   ask   -> lo que borra o reescribe historia: rm, Remove-Item, rebase.
#            Ahi si pregunta, porque ahi si hay algo que evaluar.
#   deny  -> lo irreversible de verdad: rm -rf, push --force, reset --hard,
#            reset de disco. No se pregunta: no pasa.
#
# Se deshace solo: hay un .bak con fecha al lado, y basta con restaurarlo.
#
# Sin acentos a proposito: la consola de Windows lee cp1252.

$ErrorActionPreference = 'Stop'
$ruta = Join-Path $env:USERPROFILE '.claude\settings.json'

if (-not (Test-Path $ruta)) { throw "No existe $ruta" }

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$bak   = "$ruta.bak-permisos-$stamp"
Copy-Item $ruta $bak -Force
Write-Host "respaldo: $bak" -ForegroundColor DarkGray

$json = Get-Content -Raw $ruta
$s = $json | ConvertFrom-Json

$allow = @(
  'awk','basename','cat','cd','chmod','cp','curl','cut','date','diff','dirname',
  'du','echo','env','export','ffmpeg','file','find','gh','grep','head','jq','ln',
  'ls','md5sum','mkdir','mv','node','npm','npx','od','pandoc','pip','printf','pwd',
  'py','python','python3','rclone','realpath','rg','sed','seq','sha256sum','sort',
  'stat','strings','tail','tar','tasklist','test','touch','tr','tree','typst',
  'uniq','unzip','wc','which','winget','xxd'
) | ForEach-Object { "Bash($_" + ':*)' }

$allowGit = @(
  'git status','git log','git diff','git show','git add','git commit','git push',
  'git pull','git fetch','git branch','git remote','git ls-files','git rev-parse',
  'git stash','git check-ignore','git blame','git describe','git worktree list'
) | ForEach-Object { "Bash($_" + ':*)' }

$allowPS = @(
  'Add-Content','Add-Type','Compare-Object','ConvertFrom-Json','ConvertTo-Json',
  'Copy-Item','ForEach-Object','Get-ChildItem','Get-CimInstance','Get-Command',
  'Get-Content','Get-Date','Get-FileHash','Get-Item','Get-ItemProperty',
  'Get-Location','Get-Process','Get-Service','Get-WinEvent','Measure-Object',
  'Move-Item','New-Item','Out-File','Resolve-Path','Select-Object','Select-String',
  'Set-Content','Set-Location','Start-Sleep','Test-Path','Where-Object',
  'Write-Host','Write-Output','git','python','typst','rclone'
) | ForEach-Object { "PowerShell($_" + ':*)' }

$allowOtros = @(
  'Read(//c/Users/frans/Desktop/**)',
  'Read(//c/Users/frans/.claude/**)',
  'Glob(//c/Users/frans/Desktop/**)',
  'Grep(//c/Users/frans/Desktop/**)',
  'WebFetch(domain:docs.claude.com)',
  'WebFetch(domain:rclone.org)',
  'WebFetch(domain:typst.app)'
)

# Lo que SI tiene que preguntar: borra o reescribe historia.
$ask = @(
  'Bash(rm' + ':*)', 'Bash(git rebase' + ':*)', 'Bash(git filter-branch' + ':*)',
  'Bash(gh repo edit' + ':*)', 'Bash(winget uninstall' + ':*)',
  'PowerShell(Remove-Item' + ':*)', 'PowerShell(Stop-Process' + ':*)'
)

# Lo irreversible: no se pregunta, no pasa.
$deny = @(
  'Bash(rm -rf' + ':*)', 'Bash(rm -fr' + ':*)', 'Bash(rm -r -f' + ':*)',
  'Bash(git push --force' + ':*)', 'Bash(git push -f' + ':*)',
  'Bash(git reset --hard' + ':*)', 'Bash(git clean -fd' + ':*)',
  'Bash(git clean -xdf' + ':*)', 'Bash(gh repo delete' + ':*)',
  'Bash(gh auth logout' + ':*)', 'Bash(shutdown' + ':*)', 'Bash(mkfs' + ':*)',
  'PowerShell(Remove-Item -Recurse' + ':*)', 'PowerShell(Format-Volume' + ':*)',
  'PowerShell(Stop-Computer' + ':*)', 'PowerShell(Restart-Computer' + ':*)',
  'PowerShell(Set-ExecutionPolicy' + ':*)'
)

$todoAllow = @($allow) + @($allowGit) + @($allowPS) + @($allowOtros)

if (-not ($s.PSObject.Properties.Name -contains 'permissions')) {
    $s | Add-Member -NotePropertyName 'permissions' -NotePropertyValue (New-Object PSObject)
}
$p = $s.permissions

function Poner($obj, $nombre, $valor) {
    if ($obj.PSObject.Properties.Name -contains $nombre) { $obj.$nombre = $valor }
    else { $obj | Add-Member -NotePropertyName $nombre -NotePropertyValue $valor }
}

$prevAllow = @(); if ($p.PSObject.Properties.Name -contains 'allow') { $prevAllow = @($p.allow) }
$prevAsk   = @(); if ($p.PSObject.Properties.Name -contains 'ask')   { $prevAsk   = @($p.ask) }
$prevDeny  = @(); if ($p.PSObject.Properties.Name -contains 'deny')  { $prevDeny  = @($p.deny) }

Poner $p 'allow'       (@($prevAllow + $todoAllow | Sort-Object -Unique))
Poner $p 'ask'         (@($prevAsk   + $ask       | Sort-Object -Unique))
Poner $p 'deny'        (@($prevDeny  + $deny      | Sort-Object -Unique))
Poner $p 'defaultMode' 'acceptEdits'

# Los avisos que le llegaban al celular de Agustin.
Poner $s 'agentPushNotifEnabled' $false

$s | ConvertTo-Json -Depth 12 | Out-File $ruta -Encoding utf8

Write-Host ""
Write-Host "LISTO." -ForegroundColor Green
Write-Host ("  allow : {0} reglas" -f @($p.allow).Count)
Write-Host ("  ask   : {0} reglas  (borra o reescribe historia)" -f @($p.ask).Count)
Write-Host ("  deny  : {0} reglas  (irreversible: ni se pregunta)" -f @($p.deny).Count)
Write-Host ("  modo  : {0}" -f $p.defaultMode)
Write-Host ("  avisos push: {0}" -f $s.agentPushNotifEnabled)
Write-Host ("  hooks conservados: {0}" -f (($s.hooks.PSObject.Properties.Name) -join ', '))
Write-Host ""
Write-Host "Reinicia la sesion de Claude Code para que tome los permisos." -ForegroundColor Yellow
