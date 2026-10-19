# -*- coding: utf-8 -*-
"""uso-lecturas.py -- el lazo de uso de T19 (pieza D): que lecturas exigidas no se usan, y la decision de Fran.

Fran (2026-10-19, proyectos/ingenieria/arquitectura-se/docs/t19-arbol-de-conocimiento.md sec. 3-4): leer de mas hasta
que el uso diga que sobra; lo que sobra se le propone y sale SOLO con su si. El sensor es lo que cada sesion declara al
cerrar (auditar-sesion.py --uso), que la auditoria guarda como una muestra por clase de sesion en
.claude/auditorias/uso-lecturas.jsonl. Esta herramienta las acumula por clase y propone; la decision de Fran va a
.claude/retiro-lecturas.jsonl con sus palabras. Requisitos: L2-USO-01..07 de
proyectos/ingenieria/arquitectura-se/docs/10-requisitos.md sec. 13.

Limite declarado (DA-043): el sensor es lo que la sesion dice de si misma. Una sesion que declara haber usado todo
calla el lazo; una que no declara no cuenta (no es una muestra: un sensor ciego veria todo sin uso).

  python uso-lecturas.py proponer [--clase C | --proyecto P]   las propuestas; la cascada las imprime al declarar
  python uso-lecturas.py decidir --clase C --ruta R --si|--no --fran "lo que dijo Fran, textual"
  python uso-lecturas.py verificar        el medidor (capa rapida de chequeo-completo): sale 1 si hay ROJO
  python uso-lecturas.py --autotest
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import time
from pathlib import Path

RAIZ = Path(os.environ.get("USO_LECTURAS_RAIZ") or Path(__file__).resolve().parent)
REG_USO = Path(".claude") / "auditorias" / "uso-lecturas.jsonl"   # lo escribe auditar-sesion.py (L2-AUD-12)
REG_DEC = Path(".claude") / "retiro-lecturas.jsonl"
VENTANA = 5   # TBR (L1-27): lo fija la primera vuelta del lazo
CLAVES_MUESTRA = ("sesion", "fecha", "clase")


def leer(f: Path) -> tuple:
    """(renglones, errores). Un renglon ilegible es un error con su archivo y su numero, nunca un salteo (L2-USO-07)."""
    out, err = [], []
    if not f.exists():
        return out, err
    for n, l in enumerate(f.read_text(encoding="utf-8").splitlines(), 1):
        if not l.strip():
            continue
        try:
            x = json.loads(l)
            if not isinstance(x, dict):
                raise ValueError("no es un objeto")
        except ValueError as e:
            err.append("%s:%d ilegible (%s)" % (f.name, n, e))
            continue
        x["_n"] = n
        out.append(x)
    return out, err


def falla_muestra(x: dict) -> str:
    if not all(isinstance(x.get(k), str) and x.get(k) for k in CLAVES_MUESTRA):
        return "le falta sesion, fecha o clase"
    if not isinstance(x.get("exigidas"), list) or not isinstance(x.get("usadas"), list):
        return "le falta la lista de exigidas o de usadas"
    if any(not isinstance(e, dict) or not e.get("ruta") for e in x["exigidas"]):
        return "una exigida sin ruta"
    return ""


def falla_decision(x: dict) -> str:
    if x.get("veredicto") not in ("si", "no"):
        return "el veredicto no es si ni no"
    if not str(x.get("fran", "")).strip():
        return "sin las palabras de Fran"
    if not all(x.get(k) for k in ("fecha", "clase", "ruta")):
        return "sin fecha, clase o ruta"
    return ""


def cargar(raiz: Path = RAIZ) -> tuple:
    """(muestras, decisiones, errores). Lo mal formado es error y queda afuera: el medidor lo dice en ROJO."""
    mu, e1 = leer(raiz / REG_USO)
    de, e2 = leer(raiz / REG_DEC)
    err = e1 + e2
    err += ["%s:%d %s" % (REG_USO.name, x["_n"], falla_muestra(x)) for x in mu if falla_muestra(x)]
    err += ["%s:%d %s" % (REG_DEC.name, x["_n"], falla_decision(x)) for x in de if falla_decision(x)]
    return [x for x in mu if not falla_muestra(x)], [x for x in de if not falla_decision(x)], err


def propuestas(muestras: list, decisiones: list, clase: str | None = None, ventana: int = VENTANA) -> list:
    """L2-USO-01 y L2-USO-05. Por clase y lectura: las muestras de la clase que la exigieron despues de su ultimo uso y
    de la ultima decision de Fran sobre ella; si son la ventana o mas y ninguna la uso, es una propuesta."""
    por_clase = {}
    for m in sorted(muestras, key=lambda x: (x["fecha"], x["sesion"])):
        por_clase.setdefault(m["clase"], []).append(m)
    ult = {}
    for d in decisiones:
        k = (d["clase"], d["ruta"])
        ult[k] = max(ult.get(k, ""), d["fecha"])
    out = []
    for c, ms in sorted(por_clase.items()):
        if clase and c != clase:
            continue
        rutas = {}
        for m in ms:
            for e in m["exigidas"]:
                rutas[e["ruta"]] = e.get("por", "")   # el motivo mas reciente: el catalogo pudo cambiarlo
        for r, por in sorted(rutas.items()):
            desde, sin, primera = ult.get((c, r), ""), 0, ""
            for m in ms:
                if m["fecha"] <= desde:
                    continue
                if r in m["usadas"]:
                    sin, primera = 0, ""
                elif any(e["ruta"] == r for e in m["exigidas"]):
                    sin, primera = sin + 1, primera or m["fecha"]
            if sin >= ventana:
                out.append({"clase": c, "ruta": r, "sin_uso": sin, "desde": primera, "por": por})
    return out


def clase_de_proyecto(proyecto: str, raiz: Path = RAIZ) -> str | None:
    """La Clase_De_Uso de un proyecto: su naturaleza es la carpeta donde vive (la misma regla que la puerta)."""
    for nat in sorted((raiz / "proyectos").glob("*")):
        if (nat / proyecto).is_dir():
            return "proyecto:" + nat.name
    return None


def proponer(raiz: Path = RAIZ, clase: str | None = None) -> int:
    mu, de, err = cargar(raiz)
    for e in err:
        print("  [ROJO] lazo de uso: %s" % e)
    pr = propuestas(mu, de, clase)
    n = sum(1 for m in mu if not clase or m["clase"] == clase)
    print("  LAZO DE USO (T19, pieza D) -- %s: %d muestra(s) con uso declarado, ventana %d; %d propuesta(s) de retiro"
          % (clase or "todas las clases", n, VENTANA, len(pr)))
    for p in pr:
        print("    PROPUESTA para Fran: %s sin uso en %d sesiones de %s (desde %s); se exige por: %s"
              % (p["ruta"], p["sin_uso"], p["clase"], p["desde"], p["por"]))
        print('      decide Fran (la sesion lo lleva al cuadro): python uso-lecturas.py decidir --clase %s --ruta "%s" '
              '--si|--no --fran "<sus palabras>"' % (p["clase"], p["ruta"]))
    return 1 if err else 0


def decidir(clase: str, ruta: str, si: bool, fran: str, raiz: Path = RAIZ, ahora: str | None = None) -> str:
    """L2-USO-03 y L2-USO-04. Devuelve '' si quedo registrada; si no, por que se rechazo."""
    mu, _, err = cargar(raiz)
    if err:
        return "rechazada: el registro tiene renglones ilegibles; arreglarlos antes (%s)" % err[0]
    if not fran.strip():
        return "rechazada (L2-USO-04): sin las palabras de Fran (--fran \"...\", textuales)"
    r = ruta.strip().lower().replace("\\", "/")
    if not any(m["clase"] == clase and any(e["ruta"] == r for e in m["exigidas"]) for m in mu):
        return "rechazada (L2-USO-04): %s no figura como lectura exigida de la clase %s en ninguna muestra" % (r, clase)
    linea = {"fecha": ahora or time.strftime("%Y-%m-%d %H:%M:%S"), "clase": clase, "ruta": r,
             "veredicto": "si" if si else "no", "fran": fran.strip()}
    salida = (json.dumps(linea, ensure_ascii=False) + "\n").encode("utf-8")
    with open(raiz / REG_DEC, "ab") as fh:
        fh.write(salida)
    return ""


def medir(raiz: Path = RAIZ) -> tuple:
    """(rojos, resumen). L2-USO-06 y L2-USO-07; las propuestas pendientes son informacion, no rojo (L2-USO-02)."""
    mu, de, err = cargar(raiz)
    rojos = list(err)
    for d in de:
        if d["veredicto"] != "si":
            continue
        tarde = [m for m in mu if m["clase"] == d["clase"] and m["fecha"] > d["fecha"]
                 and any(e["ruta"] == d["ruta"] for e in m["exigidas"])]
        if tarde:
            rojos.append("retiro aprobado por Fran el %s y sin aplicar: la sesion %s (%s) todavia tuvo exigida %s en "
                         "la clase %s; sacarla del catalogo (.claude/cascada.json) (L2-USO-06)"
                         % (d["fecha"], tarde[0]["sesion"][:8], tarde[0]["fecha"], d["ruta"], d["clase"]))
    pr = propuestas(mu, de)
    clases = sorted({m["clase"] for m in mu})
    resumen = ("lazo de uso: %d muestra(s) (%s), %d decision(es) de Fran, %d propuesta(s) pendiente(s)%s"
               % (len(mu), ", ".join("%s %d" % (c, sum(1 for m in mu if m["clase"] == c)) for c in clases) or "ninguna",
                  len(de), len(pr), " -- python uso-lecturas.py proponer" if pr else ""))
    return rojos, resumen


def verificar(raiz: Path = RAIZ) -> int:
    rojos, resumen = medir(raiz)
    for r in rojos:
        print("ROJO: " + r)
    print(resumen)
    return 1 if rojos else 0


# ------------------------------------------------------------------------------------------------ autotest
def autotest() -> int:
    import shutil
    import tempfile
    mal = 0

    def caso(nombre, ok, detalle=""):
        nonlocal mal
        mal += not ok
        print("%s  %-74s %s" % ("ok " if ok else "MAL", nombre, "" if ok else "-> " + str(detalle)[:200]))

    def muestra(i, clase="proyecto:ingenieria", usadas=("a.md",), exigidas=("a.md", "b.md")):
        return {"sesion": "s%02d" % i, "fecha": "2026-10-%02d 10:00:00" % i, "clase": clase,
                "exigidas": [{"ruta": r, "por": "base: %s" % r} for r in exigidas], "usadas": list(usadas)}

    def rutas(pr):
        return sorted((p["clase"], p["ruta"], p["sin_uso"]) for p in pr)

    # L2-USO-01: la ventana
    m5 = [muestra(i) for i in range(1, 6)]
    caso("USO-01: b.md exigida y sin uso en 5 muestras -> propuesta; a.md usada -> no",
         rutas(propuestas(m5, [])) == [("proyecto:ingenieria", "b.md", 5)], propuestas(m5, []))
    caso("CONTROL: con 4 muestras no hay propuesta (la ventana es 5)", propuestas(m5[:4], []) == [])
    reset = m5[:2] + [muestra(3, usadas=("a.md", "b.md"))] + [muestra(i) for i in range(4, 8)]
    caso("CONTROL: un uso en el medio reinicia la cuenta (4 sin uso despues) -> no",
         propuestas(reset, []) == [], propuestas(reset, []))
    caso("USO-01: la quinta sin uso despues del uso -> propuesta",
         rutas(propuestas(reset + [muestra(8)], [])) == [("proyecto:ingenieria", "b.md", 5)])
    otra = [muestra(i, clase="ingenieria") for i in range(1, 6)] + m5[:2]
    caso("CONTROL: las muestras de OTRA clase no cuentan para esta",
         rutas(propuestas(otra, [])) == [("ingenieria", "b.md", 5)], rutas(propuestas(otra, [])))
    caso("CONTROL: --clase filtra", propuestas(otra + m5, [], clase="ingenieria")
         and all(p["clase"] == "ingenieria" for p in propuestas(otra + m5, [], clase="ingenieria")))
    # L2-USO-05: la decision de Fran reinicia la ventana
    no = [{"fecha": "2026-10-05 12:00:00", "clase": "proyecto:ingenieria", "ruta": "b.md", "veredicto": "no",
           "fran": "no, dejala"}]
    caso("USO-05: un 'no' de Fran calla la propuesta", propuestas(m5, no) == [], propuestas(m5, no))
    m10 = m5 + [muestra(i) for i in range(6, 11)]
    caso("USO-05: y vuelve con otras 5 sin uso despues de la decision",
         rutas(propuestas(m10, no)) == [("proyecto:ingenieria", "b.md", 5)], rutas(propuestas(m10, no)))
    # L2-USO-03/04: decidir, sobre una raiz sintetica
    tmp = Path(tempfile.mkdtemp(prefix="uso-lecturas-"))
    (tmp / REG_USO).parent.mkdir(parents=True)
    (tmp / REG_USO).write_text("\n".join(json.dumps(m) for m in m5) + "\n", encoding="utf-8")
    r = decidir("proyecto:ingenieria", "b.md", True, "  ", tmp)
    caso("USO-04: sin las palabras de Fran -> rechazada", r.startswith("rechazada") and "palabras" in r, r)
    r = decidir("proyecto:ingenieria", "c.md", True, "si, sacala", tmp)
    caso("USO-04: una lectura que ninguna muestra exigio -> rechazada", r.startswith("rechazada") and "c.md" in r, r)
    caso("CONTROL: lo rechazado no escribe nada", not (tmp / REG_DEC).exists())
    r = decidir("proyecto:ingenieria", "B.md", True, "si, sacala del tronco", tmp, ahora="2026-10-06 09:00:00")
    d, err = leer(tmp / REG_DEC)
    caso("USO-03: la decision queda con fecha, clase, lectura, veredicto y las palabras de Fran",
         r == "" and not err and len(d) == 1 and d[0]["ruta"] == "b.md" and d[0]["veredicto"] == "si"
         and d[0]["fran"] == "si, sacala del tronco" and d[0]["fecha"] == "2026-10-06 09:00:00", (r, d))
    # L2-USO-06/07: el medidor
    rojos, res = medir(tmp)
    caso("CONTROL: aprobado y sin muestras posteriores -> sin rojo", rojos == [], rojos)
    with open(tmp / REG_USO, "a", encoding="utf-8") as fh:
        fh.write(json.dumps(muestra(7)) + "\n")
    rojos, _ = medir(tmp)
    caso("USO-06: una muestra posterior al si todavia la exige -> ROJO",
         len(rojos) == 1 and "sin aplicar" in rojos[0] and "b.md" in rojos[0], rojos)
    with open(tmp / REG_USO, "a", encoding="utf-8") as fh:
        fh.write(json.dumps(muestra(8, exigidas=("a.md",))) + "\n")
    lin = (tmp / REG_USO).read_text(encoding="utf-8").splitlines()
    (tmp / REG_USO).write_text("\n".join([l for l in lin if '"s07"' not in l]) + "\n", encoding="utf-8")
    rojos, _ = medir(tmp)
    caso("CONTROL: aplicado (la muestra posterior ya no la exige) -> sin rojo", rojos == [], rojos)
    with open(tmp / REG_USO, "a", encoding="utf-8") as fh:
        fh.write("{roto\n")
    rojos, _ = medir(tmp)
    caso("USO-07: un renglon ilegible -> ROJO con el archivo y el renglon",
         any("uso-lecturas.jsonl:" in r and "ilegible" in r for r in rojos), rojos)
    caso("USO-07: con el registro roto, decidir se rechaza", decidir("proyecto:ingenieria", "a.md", False, "no", tmp)
         .startswith("rechazada"))
    (tmp / REG_DEC).write_text(json.dumps({"fecha": "2026-10-06 09:00:00", "clase": "x", "ruta": "b.md",
                                           "veredicto": "si", "fran": ""}) + "\n", encoding="utf-8")
    _, _, err = cargar(tmp)
    caso("USO-07: una decision sin las palabras de Fran (escrita a mano) -> ROJO",
         any("retiro-lecturas.jsonl:1" in e and "palabras" in e for e in err), err)
    # la clase de un proyecto sale de la carpeta donde vive
    (tmp / "proyectos" / "documentos" / "demo-apunte").mkdir(parents=True)
    caso("CONTROL: la clase de un proyecto es su naturaleza", clase_de_proyecto("demo-apunte", tmp) == "proyecto:documentos"
         and clase_de_proyecto("no-existe", tmp) is None)
    shutil.rmtree(tmp, ignore_errors=True)
    print("autotest: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="El lazo de uso de T19: propuestas de retiro y la decision de Fran.")
    ap.add_argument("accion", nargs="?", choices=("proponer", "decidir", "verificar"))
    ap.add_argument("--clase")
    ap.add_argument("--proyecto")
    ap.add_argument("--ruta")
    ap.add_argument("--si", action="store_true")
    ap.add_argument("--no", action="store_true")
    ap.add_argument("--fran", default="")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        sys.exit(autotest())
    if a.accion == "proponer":
        c = a.clase or (clase_de_proyecto(a.proyecto) if a.proyecto else None)
        if a.proyecto and not c:
            print("  [ROJO] lazo de uso: el proyecto %s no esta en proyectos/<naturaleza>/" % a.proyecto)
            sys.exit(1)
        sys.exit(proponer(clase=c))
    if a.accion == "decidir":
        if not a.clase or not a.ruta or a.si == a.no:
            print("uso: decidir --clase C --ruta R (--si | --no) --fran \"lo que dijo Fran\"")
            sys.exit(2)
        r = decidir(a.clase, a.ruta, a.si, a.fran)
        if r:
            print(r)
            sys.exit(1)
        print("registrada: %s en %s -> %s. %s" % (a.ruta, a.clase, "SI" if a.si else "NO",
                                                  "Aplicarla en .claude/cascada.json y commitear los dos." if a.si else
                                                  "La cuenta vuelve a empezar desde hoy."))
        sys.exit(0)
    if a.accion == "verificar":
        sys.exit(verificar())
    ap.print_help()
    sys.exit(2)
