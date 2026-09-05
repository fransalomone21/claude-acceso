# crear-accesos-directos.ps1 -- deja BLACK y su menu de parches en el Escritorio.
# Se puede volver a correr cuantas veces se quiera: pisa los .lnk existentes.
# Sin acentos a proposito: la consola de Windows lee cp1252.

$ErrorActionPreference = 'Stop'
$lz   = $PSScriptRoot
$desk = [Environment]::GetFolderPath('Desktop')
$ps   = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$w    = New-Object -ComObject WScript.Shell

$a = $w.CreateShortcut((Join-Path $desk 'BLACK.lnk'))
$a.TargetPath       = $ps
$a.Arguments        = '-NoProfile -ExecutionPolicy Bypass -WindowStyle Minimized -File "' + (Join-Path $lz 'JUGAR-BLACK.ps1') + '"'
$a.WorkingDirectory = $lz
$a.IconLocation     = (Join-Path $env:ProgramFiles 'PCSX2\pcsx2-qt.exe') + ',0'
$a.Description      = 'Abre BLACK en PCSX2 2.8.0 con el mapeo de teclado y mouse del proyecto'
$a.Save()

$b = $w.CreateShortcut((Join-Path $desk 'BLACK - Parches.lnk'))
$b.TargetPath       = $ps
$b.Arguments        = '-NoProfile -ExecutionPolicy Bypass -File "' + (Join-Path $lz 'PARCHES-BLACK.ps1') + '"'
$b.WorkingDirectory = $lz
$b.IconLocation     = (Join-Path $env:SystemRoot 'System32\shell32.dll') + ',21'
$b.Description      = 'Prender y apagar parches de BLACK (60 FPS, widescreen, mods del proyecto)'
$b.Save()

Get-ChildItem -LiteralPath $desk -Filter 'BLACK*.lnk' | Select-Object Name, LastWriteTime
