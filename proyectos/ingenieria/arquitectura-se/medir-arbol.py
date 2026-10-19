"""Mide cuanto pesa cada pieza del conocimiento del metodo, para disenar el arbol (tronco / ramas).

Solo lee; corre desde cualquier carpeta. Diseno y lectura de la salida: docs/t19-arbol-de-conocimiento.md.
"""
import json
import re
import sys
from collections import Counter, defaultdict
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(RAIZ / ".claude" / "hooks"))
import cascada_puerta as cp  # noqa: E402

cat = cp.cargar_catalogo()


def chars(it):
    p = Path(it["ver"])
    lineas = p.read_text(encoding="utf-8", errors="replace").splitlines()
    return sum(len(l) + 1 for l in lineas[it["a"] - 1:it["b"]])


def clase(por):
    if por.startswith("base: nivel 0b"):
        return "tronco: libro de bolsillo"
    if por.startswith("base: los requisitos"):
        return "proyecto: su doc de requisitos"
    if por.startswith("base"):
        return "proyecto: naturaleza+contrato+estado"
    if por.startswith("necesidad"):
        return "rama: necesidad"
    if por.startswith("concepto"):
        return "rama: concepto"
    return "otro"


print("== 1. Lo que la puerta exige al ENTRAR, por proyecto y necesidad (caracteres) ==")
casos = [
    ("arquitectura-se", ["metodo", "diseno"], []),
    ("telescopio", ["diseno"], ["requisitos", "alcance"]),
    ("black", ["ingenieria-inversa"], ["pcsx2"]),
    ("trabajo-final-iise", ["materia"], ["requisitos", "alcance"]),
    ("fisica-espacial", ["materia"], ["typst"]),
    ("coaching", ["ninguna"], []),
]
for proy, necs, conc in casos:
    try:
        items, _, notas = cp.exigido(cat, proy, necs, conc)
    except Exception as e:  # noqa: BLE001
        print("  %s: revento (%s)" % (proy, e))
        continue
    por_clase = defaultdict(int)
    for it in items:
        por_clase[clase(it["por"])] += chars(it)
    total = sum(por_clase.values())
    print("  %-20s %-22s %-22s total %7d" % (proy, ",".join(necs), ",".join(conc) or "-", total))
    for k in sorted(por_clase):
        print("      %-40s %7d" % (k, por_clase[k]))

print()
print("== 2. Cada concepto de la puerta, solo (caracteres) ==")
for c in cat.get("conceptos", {}):
    items, _, _ = cp.exigido(cat, None, [], [c])
    print("  %-12s %7d  (%d lecturas)" % (c, sum(chars(i) for i in items), len(items)))

print()
print("== 3. El nucleo del chequeo (se inyecta en TODA sesion): de que proyecto viene cada vineta ==")
nucleo = (Path.home() / ".claude" / "chequeo-nucleo.md").read_text(encoding="utf-8", errors="replace")
L = [json.loads(l) for l in open(RAIZ / "perfil-global/aprendizaje/lecciones.jsonl", encoding="utf-8") if l.strip()]
norm = lambda s: re.sub(r"\s+", " ", s.lower()).strip()  # noqa: E731
lineas = [norm(l.strip()[2:]) for l in nucleo.splitlines() if l.strip().startswith("- ")]
print("  vinetas en el nucleo: %d, %d caracteres el archivo" % (len(lineas), len(nucleo)))
origen = Counter()
sin = 0
for v in lineas:
    pro = {x.get("proyecto") for x in L if x.get("renglon") and norm(x["renglon"])[:25] and v.startswith(norm(x["renglon"])[:25])}
    if not pro:
        # sin renglon anclado: se busca por las primeras 30 letras del renglon dentro de la regla
        pro = {x.get("proyecto") for x in L if v[:30] and v[:30] in norm(x.get("regla", ""))}
    if not pro:
        sin += 1
        origen["(sin leccion que la ancle)"] += 1
    for p in pro:
        origen[p] += 1
for p, n in origen.most_common():
    print("    %-28s %3d" % (p, n))
print("  (una vineta puede venir de varios proyectos; las sin ancla son reglas generales o heredadas)")

print()
print("== 4. La memoria: el indice se inyecta entero ==")
mem = Path.home() / ".claude/projects/C--Users-frans-Desktop-claude-acceso/memory/MEMORY.md"
txt = mem.read_text(encoding="utf-8")
filas = [l for l in txt.splitlines() if l.startswith("- [")]
temas = Counter()
for f in filas:
    k = f.lower()
    if any(w in k for w in ("black", "rpcs3", "gow3", "pcsx2")):
        temas["juegos / BLACK"] += len(f)
    elif any(w in k for w in ("msi", "bater", "gpu", "onedrive", "last of us", "tlou")):
        temas["maquina / juegos de la PC"] += len(f)
    elif any(w in k for w in ("telescop",)):
        temas["telescopio"] += len(f)
    elif any(w in k for w in ("coaching", "male", "abc", "docente")):
        temas["seguimiento / personas"] += len(f)
    elif any(w in k for w in ("apunte", "materia", "cursada", "unsam", "consigna", "formulas", "fisica", "guias", "tono", "catedra", "profe", "grupo")):
        temas["materias"] += len(f)
    else:
        temas["metodo / como se trabaja"] += len(f)
print("  %d memorias, %d caracteres" % (len(filas), len(txt)))
for t, n in temas.most_common():
    print("    %-28s %6d" % (t, n))
