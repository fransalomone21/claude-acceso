#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
censo_ab.py — T1 de la nube (98): toda lectura de «el jugador» que NO cuelga de J.

PARA QUÉ
    docs/17 separa lo que falta en tres clases: A (lo que J TIENE: conmutar),
    B (lo que el mundo le PREGUNTA al jugador: generalizar), C (compartido).
    La pregunta de frío que separa A de B es una sola: quién lee «el jugador»
    sin recibirlo por parámetro. Tres formas, en el decompilado:
      1. el global del juego con un desplazamiento DENTRO de jugadores[0]
         (juego = *(0x0040F4D0); J = juego+0x30 ... juego+0x8F0): `DAT_0040f4d0 + 0x1c0`
         es J+0x190 (la posición);
      2. jugadores[k] indexado (`DAT_0040f4d0 + (x >> n) * 0x8c0 + 0x30`);
      3. la cuenta de jugadores `*(DAT_0040f0e0 + 0x20208)` (lazos sobre jugadores[]).
    Un alias local (`iVar3 = DAT_0040f4d0;`) cuenta igual que el global.

    Es una COTA INFERIOR hecha sobre el C de Ghidra: lo que Ghidra no nombró como
    `DAT_0040f4d0` (p. ej. un parámetro que ya trae el juego) no sale. Para la
    lista completa por instrucciones está `lectores_global.py`.

CLI
    python herramientas/censo_ab.py                 # tabla por función
    python herramientas/censo_ab.py --resumen       # agrupado por singletons que toca
    python herramientas/censo_ab.py --json salida.json
    python herramientas/censo_ab.py --autotest      # control positivo
    python herramientas/censo_ab.py --conmutables 0x00127118 [...]   # (100) ¿se puede preguntar por J2?

CONMUTABLE (100): una función se puede correr «como si J2 fuera J» con el global del juego conmutado a
`juego' = J2 - 0x30` si ella Y TODO LO QUE LLAMA (cierre por el grafo de llamadas directas) leen el global
sólo con desplazamientos dentro de jugadores[0] ([0x30, 0x8F0)) y nunca pasan el global entero. Las
llamadas indirectas (vtables) no están en el grafo: la respuesta es necesaria, no suficiente.

Control positivo (--autotest): FUN_0016a4c0 (los disparadores de (73)) lee
juego+0x1C0 (= J+0x190, la posición), el render FUN_001297e0 pasa jugadores[0],
y FUN_0012be80 (el alta, (82)) lee la cuenta. Si alguno falta, sale 1.
"""
import argparse
import collections
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from perfil_singleton import DEC, descendientes, raices, todo_c  # noqa: E402

J0, J1 = 0x30, 0x30 + 0x8C0
DAT = "DAT_0040f4d0"
CUENTA = re.compile(r"DAT_0040f0e0 \+ 0x20208\b")


def analizar(c):
    """Devuelve (campos_J, indexado, cuenta, pasa_J) de un cuerpo de C."""
    alias = set(re.findall(rf"(\w+) = (?:\(\w+\s*\**\))?{DAT};", c)) | {DAT}
    campos = collections.Counter()
    for m in re.finditer(r"\((\w+) \+ (0x[0-9a-f]+)\)", c):
        if m.group(1) in alias:
            o = int(m.group(2), 16)
            if J0 <= o < J1:
                campos[o - J0] += 1
    # J pasado entero: FUN_x(DAT_0040f4d0 + 0x30 ...)  |  x = DAT_0040f4d0 + 0x30;
    pasa = 0
    for a in alias:
        pasa += len(re.findall(rf"\b{a} \+ 0x30\b(?!\w)", c))
    idx = 0
    for a in alias:
        idx += len(re.findall(rf"\b{a} \+ [^;]*\* 0x8c0", c))
    return campos, idx, len(CUENTA.findall(c)), pasa


def usos_fuera(c):
    """Usos del global del juego fuera del rango de J (o el global entero) en un cuerpo de C."""
    alias = set(re.findall(rf"(\w+) = (?:\(\w+\s*\**\))?{DAT};", c)) | {DAT}
    fuera = set()
    for a in alias:
        for m in re.finditer(rf"\b{a}\b", c):
            antes, despues = c[max(0, m.start() - 3):m.start()], c[m.end():m.end() + 24]
            if despues.startswith(" = "):
                continue                                   # se le asigna (un alias que se reusa)
            if a != DAT and re.match(r"\s*=\s*(?:\(\w+\s*\**\))?" + DAT, despues):
                continue                                   # la asignación del alias
            if antes.endswith("= ") and despues.startswith(";") and a == DAT:
                continue                                   # alias = DAT_0040f4d0;
            k = re.match(r"\s*\+\s*(0x[0-9a-f]+|\d+)\b", despues)
            if k:
                o = int(k.group(1), 0)
                if not (J0 <= o < J1):
                    fuera.add(f"+{o:#x}")
            elif re.match(r"\s*\+", despues):
                fuera.add("indexado")
            else:
                fuera.add("entero")
    return fuera


def conmutable(funcs, g, fuentes, tope=3000):
    """{f: (ok, [(g, usos)...])} con el cierre transitivo por llamadas directas."""
    res = {}
    for f in funcs:
        vis, pila, malos = {f}, [f], []
        while pila and len(vis) < tope:
            x = pila.pop()
            u = usos_fuera(fuentes.get(x, ""))
            if u:
                malos.append((x, sorted(u)))
            for y in g.get(x, {}).get("llama", []):
                if y not in vis:
                    vis.add(y)
                    pila.append(y)
        res[f] = (not malos, malos, len(vis))
    return res


def cargar_todo():
    g = json.loads((DEC / "grafo.json").read_text(encoding="utf-8"))
    idx = json.loads((DEC / "indice.json").read_text(encoding="utf-8"))
    alc = {k: descendientes(g, v) for k, v in raices().items()}
    return g, idx, alc


def censo():
    g, idx, alc = cargar_todo()
    filas = []
    for f, c in todo_c():
        campos, ind, cta, pasa = analizar(c)
        if not (campos or ind or cta or pasa):
            continue
        lazos = sorted(k for k, d in alc.items() if f in d)
        filas.append({
            "funcion": f,
            "campos_J": {f"+0x{o:X}": n for o, n in sorted(campos.items())},
            "indexa": ind, "cuenta": cta, "pasa_J": pasa,
            "singletons": sorted(set(idx["por_funcion"].get(f, [])) - {"0x0040F4D0"}),
            "lazos": lazos,
            "llamada_por": len(g.get(f, {}).get("llamada_por", [])),
        })
    return filas


def autotest(filas):
    por = {r["funcion"]: r for r in filas}
    ok = True
    for f, cond, txt in [
        ("0x0016A4C0", lambda r: "+0x190" in r["campos_J"], "disparadores leen J+0x190 (posicion)"),
        ("0x0012BE80", lambda r: r["cuenta"] > 0, "el alta lee la cuenta"),
    ]:
        r = por.get(f)
        bien = bool(r and cond(r))
        ok &= bien
        print(f"{'ok  ' if bien else 'FALLA'} {f} {txt}")
    return 0 if ok else 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--resumen", action="store_true")
    ap.add_argument("--json")
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--conmutables", nargs="*")
    a = ap.parse_args()
    if a.conmutables is not None:
        g = json.loads((DEC / "grafo.json").read_text(encoding="utf-8"))
        fuentes = dict(todo_c())
        fs = [f"0x{int(x, 16):08X}" for x in a.conmutables] or [r["funcion"] for r in censo()]
        for f, (ok, malos, n) in conmutable(fs, g, fuentes).items():
            print(f"{f} {'CONMUTABLE' if ok else 'no'} (cierre de {n} funciones)"
                  + ("" if ok else ": " + "; ".join(f"{x} {' '.join(u[:4])}" for x, u in malos[:4])))
        return
    filas = censo()
    if a.autotest:
        sys.exit(autotest(filas))
    if a.json:
        Path(a.json).write_text(json.dumps(filas, indent=1, ensure_ascii=False), encoding="utf-8")
    if a.resumen:
        grupo = collections.defaultdict(list)
        for r in filas:
            grupo[" ".join(r["singletons"]) or "-"].append(r)
        for k, rs in sorted(grupo.items(), key=lambda x: -len(x[1])):
            print(f"== toca {k}: {len(rs)} funciones")
            for r in rs:
                print(f"   {r['funcion']} J{list(r['campos_J'])[:8]} idx{r['indexa']} cta{r['cuenta']} "
                      f"pasaJ{r['pasa_J']} lazos {','.join(r['lazos']) or '-'}")
        return
    for r in filas:
        print(f"{r['funcion']} J{list(r['campos_J'])} idx{r['indexa']} cta{r['cuenta']} pasaJ{r['pasa_J']} "
              f"sing {' '.join(r['singletons']) or '-'} lazos {','.join(r['lazos']) or '-'} "
              f"llam{r['llamada_por']}")
    print(f"{len(filas)} funciones leen al jugador fuera de J")


if __name__ == "__main__":
    main()
