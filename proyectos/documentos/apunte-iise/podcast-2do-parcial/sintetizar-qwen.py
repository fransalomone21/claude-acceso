"""Mismo guion, mismas voces de referencia, con Qwen3-TTS 1.7B Base (Alibaba, Apache 2.0) en vez de
Chatterbox. Comparte con sintetizar-local.py el parseo del guion, la pronunciacion, los huecos y la
salida (se importa de ahi), asi la comparacion A/B cambia solo el motor.

En la PC (entorno aparte para no romper el de Chatterbox, que pide transformers 5):
  $env:PYTHONPATH="C:\\tts-iise\\qwen-libs"; python sintetizar-qwen.py --modelo C:\\tts-iise\\qwen-modelo --muestra m.wav
  ... --partes [--orden 1,2] base   |   --guion otro.md
"""
import argparse
import hashlib
import importlib.util
import json
from pathlib import Path

import numpy as np
import torch

AQUI = Path(__file__).parent
_spec = importlib.util.spec_from_file_location("chat", AQUI / "sintetizar-local.py")
S = importlib.util.module_from_spec(_spec); _spec.loader.exec_module(S)

CACHE = AQUI / "cache-qwen"
REF_TEXTO = {   # transcripcion de cache-local/ref_*.wav (faster-whisper small, 2026-11-17)
    "CARO": "genera un cortocircuito interno y una corriente altísima empieza a fluir. Si los sistemas de "
            "energía de la nave no detectan ese pico y cortan la alimentación en milisegundos, el calor "
            "directamente funde el chip. El hardware queda inservible para siempre.",
    "MARTIN": "blando, el famoso S.E.U. Y esto conceptualmente me parece mucho más retorcido, porque no hay "
              "corto circuito, no hay nada quemado, nada físico se rompe, el impacto simplemente voltea un "
              "bit de memoria, convierte un cero en un",
}
PARAM = {"temperature": 0.8, "top_p": 0.95}


class Motor:
    def __init__(self, ruta):
        from qwen_tts import Qwen3TTSModel
        self.m = Qwen3TTSModel.from_pretrained(ruta, device_map="cuda:0", dtype=torch.bfloat16, attn_implementation="sdpa")
        self.prompts = {v: self.m.create_voice_clone_prompt(ref_audio=str(S.CACHE / f"ref_{v}.wav"), ref_text=t)
                        for v, t in REF_TEXTO.items()}
        self.sr = None

    def frase(self, voz, texto):
        clave = hashlib.sha1(json.dumps([voz, texto, PARAM, "qwen1.7b"]).encode()).hexdigest()[:14]
        f = CACHE / f"q_{clave}.npz"
        if f.exists():
            d = np.load(f); self.sr = int(d["sr"]); return d["a"]
        torch.manual_seed(1000)
        wavs, sr = self.m.generate_voice_clone(text=texto, language="Spanish", voice_clone_prompt=self.prompts[voz],
                                               **PARAM)
        a = np.asarray(wavs[0], dtype=np.float32); self.sr = sr
        CACHE.mkdir(exist_ok=True); np.savez(f, a=a, sr=sr)
        return a


def render(motor, renglones):
    piezas, anterior = [], None
    for quien, t in renglones:
        if quien == "PAUSA":
            piezas.append(("sil", t)); anterior = None; continue
        if anterior is not None:
            piezas.append(("sil", S.HUECO_MISMO if anterior == quien else S.HUECO_CAMBIO))
        for i, f in enumerate(S.frases(S.pronunciar(t))):
            if i:
                piezas.append(("sil", S.HUECO_FRASE))
            piezas.append(("voz", motor.frase(quien, f)))
        anterior = quien
    sr = motor.sr
    return np.concatenate([np.zeros(int(sr * p), np.float32) if k == "sil" else p for k, p in piezas]), sr


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("salida", nargs="?")
    ap.add_argument("--muestra", metavar="WAV")
    ap.add_argument("--partes", action="store_true")
    ap.add_argument("--orden")
    ap.add_argument("--modelo", default="Qwen/Qwen3-TTS-12Hz-1.7B-Base")
    ap.add_argument("--guion")
    a = ap.parse_args()
    if a.guion:
        S.GUION = Path(a.guion)
    todas = S.secciones()
    motor = Motor(a.modelo)
    if a.muestra:
        audio, sr = render(motor, todas[0][:12])
        S.escribir(audio, sr, a.muestra)
        print(f"MUESTRA {len(audio) / sr / 60:.1f} min -> {a.muestra}", flush=True)
        return
    base = a.salida[:-4] if a.salida.endswith(".m4a") else a.salida
    orden = [int(x) for x in a.orden.split(",")] if a.orden else list(range(1, len(todas) + 1))
    for k in orden:
        destino = f"{base} - parte {k:02d}.m4a"
        audio, sr = render(motor, todas[k - 1])
        S.escribir(audio, sr, destino)
        print(f"PARTE {k} LISTA {len(audio) / sr / 60:.1f} min {destino}", flush=True)
    print("TODAS LAS PARTES LISTAS", flush=True)


if __name__ == "__main__":
    main()
