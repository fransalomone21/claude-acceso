#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
grabar_audio.py -- (96) graba LO QUE SUENA en la PC (WASAPI loopback de la salida por defecto) a un .wav.
Lo pidio Fran: los videos no tenian audio y el sonido de J2 solo se podia juzgar de oido.
Requiere `pip install pyaudiowpatch` (PyAudio con loopback de WASAPI).

    python herramientas/grabar_audio.py <salida.wav> <segundos>
    python herramientas/grabar_audio.py --probar      # 2 s a volcados/audio-prueba.wav + nivel medido

Graba la salida POR DEFECTO de Windows: si el juego suena por los auriculares del mando, hay que tenerlos como
salida por defecto (o no se graba nada: el --probar lo dice, con el nivel en 0).
"""
from __future__ import annotations

import array
import sys
import time
import wave
from pathlib import Path

import pyaudiowpatch as pa


def dispositivo(p):
    w = p.get_host_api_info_by_type(pa.paWASAPI)
    salida = p.get_device_info_by_index(w["defaultOutputDevice"])
    if salida.get("isLoopbackDevice"):
        return salida
    for d in p.get_loopback_device_info_generator():
        if salida["name"] in d["name"]:
            return d
    raise RuntimeError("no hay loopback para la salida por defecto: %s" % salida["name"])


def grabar(ruta: Path, segundos: float) -> dict:
    p = pa.PyAudio()
    try:
        d = dispositivo(p)
        canales, tasa = int(d["maxInputChannels"]), int(d["defaultSampleRate"])
        st = p.open(format=pa.paInt16, channels=canales, rate=tasa, input=True, frames_per_buffer=1024,
                    input_device_index=d["index"])
        cuadros, t0 = [], time.time()
        while time.time() - t0 < segundos:
            cuadros.append(st.read(1024, exception_on_overflow=False))
        st.stop_stream(); st.close()
        ruta.parent.mkdir(parents=True, exist_ok=True)
        with wave.open(str(ruta), "wb") as w:
            w.setnchannels(canales); w.setsampwidth(2); w.setframerate(tasa)
            w.writeframes(b"".join(cuadros))
        muestras = array.array("h", b"".join(cuadros))
        pico = max((abs(x) for x in muestras), default=0)
        return {"wav": str(ruta), "dispositivo": d["name"], "canales": canales, "tasa": tasa,
                "segundos": round(len(muestras) / canales / tasa, 2), "pico": pico}
    finally:
        p.terminate()


def main() -> int:
    if "--probar" in sys.argv:
        r = grabar(Path(__file__).resolve().parent.parent / "volcados" / "audio-prueba.wav", 2.0)
        print(r, "-> SILENCIO: nada sonaba o la salida no es la del juego" if r["pico"] == 0 else "")
        return 0
    if len(sys.argv) < 3:
        print(__doc__); return 1
    print(grabar(Path(sys.argv[1]), float(sys.argv[2])))
    return 0


if __name__ == "__main__":
    sys.exit(main())
