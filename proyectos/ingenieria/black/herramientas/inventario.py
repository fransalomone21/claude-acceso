#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
inventario.py — qué instrumental hay en ESTA máquina, y qué está tirado sin usar.

POR QUÉ EXISTE
    El 2026-08-16 Fran señaló un error de proceso real: PCSX2-MCP estaba
    bajado y descomprimido en `Descargas` desde el 2026-08-15, y varias
    sesiones seguidas lo dieron por "no instalado" porque el repo decía eso.
    El repo es la memoria del PROYECTO; no es la memoria de la MÁQUINA. Un
    documento no puede saber que apareció una carpeta nueva en Descargas.

    Esto lo mira de verdad, cada vez que se corre. La regla nueva es:
    **al abrir una sesión, se corre `inventario.py` antes de decir que algo
    falta.**

QUÉ CONTESTA
    1. Qué hay instalado, con versión y ruta.
    2. Qué está BAJADO PERO SIN INCORPORAR — la categoría que se nos escapó.
    3. Qué falta del runbook de `docs/06-herramientas-externas.md`.
    4. Riesgos del entorno: carpetas del proyecto adentro de OneDrive.

CLI
    python herramientas/inventario.py
    python herramientas/inventario.py --json volcados/inventario.json
"""

from __future__ import annotations

import argparse
import glob
import importlib.util
import json
import os
import platform
import shutil
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from salida import tolerar_salida_pobre  # noqa: E402
import estado  # noqa: E402

HERR = Path.home() / "herramientas"
DESCARGAS = Path.home() / "Downloads"

# --------------------------------------------------------------------------
# El catálogo. Una fila por pieza de instrumental que al proyecto le importa.
#
#   clave     : cómo se detecta -> "pip" | "ruta" | "exe" | "winget"
#   objetivo  : el módulo / la ruta / el ejecutable / el id de winget
#   para_que  : una línea, para que el reporte se lea solo
#   doc       : dónde está documentada en el repo
# --------------------------------------------------------------------------
CATALOGO = [
    # --- el núcleo: sin esto no se trabaja ---
    ("Ghidra 12.1.2",       "ruta",   HERR / "ghidra_12.1.2_PUBLIC",
     "decompilar el ELF a C", "docs/06-herramientas-externas.md"),
    ("extensión EE Reloaded", "ruta",
     HERR / "ghidra_12.1.2_PUBLIC" / "Ghidra" / "Extensions" / "ghidra-emotionengine-reloaded",
     "el procesador r5900 y el importador de savestates", "docs/06-herramientas-externas.md"),
    ("pyghidra",            "pip",    "pyghidra",
     "manejar Ghidra desde Python, sin GUI", "herramientas/decompilar.py"),
    ("capstone",            "pip",    "capstone",
     "desensamblar FPU del R5900 (MIPS64 + skipdata)", "docs/05-iso.md"),
    ("numpy",               "pip",    "numpy",
     "el primer filtro del escaneo diferencial", "herramientas/escanear.py"),

    # --- ISO y formatos ---
    ("pycdlib",             "pip",    "pycdlib",
     "leer y reescribir el ISO — destraba el mod permanente", "docs/06-herramientas-externas.md"),
    ("ImHex",               "winget", "WerWolv.ImHex",
     "editor hex con lenguaje de patrones, para .WDD/.DB/.BKS/.SSH/.SLB", "docs/06-herramientas-externas.md"),
    ("vgmstream",           "ruta",   HERR / "vgmstream" / "vgmstream-cli.exe",
     "los .AWD de audio (RenderWare AWD header)", "herramientas/awd.py"),
    ("ffmpeg",              "exe",    "ffmpeg",
     "los 419 MB de VIDEOS/ (.M2V = MPEG-2 elemental)", "docs/06-herramientas-externas.md"),
    ("zstandard",           "pip",    "zstandard",
     "savestates comprimidos con zstd (opcional: mejor guardarlos sin comprimir)",
     "herramientas/estado.py"),
    ("kaitaistruct",        "pip",    "kaitaistruct",
     "formalizar el contenedor .BIN — sólo después de tener el patrón de ImHex",
     "docs/06-herramientas-externas.md"),

    # --- copia del ELF y proyecto analizado ---
    ("copia del ELF",       "ruta",   HERR / "SLUS_213.76",
     "el ejecutable extraído del ISO", "docs/05-iso.md"),
    ("proyecto Ghidra BLACK", "ruta",  HERR / "ghidra-proyectos2" / "BLACK",
     "9842 funciones ya analizadas con r5900", "docs/06-herramientas-externas.md"),
]

# Lo que Fran baja a mano. Si aparece acá, la sesión NO puede decir "no está".
# El patrón es un glob sobre Descargas; se reporta aunque no esté instalado.
BAJADAS_A_MANO = [
    ("PCSX2-MCP", "PCSX2-MCP*",
     "30 herramientas de depuración por MCP. Trae un pcsx2-qt.exe SIN FIRMAR "
     "que reemplaza al emulador: lo ejecuta Fran, no la sesión."),
    ("Node.js (instalador)", "node-v*.msi",
     "hace falta para mcp-pine y para el server de PCSX2-MCP."),
    ("RW Analyze", "*rwanalyze*",
     "visor/editor de RenderWare binary streams — para los .WDD."),
    ("Magic.TXD", "*[Mm]agic*TXD*",
     "editor de texture dictionaries de RenderWare, soporta PS2."),
    ("RenderWare SDK", "*rw*3*1*ps2*",
     "el SDK original de Criterion: la fuente de verdad de los formatos RW."),
]

# El proyecto NO quiere nada suyo adentro de OneDrive: sincroniza mientras el
# emulador y git escriben, y ya fue sospechoso de dos muertes de PCSX2.
#
# La carpeta de savestates NO se hardcodea: se pregunta cuál es la real con
# `estado.carpeta_savestates()` (la misma función que usan las herramientas
# que leen savestates). Antes esto miraba si existía la ruta vieja
# `~/OneDrive/Documents/PCSX2` y gritaba "ADENTRO DE ONEDRIVE" aunque PCSX2
# llevara días escribiendo en otro lado — una copia vieja que sobrevive no
# es lo mismo que "Documentos sigue redirigido hoy".
RIESGOS_ONEDRIVE_ESTATICOS = [
    ("repo claude-acceso", Path(__file__).resolve().parents[2]),
]


def _version_pip(modulo: str) -> str:
    try:
        from importlib.metadata import version
        return version(modulo)
    except Exception:
        return "?"


def _winget_instalado(id_paquete: str) -> tuple[bool, str]:
    if platform.system() != "Windows" or not shutil.which("winget"):
        return False, "winget no disponible"
    try:
        r = subprocess.run(["winget", "list", "--id", id_paquete, "-e"],
                           capture_output=True, text=True, timeout=90,
                           encoding="utf-8", errors="replace")
        salida = (r.stdout or "")
        if id_paquete.lower() in salida.lower():
            for linea in salida.splitlines():
                if id_paquete.lower() in linea.lower():
                    return True, linea.strip()
            return True, ""
        return False, ""
    except Exception as e:
        return False, f"error consultando winget: {e}"


def revisar_catalogo() -> list[dict]:
    filas = []
    for nombre, clase, objetivo, para_que, doc in CATALOGO:
        hay, detalle = False, ""
        if clase == "pip":
            hay = importlib.util.find_spec(str(objetivo)) is not None
            detalle = _version_pip(str(objetivo)) if hay else "pip install " + str(objetivo)
        elif clase == "ruta":
            p = Path(objetivo)
            hay = p.exists()
            detalle = str(p)
        elif clase == "exe":
            ruta = shutil.which(str(objetivo))
            hay = ruta is not None
            detalle = ruta or f"no está en PATH: {objetivo}"
        elif clase == "winget":
            hay, detalle = _winget_instalado(str(objetivo))
            if not hay and not detalle:
                detalle = f"winget install --id {objetivo}"
        filas.append({"nombre": nombre, "tipo": clase, "hay": hay,
                      "detalle": detalle, "para_que": para_que, "doc": doc})
    return filas


def revisar_descargas() -> list[dict]:
    """
    Lo que Fran bajó a mano. Esta es la sección que existe por el error del
    2026-08-16: el repo decía "no instalado" y el archivo estaba hace un día.
    """
    filas = []
    for nombre, patron, nota in BAJADAS_A_MANO:
        encontrados = sorted(glob.glob(str(DESCARGAS / patron)))
        filas.append({"nombre": nombre, "patron": patron, "nota": nota,
                      "rutas": encontrados, "hay": bool(encontrados)})
    return filas


def revisar_onedrive() -> list[dict]:
    filas = []

    savestates = estado.carpeta_savestates()
    if savestates:
        p = Path(savestates)
        filas.append({"nombre": "carpeta de savestates (en uso hoy)", "ruta": str(p),
                      "existe": True, "en_onedrive": "onedrive" in str(p).lower()})
    else:
        filas.append({"nombre": "carpeta de savestates (en uso hoy)",
                      "ruta": "ninguna candidata existe todavía",
                      "existe": False, "en_onedrive": False})

    for nombre, p in RIESGOS_ONEDRIVE_ESTATICOS:
        filas.append({"nombre": nombre, "ruta": str(p),
                      "existe": p.exists(), "en_onedrive": "onedrive" in str(p).lower()})
    return filas


def _marca(hay: bool) -> str:
    return "[ OK ]" if hay else "[FALTA]"


def main(argv=None) -> int:
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(
        description="Qué instrumental hay en esta máquina, y qué está sin usar",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="Correlo al ABRIR la sesión, antes de decir que algo falta.")
    ap.add_argument("--json", help="además, escribir el inventario a un archivo")
    args = ap.parse_args(argv)

    catalogo = revisar_catalogo()
    descargas = revisar_descargas()
    onedrive = revisar_onedrive()

    print("=" * 74)
    print("  INSTRUMENTAL DEL PROYECTO")
    print("=" * 74)
    for f in catalogo:
        print(f"  {_marca(f['hay'])} {f['nombre']:<24} {f['detalle']}")
        if not f["hay"]:
            print(f"           para qué: {f['para_que']}")
            print(f"           doc     : {f['doc']}")

    faltan = [f for f in catalogo if not f["hay"]]

    print()
    print("=" * 74)
    print("  BAJADO A MANO — mirar ANTES de decir 'no está instalado'")
    print("=" * 74)
    sin_incorporar = []
    for f in descargas:
        if f["hay"]:
            sin_incorporar.append(f)
            print(f"  [BAJADO] {f['nombre']}")
            for r in f["rutas"]:
                print(f"           {r}")
            print(f"           {f['nota']}")
        else:
            print(f"  [ no  ] {f['nombre']:<24} (patrón {f['patron']})")

    print()
    print("=" * 74)
    print("  ONEDRIVE — el proyecto no quiere nada suyo adentro")
    print("=" * 74)
    en_riesgo = [f for f in onedrive if f["existe"] and f["en_onedrive"]]
    for f in onedrive:
        if not f["existe"]:
            estado = "no existe"
        elif f["en_onedrive"]:
            estado = "ADENTRO DE ONEDRIVE -> sacarlo"
        else:
            estado = "fuera de OneDrive, bien"
        print(f"  {f['nombre']:<24} {estado}")
        print(f"           {f['ruta']}")

    print()
    print("-" * 74)
    print(f"  instrumental: {len(catalogo) - len(faltan)}/{len(catalogo)} presente"
          f"   |   bajado sin incorporar: {len(sin_incorporar)}"
          f"   |   en OneDrive: {len(en_riesgo)}")
    print("-" * 74)

    if args.json:
        Path(args.json).parent.mkdir(parents=True, exist_ok=True)
        Path(args.json).write_text(json.dumps(
            {"catalogo": catalogo, "descargas": descargas, "onedrive": onedrive},
            indent=1, ensure_ascii=False), encoding="utf-8")
        print(f"  escrito: {args.json}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
