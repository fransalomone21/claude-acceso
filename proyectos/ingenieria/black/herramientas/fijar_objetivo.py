#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fijar_objetivo.py — le pregunta a PCSX2 quién es (serial, CRC) por PINE y
actualiza kb/objetivo.json solo. Es el último paso del checkpoint 0: cierra
el círculo entre "conectar" y "quedar anotado".

QUÉ HACE
    1. Se conecta por PINE y pide serial, CRC, título y versión del juego.
    2. Busca en kb/objetivo.json#versiones una entrada con ese serial.
       - Si existe: la marca confirmada=true, ajusta el CRC al observado
         (avisando fuerte si no coincidía con el anotado) y la pone como
         version_activa.
       - Si no existe: crea una entrada nueva con el serial como clave,
         confirmada=true, y la pone como version_activa.
    3. Guarda kb/objetivo.json.

La parte que decide qué cambiar (`aplicar_info`) es una función pura, sin
tocar disco ni red: por eso se puede probar sin PCSX2 abierto
(pruebas/prueba_herramientas.py la ejercita).

USO
    python3 fijar_objetivo.py              # conecta, actualiza, guarda
    python3 fijar_objetivo.py --solo-ver   # conecta y muestra, no guarda nada
"""

from __future__ import annotations

import argparse
import copy
import json
import os
import sys
from datetime import datetime, timezone

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUTA_OBJETIVO = os.path.join(RAIZ, "kb", "objetivo.json")


class FijarObjetivoError(RuntimeError):
    pass


def _normalizar_serial(s: str) -> str:
    return s.strip().upper()


def _normalizar_crc(c: str) -> str:
    return c.strip().upper()


def aplicar_info(objetivo: dict, info: dict, cuando: str | None = None) -> tuple[dict, list[str]]:
    """
    Función pura: no toca disco ni red. `objetivo` es el dict ya cargado de
    kb/objetivo.json; `info` es lo que devuelve Pine.info() (serial, crc,
    titulo, version_pcsx2, version_juego, estado). Devuelve (objetivo
    actualizado -copia nueva-, mensajes para mostrarle al usuario).
    """
    cuando = cuando or datetime.now(timezone.utc).isoformat(timespec="seconds")
    obj = copy.deepcopy(objetivo)
    mensajes: list[str] = []

    serial_obs = _normalizar_serial(info.get("serial", ""))
    crc_obs = _normalizar_crc(info.get("crc", ""))

    if not serial_obs:
        raise FijarObjetivoError(
            "PCSX2 no devolvió serial: probablemente no hay un juego cargado todavía "
            "(está en el menú). Cargá BLACK y volvé a correr esto."
        )

    obj.setdefault("versiones", {})
    clave_encontrada = None
    for clave, v in obj["versiones"].items():
        if _normalizar_serial(v.get("serial", "")) == serial_obs:
            clave_encontrada = clave
            break

    if clave_encontrada is None:
        # Serial nuevo: no había ninguna entrada preparada para esta versión.
        nueva_clave = serial_obs
        obj["versiones"][nueva_clave] = {
            "serial": serial_obs,
            "crc": crc_obs,
            "elf": None,
            "region": "desconocida (completar a mano)",
            "confirmada": True,
            "fuente_crc": f"confirmado por pine.py info el {cuando}",
        }
        obj["version_activa"] = nueva_clave
        mensajes.append(
            f"serial '{serial_obs}' no estaba en kb/objetivo.json: se creó la entrada "
            f"'{nueva_clave}'. Completá `region` a mano si la sabés."
        )
    else:
        v = obj["versiones"][clave_encontrada]
        crc_anotado = _normalizar_crc(v.get("crc") or "")
        if crc_anotado and crc_anotado != crc_obs:
            mensajes.append(
                f"AVISO: el CRC anotado para '{clave_encontrada}' era {crc_anotado} y "
                f"PCSX2 devolvió {crc_obs}. Piso el valor con el observado, que es la "
                f"fuente de verdad, pero revisá por qué no coincidía: puede que sea "
                f"otra revisión de disco, o un dato viejo mal copiado."
            )
        v["crc"] = crc_obs
        v["confirmada"] = True
        v["fuente_crc"] = f"confirmado por pine.py info el {cuando}"
        obj["version_activa"] = clave_encontrada
        mensajes.append(f"'{clave_encontrada}' confirmada y puesta como version_activa.")

    return obj, mensajes


def cargar_objetivo(ruta: str = RUTA_OBJETIVO) -> dict:
    with open(ruta, encoding="utf-8") as f:
        return json.load(f)


def guardar_objetivo(objetivo: dict, ruta: str = RUTA_OBJETIVO) -> None:
    with open(ruta, "w", encoding="utf-8") as f:
        json.dump(objetivo, f, indent=2, ensure_ascii=False)
        f.write("\n")


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="Confirma la identidad del juego contra PCSX2 y actualiza kb/objetivo.json")
    ap.add_argument("--slot", type=int, default=28011)
    ap.add_argument("--solo-ver", action="store_true", help="conecta y muestra, no escribe nada")
    args = ap.parse_args(argv)

    from pine import Pine, PineError

    try:
        with Pine(slot=args.slot) as p:
            info = p.info()
    except PineError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1

    print("PCSX2 respondió:")
    for k, v in info.items():
        print(f"  {k:16} {v}")
    print()

    try:
        objetivo = cargar_objetivo()
        actualizado, mensajes = aplicar_info(objetivo, info)
    except FijarObjetivoError as e:
        print(f"error: {e}", file=sys.stderr)
        return 1

    for m in mensajes:
        print(f"· {m}")

    if args.solo_ver:
        print("\n(--solo-ver: no se escribió kb/objetivo.json)")
        return 0

    guardar_objetivo(actualizado)
    print(f"\nkb/objetivo.json actualizado. version_activa = "
          f"{actualizado['version_activa']!r}")
    print("No te olvides de comitear.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
