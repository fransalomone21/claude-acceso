#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""divergencias.py -- el verificador de cero divergencias (T20, 2026-10-12).

Requisitos: L2-DIV-01..05 de proyectos/ingenieria/arquitectura-se/docs/10-requisitos.md (padres L1-06 y L0-05; la
ley de Fran N-06: ningun dato en dos lugares que puedan contradecirse). Diseno: docs/t20-cero-divergencias.md §2 y §4
del mismo proyecto. Saboteador: probar-divergencias.py.

Cada Dato_Vigente tiene UN dueno (archivo + extractor) y sus copias declaradas en .claude/datos.json:
  vista    el valor extraido de la copia tiene que ser igual al del dueno           -> si no, ROJO (L2-DIV-01)
  puntero  la copia nombra al dueno y NO contiene la forma del valor, salvo en un
           bloque fechado (una medicion es historia, no diverge)                   -> si la tiene, ROJO (L2-DIV-02)
Falla CERRADO: registro ausente, que no parsea o vacio; dato sin dueno o con dos; archivo del dueno o de una copia
que no existe; puntero que ya no nombra al dueno; extractor que no encuentra nada -> ROJO (L2-DIV-03, L2-DIV-05).
Las copias NO declaradas no se pueden enumerar: se buscan por la forma del valor en el ambito del dato, fuera de los
bloques fechados, y se listan como [aviso] sin cambiar el codigo de salida (L2-DIV-04: heuristica, informa).

Fechado, medible: el markdown va en parrafos envueltos, asi que la fecha va en la PRIMERA linea del bloque (lineas
seguidas sin renglon vacio). Un bloque es fechado si esa linea, o la linea misma, lleva una fecha (2026-10-12, 12/10)
o una sesion o commit entre comillas invertidas. Un archivo con fecha en el nombre es fechado entero.

Uso:
  python divergencias.py                              el registro real (.claude/datos.json) sobre este arbol
  python divergencias.py --raiz R --registro F        otro arbol (lo usa el saboteador)
Sale 0 verde, 1 rojo, 2 revento. El ROJO es una linea [FAIL] (la que chequeo-completo copia al tablero) con el
dato, el dueno y la copia. Sin acentos en lo que escribe el script: la consola de Windows la lee como cp1252.
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import re
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
# Una fecha (2026-10-12, 12/10) o una sesion o commit: 7-8 hexadecimales con al menos un digito y una letra (asi no
# cuentan palabras como 'decade' ni numeros como 20261012).
FECHA = re.compile(r"\b20\d\d-\d\d-\d\d\b|\b(?:0?[1-9]|[12]\d|3[01])/(?:0?[1-9]|1[0-2])\b"
                   r"|\b(?=[0-9a-f]*\d)(?=[0-9a-f]*[a-f])[0-9a-f]{7,8}\b")
FECHA_NOMBRE = re.compile(r"20\d\d-\d\d-\d\d")
TITULO = re.compile(r"^(#{1,6})\s")
CLASES = ("vista", "puntero")


def lineas_vigentes(texto: str):
    """(numero, linea) de las lineas que NO son medicion fechada: ni ellas, ni la primera linea de su bloque, ni el
    titulo de su seccion llevan fecha o sesion."""
    inicio, fechado, nivel_fechado = True, False, 0
    for n, linea in enumerate(texto.splitlines(), 1):
        t = TITULO.match(linea)
        if t:
            nivel = len(t.group(1))
            if nivel_fechado and nivel <= nivel_fechado:
                nivel_fechado = 0
            if not nivel_fechado and FECHA.search(linea):
                nivel_fechado = nivel
            inicio = True
            if not nivel_fechado:  # un titulo sin fecha ('## Fase 2 -- ABIERTA') es una copia como cualquier linea
                yield n, linea
            continue
        if not linea.strip():
            inicio = True
            continue
        if inicio:
            fechado, inicio = bool(FECHA.search(linea)), False
        if not nivel_fechado and not fechado and not FECHA.search(linea):
            yield n, linea


def fase_activa():
    """La definicion de 'fase en curso' es UNA (la compuerta): se importa, no se copia."""
    spec = importlib.util.spec_from_file_location("fase_activa_div", RAIZ / ".claude" / "hooks" / "fase_activa.py")
    m = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(m)
    return m


def extraer(ruta: Path, extractor) -> list:
    """Los valores que el extractor saca del archivo, en orden. Lista vacia = no encontro nada."""
    if extractor == "fase_activa":
        f = fase_activa().fase_abierta(ruta)
        return [f[0]] if f and f[0] != "ninguna" else []
    texto = ruta.read_text(encoding="utf-8", errors="replace")
    sec = extractor.get("seccion")
    if sec:
        out, dentro = [], False
        for l in texto.splitlines():
            if l.startswith("## "):
                dentro = l.startswith(sec)
            elif dentro:
                out.append(l)
        texto = "\n".join(out)
    return [(m.group(1) if m.groups() else m.group(0)).strip() for m in re.finditer(extractor["regex"], texto)]


def validar(reg) -> list:
    """El registro es un mecanismo compartido: se chequea ANTES de usarlo (Saltzer, least common mechanism)."""
    if not isinstance(reg, dict) or not isinstance(reg.get("datos"), list) or not reg["datos"]:
        return ["REGISTRO sin lista 'datos' o vacio: un registro vacio no es verde"]
    mal, ids = [], {}
    for i, d in enumerate(reg["datos"]):
        did = d.get("id") if isinstance(d, dict) else None
        if not did:
            mal.append("REGISTRO dato %d sin id" % i)
            continue
        if did in ids:
            mal.append("DOS DUENOS %s: el dato figura dos veces en el registro (L2-DIV-05)" % did)
        ids[did] = True
        du = d.get("dueno")
        if isinstance(du, list) or "duenos" in d:
            mal.append("DOS DUENOS %s: un dato vigente tiene un solo archivo dueno (L2-DIV-05)" % did)
            continue
        if not isinstance(du, dict) or not du.get("archivo") or not du.get("extractor"):
            mal.append("SIN DUENO %s: falta 'dueno' con 'archivo' y 'extractor' (L2-DIV-05)" % did)
        for c in d.get("copias", []):
            if c.get("clase") not in CLASES or not c.get("archivo"):
                mal.append("REGISTRO %s: copia sin archivo o con clase fuera de %s" % (did, "/".join(CLASES)))
            elif c["clase"] == "vista" and not c.get("extractor"):
                mal.append("REGISTRO %s: copia vista sin extractor (%s)" % (did, c["archivo"]))
            elif c["clase"] == "puntero" and (not c.get("nombra") or not d.get("forma")):
                mal.append("REGISTRO %s: puntero sin 'nombra' o dato sin 'forma' (%s)" % (did, c["archivo"]))
    return mal


def medir(raiz: Path, registro: Path):
    """(rojos, avisos, oks). Cada rojo es la linea entera que va despues de [FAIL]."""
    if not registro.exists():
        return ["REGISTRO ausente: %s (falla cerrado)" % registro], [], []
    try:
        reg = json.loads(registro.read_text(encoding="utf-8"))
    except Exception as e:  # noqa: BLE001 -- el registro que no parsea es ROJO, no un traceback
        return ["REGISTRO no parsea: %s (%s)" % (registro, e)], [], []
    mal = validar(reg)
    if mal:
        return mal, [], []
    rojos, avisos, oks = [], [], []
    for d in reg["datos"]:
        did, du = d["id"], d["dueno"]
        p_du = raiz / du["archivo"]
        if not p_du.exists():
            rojos.append("DUENO AUSENTE %s: %s no existe" % (did, du["archivo"]))
            continue
        valor = extraer(p_du, du["extractor"])
        if not valor:
            rojos.append("DUENO VACIO %s: el extractor no encuentra nada en %s (el dato se mudo o el extractor esta "
                         "viejo; L2-DIV-03)" % (did, du["archivo"]))
            continue
        declarados = {du["archivo"]}
        forma = re.compile(d["forma"]) if d.get("forma") else None
        for c in d.get("copias", []):
            declarados.add(c["archivo"])
            p_c = raiz / c["archivo"]
            if not p_c.exists():
                rojos.append("COPIA AUSENTE %s: %s esta declarada y no existe (registro viejo)" % (did, c["archivo"]))
                continue
            if c["clase"] == "vista":
                v = extraer(p_c, c["extractor"])
                if v != valor:
                    rojos.append("DIVERGE %s: dueno %s = %s | copia vista %s (%s) = %s" % (
                        did, du["archivo"], ", ".join(valor), c["archivo"], c.get("que", "vista"),
                        ", ".join(v) or "(nada)"))
            else:
                texto = p_c.read_text(encoding="utf-8", errors="replace")
                if c["nombra"] not in texto:
                    rojos.append("YA NO NOMBRA %s: el puntero %s no nombra a %s (registro viejo o copia sacada)" % (
                        did, c["archivo"], c["nombra"]))
                for n, l in lineas_vigentes(texto):
                    if forma.search(l):
                        rojos.append("PUNTERO COPIA EL VALOR %s: dueno %s = %s | copia %s:%d: %s" % (
                            did, du["archivo"], ", ".join(valor), c["archivo"], n, l.strip()[:120]))
        oks.append("%s: dueno %s = %s; %d copia(s) declarada(s)" % (
            did, du["archivo"], ", ".join(valor), len(d.get("copias", []))))
        amb = d.get("ambito")
        if forma and amb and (raiz / amb).is_dir():
            for f in sorted((raiz / amb).rglob("*.md")):
                rel = f.relative_to(raiz).as_posix()
                if rel in declarados or FECHA_NOMBRE.search(f.name):
                    continue
                for n, l in lineas_vigentes(f.read_text(encoding="utf-8", errors="replace")):
                    if forma.search(l):
                        avisos.append("copia ausente del registro (L2-DIV-04) %s: %s:%d: %s" % (
                            did, rel, n, l.strip()[:110]))
    return rojos, avisos, oks


def main() -> int:
    try:
        sys.stdout.reconfigure(errors="replace")
    except Exception:  # noqa: BLE001
        pass
    ap = argparse.ArgumentParser(description="verificador de cero divergencias (T20)")
    ap.add_argument("--raiz", default=str(RAIZ))
    ap.add_argument("--registro", default=None)
    a = ap.parse_args()
    raiz = Path(a.raiz).resolve()
    registro = Path(a.registro) if a.registro else raiz / ".claude" / "datos.json"
    try:
        rojos, avisos, oks = medir(raiz, registro)
    except Exception as e:  # noqa: BLE001 -- tres resultados: verde, rojo y REVENTO (no es un rojo)
        print("[FAIL] REVENTO divergencias.py: %s: %s" % (type(e).__name__, e))
        return 2
    for o in oks:
        print("[OK  ] %s" % o)
    for r in rojos:
        print("[FAIL] %s" % r)
    for av in avisos:
        print("[aviso] %s" % av)
    print("divergencias: %d dato(s), %d rojo(s), %d aviso(s) -- %s" % (
        len(oks), len(rojos), len(avisos), "ROJO" if rojos else "verde"))
    return 1 if rojos else 0


if __name__ == "__main__":
    sys.exit(main())
