#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
pnach.py — compila las definiciones de mods (mods/*.toml) a un archivo .pnach
que PCSX2 entiende.

POR QUÉ NO ESCRIBIR EL .pnach A MANO
    Porque un .pnach es una lista plana de direcciones sin contexto. A los dos
    días no sabés qué era `patch=1,EE,0020389C,word,000001F4`. Acá cada parche
    se declara con su nota, su tipo y —si es un parche de código— su assembly
    en texto, que se ensambla en el momento. El .pnach es el resultado
    compilado, no la fuente.

FORMATO DE SALIDA (verificado contra pcsx2/Patch.cpp)
    patch=<cuando>,<cpu>,<direccion>,<tipo>,<valor>
      cuando: 0 al arrancar · 1 continuo · 2 ambos · 3 al activarlo en la GUI
      cpu   : EE | IOP
      tipo  : byte(8) short(16) word(32) double(64) extended bytes
    El archivo va en la carpeta `Cheats` que indique el .ini de PCSX2 (por
    defecto se llama `cheats`, pero en instalaciones reales puede tener otro
    nombre — este módulo lee el .ini en vez de asumirlo), con nombre
    <SERIAL>_<CRC>.pnach  (por ejemplo SLUS-21376_5C891FF1.pnach — con guión
    bajo, verificado contra el log de una PCSX2 2.6.3 real; versiones viejas
    de la documentación de la comunidad usan un punto como separador y están
    desactualizadas).

USO
    python3 pnach.py compilar                 # todos los mods habilitados
    python3 pnach.py compilar --solo vida-maxima
    python3 pnach.py compilar --instalar      # lo copia a la carpeta de PCSX2
    python3 pnach.py listar
"""

from __future__ import annotations

import argparse
import glob
import os
import platform
import shutil
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import mips  # noqa: E402

try:
    import tomllib
except ImportError:  # pragma: no cover
    tomllib = None  # type: ignore

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODS = os.path.join(RAIZ, "mods")
SALIDA = os.path.join(RAIZ, "construido")
KB = os.path.join(RAIZ, "kb")

CUANDO = {"arranque": 0, "continuo": 1, "ambos": 2, "gui": 3}
TIPOS = {
    "u8": "byte", "i8": "byte", "byte": "byte",
    "u16": "short", "i16": "short", "short": "short",
    "u32": "word", "i32": "word", "word": "word", "f32": "word",
    "u64": "double", "i64": "double", "double": "double",
    "extended": "extended", "bytes": "bytes",
}
ANCHO_HEX = {"byte": 2, "short": 4, "word": 8, "double": 16, "extended": 8}


class PnachError(RuntimeError):
    pass


def _exigir_tomllib() -> None:
    if tomllib is None:
        raise PnachError(
            "Necesito Python 3.11 o más nuevo (por el módulo tomllib).\n"
            f"Estás en {platform.python_version()}."
        )


def _ruta_ini_pcsx2() -> str | None:
    sistema = platform.system()
    candidatos = []
    if sistema == "Windows":
        candidatos.append(os.path.join(os.path.expanduser("~"), "Documents", "PCSX2", "inis", "PCSX2.ini"))
    elif sistema == "Darwin":
        candidatos.append(os.path.expanduser("~/Library/Application Support/PCSX2/inis/PCSX2.ini"))
    else:
        xdg = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
        candidatos.append(os.path.join(xdg, "PCSX2", "inis", "PCSX2.ini"))
        candidatos.append(os.path.expanduser("~/.var/app/net.pcsx2.PCSX2/config/PCSX2/inis/PCSX2.ini"))
    for c in candidatos:
        if os.path.isfile(c):
            return c
    return None


def _leer_carpeta_de_ini(
    clave: str, relativo_por_defecto: str, ruta_ini: str | None = None
) -> str | None:
    """
    Lee una ruta de la sección [Folders] del PCSX2.ini real, en vez de
    adivinar el nombre convencional. Hace falta: en instalaciones reales el
    nombre puede no ser el de fábrica (una PCSX2 2.6.3 real observada tenía
    la carpeta de cheats configurada como `cheats_ws`, no `cheats`).

    `ruta_ini` es para las pruebas: sin pasarlo, se busca el .ini real.
    """
    ruta_ini = ruta_ini if ruta_ini is not None else _ruta_ini_pcsx2()
    if not ruta_ini or not os.path.isfile(ruta_ini):
        return None
    # .../PCSX2/inis/PCSX2.ini -> .../PCSX2  (los folders son relativos a esto)
    raiz_datos = os.path.dirname(os.path.dirname(ruta_ini))

    en_seccion = False
    valor = None
    with open(ruta_ini, encoding="utf-8", errors="replace") as f:
        for linea in f:
            t = linea.strip()
            if t.startswith("[") and t.endswith("]"):
                en_seccion = (t == "[Folders]")
                continue
            if en_seccion and "=" in t:
                k, _, v = t.partition("=")
                if k.strip() == clave:
                    valor = v.strip()
                    break

    if valor is None:
        valor = relativo_por_defecto
    return valor if os.path.isabs(valor) else os.path.join(raiz_datos, valor)


def carpeta_cheats() -> str | None:
    desde_ini = _leer_carpeta_de_ini("Cheats", "cheats")
    if desde_ini:
        return desde_ini

    # No hay .ini todavía (PCSX2 nunca corrió en esta máquina): convención de
    # fábrica, sólo como último recurso.
    sistema = platform.system()
    candidatos = []
    if sistema == "Windows":
        candidatos.append(os.path.join(os.path.expanduser("~"), "Documents", "PCSX2", "cheats"))
    elif sistema == "Darwin":
        candidatos.append(os.path.expanduser("~/Library/Application Support/PCSX2/cheats"))
    else:
        xdg = os.environ.get("XDG_CONFIG_HOME", os.path.expanduser("~/.config"))
        candidatos.append(os.path.join(xdg, "PCSX2", "cheats"))
        candidatos.append(os.path.expanduser("~/.var/app/net.pcsx2.PCSX2/config/PCSX2/cheats"))
    for c in candidatos:
        if os.path.isdir(os.path.dirname(c)):
            return c
    return None


def leer_objetivo() -> dict:
    import json
    ruta = os.path.join(KB, "objetivo.json")
    with open(ruta) as f:
        obj = json.load(f)
    activa = obj.get("version_activa")
    if not activa:
        raise PnachError(
            "kb/objetivo.json no tiene `version_activa`.\n"
            "Corré `python3 herramientas/pine.py info` con el juego cargado y anotá\n"
            "ahí el serial y el CRC de TU copia. Las direcciones NO son portables\n"
            "entre versiones (NTSC-U, PAL, etc.), así que esto importa."
        )
    v = obj["versiones"][activa]
    if not v.get("crc"):
        raise PnachError(f"la versión '{activa}' no tiene CRC anotado en kb/objetivo.json")
    return {"version": activa, **v}


def resolver_valor(p: dict, direccion: int) -> tuple[str, str]:
    """Devuelve (tipo_pnach, valor_hexadecimal) para una entrada de parche."""
    if "asm" in p:
        lineas = p["asm"] if isinstance(p["asm"], list) else [p["asm"]]
        if len(lineas) != 1:
            raise PnachError(
                "un `patch=` escribe una sola palabra. Para varias instrucciones "
                "poné un [[parche]] por instrucción, con su dirección."
            )
        try:
            palabra = mips.ensamblar(lineas[0], direccion)
        except mips.MipsError as e:
            raise PnachError(f"assembly inválido en 0x{direccion:08X}: {e}") from e
        return "word", f"{palabra:08X}"

    if "valor" not in p:
        raise PnachError(f"el parche en 0x{direccion:08X} no tiene ni `valor` ni `asm`")

    tipo_decl = str(p.get("tipo", "u32")).lower()
    if tipo_decl not in TIPOS:
        raise PnachError(f"tipo desconocido: {tipo_decl}")
    tipo = TIPOS[tipo_decl]
    valor = p["valor"]

    if tipo == "bytes":
        crudo = valor.replace(" ", "").replace("_", "")
        int(crudo, 16)  # valida
        return tipo, crudo.upper()

    if tipo_decl == "f32":
        import struct as _s
        n = _s.unpack("<I", _s.pack("<f", float(valor)))[0]
    elif isinstance(valor, str):
        n = int(valor, 0)
    else:
        n = int(valor)

    ancho = ANCHO_HEX[tipo]
    if n < 0:
        n &= (1 << (ancho * 4)) - 1
    return tipo, f"{n:0{ancho}X}"


def compilar_mod(ruta: str) -> tuple[dict, list[str]]:
    _exigir_tomllib()
    with open(ruta, "rb") as f:
        mod = tomllib.load(f)  # type: ignore[union-attr]

    nombre = mod.get("nombre") or os.path.splitext(os.path.basename(ruta))[0]
    lineas = [f"[{nombre}]"]
    if mod.get("autor"):
        lineas.append(f"author={mod['autor']}")
    if mod.get("descripcion"):
        lineas.append(f"description={mod['descripcion']}")

    parches = mod.get("parche", [])
    if not parches:
        raise PnachError(f"{os.path.basename(ruta)} no declara ningún [[parche]]")

    for p in parches:
        if "direccion" not in p:
            raise PnachError(f"{os.path.basename(ruta)}: hay un [[parche]] sin `direccion`")
        d = p["direccion"] if isinstance(p["direccion"], int) else int(p["direccion"], 0)
        cuando = str(p.get("cuando", mod.get("cuando", "continuo"))).lower()
        if cuando not in CUANDO:
            raise PnachError(f"`cuando` inválido: {cuando}. Opciones: {', '.join(CUANDO)}")
        cpu = str(p.get("cpu", "EE")).upper()
        if cpu not in ("EE", "IOP"):
            raise PnachError(f"cpu inválida: {cpu}")
        tipo, hexval = resolver_valor(p, d)
        if p.get("nota"):
            lineas.append(f"// {p['nota']}")
        lineas.append(f"patch={CUANDO[cuando]},{cpu},{d:08X},{tipo},{hexval}")

    return mod, lineas


def cmd_compilar(args) -> int:
    objetivo = leer_objetivo()
    rutas = sorted(glob.glob(os.path.join(MODS, "*.toml")))
    if not rutas:
        raise PnachError(f"no hay archivos .toml en {MODS}")

    _exigir_tomllib()
    bloques, incluidos, salteados = [], [], []
    for ruta in rutas:
        base = os.path.splitext(os.path.basename(ruta))[0]
        if args.solo and base not in args.solo:
            continue
        with open(ruta, "rb") as f:
            cabecera = tomllib.load(f)  # type: ignore[union-attr]
        if not cabecera.get("habilitado", True) and not args.solo:
            salteados.append(base)
            continue
        mod, lineas = compilar_mod(ruta)
        bloques.append("\n".join(lineas))
        incluidos.append(base)

    if not bloques:
        raise PnachError("ningún mod quedó seleccionado")

    nombre_archivo = f"{objetivo['serial']}_{objetivo['crc'].upper()}.pnach"
    cabecera = [
        f"gametitle=BLACK ({objetivo['serial']}) [{objetivo['version']}]",
        "comment=Generado por black/herramientas/pnach.py — NO editar a mano.",
        "comment=La fuente son los archivos de black/mods/*.toml.",
        "",
    ]
    texto = "\n".join(cabecera) + "\n\n".join(bloques) + "\n"

    os.makedirs(SALIDA, exist_ok=True)
    destino = os.path.join(SALIDA, nombre_archivo)
    with open(destino, "w") as f:
        f.write(texto)

    print(f"{destino}")
    print(f"  mods incluidos: {', '.join(incluidos)}")
    if salteados:
        print(f"  deshabilitados: {', '.join(salteados)}")

    if args.instalar:
        carpeta = carpeta_cheats()
        if not carpeta:
            raise PnachError("no encontré la carpeta `cheats` de PCSX2; copialo a mano")
        os.makedirs(carpeta, exist_ok=True)
        shutil.copy2(destino, os.path.join(carpeta, nombre_archivo))
        print(f"  instalado en: {os.path.join(carpeta, nombre_archivo)}")
        print("\nEn PCSX2: Settings > Cheats, activá los que quieras. "
              "Si el juego ya está corriendo, recargá el estado o reiniciá.")
    else:
        print("\n(usá --instalar para copiarlo a la carpeta cheats de PCSX2)")
    return 0


def cmd_listar(args) -> int:
    _exigir_tomllib()
    rutas = sorted(glob.glob(os.path.join(MODS, "*.toml")))
    if not rutas:
        print(f"no hay mods en {MODS}")
        return 0
    for ruta in rutas:
        with open(ruta, "rb") as f:
            mod = tomllib.load(f)  # type: ignore[union-attr]
        base = os.path.splitext(os.path.basename(ruta))[0]
        marca = "on " if mod.get("habilitado", True) else "off"
        n = len(mod.get("parche", []))
        print(f"[{marca}] {base:<28} {n:>2} parche(s)  {mod.get('nombre', '')}")
    return 0


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="Compilador de mods a .pnach")
    sub = ap.add_subparsers(dest="cmd", required=True)

    p_c = sub.add_parser("compilar")
    p_c.add_argument("--solo", action="append", default=[],
                     help="nombre de mod (sin .toml); repetible")
    p_c.add_argument("--instalar", action="store_true")
    p_c.set_defaults(func=cmd_compilar)

    p_l = sub.add_parser("listar")
    p_l.set_defaults(func=cmd_listar)

    args = ap.parse_args(argv)
    try:
        return args.func(args)
    except (PnachError, FileNotFoundError) as e:
        print(f"error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
