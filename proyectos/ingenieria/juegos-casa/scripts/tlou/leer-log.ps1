# Lee el RPCS3.log aunque RPCS3 lo tenga abierto, y muestra las lineas que dicen si TLOU Factions esta armado.
param([string]$Log = 'C:\Games\RPCS3\log\RPCS3.log', [string]$Patron = 'PAT: Applied|PPU executable hash|SYS: Version|custom config|rpcn|IP swap|sceNp|connect to|net1|net10|Fatal|F \{')
$fs = [IO.File]::Open($Log, 'Open', 'Read', 'ReadWrite')
$sr = New-Object IO.StreamReader($fs)
$n = 0
while ($null -ne ($l = $sr.ReadLine())) {
  if ($l -match $Patron) { $l.Substring(0, [Math]::Min(220, $l.Length)); $n++; if ($n -ge 60) { break } }
}
$sr.Close()
