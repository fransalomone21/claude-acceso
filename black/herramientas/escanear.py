#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
escanear.py — escáner diferencial de memoria del EE. El reemplazo scriptable
de Cheat Engine, pensado para que cada búsqueda quede registrada y sea
reproducible desde cualquiera de las dos máquinas.

IDEA
    Una "sesión de escaneo" es una carpeta bajo volcados/. Vas aplicando
    filtros sucesivos y el conjunto de candidatos se achica. Cada paso queda
    anotado en sesion.json: qué filtro, cuándo, cuántos quedaron. Eso es el
    registro de laboratorio; sin eso, en dos días no te acordás de nada.

DE DÓNDE SALEN LAS FOTOS DE MEMORIA
    - savestate (por defecto): 32 MB completos y consistentes, de un saque.
    - PINE en vivo: sólo cuando ya quedan pocos candidatos. Es instantáneo y
      no te obliga a guardar estado.
    El cambio de una fuente a otra es automático según cuántos candidatos haya.

FLUJO TÍPICO (buscar la vida del jugador)
    # 1. con la vida llena, foto inicial
    python3 escanear.py nuevo vida --tipo u32
    # 2. te pegan un tiro, y filtrás por "bajó"
    python3 escanear.py filtrar vida bajo
    # 3. te curás
    python3 escanear.py filtrar vida subio
    # 4. repetí hasta que queden unos pocos
    python3 escanear.py listar vida
    # 5. probá: escribile un valor y mirá la barra en pantalla
    python3 escanear.py poner vida --indice 0 --valor 500

FILTROS
    =N  !=N  <N  >N       comparación contra un valor concreto
    bajo  subio  igual  cambio      contra la lectura anterior
    bajo=N  subio=N       cambió exactamente N
    entre=A:B             valor en el rango [A, B]
"""

from __future__ import annotations

import argparse
import json
import os
import re
import struct
import sys
import time
from datetime import datetime, timezone

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import estado as mod_estado  # noqa: E402

try:
    import numpy as np
except ImportError:  # pragma: no cover
    np = None  # type: ignore

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VOLCADOS = os.path.join(RAIZ, "volcados")

# Para los "próximo paso: corré..." que se imprimen en runtime. "python3" está
# bien en la documentación (Linux/Mac), pero un mensaje que el propio script
# imprime tiene que decir el comando que YA está corriendo, sea cual sea: en
# Windows suele ser "python" a secas, y "python3" ahí no existe.
PY = os.path.basename(sys.executable)
if PY.lower().endswith(".exe"):
    PY = PY[:-4]

# Región útil de la RAM del EE. Abajo de 0x100000 vive el kernel, no el juego.
INICIO_DEF = 0x0010_0000
FIN_DEF = 0x0200_0000

# Por encima de esto seguimos usando savestates; por debajo, PINE en vivo.
UMBRAL_VIVO = 60_000

TIPOS = {
    "u8": ("<u1", 1, False), "u16": ("<u2", 2, False),
    "u32": ("<u4", 4, False), "u64": ("<u8", 8, False),
    "i8": ("<i1", 1, True), "i16": ("<i2", 2, True),
    "i32": ("<i4", 4, True), "i64": ("<i8", 8, True),
    "f32": ("<f4", 4, True),
}


class EscaneoError(RuntimeError):
    pass


def _ahora() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def _exigir_numpy(para: str) -> None:
    if np is None:
        raise EscaneoError(
            f"{para} necesita numpy sobre los 32 MB completos.\n"
            "Instalalo con:  pip install numpy\n"
            "(Sin numpy sólo funcionan los filtros de valor exacto, que igual "
            "alcanzan para la mayoría de las búsquedas.)"
        )


# --- persistencia de la sesión ----------------------------------------------
class Sesion:
    def __init__(self, nombre: str):
        self.nombre = nombre
        self.dir = os.path.join(VOLCADOS, f"escaneo-{nombre}")
        self.ruta_meta = os.path.join(self.dir, "sesion.json")
        self.ruta_cand = os.path.join(self.dir, "candidatos.bin")
        self.ruta_vals = os.path.join(self.dir, "valores.bin")
        self.ruta_snap = os.path.join(self.dir, "anterior.ee.bin")
        self.meta: dict = {}

    # -- ciclo de vida --------------------------------------------------------
    def crear(self, tipo: str, inicio: int, fin: int, paso: int | None) -> None:
        if tipo not in TIPOS:
            raise EscaneoError(f"tipo desconocido: {tipo}. Opciones: {', '.join(TIPOS)}")
        os.makedirs(self.dir, exist_ok=True)
        _, ancho, _ = TIPOS[tipo]
        self.meta = {
            "nombre": self.nombre,
            "tipo": tipo,
            "inicio": inicio,
            "fin": fin,
            "paso": paso if paso else ancho,
            "creada": _ahora(),
            "pasos": [],
            "n_candidatos": None,  # None = todavía no se filtró nada
        }
        self.guardar_meta()

    def cargar(self) -> None:
        if not os.path.exists(self.ruta_meta):
            raise EscaneoError(
                f"No existe la sesión '{self.nombre}'. Creala con:\n"
                f"  {PY} escanear.py nuevo {self.nombre} --tipo u32"
            )
        with open(self.ruta_meta) as f:
            self.meta = json.load(f)

    def guardar_meta(self) -> None:
        with open(self.ruta_meta, "w") as f:
            json.dump(self.meta, f, indent=2, ensure_ascii=False)
            f.write("\n")

    # -- accesores ------------------------------------------------------------
    @property
    def dtype(self) -> str:
        return TIPOS[self.meta["tipo"]][0]

    @property
    def ancho(self) -> int:
        return TIPOS[self.meta["tipo"]][1]

    def candidatos(self):
        if self.meta["n_candidatos"] is None:
            return None
        _exigir_numpy("Leer el conjunto de candidatos")
        return np.fromfile(self.ruta_cand, dtype="<u4")

    def valores(self):
        _exigir_numpy("Leer los valores guardados")
        return np.fromfile(self.ruta_vals, dtype=self.dtype)

    def guardar_candidatos(self, offsets, valores) -> None:
        offsets.astype("<u4").tofile(self.ruta_cand)
        valores.astype(self.dtype).tofile(self.ruta_vals)
        self.meta["n_candidatos"] = int(offsets.size)

    # -- variantes sin numpy, para que la herramienta sirva igual sin instalar nada --
    def candidatos_py(self) -> list[int] | None:
        if self.meta["n_candidatos"] is None:
            return None
        with open(self.ruta_cand, "rb") as f:
            crudo = f.read()
        return [struct.unpack_from("<I", crudo, i)[0] for i in range(0, len(crudo), 4)]

    def valores_py(self) -> list:
        fmt = {"u8": "<B", "i8": "<b", "u16": "<H", "i16": "<h", "u32": "<I",
               "i32": "<i", "u64": "<Q", "i64": "<q", "f32": "<f"}[self.meta["tipo"]]
        with open(self.ruta_vals, "rb") as f:
            crudo = f.read()
        a = self.ancho
        return [struct.unpack_from(fmt, crudo, i)[0] for i in range(0, len(crudo), a)]

    def guardar_candidatos_py(self, offsets: list[int], valores: list) -> None:
        fmt = {"u8": "<B", "i8": "<b", "u16": "<H", "i16": "<h", "u32": "<I",
               "i32": "<i", "u64": "<Q", "i64": "<q", "f32": "<f"}[self.meta["tipo"]]
        with open(self.ruta_cand, "wb") as f:
            f.write(b"".join(struct.pack("<I", o) for o in offsets))
        with open(self.ruta_vals, "wb") as f:
            f.write(b"".join(struct.pack(fmt, v) for v in valores))
        self.meta["n_candidatos"] = len(offsets)

    def anotar_paso(self, filtro: str, fuente: str, n: int) -> None:
        self.meta["pasos"].append(
            {"cuando": _ahora(), "filtro": filtro, "fuente": fuente, "quedaron": n}
        )
        self.guardar_meta()


# --- obtención de fotos de memoria -------------------------------------------
def foto_savestate(ruta_p2s: str | None, pedir: bool, espera: float):
    """
    Devuelve (32 MB de RAM del EE, descripción, ruta absoluta, mtime).

    La ruta y el mtime son la "huella" de la foto: sirven para detectar que
    dos pasos de una sesión salieron del MISMO archivo, que es un error
    silencioso muy fácil de cometer (comparar una foto contra sí misma
    siempre da cero candidatos, sin ningún síntoma de que algo anduvo mal).
    """
    if pedir:
        from pine import Pine, PineError  # import perezoso: sólo si hace falta
        try:
            antes = None
            carpeta = mod_estado.carpeta_savestates()
            if carpeta:
                try:
                    antes = os.path.getmtime(mod_estado.ultimo_savestate(carpeta))
                except mod_estado.EstadoError:
                    antes = None
            with Pine() as p:
                p.guardar_estado(0)
            # PCSX2 guarda de forma asíncrona: esperamos a que aparezca el archivo.
            limite = time.time() + espera
            while time.time() < limite:
                time.sleep(0.15)
                try:
                    cand = mod_estado.ultimo_savestate(carpeta)
                except mod_estado.EstadoError:
                    continue
                if antes is None or os.path.getmtime(cand) > antes:
                    time.sleep(0.25)  # que termine de escribir
                    ruta_p2s = cand
                    break
            else:
                raise EscaneoError(
                    "Pedí el savestate pero no apareció ningún archivo nuevo. "
                    "Guardalo a mano con F1 y volvé a correr el comando."
                )
        except PineError as e:
            raise EscaneoError(
                f"No pude pedirle el savestate a PCSX2 ({e}).\n"
                "Guardalo a mano con F1 y repetí el comando sin --pedir."
            ) from e

    ruta = ruta_p2s or mod_estado.ultimo_savestate()
    return (mod_estado.leer_ee(ruta), f"savestate:{os.path.basename(ruta)}",
            os.path.abspath(ruta), os.path.getmtime(ruta))


def _huella(ruta: str, mtime: float) -> dict:
    return {"ruta": ruta, "mtime": mtime}


def _exigir_foto_nueva(s: "Sesion", filtro: dict, ruta: str, mtime: float) -> None:
    """
    Un filtro relativo (bajo/subio/igual/cambio) compara la foto de ahora
    contra la del paso anterior. Si las dos salieron del mismo archivo, la
    comparación no significa nada: `bajo` da cero candidatos, `igual` da
    todos, y en ninguno de los dos casos hay un síntoma de que el problema
    fue el procedimiento y no los datos. Mejor frenar y decirlo.

    Los filtros de valor exacto (=N) sí pueden reusar la misma foto: ahí no
    se compara contra nada anterior, se busca dentro de esa misma foto.
    """
    if filtro["clase"] != "relativo":
        return
    previa = s.meta.get("ultima_fuente")
    if not previa:
        return
    if previa.get("ruta") == ruta and previa.get("mtime") == mtime:
        raise EscaneoError(
            f"Esta foto es EL MISMO savestate que el paso anterior "
            f"({os.path.basename(ruta)}).\n"
            f"Un filtro '{filtro['op']}' compara contra la lectura anterior, así que "
            "comparar una foto contra sí misma no puede dar nada útil.\n\n"
            "Lo que falta es un savestate NUEVO, tomado DESPUÉS de que el valor "
            "cambiara en el juego:\n"
            f"  1. En el juego, hacé que cambie (que te peguen, disparar, curarte).\n"
            f"  2. {PY} escanear.py filtrar {s.nombre} {filtro['op']}\n"
            "     (por defecto pide el savestate solo por PINE; si PCSX2 no está "
            "conectado, guardalo a mano con F1 primero)"
        )


def foto_vivo(offsets, tipo: str) -> tuple[object, str]:
    """Lee los candidatos directo de PCSX2 por PINE. Sólo para conjuntos chicos."""
    from pine import Pine
    dtype, ancho, _ = TIPOS[tipo]
    with Pine() as p:
        crudos = p.leer_muchas([int(o) for o in offsets], ancho=ancho)
    _exigir_numpy("Leer valores en vivo")
    buf = b"".join(int(v).to_bytes(ancho, "little") for v in crudos)
    return np.frombuffer(buf, dtype=dtype).copy(), "pine"


# --- filtros ------------------------------------------------------------------
RE_FILTRO = re.compile(
    r"^(?:(?P<cmp>==?|!=|<=|>=|<|>)\s*(?P<val>-?[\w.]+)"
    r"|(?P<rel>bajo|subio|igual|cambio)(?:\s*=\s*(?P<delta>-?[\w.]+))?"
    r"|entre\s*=\s*(?P<a>-?[\w.]+)\s*:\s*(?P<b>-?[\w.]+))$",
    re.IGNORECASE,
)


def _num(texto: str, tipo: str):
    if tipo == "f32":
        return float(texto)
    return int(texto, 0)


def parsear_filtro(texto: str, tipo: str) -> dict:
    m = RE_FILTRO.match(texto.strip())
    if not m:
        raise EscaneoError(
            f"No entiendo el filtro '{texto}'.\n"
            "Válidos: =N  !=N  <N  >N  bajo  subio  igual  cambio  "
            "bajo=N  subio=N  entre=A:B"
        )
    g = m.groupdict()
    if g["cmp"]:
        op = "==" if g["cmp"] == "=" else g["cmp"]
        return {"clase": "valor", "op": op, "val": _num(g["val"], tipo)}
    if g["rel"]:
        return {
            "clase": "relativo",
            "op": g["rel"].lower(),
            "delta": _num(g["delta"], tipo) if g["delta"] else None,
        }
    return {"clase": "rango", "a": _num(g["a"], tipo), "b": _num(g["b"], tipo)}


def aplicar_filtro(filtro: dict, actuales, anteriores):
    """Devuelve una máscara booleana de numpy."""
    if filtro["clase"] == "valor":
        v = filtro["val"]
        return {
            "==": lambda: actuales == v,
            "!=": lambda: actuales != v,
            "<": lambda: actuales < v,
            ">": lambda: actuales > v,
            "<=": lambda: actuales <= v,
            ">=": lambda: actuales >= v,
        }[filtro["op"]]()

    if filtro["clase"] == "rango":
        return (actuales >= filtro["a"]) & (actuales <= filtro["b"])

    if anteriores is None:
        raise EscaneoError(
            f"El filtro '{filtro['op']}' compara contra la lectura anterior, "
            "pero esta sesión todavía no tiene una. Empezá con un filtro de "
            "valor exacto (=N) o hacé dos pasadas."
        )

    # Comparación en enteros con signo amplio, para que no dé la vuelta el unsigned.
    if filtro["op"] in ("bajo", "subio") or filtro["delta"] is not None:
        a = actuales.astype("f8") if actuales.dtype.kind == "f" else actuales.astype("i8")
        b = anteriores.astype("f8") if anteriores.dtype.kind == "f" else anteriores.astype("i8")
        d = filtro["delta"]
        if filtro["op"] == "bajo":
            return (b - a == d) if d is not None else (a < b)
        if filtro["op"] == "subio":
            return (a - b == d) if d is not None else (a > b)

    if filtro["op"] == "igual":
        return actuales == anteriores
    if filtro["op"] == "cambio":
        return actuales != anteriores
    raise EscaneoError(f"filtro relativo desconocido: {filtro['op']}")


# --- búsqueda de valor exacto sin numpy --------------------------------------
def buscar_exacto_bytes(ram: bytes, valor: int, tipo: str,
                        inicio: int, fin: int, paso: int) -> list[int]:
    """Primera pasada por valor exacto sin numpy: usa bytes.find, que es C puro."""
    _, ancho, con_signo = TIPOS[tipo]
    if tipo == "f32":
        aguja = struct.pack("<f", float(valor))
    else:
        aguja = int(valor).to_bytes(ancho, "little", signed=con_signo and valor < 0)
    salida: list[int] = []
    pos = ram.find(aguja, inicio, fin)
    while pos != -1:
        if pos % paso == 0:
            salida.append(pos)
        pos = ram.find(aguja, pos + 1, fin)
    return salida


# --- comandos -----------------------------------------------------------------
def cmd_nuevo(args) -> int:
    s = Sesion(args.nombre)
    s.crear(args.tipo, args.inicio, args.fin, args.paso)
    ram, fuente, ruta, mtime = foto_savestate(args.desde, args.pedir, args.espera)
    with open(s.ruta_snap, "wb") as f:
        f.write(ram)
    s.meta["origen_inicial"] = fuente
    s.meta["ultima_fuente"] = _huella(ruta, mtime)
    s.guardar_meta()
    total = (args.fin - args.inicio) // s.meta["paso"]
    print(f"sesión '{args.nombre}' creada  [{args.tipo}]")
    print(f"  foto inicial: {fuente}")
    print(f"  región 0x{args.inicio:08X}-0x{args.fin:08X}, paso {s.meta['paso']}")
    print(f"  ~{total:,} posiciones en juego")
    print(f"\nAhora hacé que el valor cambie en el juego y filtrá:")
    print(f"  {PY} escanear.py filtrar {args.nombre} bajo")
    return 0


def _filtrar_sin_numpy(s: "Sesion", filtro: dict, args) -> int:
    """
    Camino sin numpy. Cubre todo lo que compara contra un valor concreto
    (=N, !=N, <N, >N, entre=A:B) y, una vez que hay candidatos, también los
    filtros relativos. Lo único que queda fuera es un filtro relativo sobre
    los 32 MB enteros: son 8 millones de comparaciones y ahí numpy no se
    reemplaza con un bucle de Python.
    """
    tipo = s.meta["tipo"]
    fmt = {"u8": "<B", "i8": "<b", "u16": "<H", "i16": "<h", "u32": "<I",
           "i32": "<i", "u64": "<Q", "i64": "<q", "f32": "<f"}[tipo]
    cands = s.candidatos_py()
    ram, fuente, ruta, mtime = foto_savestate(args.desde, args.pedir, args.espera)
    _exigir_foto_nueva(s, filtro, ruta, mtime)

    if filtro["clase"] == "relativo":
        if cands is None:
            raise EscaneoError(
                f"El filtro '{filtro['op']}' sobre toda la RAM necesita numpy "
                "(son ~8 millones de posiciones).\n"
                "  pip install numpy\n"
                "Alternativa sin instalar nada: arrancá con un valor exacto, "
                "por ejemplo `=100` si sabés cuánta vida tenés en pantalla."
            )
        previos = s.valores_py()
        actuales = [struct.unpack_from(fmt, ram, o)[0] for o in cands]
        d = filtro["delta"]
        pred = {
            "bajo": (lambda a, b: b - a == d) if d is not None else (lambda a, b: a < b),
            "subio": (lambda a, b: a - b == d) if d is not None else (lambda a, b: a > b),
            "igual": lambda a, b: a == b,
            "cambio": lambda a, b: a != b,
        }[filtro["op"]]
        pares = [(o, a) for o, a, b in zip(cands, actuales, previos) if pred(a, b)]

    elif cands is None:
        if filtro["clase"] != "valor" or filtro["op"] != "==":
            raise EscaneoError(
                "Sobre toda la RAM, sin numpy, la primera pasada tiene que ser por "
                "valor exacto (=N). Para el resto: pip install numpy"
            )
        # bytes.find es C puro: barre los 32 MB en un parpadeo.
        offs = buscar_exacto_bytes(
            ram, filtro["val"], tipo, s.meta["inicio"], s.meta["fin"], s.meta["paso"]
        )
        pares = [(o, struct.unpack_from(fmt, ram, o)[0]) for o in offs]

    else:
        if filtro["clase"] == "rango":
            def pred1(v):
                return filtro["a"] <= v <= filtro["b"]
        else:
            v = filtro["val"]
            pred1 = {
                "==": lambda x: x == v, "!=": lambda x: x != v,
                "<": lambda x: x < v, ">": lambda x: x > v,
                "<=": lambda x: x <= v, ">=": lambda x: x >= v,
            }[filtro["op"]]
        pares = []
        for o in cands:
            val = struct.unpack_from(fmt, ram, o)[0]
            if pred1(val):
                pares.append((o, val))

    s.guardar_candidatos_py([o for o, _ in pares], [v for _, v in pares])
    s.meta["ultima_fuente"] = _huella(ruta, mtime)
    s.anotar_paso(args.filtro, fuente, len(pares))
    print(f"quedaron {len(pares):,} candidatos   (fuente: {fuente})")
    if pares and len(pares) <= 20:
        for i, (o, v) in enumerate(pares):
            print(f"  [{i:>3}] 0x{o:08X}  = {v}")
    elif pares:
        print(f"  {PY} escanear.py listar {s.nombre}")
    return 0


def cmd_filtrar(args) -> int:
    s = Sesion(args.nombre)
    s.cargar()
    tipo = s.meta["tipo"]
    filtro = parsear_filtro(args.filtro, tipo)

    if np is None:
        return _filtrar_sin_numpy(s, filtro, args)

    cands = s.candidatos()
    # Si pediste un savestate concreto, respetamos eso y no vamos a PINE.
    usar_vivo = (
        cands is not None
        and cands.size <= UMBRAL_VIVO
        and not args.forzar_savestate
        and not args.desde
    )

    huella_nueva = None
    if usar_vivo:
        # PINE lee el estado de AHORA: nunca puede ser una foto repetida.
        actuales, fuente = foto_vivo(cands, tipo)
        anteriores = s.valores()
        offsets = cands
    else:
        ram, fuente, ruta, mtime = foto_savestate(args.desde, args.pedir, args.espera)
        _exigir_foto_nueva(s, filtro, ruta, mtime)
        huella_nueva = _huella(ruta, mtime)
        arr = np.frombuffer(ram, dtype=s.dtype)
        if cands is None:
            paso_elem = s.meta["paso"] // s.ancho or 1
            i0 = s.meta["inicio"] // s.ancho
            i1 = s.meta["fin"] // s.ancho
            idx = np.arange(i0, i1, paso_elem, dtype="<u4")
            offsets = (idx * s.ancho).astype("<u4")
            actuales = arr[idx]
            anteriores = None
            if filtro["clase"] == "relativo" and os.path.exists(s.ruta_snap):
                previo = np.fromfile(s.ruta_snap, dtype=s.dtype)
                anteriores = previo[idx]
        else:
            idx = (cands // s.ancho).astype("i8")
            offsets = cands
            actuales = arr[idx]
            anteriores = s.valores()
        with open(s.ruta_snap, "wb") as f:
            f.write(ram)

    mascara = aplicar_filtro(filtro, actuales, anteriores)
    offsets = offsets[mascara]
    actuales = actuales[mascara]
    s.guardar_candidatos(offsets, actuales)
    if huella_nueva:
        s.meta["ultima_fuente"] = huella_nueva
    s.anotar_paso(args.filtro, fuente, int(offsets.size))

    # Una vez que el conjunto es chico, el snapshot de 32 MB ya no sirve.
    if offsets.size <= UMBRAL_VIVO and os.path.exists(s.ruta_snap):
        os.remove(s.ruta_snap)

    print(f"quedaron {offsets.size:,} candidatos   (fuente: {fuente})")
    if offsets.size and offsets.size <= 20:
        _mostrar(offsets, actuales, tipo, 20)
    elif offsets.size:
        print(f"  {PY} escanear.py listar {args.nombre}")
    return 0


def _mostrar(offsets, valores, tipo: str, n: int) -> None:
    for i in range(min(n, len(offsets))):
        o = int(offsets[i])
        v = valores[i]
        extra = f"  0x{int(v):X}" if tipo != "f32" else ""
        print(f"  [{i:>3}] 0x{o:08X}  = {v}{extra}")


def cmd_listar(args) -> int:
    s = Sesion(args.nombre)
    s.cargar()
    print(f"sesión '{args.nombre}' [{s.meta['tipo']}]"
          f" — región 0x{s.meta['inicio']:08X}..0x{s.meta['fin']:08X}")
    for p in s.meta["pasos"]:
        print(f"  · {p['filtro']:<12} -> {p['quedaron']:>10,}   ({p['fuente']})")
    if s.meta["n_candidatos"] is None:
        print("\ntodavía no se aplicó ningún filtro")
        return 0
    offsets, valores = s.candidatos_py(), s.valores_py()
    print(f"\n{len(offsets):,} candidatos\n")
    _mostrar(offsets, valores, s.meta["tipo"], args.n)
    return 0


def cmd_vivo(args) -> int:
    """Relee los candidatos por PINE sin filtrar. Para ver cuál se mueve."""
    from pine import Pine
    s = Sesion(args.nombre)
    s.cargar()
    offsets = s.candidatos_py()
    if offsets is None or len(offsets) > UMBRAL_VIVO:
        raise EscaneoError("hay demasiados candidatos para leer en vivo; filtrá más")
    tipo = s.meta["tipo"]
    _, ancho, _ = TIPOS[tipo]
    with Pine() as p:
        if tipo == "f32":
            valores = [p.leer_f32(o) for o in offsets]
        else:
            valores = p.leer_muchas(offsets, ancho=ancho, con_signo=tipo[0] == "i")
    _mostrar(offsets, valores, tipo, args.n)
    return 0


def cmd_poner(args) -> int:
    """Escribe un valor en un candidato. La prueba definitiva: mirá la pantalla."""
    from pine import Pine
    s = Sesion(args.nombre)
    s.cargar()
    offsets = s.candidatos_py()
    if offsets is None:
        raise EscaneoError("la sesión no tiene candidatos todavía")
    tipo = s.meta["tipo"]
    _, ancho, _ = TIPOS[tipo]
    objetivos = (
        [int(offsets[args.indice])] if args.indice is not None
        else [int(o) for o in offsets]
    )
    if len(objetivos) > 100 and args.indice is None:
        raise EscaneoError(
            f"son {len(objetivos)} direcciones; escribirlas todas puede colgar el juego. "
            "Filtrá más, o usá --indice para una sola."
        )
    with Pine() as p:
        for d in objetivos:
            if tipo == "f32":
                p.escribir_f32(d, float(args.valor))
            else:
                p.escribir(d, int(args.valor, 0), ancho)
    print(f"escribí {args.valor} en {len(objetivos)} dirección(es)")
    return 0


def _entero(t: str) -> int:
    return int(t, 0)


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description="Escáner diferencial de memoria del EE")
    sub = ap.add_subparsers(dest="cmd", required=True)

    def comunes(p):
        p.add_argument("--desde", help="archivo .p2s concreto (si se pasa, no se pide nada por PINE)")
        # Pedir el savestate es el comportamiento correcto por defecto: cada paso
        # de un escaneo necesita una foto NUEVA. Dejarlo opt-in hacía muy fácil
        # comparar sin querer una foto contra sí misma.
        p.add_argument("--pedir", action="store_true",
                       help="(ya es el default) pedirle el savestate a PCSX2 por PINE")
        p.add_argument("--no-pedir", action="store_true",
                       help="no pedir nada: usar el savestate más reciente que haya en disco")
        p.add_argument("--espera", type=float, default=8.0,
                       help="segundos a esperar el savestate pedido")

    p_n = sub.add_parser("nuevo", help="crea una sesión y toma la foto inicial")
    p_n.add_argument("nombre")
    p_n.add_argument("--tipo", default="u32", choices=list(TIPOS))
    p_n.add_argument("--inicio", type=_entero, default=INICIO_DEF)
    p_n.add_argument("--fin", type=_entero, default=FIN_DEF)
    p_n.add_argument("--paso", type=_entero, default=None)
    comunes(p_n)
    p_n.set_defaults(func=cmd_nuevo)

    p_f = sub.add_parser("filtrar", help="aplica un filtro y achica el conjunto")
    p_f.add_argument("nombre")
    p_f.add_argument("filtro")
    p_f.add_argument("--forzar-savestate", action="store_true")
    comunes(p_f)
    p_f.set_defaults(func=cmd_filtrar)

    p_l = sub.add_parser("listar", help="muestra el estado de la sesión")
    p_l.add_argument("nombre")
    p_l.add_argument("-n", type=int, default=40)
    p_l.set_defaults(func=cmd_listar)

    p_v = sub.add_parser("vivo", help="relee los candidatos por PINE")
    p_v.add_argument("nombre")
    p_v.add_argument("-n", type=int, default=40)
    p_v.set_defaults(func=cmd_vivo)

    p_p = sub.add_parser("poner", help="escribe un valor en los candidatos")
    p_p.add_argument("nombre")
    p_p.add_argument("--valor", required=True)
    p_p.add_argument("--indice", type=int, default=None)
    p_p.set_defaults(func=cmd_poner)

    args = ap.parse_args(argv)

    # Un solo lugar donde se decide si se pide savestate, para que todos los
    # comandos se comporten igual: se pide siempre, salvo que hayas apuntado a
    # un archivo concreto o lo hayas desactivado a mano.
    if hasattr(args, "pedir"):
        args.pedir = not args.no_pedir and not args.desde

    try:
        return args.func(args)
    except (EscaneoError, mod_estado.EstadoError) as e:
        print(f"error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
