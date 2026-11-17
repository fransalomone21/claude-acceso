# En la PC (C:\tts-iise). Uso: correr-resumen.ps1 <orden> <motor: chatterbox|qwen>
# Un proceso por llamada; se lanzan varios en paralelo (cada uno ~6,8 GB de la 3090).
$orden = $args[0]; $motor = $args[1]
$env:PATH = "C:\tts-iise;$env:PATH"; $env:HF_HUB_OFFLINE = "1"; $env:HF_HOME = "C:\tts-iise\hf"; $env:PYTHONFAULTHANDLER = "1"
New-Item -ItemType Directory -Force C:\tts-iise\salida-resumen | Out-Null
$log = "C:\tts-iise\salida-resumen\log-$motor-$($orden -replace ',','_').txt"
if ($motor -eq "qwen") {
  $env:PYTHONPATH = "C:\tts-iise\qwen-libs"
  & C:\tts-iise\venv\Scripts\python.exe C:\tts-iise\podcast\sintetizar-qwen.py --modelo C:\tts-iise\qwen-modelo --guion C:\tts-iise\resumen\guion.md --partes --orden $orden "C:\tts-iise\salida-resumen\Resumen IISE 2do parcial (qwen)" *> $log
} else {
  & C:\tts-iise\venv\Scripts\python.exe C:\tts-iise\podcast\sintetizar-local.py --modelo C:\tts-iise\modelo --guion C:\tts-iise\resumen\guion.md --partes --orden $orden "C:\tts-iise\salida-resumen\Resumen IISE 2do parcial" *> $log
}
"FIN $motor $orden exit $LASTEXITCODE" | Add-Content $log
