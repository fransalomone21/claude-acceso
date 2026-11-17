#!/usr/bin/env bash
# Instala Qwen3-TTS en la notebook APARTE del entorno de Chatterbox (P6 de PROBLEMAS.md):
# libs en qwen-libs (se usan por PYTHONPATH) y el modelo en qwen-modelo, junto al tts-venv.
set -u
BASE="$LOCALAPPDATA/Temp/claude"
PY="$BASE/tts-venv/Scripts/python.exe"
"$PY" -m pip install -q --target "$BASE/qwen-libs" --no-deps qwen-tts==0.1.1 transformers==4.57.3 accelerate==1.12.0 sox einops onnxruntime "huggingface-hub==0.36.0" "tokenizers==0.22.1" psutil
PYTHONPATH="$BASE/qwen-libs" "$PY" -c "from huggingface_hub import snapshot_download as s; print(s('Qwen/Qwen3-TTS-12Hz-1.7B-Base', local_dir=r'$BASE/qwen-modelo'))"
PYTHONPATH="$BASE/qwen-libs" "$PY" -c "import qwen_tts, transformers; print('QWEN LISTO EN LA NOTEBOOK', transformers.__version__)"
