#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
awd.py — leer los diccionarios de audio de RenderWare (.AWD) del ISO.

No parsea el formato: se lo pide a **vgmstream**, que es el parser
certificado de audio de videojuegos y trae soporte de `RenderWare AWD header`
desde hace años. Nosotros sólo lo manejamos y ordenamos la salida.

POR QUÉ IMPORTA UN CATÁLOGO DE SONIDOS EN UN PROYECTO DE INGENIERÍA REVERSA
    Porque los `.AWD` traen los NOMBRES de cada stream, y los nombres los
    puso el equipo de Criterion. `AIWPNS.AWD` (AI Weapons) dice qué armas usa
    la IA en cada nivel; `PAUDIO.AWD` (Player Audio), las del jugador. Eso es
    exactamente la etiqueta que le falta a los 17 registros de la tabla de
    armas de `kb/estructuras.json#arma`, que hoy se identifican por perfil de
    parámetros porque el código de 3 letras está corrido.

    O sea: es una fuente de nombres INDEPENDIENTE del binario, y por eso
    sirve para cruzar.

DEPENDENCIA EXTERNA
    vgmstream-cli. Se baja de https://github.com/vgmstream/vgmstream/releases
    (`vgmstream-win64.zip`), se descomprime en cualquier lado y se apunta con
    `--vgmstream` o con la variable de entorno `VGMSTREAM`. Por defecto busca
    en `C:/Users/<vos>/herramientas/vgmstream/vgmstream-cli.exe` y en el PATH.

    Si no está, la herramienta lo dice y sale — no inventa resultados.

EJEMPLOS
    python herramientas/awd.py listar "D:/LEVELS/LEVEL_01/STG_0001/AIWPNS.AWD"
    python herramientas/awd.py catalogo D:/ --json volcados/catalogo-awd.json
    python herramientas/awd.py catalogo D:/ --filtro AIWPNS
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402


def hallar_vgmstream(pedido: str | None) -> str:
    """Devuelve la ruta al ejecutable, o corta con un mensaje que sirva."""
    candidatos = [
        pedido,
        os.environ.get("VGMSTREAM"),
        str(Path.home() / "herramientas" / "vgmstream" / "vgmstream-cli.exe"),
        shutil.which("vgmstream-cli"),
        shutil.which("vgmstream-cli.exe"),
    ]
    for c in candidatos:
        if c and Path(c).is_file():
            return c
    raise SystemExit(
        "no encuentro vgmstream-cli.\n"
        "  Bajalo de https://github.com/vgmstream/vgmstream/releases\n"
        "  (vgmstream-win64.zip), descomprimilo, y pasá la ruta con\n"
        "  --vgmstream o poné la variable de entorno VGMSTREAM."
    )


# Campos de la salida de `vgmstream-cli -m`. Uno por línea, `clave: valor`.
CAMPOS = {
    "stream name": "nombre",
    "stream index": "indice",
    "stream count": "total",
    "sample rate": "hz",
    "channels": "canales",
    "encoding": "codificacion",
    "metadata from": "formato",
}
RE_MUESTRAS = re.compile(r"stream total samples:\s*(\d+)\s*\(([^)]*)\)")


def leer_awd(vgm: str, ruta: Path) -> dict:
    """Todos los streams de un .AWD, en una sola invocación (-S 0)."""
    try:
        p = subprocess.run([vgm, "-m", "-S", "0", str(ruta)],
                           capture_output=True, text=True, timeout=180)
    except subprocess.TimeoutExpired:
        return {"archivo": str(ruta), "error": "timeout"}
    if p.returncode != 0 and not p.stdout.strip():
        return {"archivo": str(ruta), "error": (p.stderr or "sin salida").strip()[:200]}

    streams, actual = [], {}
    for linea in p.stdout.splitlines():
        linea = linea.strip()
        if linea.startswith("metadata for"):
            if actual:
                streams.append(actual)
            actual = {}
            continue
        m = RE_MUESTRAS.match(linea)
        if m:
            actual["muestras"] = int(m.group(1))
            actual["duracion"] = m.group(2)
            continue
        if ":" not in linea:
            continue
        k, _, v = linea.partition(":")
        if k.strip() in CAMPOS:
            actual[CAMPOS[k.strip()]] = v.strip()
    if actual:
        streams.append(actual)

    return {
        "archivo": str(ruta),
        "bytes": ruta.stat().st_size,
        "formato": streams[0].get("formato") if streams else None,
        "streams": streams,
    }


def imprimir(info: dict, verboso: bool) -> None:
    if info.get("error"):
        print(f"  [ERROR] {info['archivo']}: {info['error']}")
        return
    n = len(info["streams"])
    print(f"  {info['archivo']}  —  {n} streams, {info.get('formato')}")
    if not verboso:
        nombres = [s.get("nombre", "?") for s in info["streams"]]
        # en dos columnas para que entre
        for i in range(0, len(nombres), 4):
            print("      " + "  ".join(f"{x:<22}" for x in nombres[i:i + 4]).rstrip())
        return
    for s in info["streams"]:
        print(f"      [{s.get('indice','?'):>3}] {s.get('nombre','?'):<24} "
              f"{s.get('hz','?'):>7} {s.get('canales','?')}ch  "
              f"{s.get('duracion','?')}")


def cmd_listar(args) -> int:
    vgm = hallar_vgmstream(args.vgmstream)
    info = leer_awd(vgm, Path(args.archivo))
    imprimir(info, args.verboso)
    return 1 if info.get("error") else 0


def cmd_catalogo(args) -> int:
    vgm = hallar_vgmstream(args.vgmstream)
    raiz = Path(args.raiz)
    archivos = sorted(p for p in raiz.rglob("*")
                      if p.is_file() and p.suffix.upper() == ".AWD")
    if args.filtro:
        archivos = [p for p in archivos if args.filtro.upper() in str(p).upper()]
    print(f"  {len(archivos)} archivos .AWD bajo {raiz}\n")

    catalogo, total = [], 0
    for p in archivos:
        info = leer_awd(vgm, p)
        catalogo.append(info)
        total += len(info.get("streams", []))
        imprimir(info, args.verboso)
        print()

    print(f"  TOTAL: {total} streams en {len(archivos)} archivos")
    if args.json:
        Path(args.json).write_text(
            json.dumps(catalogo, indent=1, ensure_ascii=False), encoding="utf-8")
        print(f"  escrito: {args.json}")
    return 0


def main(argv=None) -> int:
    tolerar_salida_pobre()
    p = argparse.ArgumentParser(
        description="Leer los .AWD (RenderWare Audio Wave Dictionary) del ISO",
        epilog="Necesita vgmstream-cli. Ver el encabezado del archivo.")
    p.add_argument("--vgmstream", help="ruta a vgmstream-cli.exe")
    p.add_argument("-v", "--verboso", action="store_true",
                   help="una línea por stream, con hz y duración")
    sub = p.add_subparsers(dest="cmd", required=True)

    a = sub.add_parser("listar", help="los streams de un .AWD")
    a.add_argument("archivo")
    a.set_defaults(func=cmd_listar)

    b = sub.add_parser("catalogo", help="barrer todos los .AWD de un árbol")
    b.add_argument("raiz")
    b.add_argument("--filtro", help="sólo rutas que contengan este texto")
    b.add_argument("--json", help="escribir el catálogo completo acá")
    b.set_defaults(func=cmd_catalogo)

    args = p.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    raise SystemExit(main())
