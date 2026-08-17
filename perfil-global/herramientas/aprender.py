#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Aprendizaje GLOBAL: el registro de lecciones de proceso de todos los proyectos.

POR QUE ES GLOBAL Y NO DE UN PROYECTO
    La version anterior de esta herramienta vivia en `black/herramientas/` y
    escribia en `black/kb/aprendizaje.jsonl`. Funcionaba, y por eso mismo el
    problema tardo en verse: una leccion aprendida trabajando en cualquier
    otra cosa -- el perfil, otro repo, una sesion de electronica -- no tenia
    donde caer. El mecanismo existia y cubria un solo proyecto.

    Una leccion de proceso, por definicion (ver el protocolo en la skill
    lecciones-aprendidas), es la que VA A VOLVER A PASAR EN OTRO PROYECTO. O
    sea: justo la clase de cosa que no puede guardarse adentro de uno.

LA FUENTE DE VERDAD ES EL REPO, NO LA MAQUINA
    Todo se escribe en <repo>/perfil-global/aprendizaje/lecciones.jsonl, que
    se commitea. `~/.claude/` es una COPIA instalada: si el registro viviera
    solo ahi, formatear la maquina seria perder el aprendizaje entero.

    La copia instalada del script sabe volver al repo por
    ~/.claude/aprendizaje/origen.txt, que escribe install.ps1. Asi una leccion
    aprendida en cualquier carpeta de la maquina cae igual en el repo.

LAS TRES CAPAS, Y CUAL DISPARA SOLA
    1. chequeo-de-trabajo.md   -> lo inyecta el hook SessionStart. Es la
                                  sintesis curada: se lee sin pedirla.
    2. lecciones.jsonl         -> el indice completo, legible por script.
                                  Se consulta con `digesto`.
    3. skills/lecciones-aprendidas/SKILL.md -> la version larga, con el caso
                                  concreto de cada una. Se lee bajo demanda.

    Este script mantiene la 2 y regenera LECCIONES.md. La 1 es curada a mano
    -- sintetizar requiere criterio -- pero `install.ps1` avisa cuando quedo
    atrasada respecto de la 2.

USO
    python aprender.py agregar --titulo "..." --costo "..." \
        --sintoma "..." --regla "..." [--grupo proceso] [--proyecto black]
    python aprender.py listar [--grupo medicion] [--proyecto black]
    python aprender.py digesto            # todas las reglas, agrupadas
    python aprender.py donde              # que archivo esta usando y por que
    python aprender.py regenerar          # reescribe LECCIONES.md
"""
from __future__ import annotations

import argparse
import io
import json
import os
import sys
from datetime import date
from pathlib import Path

# La consola de Windows es cp1252 y se muere con cualquier caracter que no
# entre. Preferimos un signo de pregunta a una excepcion que corte la salida.
try:
    sys.stdout.reconfigure(errors="replace")
    sys.stderr.reconfigure(errors="replace")
except Exception:  # pragma: no cover - Python viejo
    pass

CAMPOS = ("titulo", "costo", "sintoma", "regla")

# El orden importa: es el orden en que se leen al abrir una sesion.
GRUPOS = (
    ("evidencia",    "Antes de creerle a algo"),
    ("busqueda",     "Antes de buscar, y al leer un resultado vacio"),
    ("medicion",     "Antes de medir"),
    ("herramientas", "Antes de confiar en una herramienta"),
    ("proceso",      "Como se trabaja"),
    ("entorno",      "La maquina"),
)
NOMBRES_GRUPO = dict(GRUPOS)


# --------------------------------------------------------------------------
# Ubicar el repo. Sin silencio: si no lo encuentra, lo dice y sale con error.
# --------------------------------------------------------------------------
def _valida(raiz: Path) -> bool:
    return (raiz / "perfil-global").is_dir()


def raiz_repo(explicito: str | None = None) -> Path:
    intentos = []

    if explicito:
        p = Path(explicito).expanduser().resolve()
        if _valida(p):
            return p
        intentos.append("--repo %s (no tiene perfil-global/)" % p)

    # Corriendo desde el repo: .../perfil-global/herramientas/aprender.py
    aqui = Path(__file__).resolve()
    cand = aqui.parent.parent.parent
    if _valida(cand):
        return cand
    intentos.append("junto al script: %s" % cand)

    # Corriendo la copia instalada en ~/.claude/herramientas/
    origen = Path.home() / ".claude" / "aprendizaje" / "origen.txt"
    if origen.exists():
        p = Path(origen.read_text(encoding="utf-8").strip()).expanduser()
        if _valida(p):
            return p
        intentos.append("%s dice %s, que no existe o se movio" % (origen, p))
    else:
        intentos.append("%s (no existe: correr perfil-global\\install.ps1)" % origen)

    sys.stderr.write(
        "aprender.py: no encuentro el repo del perfil.\n"
        "  Se probo:\n    - " + "\n    - ".join(intentos) + "\n"
        "  Solucion: pasar --repo C:\\ruta\\al\\repo, o correr install.ps1\n"
        "  desde el repo para que quede anotado el origen.\n"
    )
    raise SystemExit(2)


def rutas(raiz: Path):
    base = raiz / "perfil-global" / "aprendizaje"
    return base / "lecciones.jsonl", base / "LECCIONES.md"


# --------------------------------------------------------------------------
def leer(jsonl: Path) -> list[dict]:
    if not jsonl.exists():
        return []
    out = []
    with io.open(jsonl, encoding="utf-8") as f:
        for n, linea in enumerate(f, 1):
            linea = linea.strip()
            if not linea:
                continue
            try:
                out.append(json.loads(linea))
            except json.JSONDecodeError as e:
                # Un jsonl corrupto no se ignora en silencio: una leccion
                # perdida sin aviso es peor que un error ruidoso.
                sys.stderr.write("aprender.py: linea %d ilegible en %s: %s\n"
                                 % (n, jsonl, e))
                raise SystemExit(2)
    return out


def escribir_md(lecciones: list[dict], md: Path) -> None:
    p = [
        "# Lecciones de proceso -- registro completo",
        "",
        "**Generado por `perfil-global/herramientas/aprender.py`. No editar a mano:**",
        "se reescribe entero. Para agregar: `aprender.py agregar`.",
        "",
        "Este archivo es el **indice**: una leccion por bloque, con su regla.",
        "La version larga -- el caso concreto, que costo, como se descubrio --",
        "esta en `perfil-global/lecciones-aprendidas/SKILL.md`, y el campo `ref`",
        "dice en que seccion. Las entradas migradas desde esa skill el",
        "2026-08-17 llevan esa fecha, no la del dia en que se aprendieron.",
        "",
        "La sintesis que se lee sola al abrir sesion es",
        "`perfil-global/chequeo-de-trabajo.md`.",
        "",
        "---",
        "",
    ]
    for clave, titulo in GRUPOS:
        delgrupo = [l for l in lecciones if l.get("grupo") == clave]
        if not delgrupo:
            continue
        p += ["## %s" % titulo, ""]
        for l in delgrupo:
            p.append("### %s" % l["titulo"])
            p.append("")
            meta = [x for x in (l.get("proyecto"), l.get("fecha")) if x]
            if l.get("ref"):
                meta.append("ver `%s`" % l["ref"])
            p.append("**Regla:** %s" % l["regla"])
            p.append("")
            p.append("**Sintoma:** %s" % l["sintoma"])
            p.append("")
            p.append("**Costo:** %s  ·  %s" % (l["costo"], "  ·  ".join(meta)))
            p.append("")
    sueltas = [l for l in lecciones if l.get("grupo") not in NOMBRES_GRUPO]
    if sueltas:
        p += ["## Sin agrupar", ""]
        for l in sueltas:
            p += ["### %s" % l["titulo"], "", "**Regla:** %s" % l["regla"], ""]
    p += ["---", "", "Total: %d lecciones." % len(lecciones), ""]
    with io.open(md, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(p))


# --------------------------------------------------------------------------
def cmd_agregar(a) -> int:
    raiz = raiz_repo(a.repo)
    jsonl, md = rutas(raiz)
    lecciones = leer(jsonl)

    if a.grupo not in NOMBRES_GRUPO:
        sys.stderr.write("grupo invalido: %s\n  validos: %s\n"
                         % (a.grupo, ", ".join(k for k, _ in GRUPOS)))
        return 2

    nueva = {c: getattr(a, c) for c in CAMPOS}
    nueva["fecha"] = a.fecha or date.today().isoformat()
    nueva["proyecto"] = a.proyecto
    nueva["grupo"] = a.grupo
    if a.ref:
        nueva["ref"] = a.ref

    if any(l["titulo"].lower() == nueva["titulo"].lower() for l in lecciones):
        print("ya hay una leccion con ese titulo; no se duplica.")
        print("Si la nueva CONTRADICE a la vieja, se corrige la vieja: este")
        print("archivo no es historial. Editar lecciones.jsonl y regenerar.")
        return 1

    jsonl.parent.mkdir(parents=True, exist_ok=True)
    with io.open(jsonl, "a", encoding="utf-8", newline="\n") as f:
        f.write(json.dumps(nueva, ensure_ascii=False) + "\n")
    lecciones.append(nueva)
    escribir_md(lecciones, md)

    print("agregada: %s  (%d en total)" % (nueva["titulo"], len(lecciones)))
    print("")
    print("Falta un paso, y es el que hace que sirva:")
    print("  si esta regla aplica a CUALQUIER trabajo, foldeala en")
    print("  perfil-global/chequeo-de-trabajo.md -- que es lo unico que se")
    print("  lee solo al abrir una sesion -- y corre install.ps1.")
    print("  Si es especifica de un dominio, con estar aca alcanza.")
    return 0


def cmd_listar(a) -> int:
    raiz = raiz_repo(a.repo)
    jsonl, _ = rutas(raiz)
    lecciones = leer(jsonl)
    if a.grupo:
        lecciones = [l for l in lecciones if l.get("grupo") == a.grupo]
    if a.proyecto:
        lecciones = [l for l in lecciones if l.get("proyecto") == a.proyecto]
    if not lecciones:
        print("no hay lecciones que cumplan el filtro")
        return 0
    for l in lecciones:
        print("  [%s] %-12s %s" % (l.get("fecha", "?"),
                                   l.get("proyecto", "-"), l["titulo"]))
        print("       %s" % l["regla"])
    print("\n  total: %d" % len(lecciones))
    return 0


def cmd_digesto(a) -> int:
    """Todas las reglas, agrupadas. Para consultar, no para inyectar:
    lo que se inyecta al abrir sesion es chequeo-de-trabajo.md, que es la
    sintesis. Esto es la lista completa."""
    raiz = raiz_repo(a.repo)
    jsonl, _ = rutas(raiz)
    lecciones = leer(jsonl)
    if not lecciones:
        print("todavia no hay lecciones registradas")
        return 0
    print("LECCIONES DE PROCESO (%d) - perfil-global/aprendizaje/lecciones.jsonl"
          % len(lecciones))
    for clave, titulo in GRUPOS:
        delgrupo = [l for l in lecciones if l.get("grupo") == clave]
        if not delgrupo:
            continue
        print("")
        print("  %s" % titulo.upper())
        for l in delgrupo:
            print("    - %s: %s" % (l["titulo"], l["regla"]))
    return 0


def cmd_donde(a) -> int:
    raiz = raiz_repo(a.repo)
    jsonl, md = rutas(raiz)
    print("repo del perfil : %s" % raiz)
    print("registro        : %s  (%s)"
          % (jsonl, "existe" if jsonl.exists() else "NO EXISTE todavia"))
    print("indice generado : %s" % md)
    print("script corriendo: %s" % Path(__file__).resolve())
    origen = Path.home() / ".claude" / "aprendizaje" / "origen.txt"
    print("origen.txt      : %s  (%s)"
          % (origen, "existe" if origen.exists() else "no existe"))
    print("lecciones       : %d" % len(leer(jsonl)))
    return 0


def cmd_regenerar(a) -> int:
    raiz = raiz_repo(a.repo)
    jsonl, md = rutas(raiz)
    lecciones = leer(jsonl)
    escribir_md(lecciones, md)
    print("regenerado %s con %d lecciones" % (md, len(lecciones)))
    return 0


def main() -> int:
    p = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--repo", default=None,
                   help="raiz del repo que contiene perfil-global/")
    sub = p.add_subparsers(dest="cmd", required=True)

    pa = sub.add_parser("agregar", help="registra una leccion nueva")
    pa.add_argument("--titulo", required=True)
    pa.add_argument("--costo", required=True,
                    help="que costo de verdad: 'una hora', 'un experimento'")
    pa.add_argument("--sintoma", required=True,
                    help="como se veia el problema ANTES de entenderlo")
    pa.add_argument("--regla", required=True, help="que hacer distinto")
    pa.add_argument("--grupo", required=True,
                    choices=[k for k, _ in GRUPOS])
    pa.add_argument("--proyecto", default="general",
                    help="black | perfil | general | ...")
    pa.add_argument("--ref", default=None,
                    help="seccion de la version larga, si la hay")
    pa.add_argument("--fecha", default=None)
    pa.set_defaults(fn=cmd_agregar)

    pl = sub.add_parser("listar", help="lecciones, con filtros")
    pl.add_argument("--grupo", default=None)
    pl.add_argument("--proyecto", default=None)
    pl.set_defaults(fn=cmd_listar)

    pd = sub.add_parser("digesto", help="todas las reglas, agrupadas")
    pd.set_defaults(fn=cmd_digesto)

    pw = sub.add_parser("donde", help="que archivos usa y por que")
    pw.set_defaults(fn=cmd_donde)

    pr = sub.add_parser("regenerar", help="reescribe LECCIONES.md")
    pr.set_defaults(fn=cmd_regenerar)

    a = p.parse_args()
    return a.fn(a)


if __name__ == "__main__":
    sys.exit(main())
