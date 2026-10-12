#!/usr/bin/env python3
"""lluvia-de-ideas.py -- el DISPARADOR del momento lluvia de ideas (necesidad transversal; Fran, 2026-10-12).

Que mide: cuantas sesiones AUDITADAS tuvo un proyecto desde su ultima lluvia de ideas, contra el umbral que el
proyecto declara en .claude/cascada.json ("lluvia": {"cada": N}). Lo corre cascada.ps1 al entrar a un proyecto, y
imprime el valor Y el umbral (un medidor sin umbral da OK sobre el defecto).

Por que existe: la pieza 2 del coop de BLACK llevo 13 sesiones bajando capa por capa sin que nadie mirara desde
arriba. La regla estaba escrita ('falta el nivel 1') y ningun flujo la disparaba (Meadows: el medidor a la vista).

Fuentes, medidas en el disco (no leidas de un documento que las cuente):
  - la ultima lluvia: la fecha mas nueva entre los archivos del proyecto cuyo nombre trae 'lluvia-de-ideas-AAAA-MM-DD'
  - las sesiones: .claude/auditorias/AAAA-MM-DD-<id>.md cuya linea 'Proyectos:' nombra al proyecto, con fecha
    ESTRICTAMENTE posterior a la de la ultima lluvia (la sesion que la escribio no cuenta)

Uso:
  python lluvia-de-ideas.py aviso <proyecto>   el medidor (y el aviso si se llego al umbral); sin cadencia, nada
  python lluvia-de-ideas.py --autotest         controles positivos y negativos sobre un repo sintetico
  python lluvia-de-ideas.py --sabotaje         rompe el reconocimiento de la fecha: el autotest TIENE que dar rojo

Salida en ASCII a proposito: la consola de Windows la lee como cp1252.
"""
import json
import re
import shutil
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
PAT_DOC = re.compile(r"lluvia-de-ideas-(\d{4}-\d{2}-\d{2})")
PAT_AUD = re.compile(r"^(\d{4}-\d{2}-\d{2})-[0-9A-Za-z]+\.md$")


def carpeta_proyecto(raiz, nombre):
    """proyectos/<naturaleza>/<nombre>; None si no hay una sola."""
    hallados = [p for p in (raiz / "proyectos").glob("*/" + nombre) if p.is_dir()]
    return hallados[0] if len(hallados) == 1 else None


def ultima_lluvia(carpeta):
    fechas = []
    for f in carpeta.rglob("*lluvia-de-ideas-*.md"):
        if ".git" in f.parts:
            continue
        m = PAT_DOC.search(f.name)
        if m:
            fechas.append(m.group(1))
    return max(fechas) if fechas else None


def proyectos_de_auditoria(txt):
    lin = next((l for l in txt.splitlines() if l.startswith("Proyectos:")), "")
    return {x.strip(" .") for x in lin[len("Proyectos:"):].split(",") if x.strip(" .")}


def sesiones_desde(raiz, nombre, fecha):
    aud = raiz / ".claude" / "auditorias"
    if not aud.is_dir():
        return 0
    n = 0
    for f in aud.iterdir():
        m = PAT_AUD.match(f.name)
        if not m or (fecha is not None and m.group(1) <= fecha):
            continue
        try:
            txt = f.read_text(encoding="utf-8", errors="replace")
        except OSError:
            continue
        if nombre in proyectos_de_auditoria(txt):
            n += 1
    return n


def cadencia(raiz, nombre):
    cat = json.loads((raiz / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    ll = (cat.get("proyectos", {}).get(nombre) or {}).get("lluvia")
    if isinstance(ll, dict) and isinstance(ll.get("cada"), int) and ll["cada"] > 0:
        return ll["cada"]
    return None


def medir(raiz, nombre, ultima=ultima_lluvia):
    cada = cadencia(raiz, nombre)
    if cada is None:
        return None
    carpeta = carpeta_proyecto(raiz, nombre)
    fecha = ultima(carpeta) if carpeta else None
    n = sesiones_desde(raiz, nombre, fecha)
    return {"cada": cada, "fecha": fecha, "n": n, "toca": n >= cada, "carpeta": carpeta is not None}


def aviso(raiz, nombre):
    m = medir(raiz, nombre)
    if m is None:
        return 0  # el proyecto no declara cadencia: no es de esta magnitud, o no se sumo todavia
    ult = m["fecha"] or "nunca"
    if not m["carpeta"]:
        print("  ! lluvia de ideas: no encuentro la carpeta de %s (proyectos/*/%s): cuento sin fecha" % (nombre, nombre))
    if m["toca"]:
        print("  MOMENTO LLUVIA DE IDEAS: %s lleva %d sesiones auditadas desde la ultima lluvia (%s); umbral %d."
              % (nombre, m["n"], ult, m["cada"]))
        print("    Antes de seguir ejecutando: -Necesidad lluvia-de-ideas y /lluvia-de-ideas (frenar, mirar desde "
              "arriba, de lo fundamental a lo especifico, y buscar afuera lo ya resuelto).")
    else:
        print("  lluvia de ideas: %d de %d sesiones auditadas desde la ultima (%s)." % (m["n"], m["cada"], ult))
    return 0


# ------------------------------------------------------------------------------------------------ autotest
def _repo_sintetico(base):
    (base / ".claude" / "auditorias").mkdir(parents=True)
    for p in ("grande", "chico", "otro", "rande"):
        (base / "proyectos" / "ingenieria" / p / "docs").mkdir(parents=True)
    cat = {"proyectos": {"grande": {"lluvia": {"cada": 3}}, "chico": {}, "otro": {"lluvia": {"cada": 3}},
                         "rande": {"lluvia": {"cada": 1}}}}
    (base / ".claude" / "cascada.json").write_text(json.dumps(cat), encoding="utf-8")
    auds = {"2026-10-01-aaa1.md": "grande", "2026-10-02-bbb2.md": "grande, otro", "2026-10-03-ccc3.md": "grande",
            "2026-10-03-ddd4.md": "otro", "notas.md": "grande"}
    for nombre, proys in auds.items():
        (base / ".claude" / "auditorias" / nombre).write_text(
            "# Auditoria\n\nGenerada.\nProyectos: %s.\n" % proys, encoding="utf-8")


def autotest(ultima=ultima_lluvia):
    """Devuelve la lista de fallos (vacia = verde). Cada caso dice QUE LLEGO, no solo el veredicto."""
    fallos = []
    base = Path(tempfile.mkdtemp(prefix="lluvia-autotest-"))
    try:
        _repo_sintetico(base)
        casos = []
        # 1. control positivo: 3 sesiones de 'grande', sin lluvia previa, umbral 3 -> avisa
        casos.append(("sin lluvia previa, 3 sesiones, umbral 3 -> avisa", "grande", None,
                      {"n": 3, "fecha": None, "toca": True}))
        # 2. negativo: una lluvia del 2026-10-02; solo cuenta la del 03 (la del mismo dia NO) -> no avisa
        casos.append(("lluvia del 02: cuenta solo la sesion del 03 -> no avisa", "grande",
                      "proyectos/ingenieria/grande/docs/07-lluvia-de-ideas-2026-10-02.md",
                      {"n": 1, "fecha": "2026-10-02", "toca": False}))
        # 3. sin cadencia declarada -> el medidor no existe (None)
        casos.append(("proyecto sin cadencia -> nada", "chico", None, None))
        # 4. las sesiones de OTRO proyecto no cuentan
        casos.append(("solo cuentan las sesiones que nombran al proyecto", "otro", None,
                      {"n": 2, "fecha": None, "toca": False}))
        # 5. un nombre contenido en otro ('rande' en 'grande') no cuenta
        casos.append(("'rande' no es 'grande' (subcadena)", "rande", None, {"n": 0, "fecha": None, "toca": False}))
        for titulo, proy, doc, esperado in casos:
            if doc:
                (base / doc).write_text("# lluvia\n", encoding="utf-8")
            try:
                m = medir(base, proy, ultima)
            except Exception as e:  # tres resultados, no dos: verde, rojo, REVENTO
                fallos.append("REVENTO  %s: %s" % (titulo, e))
                print("  [REVENTO] %s: %s" % (titulo, e))
                continue
            llego = None if m is None else {k: m[k] for k in ("n", "fecha", "toca")}
            ok = llego == esperado
            print("  [%s] %s  -- llego %s" % ("OK  " if ok else "ROJO", titulo, llego))
            if not ok:
                fallos.append("ROJO %s: esperaba %s, llego %s" % (titulo, esperado, llego))
    finally:
        shutil.rmtree(base, ignore_errors=True)
    return fallos


def _ultima_saboteada(carpeta):
    """El sabotaje: no reconoce la fecha del nombre (como si el patron se hubiera roto)."""
    return None


def main(argv):
    if len(argv) >= 1 and argv[0] == "--autotest":
        fallos = autotest()
        print("  autotest: %s" % ("VERDE" if not fallos else "ROJO (%d)" % len(fallos)))
        return 0 if not fallos else 1
    if len(argv) >= 1 and argv[0] == "--sabotaje":
        print("  sabotaje: la fecha de la ultima lluvia deja de reconocerse; el autotest TIENE que dar rojo")
        fallos = autotest(_ultima_saboteada)
        if fallos and all(f.startswith("ROJO") for f in fallos):
            print("  sabotaje DETECTADO (%d rojo/s, ninguna caida): la suite ve el defecto" % len(fallos))
            return 0
        print("  sabotaje NO detectado o detectado por otro motivo: la suite es ciega -> %s" % fallos)
        return 1
    if len(argv) == 2 and argv[0] == "aviso":
        return aviso(RAIZ, argv[1])
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
