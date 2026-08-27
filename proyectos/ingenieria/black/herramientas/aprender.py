#!/usr/bin/env python3
"""Autoaprendizaje del proyecto: registro append-only de lecciones de proceso.

    DEPRECADO (2026-08-17). Usar la version GLOBAL:

        python ..\\perfil-global\\herramientas\\aprender.py agregar ...
        (o, desde cualquier carpeta de la maquina:
         python %USERPROFILE%\\.claude\\herramientas\\aprender.py agregar ...)

    Las 5 lecciones que habia en black/kb/aprendizaje.jsonl ya estan migradas
    a perfil-global/aprendizaje/lecciones.jsonl. Este script se deja para
    poder leer el historico; escribir aca crea una segunda fuente de verdad.

    Por que: una leccion de proceso es, por definicion, la que va a volver a
    pasar en OTRO proyecto. Guardada adentro de uno, no la ve nadie mas. Ver
    la leccion 25 de /lecciones-aprendidas.

Una leccion entra aca si costo tiempo por COMO se trabajo, no por lo que decia
el codigo. Un bug en el juego va a la bitacora; "supuse quien disparaba y medi
el experimento equivocado" va aca.

    python herramientas/aprender.py agregar \\
        --titulo "Alineacion no es causalidad" \\
        --costo "un experimento entero" \\
        --sintoma "un puntero alineado a registro en 10 de 10 objetos" \\
        --regla "antes de creerle a un candidato estructural, moverlo y medir"

    python herramientas/aprender.py listar
    python herramientas/aprender.py digesto      # lo que se lee al abrir sesion
"""
import argparse
import json
import io
import os
import sys
from datetime import date

AQUI = os.path.dirname(os.path.abspath(__file__))
RAIZ = os.path.dirname(AQUI)
JSONL = os.path.join(RAIZ, "kb", "aprendizaje.jsonl")
MD = os.path.join(RAIZ, "APRENDIZAJE.md")

CAMPOS = ("titulo", "costo", "sintoma", "regla")


def _leer():
    if not os.path.exists(JSONL):
        return []
    con = []
    with io.open(JSONL, encoding="utf-8") as f:
        for linea in f:
            linea = linea.strip()
            if linea:
                con.append(json.loads(linea))
    return con


def _escribir_md(lecciones):
    partes = [
        "# Aprendizaje acumulado del proyecto",
        "",
        "Generado por `herramientas/aprender.py`. **No editar a mano**: se",
        "reescribe entero. Para agregar algo, usar `aprender.py agregar`.",
        "",
        "Entra aca lo que costo tiempo por **como se trabajo**, no por lo que",
        "decia el codigo. Se lee al empezar cualquier tarea de investigacion.",
        "",
        "---",
        "",
    ]
    for i, l in enumerate(reversed(lecciones), 1):
        partes += [
            "## %d. %s" % (i, l["titulo"]),
            "",
            "**Costo:** %s  ·  **Fecha:** %s" % (l["costo"], l["fecha"]),
            "",
            "**Sintoma:** %s" % l["sintoma"],
            "",
            "**Regla:** %s" % l["regla"],
            "",
        ]
    with io.open(MD, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(partes))


def agregar(a):
    lecciones = _leer()
    nueva = {c: getattr(a, c) for c in CAMPOS}
    nueva["fecha"] = a.fecha or date.today().isoformat()
    if any(l["titulo"].lower() == nueva["titulo"].lower() for l in lecciones):
        print("ya existe una leccion con ese titulo; no se duplica")
        return 1
    os.makedirs(os.path.dirname(JSONL), exist_ok=True)
    with io.open(JSONL, "a", encoding="utf-8", newline="\n") as f:
        f.write(json.dumps(nueva, ensure_ascii=False) + "\n")
    lecciones.append(nueva)
    _escribir_md(lecciones)
    print("agregada: %s  (%d en total)" % (nueva["titulo"], len(lecciones)))
    return 0


def listar(a):
    lecciones = _leer()
    if not lecciones:
        print("todavia no hay lecciones registradas")
        return 0
    for l in reversed(lecciones):
        print("  [%s] %s" % (l["fecha"], l["titulo"]))
        print("        %s" % l["regla"])
    print("\n  total: %d" % len(lecciones))
    return 0


def digesto(a):
    """Lo que conviene inyectar al abrir una sesion: solo las reglas."""
    lecciones = _leer()
    if not lecciones:
        return 0
    print("APRENDIZAJE ACUMULADO (%d lecciones) - de black/APRENDIZAJE.md" % len(lecciones))
    for l in reversed(lecciones[-int(a.cuantas):]):
        print("  - %s: %s" % (l["titulo"], l["regla"]))
    return 0


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = p.add_subparsers(dest="cmd", required=True)

    pa = sub.add_parser("agregar", help="registra una leccion nueva")
    pa.add_argument("--titulo", required=True)
    pa.add_argument("--costo", required=True, help="que costo: 'una hora', 'un experimento entero'")
    pa.add_argument("--sintoma", required=True, help="como se veia el problema ANTES de entenderlo")
    pa.add_argument("--regla", required=True, help="que hacer distinto la proxima vez")
    pa.add_argument("--fecha", default=None)
    pa.set_defaults(fn=agregar)

    pl = sub.add_parser("listar", help="todas las lecciones")
    pl.set_defaults(fn=listar)

    pd = sub.add_parser("digesto", help="las reglas solas, para inyectar al abrir sesion")
    pd.add_argument("--cuantas", default=12)
    pd.set_defaults(fn=digesto)

    a = p.parse_args()
    return a.fn(a)


if __name__ == "__main__":
    sys.exit(main())
