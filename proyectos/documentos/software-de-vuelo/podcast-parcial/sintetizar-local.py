"""Sintetiza guion.md TODO LOCAL, en la placa de video, con Chatterbox multilingue (Resemble AI, MIT).

Uso (con el python del entorno donde esta chatterbox-tts):
  python sintetizar-local.py --muestra salida.wav     los primeros ~12 renglones
  python sintetizar-local.py salida.m4a               el podcast entero

Las voces se clonan de una referencia corta generada con las voces es-AR de edge-tts (acento rioplatense);
Chatterbox le pone la expresion. Cada frase se guarda en cache-local/ apenas sale: si se corta, se vuelve
a correr y sigue. Una frase cuya duracion no cuadra con su largo (el modelo a veces balbucea o se come el
final) se rehace con otra semilla.
Necesita: pip install chatterbox-tts edge-tts (torch con CUDA), y ffmpeg.
"""
import argparse
import asyncio
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

import numpy as np
import torch

AQUI = Path(__file__).parent
sys.path.insert(0, str(AQUI))
from sintetizar import PRONUNCIA, VOCES as VOCES_EDGE, leer_guion, pronunciar  # noqa: E402

CACHE = AQUI / "cache-local"   # ignorado por git
# v2 «con más onda» (Fran, 13/11): más exageración y menos cfg = más expresivo y más suelto de ritmo
PARAM = {"exaggeration": 0.68, "cfg_weight": 0.38, "temperature": 0.8}
REFERENCIA = {
    "CARO": "¡Bueno, che, arrancamos! Mirá, la idea no es contarte la materia como un documental, eh. Venimos a entrenar: cuatro opciones, tres suenan re bien, y una sola es la posta.",
    "MARTIN": "Y las que suenan bien son las que te cagan, ¿viste? Posta te digo: el multiple choice no te pregunta qué es un watchdog, te pregunta si lo distinguís del lockstep.",
}
RITMO_REF = {"CARO": "+10%", "MARTIN": "+8%"}
MAX_FRASE = 220            # caracteres por llamada: mas largo, mas balbuceo
CPS = 14.5                 # caracteres por segundo esperables (medido en la muestra)
HUECO_FRASE, HUECO_MISMO, HUECO_CAMBIO = 0.12, 0.2, 0.35


def referencias():
    import edge_tts
    CACHE.mkdir(exist_ok=True)
    out = {}
    for voz, texto in REFERENCIA.items():
        wav = CACHE / f"ref_{voz}.wav"
        if not wav.exists():
            mp3 = CACHE / f"ref_{voz}.mp3"
            asyncio.run(edge_tts.Communicate(pronunciar(texto), VOCES_EDGE[voz], rate=RITMO_REF[voz],
                                             pitch="+4Hz").save(str(mp3)))
            subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", str(mp3), "-ar", "24000", "-ac", "1", str(wav)], check=True)
        out[voz] = str(wav)
    return out


def frases(texto):
    partes, actual = [], ""
    for f in re.split(r"(?<=[.?!:;])\s+", texto):
        if actual and len(actual) + len(f) + 1 > MAX_FRASE:
            partes.append(actual); actual = f
        else:
            actual = f"{actual} {f}".strip()
    if actual:
        partes.append(actual)
    return partes


def generar(modelo, refs, voz, texto):
    # Chatterbox revienta con un texto de una letra ("B."): IndexError en max() sobre cero tokens.
    # Medido en la ronda rapida (2026-11-13). Se dice la frase entera, que ademas suena mas natural.
    pelado = texto.strip(" .,")
    if len(pelado) <= 2:
        texto = f"La {pelado}."
    # la referencia entra en la clave: si cambia la voz de muestra, la cache vieja no sirve
    ref_md5 = hashlib.md5(Path(refs[voz]).read_bytes()).hexdigest()
    clave = hashlib.sha1(json.dumps([voz, texto, PARAM, ref_md5]).encode()).hexdigest()[:14]
    archivo = CACHE / f"f_{clave}.npy"
    if archivo.exists():
        return np.load(archivo)
    esperado = max(len(texto) / CPS, 0.6)
    mejor = None
    for semilla in range(4):
        torch.manual_seed(1000 + semilla)
        w = modelo.generate(texto, language_id="es", audio_prompt_path=refs[voz], **PARAM)
        a = w.squeeze(0).cpu().numpy()
        dur = len(a) / modelo.sr
        razon = dur / esperado
        if mejor is None or abs(np.log(razon)) < abs(np.log(mejor[1])):
            mejor = (a, razon)
        if 0.55 <= razon <= 1.8:
            break
        print(f"    rehago (dura {dur:.1f} s, esperaba ~{esperado:.1f}): {texto[:50]}", flush=True)
    a = mejor[0]
    np.save(archivo, a)
    return a


def secciones():
    """El guion partido por sus renglones en blanco (cada tema es una seccion)."""
    texto = (AQUI / "guion.md").read_text(encoding="utf-8").split("## Guion", 1)[1]
    res = []
    for bloque in re.split(r"\n\s*\n", texto.strip()):
        rs = []
        for linea in bloque.splitlines():
            m = re.match(r"\[PAUSA (\d+(?:\.\d+)?)\]", linea.strip())
            if m:
                rs.append(("PAUSA", float(m.group(1)))); continue
            m = re.match(r"(CARO|MARTIN):\s*(.+)", linea.strip())
            if m:
                rs.append((m.group(1), m.group(2)))
        if rs:
            res.append(rs)
    return res


def escribir(audio, sr, destino):
    pcm = (np.clip(audio, -1, 1) * 32767).astype("<i2").tobytes()
    args = ["ffmpeg", "-y", "-loglevel", "error", "-f", "s16le", "-ar", str(sr), "-ac", "1", "-i", "-",
            "-af", "loudnorm=I=-16:TP=-1.5:LRA=11"]
    args += ["-ar", "44100", "-ac", "1", "-c:a", "aac", "-b:a", "56k", destino] if destino.endswith(".m4a") else [destino]
    subprocess.run(args, input=pcm, check=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("salida", nargs="?")
    ap.add_argument("--muestra", metavar="WAV")
    ap.add_argument("--partes", action="store_true", help="un archivo por tema, avisando cada uno apenas sale")
    ap.add_argument("--orden", help="con --partes: que temas y en que orden, p. ej. 9,7,10")
    a = ap.parse_args()
    from chatterbox.mtl_tts import ChatterboxMultilingualTTS
    refs = referencias()
    modelo = ChatterboxMultilingualTTS.from_pretrained(device="cuda")
    sr = modelo.sr
    if a.partes:
        base = a.salida[:-4] if a.salida.endswith(".m4a") else a.salida
        todas = secciones()
        orden = [int(x) for x in a.orden.split(",")] if a.orden else list(range(1, len(todas) + 1))
        for k in orden:
            sec = todas[k - 1]
            destino = f"{base} - parte {k:02d}.m4a"   # el numero es el del tema: ordenan en el orden de la materia
            audio = render(modelo, refs, sec, sr)
            escribir(audio, sr, destino)
            print(f"PARTE {k} LISTA {len(audio) / sr / 60:.1f} min {destino}", flush=True)
        print("TODAS LAS PARTES LISTAS", flush=True)
        return
    renglones = leer_guion()
    if a.muestra:
        renglones = renglones[:13]
    audio = render(modelo, refs, renglones, sr)
    destino = a.muestra or a.salida
    if not destino:
        raise SystemExit("falta la salida")
    escribir(audio, sr, destino)
    print(f"{len(audio) / sr / 60:.1f} min -> {destino}")


def render(modelo, refs, renglones, sr):
    sil = lambda s: np.zeros(int(sr * s), dtype=np.float32)
    piezas, anterior = [], None
    hablados = [r for r in renglones if r[0] != "PAUSA"]
    n = 0
    for quien, t in renglones:
        if quien == "PAUSA":
            piezas.append(sil(t)); anterior = None
            continue
        n += 1
        if n % 10 == 1:
            print(f"renglon {n}/{len(hablados)}", flush=True)
        if anterior is not None:
            piezas.append(sil(HUECO_MISMO if anterior == quien else HUECO_CAMBIO))
        for i, f in enumerate(frases(pronunciar(t))):
            if i:
                piezas.append(sil(HUECO_FRASE))
            piezas.append(generar(modelo, refs, quien, f).astype(np.float32))
        anterior = quien
    return np.concatenate(piezas)


if __name__ == "__main__":
    main()
