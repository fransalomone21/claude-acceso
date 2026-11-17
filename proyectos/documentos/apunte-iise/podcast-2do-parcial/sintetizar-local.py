"""Sintetiza guion.md TODO LOCAL, en la placa de video, con Chatterbox multilingue (Resemble AI, MIT).

Las voces se clonan de las referencias de 13 s del podcast de Gemini que ya uso el podcast de
Software de Vuelo (cache-local/ref_CARO.wav y ref_MARTIN.wav, copiadas de alli). Mismo motor y
mismos parametros que software-de-vuelo/podcast-parcial/sintetizar-local.py; cambia el mapa de
pronunciacion (las siglas de IISE) y la cache.

Uso (con el python del entorno tts-venv):
  python sintetizar-local.py --muestra salida.wav         los primeros renglones
  python sintetizar-local.py --partes [--orden 1,2] base  un .m4a por parte: "base - parte NN.m4a"
Cada frase se guarda en cache-local/ apenas sale: si se corta, se vuelve a correr y sigue.
"""
import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

import numpy as np
import torch

AQUI = Path(__file__).parent
CACHE = AQUI / "cache-local"   # ignorado por git
PARAM = {"exaggeration": 0.68, "cfg_weight": 0.38, "temperature": 0.8}
MAX_FRASE = 220
CPS = 14.5
HUECO_FRASE, HUECO_MISMO, HUECO_CAMBIO = 0.12, 0.2, 0.35

PRONUNCIA = [
    # revisiones
    (r"\bSRR\b", "ese erre erre"), (r"\bMDR\b", "eme de erre"), (r"\bSDR\b", "ese de erre"),
    (r"\bPDR\b", "pe de erre"), (r"\bCDR\b", "ce de erre"), (r"\bSIR\b", "ese i erre"),
    (r"\bTRR\b", "te erre erre"), (r"\bORR\b", "o erre erre"), (r"\bFRR\b", "efe erre erre"),
    (r"\bPLAR\b", "plar"), (r"\bCERR\b", "cerr"), (r"\bPER\b", "pe e erre"), (r"\bPSR\b", "pe ese erre"),
    (r"\bNAR\b", "nar"), (r"\bKDP\b", "ka de pe"), (r"\bMCR\b", "eme ce erre"),
    # escalas y documentos
    (r"\bTRL\b", "te erre ele"), (r"\bIRL\b", "i erre ele"), (r"\bSRL\b", "ese erre ele"),
    (r"\bWBS\b", "doble u be ese"), (r"\bPBS\b", "pe be ese"), (r"\bOBS\b", "o be ese"),
    (r"\bROM\b", "rom"), (r"\bAIT\b", "a i te"), (r"\bAIV\b", "a i ve"),
    (r"\bICD\b", "i ce de"), (r"\bIRD\b", "i erre de"), (r"\bIDD\b", "i de de"), (r"\bSEMP\b", "semp"),
    (r"\bFTA\b", "efe te a"), (r"\bRBD\b", "erre be de"), (r"\bFMEA\b", "efe eme e a"), (r"\bPRA\b", "pe erre a"),
    (r"\bConOps\b", "cón óps"), (r"\bTBD\b", "te be de"), (r"\bTBR\b", "te be erre"), (r"\bDSM\b", "de ese eme"),
    (r"\bCPT\b", "ce pe te"), (r"\bFT\b", "efe te"), (r"\bAT\b", "a te"), (r"\bATP\b", "a te pe"),
    (r"\bEDM\b", "e de eme"), (r"\bEM\b", "e eme"), (r"\bQTM\b", "cu te eme"),
    (r"\bEMI\b", "e eme i"), (r"\bEMC\b", "e eme ce"),
    # misiones, organismos
    (r"\bLDCM\b", "ele de ce eme"), (r"\bOLI\b", "o ele i"), (r"\bTIRS\b", "tirs"), (r"\bUSGS\b", "u ese ge ese"),
    (r"\bROV\b", "erre o ve"), (r"\bNOAA\b", "noa"), (r"\bTESS\b", "tess"), (r"\bGLAST\b", "glast"),
    (r"\bTDRS\b", "te de erre ese"), (r"\bDSN\b", "de ese ene"), (r"\bWAN\b", "uan"), (r"\bJPL\b", "jota pe ele"),
    (r"\bGPM\b", "ge pe eme"), (r"\bJAXA\b", "jaxa"), (r"\bSAC\b", "sac"), (r"\bGAO\b", "ge a o"),
    (r"\bDoD\b", "de o de"), (r"\bINCOSE\b", "incose"), (r"\bMIT\b", "eme i te"), (r"\bNTSB\b", "ene te ese be"),
    (r"\bCDIO\b", "ce de i o"), (r"\bNASA\b", "nasa"), (r"\bESA\b", "esa"), (r"\bUNSAM\b", "unsam"),
    (r"\bESPA\b", "espa"), (r"\bSZZS\b", "ese zeta zeta ese"), (r"\bSZS\b", "ese zeta ese"), (r"\bSZ\b", "ese zeta"),
    (r"\bIISE\b", "i, i, ese, e"), (r"\bLEO\b", "leo"), (r"\bRAD\b", "rad"),
    # subsistemas
    (r"\bAOCS\b", "a o ce ese"), (r"\bADCS\b", "a de ce ese"), (r"\bACS\b", "a ce ese"),
    (r"\bGN&C\b", "ge ene and ce"), (r"\bRCS\b", "erre ce ese"), (r"\bTT&C\b", "te te and ce"),
    (r"\bC&DH\b", "ce and de hache"), (r"\bEPS\b", "e pe ese"),
    # electronica y computacion
    (r"\bGPS\b", "ge pe ese"), (r"\bCPU\b", "ce pe u"), (r"\bRF\b", "erre efe"), (r"\bPWM\b", "pe doble u eme"),
    (r"\bSPI\b", "ese pe i"), (r"\bUSB\b", "u ese be"), (r"\bLAN\b", "lan"), (r"\bPC\b", "pe ce"),
    (r"\bRTX\b", "erre te equis"), (r"\bPCSX2\b", "pe ce ese equis dos"), (r"\bTP\b", "te pe"),
    # palabras en ingles, como las dice un estudiante argentino
    (r"\bbaseline\b", "béis lain"), (r"\bspacecraft\b", "spéis kraft"), (r"\bSky Crane\b", "Skái Kréin"),
    (r"\bRange Trigger\b", "Réinch Tríguer"), (r"\bTransporter\b", "Transpórter"), (r"\bwaivers\b", "uéivers"),
    (r"\bwaiver\b", "uéiver"), (r"\bshaker\b", "shéiker"), (r"\boutgassing\b", "aut gásing"),
    (r"\bfeed through\b", "fid zru"), (r"\bSafe hold\b", "Séif jold"), (r"\bB dot\b", "Bi dot"),
    (r"\baliveness test\b", "aláivnes test"), (r"\btest as you fly\b", "test as iú flái"),
    (r"\bbuilding the system right\b", "bílding de sístem ráit"),
    (r"\bbuilding the right system\b", "bílding de ráit sístem"), (r"\bdisplay\b", "displéi"),
    (r"\bGo o No Go\b", "Gou o Nou Gou"), (r"\bjoysticks\b", "yóistiks"), (r"\bjoystick\b", "yóistik"),
    (r"\bethernet\b", "íter net"), (r"\bFabric\b", "Fábric"), (r"\bMinecraft\b", "Máincraft"),
    (r"\bZeroTier\b", "Sírou Tíer"), (r"\bBLACK\b", "Blak"), (r"\bBattlefront\b", "Bátel front"),
    (r"\bThe Last of Us\b", "De Last of As"), (r"\bChange punto org\b", "Chéinch punto org"),
    (r"\bOptimism\b", "Óptimism"), (r"\bCuriosity\b", "Kiuriósiti"), (r"\bOpportunity\b", "Oportiúniti"),
    (r"\bSpaceShipTwo\b", "Spéis Ship Tu"), (r"\bVirgin Galactic\b", "Vérjin Galáctic"), (r"\bSpaceX\b", "Spéis Ex"),
    (r"\bGene Kranz\b", "Yin Kranz"), (r"\bZero\b", "Sírou"), (r"\bGoddard\b", "Gódard"), (r"\bJohnson\b", "Yónson"),
    (r"\bITHACO\b", "Ítaco"), (r"\bNancy Leveson\b", "Nánsi Léveson"), (r"\bAkin\b", "Éikin"),
    (r"\bWhatsApp\b", "Guásap"), (r"\bOneDrive\b", "Uan Dráiv"), (r"\btrade studies\b", "tréid stádis"),
    (r"\btrade study\b", "tréid stádi"), (r"\btrade-offs\b", "tréid ofs"), (r"\bmodpack\b", "mod pak"),
    (r"\bserver\b", "sérver"), (r"\bspikes\b", "spáiks"), (r"\bshake y bake\b", "shéik y béik"),
    (r"\bLandsat\b", "Lándsat"), (r"\bCubeSat\b", "Kiub Sat"), (r"\bAriane\b", "Arián"), (r"\bStudios?\b", "Stúdio"),
    (r"\bFalcon\b", "Fálcon"), (r"\bPerseverance\b", "Perseverans"), (r"\bhardware\b", "jard uer"),
    (r"\bsoftware\b", "sóft uer"), (r"\bpad\b", "pad"), (r"\bbuilding\b", "bílding"),
]


def pronunciar(t):
    for pat, rep in PRONUNCIA:
        t = re.sub(pat, rep, t)
    return t


def secciones():
    """El guion partido por sus renglones en blanco (cada parte es una seccion)."""
    texto = (AQUI / "guion.md").read_text(encoding="utf-8").split("## Guion", 1)[1]
    res = []
    for bloque in re.split(r"\n\s*\n", texto.strip()):
        rs = []
        for linea in bloque.splitlines():
            linea = linea.strip()
            m = re.match(r"\[PAUSA (\d+(?:\.\d+)?)\]", linea)
            if m:
                rs.append(("PAUSA", float(m.group(1)))); continue
            m = re.match(r"(CARO|MARTIN):\s*(.+)", linea)
            if m:
                rs.append((m.group(1), m.group(2))); continue
            if linea:
                raise SystemExit(f"renglon sin voz: {linea[:60]}")
        if rs:
            res.append(rs)
    return res


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
    pelado = texto.strip(" .,")
    if len(pelado) <= 2:            # Chatterbox revienta con una letra sola ("B."): medido en SdV
        texto = f"La {pelado}."
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
        razon = (len(a) / modelo.sr) / esperado
        if mejor is None or abs(np.log(razon)) < abs(np.log(mejor[1])):
            mejor = (a, razon)
        if 0.55 <= razon <= 1.8:
            break
        print(f"    rehago (razon {razon:.2f}): {texto[:50]}", flush=True)
    np.save(archivo, mejor[0])
    return mejor[0]


def render(modelo, refs, renglones, sr):
    sil = lambda s: np.zeros(int(sr * s), dtype=np.float32)
    piezas, anterior = [], None
    hablados = sum(1 for r in renglones if r[0] != "PAUSA")
    n = 0
    for quien, t in renglones:
        if quien == "PAUSA":
            piezas.append(sil(t)); anterior = None
            continue
        n += 1
        if n % 10 == 1:
            print(f"renglon {n}/{hablados}", flush=True)
        if anterior is not None:
            piezas.append(sil(HUECO_MISMO if anterior == quien else HUECO_CAMBIO))
        for i, f in enumerate(frases(pronunciar(t))):
            if i:
                piezas.append(sil(HUECO_FRASE))
            piezas.append(generar(modelo, refs, quien, f).astype(np.float32))
        anterior = quien
    return np.concatenate(piezas)


def escribir(audio, sr, destino):
    pcm = (np.clip(audio, -1, 1) * 32767).astype("<i2").tobytes()
    args = ["ffmpeg", "-y", "-loglevel", "error", "-f", "s16le", "-ar", str(sr), "-ac", "1", "-i", "-",
            "-af", "loudnorm=I=-16:TP=-1.5:LRA=11"]
    args += ["-ar", "44100", "-ac", "1", "-c:a", "aac", "-b:a", "64k", destino] if destino.endswith(".m4a") else [destino]
    subprocess.run(args, input=pcm, check=True)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("salida", nargs="?")
    ap.add_argument("--muestra", metavar="WAV")
    ap.add_argument("--partes", action="store_true")
    ap.add_argument("--orden", help="con --partes: que partes y en que orden, p. ej. 1,2,3")
    ap.add_argument("--solo-contar", action="store_true", help="no sintetiza: cuenta partes y renglones")
    ap.add_argument("--modelo", help="carpeta con los archivos del modelo (otra maquina, sin la cache de HF)")
    a = ap.parse_args()
    todas = secciones()
    if a.solo_contar:
        for k, s in enumerate(todas, 1):
            print(k, sum(1 for r in s if r[0] != "PAUSA"), "renglones,",
                  sum(len(r[1]) for r in s if r[0] != "PAUSA"), "caracteres")
        return
    refs = {v: str(CACHE / f"ref_{v}.wav") for v in ("CARO", "MARTIN")}
    for r in refs.values():
        if not Path(r).exists():
            raise SystemExit(f"falta la referencia de voz {r} (copiarla de software-de-vuelo/podcast-parcial/cache-local)")
    from chatterbox.mtl_tts import ChatterboxMultilingualTTS
    if a.modelo:
        modelo = ChatterboxMultilingualTTS.from_local(a.modelo, device="cuda")
    else:
        modelo = ChatterboxMultilingualTTS.from_pretrained(device="cuda")
    sr = modelo.sr
    if a.muestra:
        audio = render(modelo, refs, todas[0][:12], sr)
        escribir(audio, sr, a.muestra)
        print(f"MUESTRA {len(audio) / sr / 60:.1f} min -> {a.muestra}", flush=True)
        return
    if not a.partes or not a.salida:
        raise SystemExit("uso: --muestra WAV | --partes [--orden 1,2] base")
    base = a.salida[:-4] if a.salida.endswith(".m4a") else a.salida
    orden = [int(x) for x in a.orden.split(",")] if a.orden else list(range(1, len(todas) + 1))
    for k in orden:
        destino = f"{base} - parte {k:02d}.m4a"
        audio = render(modelo, refs, todas[k - 1], sr)
        escribir(audio, sr, destino)
        print(f"PARTE {k} LISTA {len(audio) / sr / 60:.1f} min {destino}", flush=True)
    print("TODAS LAS PARTES LISTAS", flush=True)


if __name__ == "__main__":
    main()
