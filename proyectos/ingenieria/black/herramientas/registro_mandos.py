#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
registro_mandos.py -- que botones apreto CADA puerto mientras se graba el gameplay (93y).

El video solo no dice de que mando salio una accion: J2 puede reaccionar a J1 (la pose compartida de (93m))
y en la pantalla eso se ve igual que si J2 hubiera apretado. Este registro lee por PINE lo que el JUEGO
recibe en el mando procesado de cada puerto -- no el mando fisico: los botones ya traducidos a acciones
(disparar, recargar, cambiar de arma...) -- y lo estampa debajo de cada mitad de las hojas de contacto.

    python herramientas/registro_mandos.py grabar DIR --segundos 30   # lo corre grabar-gameplay.ps1
    python herramientas/registro_mandos.py anotar DIR                 # hojas_mandos/ + eventos.txt
    python herramientas/registro_mandos.py probar --segundos 5        # imprime los cambios en vivo

El mando procesado (kb/mapa-memoria.json, mando_procesado_1/2, 'probable'): puerto 1 en 0x005856C0,
puerto 2 en 0x005857B0; boton i apretado si el u8 de +0x2A+i != 0; ejes f32 en +0x8C.. (sondas_coop.EJES,
medidos en el puerto 1). Nombres de botones: sondas_coop.BOTONES (medidos en (77)); el resto sale como b<i>.

SINCRONIA: el registro guarda la hora de reloj de cada muestra y grabar-gameplay.ps1 la hora en que arranco
ffmpeg (inicio_video.txt). El primer cuadro de ddagrab llega unas decimas despues: el desfase es de
~0,5 s como mucho, y se corrige a ojo con un evento visible (el contador de balas baja al disparar).

Si PINE no responde (emulador cerrado, o sin juego cargado) 'grabar' lo anota en mandos.txt y sale con 0:
el video se graba igual, sin los botones.
"""
from __future__ import annotations

import argparse
import json
import struct
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine, PineError  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
from sondas_coop import BOTONES, EJES  # noqa: E402

PUERTOS = {1: 0x005856C0, 2: 0x005857B0}
BOT_DESDE, BOT_N = 0x2A, 28          # +0x2A+i, i = 0..27
LEER_BOT = (0x28, 0x48)              # alineado a 8: cubre +0x2A..+0x45
LEER_EJE = (0x88, 0xD0)              # alineado a 8: cubre +0x8C..+0xCC
UMBRAL_EJE = 0.3
# (90) el juego le da a J1 el control del puerto que apreto Start; J2 toma el otro. *(J+0x588) dice cual.
J_CONTROL = 0x005A8AB0 + 0x588
CONTROL_PUERTO_2 = 0x00585A0C
NOMBRE_BOTON = {v: k for k, v in BOTONES.items()}
GRUPO_EJE = {"adelante": "camina", "atras": "camina", "lateral_a": "camina", "lateral_b": "camina",
             "pitch_arriba": "mira", "yaw_izq": "mira", "yaw_der": "mira"}


def _direcciones() -> list[int]:
    ds = []
    for base in PUERTOS.values():
        ds += [base + o for o in range(*LEER_BOT, 8)]
        ds += [base + o for o in range(*LEER_EJE, 8)]
    return ds


def _decodificar(valores: list[int]) -> dict:
    """De la lectura en lote a {puerto: {'b': [indices apretados], 'e': {eje: valor}}}."""
    nb = (LEER_BOT[1] - LEER_BOT[0]) // 8
    ne = (LEER_EJE[1] - LEER_EJE[0]) // 8
    out, k = {}, 0
    for pto in PUERTOS:
        bot = b"".join(struct.pack("<Q", v) for v in valores[k:k + nb]); k += nb
        eje = b"".join(struct.pack("<Q", v) for v in valores[k:k + ne]); k += ne
        b0 = BOT_DESDE - LEER_BOT[0]
        apretados = [i for i in range(BOT_N) if bot[b0 + i]]
        ejes = {}
        for nombre, off in EJES.items():
            (f,) = struct.unpack_from("<f", eje, off - LEER_EJE[0])
            if abs(f) >= UMBRAL_EJE and f == f:
                ejes[nombre] = round(f, 2)
        out[pto] = {"b": apretados, "e": ejes}
    return out


def acciones(estado: dict) -> list[str]:
    """Lo que se estampa: nombres de botones y 'camina'/'mira' si hay ejes."""
    # b16..b27 son las direcciones de los sticks como botones (medido en vivo, (93y)): ya salen como camina/mira
    s = [NOMBRE_BOTON.get(i, f"b{i}") for i in estado["b"] if i < 16]
    for g in ("camina", "mira"):
        if any(GRUPO_EJE.get(n) == g for n in estado["e"]):
            s.append(g)
    return s


def grabar(dir_: Path, segundos: float, hz: float = 30.0) -> int:
    dir_.mkdir(parents=True, exist_ok=True)
    nota = dir_ / "mandos.txt"
    try:
        p = Pine()
    except PineError as e:
        nota.write_text("sin registro de mandos: PINE no respondio.\n" + str(e) + "\n", encoding="utf-8")
        return 0
    ds = _direcciones()
    n = 0
    j1 = puerto_de_j1(p)
    (dir_ / "puertos.json").write_text(json.dumps({"j1_puerto": j1}) + "\n", encoding="utf-8")
    with p, open(dir_ / "mandos.jsonl", "w", encoding="utf-8") as f:
        fin = time.time() + segundos
        paso = 1.0 / hz
        while time.time() < fin:
            t = time.time()
            try:
                est = _decodificar(p.leer_muchas(ds, ancho=8))
            except PineError as e:
                nota.write_text(f"PINE se corto a las {n} muestras: {e}\n", encoding="utf-8")
                return 0
            # las claves "1"/"2" del registro son JUGADORES (J1 = el puerto que apreto Start), no puertos
            f.write(json.dumps({"t": round(t, 3), "1": est[j1], "2": est[3 - j1]}) + "\n")
            n += 1
            espera = paso - (time.time() - t)
            if espera > 0:
                time.sleep(espera)
    nota.write_text(f"{n} muestras en {segundos:g} s ({n / segundos:.1f} por segundo).\n", encoding="utf-8")
    return 0


def puerto_de_j1(p: Pine) -> int:
    return 2 if p.leer32(J_CONTROL) == CONTROL_PUERTO_2 else 1


def _cargar(dir_: Path, j1_puerto: int | None = None) -> tuple[list[dict], float]:
    ms = [json.loads(l) for l in (dir_ / "mandos.jsonl").read_text(encoding="utf-8").splitlines() if l.strip()]
    if j1_puerto == 2:   # registro viejo (antes de puertos.json), guardado por puerto: se da vuelta
        ms = [{"t": m["t"], "1": m["2"], "2": m["1"]} for m in ms]
    ini = dir_ / "inicio_video.txt"
    t0 = float(ini.read_text(encoding="ascii").strip()) if ini.exists() else ms[0]["t"]
    return ms, t0


def eventos(ms: list[dict], t0: float) -> list[str]:
    """Solo los cambios: 't=  3.25  J1 +disparar' / '-disparar'."""
    lineas, antes = [], {1: set(), 2: set()}
    for m in ms:
        for pto in (1, 2):
            ahora = set(acciones(m[str(pto)]))
            for a in sorted(ahora - antes[pto]):
                lineas.append(f"t={m['t'] - t0:6.2f}  J{pto} +{a}")
            for a in sorted(antes[pto] - ahora):
                lineas.append(f"t={m['t'] - t0:6.2f}  J{pto} -{a}")
            antes[pto] = ahora
    return lineas


def anotar(dir_: Path, desfase: float = 0.0, j1_puerto: int | None = None) -> int:
    from PIL import Image, ImageDraw, ImageFont

    if not (dir_ / "mandos.jsonl").exists():
        print("sin mandos.jsonl: nada que anotar"); return 0
    ms, t0 = _cargar(dir_, j1_puerto)
    t0 += desfase
    (dir_ / "eventos.txt").write_text("\n".join(eventos(ms, t0)) + "\n", encoding="utf-8")
    cuadros = sorted((dir_ / "cuadros").glob("c_*.png"))   # 4 por segundo; c_001 = t 0
    if not cuadros:
        print("sin cuadros/"); return 0
    try:
        fuente = ImageFont.truetype("C:/Windows/Fonts/arialbd.ttf", 26)
        chica = ImageFont.truetype("C:/Windows/Fonts/arial.ttf", 22)
    except OSError:
        fuente = chica = ImageFont.load_default()
    ts = [m["t"] - t0 for m in ms]
    sal = dir_ / "hojas_mandos"; sal.mkdir(exist_ok=True)
    por_hoja, anotados = 12, []
    for k, c in enumerate(cuadros):
        t = k / 4.0
        # todo lo que se apreto en la ventana de este cuadro (+-0,125 s): un toque corto no se pierde
        vent = {1: set(), 2: set()}
        for tm, m in zip(ts, ms):
            if t - 0.125 <= tm < t + 0.125:
                for pto in (1, 2):
                    vent[pto].update(acciones(m[str(pto)]))
        im = Image.open(c).convert("RGB")
        w, h = im.size
        d = ImageDraw.Draw(im)
        d.rectangle([0, h - 40, w, h], fill=(0, 0, 0))
        d.text((8, h - 36), "J1: " + (" ".join(sorted(vent[1])) or "-"), font=fuente, fill=(120, 220, 255))
        d.text((w // 2 + 8, h - 36), "J2: " + (" ".join(sorted(vent[2])) or "-"), font=fuente, fill=(255, 200, 80))
        d.rectangle([w // 2 - 50, 0, w // 2 + 50, 28], fill=(0, 0, 0))
        d.text((w // 2 - 44, 2), f"{t:5.2f} s", font=chica, fill=(255, 255, 0))
        anotados.append(im.resize((w // 2, h // 2)))
    # hojas de 12 cuadros (3 s), 3 columnas x 4 filas: los rotulos se leen
    for i in range(0, len(anotados), por_hoja):
        grupo = anotados[i:i + por_hoja]
        cw, ch = grupo[0].size
        hoja = Image.new("RGB", (cw * 3, ch * 4))
        for j, im in enumerate(grupo):
            hoja.paste(im, ((j % 3) * cw, (j // 3) * ch))
        hoja.save(sal / f"hoja_{i // por_hoja + 1:02d}.png")
    print(f"{len(anotados)} cuadros anotados en {sal}; eventos en {dir_ / 'eventos.txt'}")
    return 0


def probar(segundos: float) -> int:
    with Pine() as p:
        ds = _direcciones()
        j1 = puerto_de_j1(p)
        print(f"J1 = puerto {j1}")
        antes = {1: set(), 2: set()}
        t0 = time.time(); n = 0
        while time.time() - t0 < segundos:
            est = _decodificar(p.leer_muchas(ds, ancho=8)); n += 1
            est = {1: est[j1], 2: est[3 - j1]}
            for pto in (1, 2):
                ahora = set(acciones(est[pto]))
                if ahora != antes[pto]:
                    print(f"{time.time() - t0:6.2f}  J{pto}: {' '.join(sorted(ahora)) or '-'}  {est[pto]['e']}")
                antes[pto] = ahora
        print(f"{n} muestras en {segundos:g} s ({n / segundos:.1f}/s)")
    return 0


def main() -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    g = sub.add_parser("grabar"); g.add_argument("dir"); g.add_argument("--segundos", type=float, default=30)
    a = sub.add_parser("anotar"); a.add_argument("dir")
    a.add_argument("--desfase", type=float, default=0.0, help="s a sumar a la hora del video (sincronia a ojo)")
    a.add_argument("--j1-puerto", type=int, choices=(1, 2), help="solo registros viejos, sin puertos.json")
    pr = sub.add_parser("probar"); pr.add_argument("--segundos", type=float, default=5)
    x = ap.parse_args()
    if x.cmd == "grabar":
        return grabar(Path(x.dir), x.segundos)
    if x.cmd == "anotar":
        return anotar(Path(x.dir), x.desfase, x.j1_puerto)
    return probar(x.segundos)


if __name__ == "__main__":
    sys.exit(main())
