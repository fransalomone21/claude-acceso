# -*- coding: utf-8 -*-
"""problemas.py -- el registro de problemas tecnicos de cada proyecto, a la vista al entrar (DA-080).

POR QUE EXISTE (2026-10-23). Fran, armando la guia del parcial de TDC: "registra y clasifica los problemas; corregi
sobre la marcha los viables, y los estructurales informalos para otra sesion de correcciones tecnicas". El metodo no
tenia donde: el HANDOFF mezcla estado con defectos y se reescribe en cada cierre, asi que lo estructural que una
sesion encuentra y no arregla se pierde antes de llegar a la sesion que lo puede arreglar. La solucion local
(teoria-circuitos, PROBLEMAS.md) se generaliza: cada proyecto tiene su PROBLEMAS.md (la plantilla la pone
nuevo-proyecto.ps1) y la cascada lista los ABIERTOS al entrar, donde se decide.

EL FORMATO (la interfaz con este script; la plantilla lo trae escrito). Una tabla Markdown cuyo encabezado empieza
    | ID | Clase | Estado | Problema | ...
Clase: contenido, forma, herramienta o metodo. Estado: abierto (para una sesion de correcciones tecnicas),
corregido (con su evidencia en la fila) o descartado (con el motivo). Un problema de clase metodo es tambien un
defecto de arquitectura: se registra con defectos.py y la fila lo nombra (DA-NNN).

    python problemas.py aviso <proyecto>   # lo corre cascada.ps1 al declarar: los abiertos, uno por renglon
    python problemas.py verificar          # rojo (1) si un PROBLEMAS.md tiene un renglon con clase o estado invalido
    python problemas.py --autotest
"""
import io
import os
import re
import sys

RAIZ = os.path.dirname(os.path.abspath(__file__))
CLASES = {"contenido", "forma", "herramienta", "metodo", "método"}
ESTADOS = {"abierto", "corregido", "descartado"}
CABECERA = re.compile(r"^\|\s*ID\s*\|\s*Clase\s*\|\s*Estado\s*\|\s*Problema\s*\|", re.I)


def carpeta(proyecto, raiz=RAIZ):
    base = os.path.join(raiz, "proyectos")
    if os.path.isdir(base):
        for nat in sorted(os.listdir(base)):
            d = os.path.join(base, nat, proyecto)
            if os.path.isdir(d):
                return d
    return None


def celdas(linea):
    return [c.strip() for c in linea.strip().strip("|").split("|")]


def leer(ruta):
    """[(id, clase, estado, problema)] de cada tabla con la cabecera del formato, y [errores]."""
    filas, errores, en_tabla = [], [], False
    for n, l in enumerate(io.open(ruta, encoding="utf-8").read().split("\n"), 1):
        if CABECERA.match(l):
            en_tabla = True
            continue
        if not en_tabla:
            continue
        if not l.strip().startswith("|"):
            en_tabla = False
            continue
        c = celdas(l)
        if len(c) < 4 or set(c[0]) <= set("-: "):
            continue  # la fila de guiones
        id_, clase, estado, problema = c[0], c[1].lower(), c[2].lower().strip("*` "), c[3]
        if clase not in CLASES:
            errores.append("%s:%d %s: clase '%s' (vale %s)" % (ruta, n, id_, c[1], "|".join(sorted(CLASES - {"método"}))))
        if estado not in ESTADOS:
            errores.append("%s:%d %s: estado '%s' (vale %s)" % (ruta, n, id_, c[2], "|".join(sorted(ESTADOS))))
        filas.append((id_, clase, estado, problema))
    return filas, errores


def aviso(proyecto, raiz=RAIZ):
    d = carpeta(proyecto, raiz)
    if d is None:
        return 0
    ruta = os.path.join(d, "PROBLEMAS.md")
    if not os.path.isfile(ruta):
        print("  PROBLEMAS (DA-080): %s no tiene PROBLEMAS.md -- se crea al primer problema con la forma de "
              "plantillas/PROBLEMAS.md" % proyecto)
        return 0
    filas, errores = leer(ruta)
    for e in errores:
        print("  [!] PROBLEMAS.md: " + e)
    # un estado invalido se cuenta ABIERTO: lo que no se sabe leer no se da por cerrado
    abiertos = [f for f in filas if f[2] not in ("corregido", "descartado")]
    if not filas and not errores:
        print("  [!] PROBLEMAS.md de %s sin ninguna fila con la cabecera '| ID | Clase | Estado | Problema |': "
              "la cascada no ve nada (verde por vacio)" % proyecto)
        return 0
    print("  PROBLEMAS ABIERTOS de %s (DA-080): %d de %d en PROBLEMAS.md%s" % (
        proyecto, len(abiertos), len(filas), " -- para una sesion de correcciones tecnicas:" if abiertos else ""))
    for id_, clase, estado, problema in abiertos:
        txt = re.sub(r"\s+", " ", re.sub(r"[*`]", "", problema))
        print("    %s [%s] %s" % (id_, clase, txt[:110] + ("..." if len(txt) > 110 else "")))
    return 0


def todos(raiz=RAIZ):
    base = os.path.join(raiz, "proyectos")
    for nat in sorted(os.listdir(base)) if os.path.isdir(base) else []:
        for p in sorted(os.listdir(os.path.join(base, nat))):
            r = os.path.join(base, nat, p, "PROBLEMAS.md")
            if os.path.isfile(r):
                yield p, r


def verificar(raiz=RAIZ):
    n, malos = 0, []
    for p, r in todos(raiz):
        filas, errores = leer(r)
        n += 1
        malos += errores
        if not filas and not errores:
            malos.append("%s: sin ninguna fila con la cabecera del formato (la cascada no ve nada)" % r)
    for m in malos:
        print("[ROJO] " + m)
    print("problemas: %d registro(s) de proyecto, %d renglon(es) mal formado(s)" % (n, len(malos)))
    return 1 if malos else 0


def autotest():
    import shutil
    import tempfile
    from contextlib import redirect_stdout
    d = tempfile.mkdtemp(prefix="problemas-")
    mal = []

    def caso(nombre, bien):
        print("%s %s" % ("BIEN" if bien else "MAL", nombre))
        if not bien:
            mal.append(nombre)

    def correr(f, *a):
        buf = io.StringIO()
        with redirect_stdout(buf):
            rc = f(*a)
        return rc, buf.getvalue()

    try:
        p = os.path.join(d, "proyectos", "documentos", "demo")
        os.makedirs(p)
        cab = "| ID | Clase | Estado | Problema | Como se vio | Arreglo |\n|---|---|---|---|---|---|\n"
        io.open(os.path.join(p, "PROBLEMAS.md"), "w", encoding="utf-8").write(
            "# Problemas\n\n" + cab +
            "| P1 | forma | corregido | una coma | render | comillas |\n"
            "| S3 | herramienta | abierto | la biblioteca vive en **otro repo** | clon | copiarla |\n"
            "| S5 | contenido | descartado | sin lector | - | - |\n")
        rc, out = correr(aviso, "demo", d)
        caso("lista el abierto y no el corregido ni el descartado",
             "S3 [herramienta] la biblioteca vive en otro repo" in out and "P1" not in out and "S5" not in out
             and "1 de 3" in out)
        rc, out = correr(verificar, d)
        caso("verificar en verde sobre un registro sano", rc == 0)
        # sabotaje: un estado invalido es rojo en verificar Y se lista como abierto (no se da por cerrado)
        io.open(os.path.join(p, "PROBLEMAS.md"), "a", encoding="utf-8").write("| S9 | forma | resuelto | algo | x | y |\n")
        rc, out = correr(verificar, d)
        caso("verificar en ROJO con un estado invalido, nombrando la fila", rc == 1 and "S9" in out and "resuelto" in out)
        rc, out = correr(aviso, "demo", d)
        caso("el estado invalido se lista como abierto", "S9 [forma]" in out and "[!] PROBLEMAS.md" in out)
        # sabotaje: la cabecera fuera de formato deja la tabla invisible -> rojo, no verde por vacio
        io.open(os.path.join(p, "PROBLEMAS.md"), "w", encoding="utf-8").write("| # | Clase | Problema |\n|---|---|---|\n| S1 | forma | x |\n")
        rc, out = correr(verificar, d)
        caso("una tabla sin la cabecera del formato es ROJO (verde por vacio)", rc == 1 and "sin ninguna fila" in out)
        # sin archivo: la cascada lo dice, no calla
        os.remove(os.path.join(p, "PROBLEMAS.md"))
        rc, out = correr(aviso, "demo", d)
        caso("sin PROBLEMAS.md la cascada lo dice", "no tiene PROBLEMAS.md" in out)
        # la plantilla real cumple el formato (la que copia nuevo-proyecto.ps1)
        plant = os.path.join(RAIZ, "plantillas", "PROBLEMAS.md")
        io.open(os.path.join(p, "PROBLEMAS.md"), "w", encoding="utf-8").write(io.open(plant, encoding="utf-8").read())
        rc, out = correr(verificar, d)
        caso("la plantilla real pasa verificar", rc == 0)
    finally:
        shutil.rmtree(d, ignore_errors=True)
    print("autotest: %s" % ("BIEN" if not mal else "MAL (%s)" % ", ".join(mal)))
    return 0 if not mal else 1


if __name__ == "__main__":
    a = sys.argv[1:]
    if a == ["--autotest"]:
        sys.exit(autotest())
    if a[:1] == ["aviso"] and len(a) == 2:
        sys.exit(aviso(a[1]))
    if a == ["verificar"]:
        sys.exit(verificar())
    print(__doc__)
    sys.exit(2)
