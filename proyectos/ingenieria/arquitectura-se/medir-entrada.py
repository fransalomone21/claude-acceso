#!/usr/bin/env python3
"""medir-entrada.py -- cuanto exige leer la puerta al entrar, por clase de sesion, y cuanto de eso se usa.

Solo lectura. No registra nada en la caja negra: llama a cascada_puerta.py --exige y --tronco, y lee el
registro del lazo de uso (.claude/auditorias/uso-lecturas.jsonl).

    python proyectos/ingenieria/arquitectura-se/medir-entrada.py
    python proyectos/ingenieria/arquitectura-se/medir-entrada.py fisica-espacial:materia black:ingenieria-inversa

Es el instrumento del efecto de DA-104 (docs/replanteo-2026-11-13.md, seccion 4, familia F1): el total de
una materia tiene que bajar despues del recorte. Sale 0 si midio todo, 2 si algun caso no devolvio renglones
(verde por vacio no es verde).
"""
import collections
import json
import re
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
PUERTA = RAIZ / ".claude" / "hooks" / "cascada_puerta.py"
REGISTRO = RAIZ / ".claude" / "auditorias" / "uso-lecturas.jsonl"

CASOS = [
    ("fisica-espacial", "materia"),
    ("malena", "materia"),
    ("trabajo-final-iise", "materia"),
    ("black", "ingenieria-inversa"),
    ("telescopio", "diseno"),
    ("ps2-casa", "ninguna"),
    ("coaching", "ninguna"),
    ("arquitectura-se", "metodo,diseno"),
]


def correr(args):
    r = subprocess.run([sys.executable, str(PUERTA)] + args, capture_output=True, cwd=str(RAIZ))
    return r.stdout.decode("utf-8", "replace") + r.stderr.decode("utf-8", "replace")


def renglones(txt):
    """Cada renglon '... N ch  motivo' de la salida de la puerta -> (N, grupo del motivo)."""
    out = []
    for linea in txt.splitlines():
        m = re.search(r"(\d+)\s*ch\s+(.*)$", linea)
        if m:
            grupo = m.group(2).strip().split(":")[0].split(",")[0].strip()
            out.append((int(m.group(1)), grupo))
    return out


def main(argv):
    casos = [tuple(a.split(":", 1)) for a in argv if ":" in a] or CASOS
    vacios = 0
    print("LO QUE EXIGE LA PUERTA AL ENTRAR (caracteres; dividir por 3,5 da tokens, a ojo)")
    for proyecto, necesidad in casos:
        rs = renglones(correr(["--exige", proyecto, "--necesidad", necesidad]))
        if not rs:
            vacios += 1
            print("  [SIN MEDIR] %s %s: la puerta no devolvio renglones" % (proyecto, necesidad))
            continue
        por = collections.Counter()
        for ch, grupo in rs:
            por[grupo] += ch
        print("  %-20s %-20s %7d en %2d lecturas" % (proyecto, necesidad, sum(c for c, _ in rs), len(rs)))
        print("      " + " | ".join("%s %d" % kv for kv in por.most_common(6)))
    rs = renglones(correr(["--tronco"]))
    if rs:
        print("  el tronco solo: %d en %d lecturas" % (sum(c for c, _ in rs), len(rs)))
    else:
        vacios += 1
        print("  [SIN MEDIR] el tronco")

    print("TASA DE USO DECLARADA (lazo de uso, T19 pieza D)")
    if not REGISTRO.exists():
        print("  [SIN MEDIR] no existe %s" % REGISTRO)
        vacios += 1
    else:
        muestras = collections.Counter()
        exigidas = collections.Counter()
        usadas = collections.Counter()
        for linea in REGISTRO.read_text(encoding="utf-8").splitlines():
            try:
                d = json.loads(linea)
            except ValueError:
                continue
            clase = d.get("clase", "?")
            muestras[clase] += 1
            exigidas[clase] += len(d.get("exigidas") or d.get("lecturas") or [])
            usadas[clase] += len(d.get("usadas") or [])
        if not muestras:
            vacios += 1
            print("  [SIN MEDIR] el registro no tiene muestras legibles")
        for clase in sorted(muestras):
            print("  %-24s %3d muestras: %4d usadas de %5d exigidas (%.0f %%)" % (
                clase, muestras[clase], usadas[clase], exigidas[clase],
                100.0 * usadas[clase] / max(1, exigidas[clase])))
    return 2 if vacios else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
