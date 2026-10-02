#!/usr/bin/env python3
"""coop_diseno.py -- mide que el plano del COOP (docs/14-coop-diseno.md) y el mod no se separen (PDP §4, COOP-B).

    python herramientas/coop_diseno.py verificar [--doc RUTA] [--mods CARPETA]

Lee el bloque ```coop-rangos del documento y exige, en este orden:
  1. cada programa de coop_mod.programas() (salvo los ganchos) tiene una fila de CODIGO/DATOS con el mismo
     rango [desde, hasta): si el codigo crecio y el plano no, rojo;
  2. cada gancho que escribe el mod (incluidos los de la escena de pantalla_dividida.py) cae en una fila
     de tipo gancho o en un sitio de la escena declarado en la fuente;
  3. ningun par de filas se pisa;
  4. ninguna `direccion = 0x...` de los otros mods de mods/ cae en un rango del coop;
  5. toda fila tiene fuente: una entrada `(NN)` (o `(NN, nube)`) que existe en docs/03-bitacora.md, o un archivo de kb/;
  6. (104) el bloque ```coop-plan-b (el DISENO de COOP-B, todavia sin codigo): sus filas no se pisan entre si
     ni con coop-rangos; cada `gancho` espera en el ELF la instruccion que declara (varias separadas por `;`
     para palabras seguidas), porque el diseno se apoya en ella; y cada fila tiene fuente como en 5;
  7. (111) la IA (coop_ia.py) esta PRENDIDA por defecto en coop_mod (decision del 2026-10-02) y cada sitio suyo
     tiene en el ELF la instruccion que reemplaza; su codigo y sus ganchos ya viven en coop-rangos (reglas 1-3).
     Hasta (110) era: el codigo cae en su reserva del plan.
Sale 0 si todo esta bien y 1 si algo falla (y dice que). Su saboteador: pruebas/probar-coop-diseno.py.
"""
import argparse
import re
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(RAIZ / "herramientas"))


def leer_rangos(doc: Path):
    t = doc.read_text(encoding="utf-8")
    m = re.search(r"```coop-rangos\n(.*?)```", t, re.S)
    if not m:
        return None
    filas = []
    for l in m.group(1).splitlines():
        if not l.strip() or l.lstrip().startswith("#"):
            continue
        c = [x.strip() for x in l.split("|")]
        filas.append({"nombre": c[0], "desde": int(c[1], 16), "hasta": int(c[2], 16), "tipo": c[3], "fuente": c[4]})
    return filas


def verificar(doc: Path, mods: Path) -> list[str]:
    import coop_mod as cm
    import pantalla_dividida as pd
    errores = []
    filas = leer_rangos(doc)
    if not filas:
        return ["no hay bloque coop-rangos en %s" % doc]
    cm.SIN_R3 = False   # (93v) el plano describe el mod entero, con la ranura 3 (apagada por defecto al instalar)
    con_ia_por_defecto = cm.CON_IA
    cm.CON_IA = True    # (111) y con la IA, que ademas tiene que estar prendida por defecto (regla 7)
    errores += verificar_ia(con_ia_por_defecto)
    progs = cm.programas()
    # 1. los programas contra el plano
    for nombre, prog in progs[:-1]:
        desde, hasta = min(pc for pc, _, _ in prog), max(pc for pc, _, _ in prog) + 4
        if not any(f["tipo"] in ("codigo", "datos") and f["desde"] <= desde and hasta <= f["hasta"] and
                   (f["tipo"] == "datos" or (f["desde"], f["hasta"]) == (desde, hasta)) for f in filas):
            errores.append("programa '%s' [%#x, %#x) sin fila que lo declare igual" % (nombre, desde, hasta))
    # 2. los ganchos
    escena = set(pd.SITIOS)
    for pc, _, texto in progs[-1][1]:
        if pc in escena:
            continue
        if not any(f["tipo"] == "gancho" and f["desde"] <= pc < f["hasta"] for f in filas):
            errores.append("gancho %#x (%s) sin fila" % (pc, texto))
    # 3. solapes entre filas (y con los sitios de la escena)
    todos = filas + [{"nombre": "sitio de la escena %#x" % s, "desde": s, "hasta": s + 4, "tipo": "gancho",
                      "fuente": "pantalla_dividida.py"} for s in escena]
    for i, a in enumerate(todos):
        for b in todos[i + 1:]:
            if a["desde"] < b["hasta"] and b["desde"] < a["hasta"]:
                errores.append("se pisan '%s' y '%s'" % (a["nombre"], b["nombre"]))
    # 4. los otros mods
    for toml in sorted(mods.glob("*.toml")):
        if toml.name in ("coop.toml", "ejemplo-plantilla.toml"):
            continue
        for m in re.finditer(r"(?m)^\s*direccion\s*=\s*(0x[0-9A-Fa-f]+)", toml.read_text(encoding="utf-8")):
            d = int(m.group(1), 16)
            for f in todos:
                if f["desde"] <= d < f["hasta"]:
                    errores.append("%s escribe %#x, dentro de '%s'" % (toml.name, d, f["nombre"]))
    # 5. fuentes
    bit = (RAIZ / "docs" / "03-bitacora.md").read_text(encoding="utf-8")
    for f in filas:
        m = re.fullmatch(r"\((\d+[a-z]?)\)", f["fuente"])
        if m:
            if not re.search(r"(?m)^#{2,3} .*\(%s(?:, [^)]*)?\)" % re.escape(m.group(1)), bit):
                errores.append("'%s': la entrada %s no esta en la bitacora" % (f["nombre"], f["fuente"]))
        elif not (f["fuente"].startswith("kb/") and (RAIZ / f["fuente"]).exists()):
            errores.append("'%s': fuente '%s' no es (NN) ni un archivo de kb/" % (f["nombre"], f["fuente"]))
    errores += verificar_plan(doc, todos, bit)
    return errores


def leer_plan(doc: Path):
    t = doc.read_text(encoding="utf-8")
    m = re.search(r"```coop-plan-b\n(.*?)```", t, re.S)
    if not m:
        return None
    filas = []
    for l in m.group(1).splitlines():
        if not l.strip() or l.lstrip().startswith("#"):
            continue
        c = [x.strip() for x in l.split("|")]
        filas.append({"nombre": c[0], "desde": int(c[1], 16), "hasta": int(c[2], 16), "tipo": c[3],
                      "espera": c[4], "fuente": c[5]})
    return filas


def verificar_plan(doc: Path, rangos, bit) -> list[str]:
    from mips import desensamblar
    from perfil_singleton import palabra_elf
    plan = leer_plan(doc)
    if plan is None:
        return ["no hay bloque coop-plan-b en %s" % doc]
    errores = []
    for i, a in enumerate(plan):
        if a["tipo"] not in ("gancho", "reserva"):
            errores.append("plan '%s': tipo '%s' (gancho o reserva)" % (a["nombre"], a["tipo"]))
        for b in plan[i + 1:] + rangos:
            if a["desde"] < b["hasta"] and b["desde"] < a["hasta"]:
                errores.append("plan: se pisan '%s' y '%s'" % (a["nombre"], b["nombre"]))
        m = re.fullmatch(r"\((\d+[a-z]?)\)", a["fuente"])
        if not m or not re.search(r"(?m)^#{2,3} .*\(%s(?:, [^)]*)?\)" % re.escape(m.group(1)), bit):
            errores.append("plan '%s': fuente '%s' no esta en la bitacora" % (a["nombre"], a["fuente"]))
        if a["tipo"] == "gancho":
            for k, esp in enumerate(x.strip() for x in a["espera"].split(";")):
                pc = a["desde"] + 4 * k
                w = palabra_elf(pc)
                real = desensamblar(w, pc) if w is not None else "(sin ELF)"
                if " ".join(real.lower().split()) != " ".join(esp.lower().split()):
                    errores.append("plan '%s': en %#x el ELF tiene '%s', el diseno espera '%s'"
                                   % (a["nombre"], pc, real, esp))
    return errores


def verificar_ia(con_ia_por_defecto) -> list[str]:
    """(111) regla 7: la IA es parte del mod POR DEFECTO (decision del 2026-10-02) y sus sitios tienen en el ELF
    la instruccion que el codigo reemplaza. Sus rangos y ganchos los miden las reglas 1-3, porque viven en coop-rangos."""
    from mips import desensamblar
    from perfil_singleton import palabra_elf
    import coop_ia
    errores = [] if con_ia_por_defecto else ["coop_mod.CON_IA apagada por defecto: el acceso COOP instalaria sin la IA"]
    for pc, _, texto in coop_ia.ganchos():
        w = palabra_elf(pc)
        real = " ".join((desensamblar(w, pc) if w is not None else "(sin ELF)").split())
        if real.lower() != coop_ia.ORIGINAL[pc].lower():
            errores.append("gancho de la IA %#x (%s): el ELF tiene '%s', se esperaba '%s'"
                           % (pc, texto, real, coop_ia.ORIGINAL[pc]))
    return errores


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    v = sub.add_parser("verificar")
    v.add_argument("--doc", type=Path, default=RAIZ / "docs" / "14-coop-diseno.md")
    v.add_argument("--mods", type=Path, default=RAIZ / "mods")
    a = ap.parse_args(argv)
    errores = verificar(a.doc, a.mods)
    for e in errores:
        print("ROJO:", e)
    print("coop_diseno: %d problema(s)" % len(errores))
    return 1 if errores else 0


if __name__ == "__main__":
    sys.exit(main())
