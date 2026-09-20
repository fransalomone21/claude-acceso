#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probar-verificar-lexico.py -- el saboteador de verificar-lexico.py.

Un verificador que nunca fallo esta sin verificar (regla 3 del perfil). Este
script rompe CADA UNO de los tres chequeos a proposito y exige ver el rojo,
y ademas corre el control positivo: sobre el arbol intacto tiene que dar
verde. Sin esa segunda mitad, un script que devolviera 1 siempre pasaria
esta prueba.

SE TRABAJA SOBRE UNA COPIA, NO SOBRE EL ARBOL REAL. Eso no es prolijidad:
es la leccion de `probar-chequeo-lecciones.ps1`, que restauraba el archivo
fuente y dejaba la copia instalada con el sabotaje adentro. Aca el arbol
vivo no se toca en ningun momento, asi que no hay nada que restaurar y no
hay forma de dejar suciedad.

Uso:
    python probar-verificar-lexico.py
"""

import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

AQUI = Path(__file__).resolve().parent
VERIFICADOR = AQUI / "verificar-lexico.py"


def armar_copia(destino):
    """Copia a `destino` lo unico que el verificador mira: el glosario y los
    modulos. Si manana mira algo mas, esta funcion es el unico lugar que se
    toca."""
    (destino / "fuentes").mkdir(parents=True, exist_ok=True)
    shutil.copy2(AQUI / "fuentes" / "glosario.md", destino / "fuentes" / "glosario.md")
    for sub in ("modulos", "anexos"):
        origen = AQUI / "apunte" / sub
        if origen.is_dir():
            shutil.copytree(origen, destino / "apunte" / sub)


def correr(raiz):
    r = subprocess.run(
        [sys.executable, str(VERIFICADOR), "--raiz", str(raiz)],
        capture_output=True, text=True, encoding="utf-8", errors="replace",
    )
    return r.returncode, (r.stdout or "") + (r.stderr or "")


def modulo_cualquiera(raiz):
    """Un .typ sobre el que sabotear. Devuelve None si todavia no hay
    ninguno: en ese caso los sabotajes (a) y (b) no se pueden probar y el
    script lo DICE, en vez de darlos por buenos."""
    d = raiz / "apunte" / "modulos"
    if not d.is_dir():
        return None
    archivos = sorted(d.glob("*.typ"))
    return archivos[0] if archivos else None


def sabotaje_a(raiz):
    """(a) un termino marcado que no esta en el glosario."""
    arch = modulo_cualquiera(raiz)
    if arch is None:
        return None
    arch.write_text(
        arch.read_text(encoding="utf-8")
        + "\n\nEsto es un #t[termino inventado por el saboteador] y no existe.\n",
        encoding="utf-8",
    )
    return "termino #t[] sin entrada en el glosario"


def sabotaje_b(raiz):
    """(b) una palabra del par prohibido, sin declarar la excepcion."""
    arch = modulo_cualquiera(raiz)
    if arch is None:
        return None
    arch.write_text(
        arch.read_text(encoding="utf-8")
        + "\n\nEl sistema debe cumplir el requisito del stakeholder.\n",
        encoding="utf-8",
    )
    return "palabra prohibida ('requisito', 'stakeholder')"


def sabotaje_c(raiz):
    """(c) el mismo termino definido dos veces en el glosario."""
    g = raiz / "fuentes" / "glosario.md"
    g.write_text(
        g.read_text(encoding="utf-8")
        + "\n### sistema\n**Definicion.** Una segunda definicion, que contradice a la primera.\n",
        encoding="utf-8",
    )
    return "termino 'sistema' definido dos veces"


def sabotaje_excepcion(raiz):
    """Control positivo fino: la MISMA palabra prohibida, pero con la
    excepcion declarada, tiene que seguir dando VERDE. Si no, el marcador no
    sirve y el modulo 0 -- que nombra las palabras que no se usan -- no se
    puede escribir."""
    arch = modulo_cualquiera(raiz)
    if arch is None:
        return None
    arch.write_text(
        arch.read_text(encoding="utf-8")
        + "\n\nNo se dice requisito ni stakeholder.  // lexico-ok: la tabla del lexico\n",
        encoding="utf-8",
    )
    return "palabra prohibida CON excepcion declarada"


def main():
    print("SABOTEADOR DE verificar-lexico.py")
    print("")

    fallos = []
    saltados = []

    # --- Control positivo: el arbol intacto tiene que dar VERDE ---
    with tempfile.TemporaryDirectory() as tmp:
        raiz = Path(tmp)
        armar_copia(raiz)
        hay_modulos = modulo_cualquiera(raiz) is not None
        codigo, salida = correr(raiz)
        if hay_modulos and codigo == 0:
            print("[OK  ] control positivo: el arbol intacto da VERDE")
        elif not hay_modulos and codigo == 1 and "SIN MODULOS" in salida:
            print("[OK  ] control positivo: sin modulos, avisa en vez de dar verde vacio")
        else:
            fallos.append("el control positivo no dio lo esperado (codigo=%d)" % codigo)
            print("[FAIL] control positivo: codigo=%d" % codigo)
            print(salida)

    # --- Los tres sabotajes: cada uno tiene que dar ROJO ---
    for nombre, sabotear in (
        ("(a) termino sin definir", sabotaje_a),
        ("(b) par prohibido", sabotaje_b),
        ("(c) doble definicion", sabotaje_c),
    ):
        with tempfile.TemporaryDirectory() as tmp:
            raiz = Path(tmp)
            armar_copia(raiz)
            que = sabotear(raiz)
            if que is None:
                saltados.append(nombre)
                print("[----] %-24s SALTADO: todavia no hay modulos que sabotear" % nombre)
                continue
            codigo, salida = correr(raiz)
            if codigo != 0:
                print("[OK  ] %-24s ROJO como corresponde -- %s" % (nombre, que))
            else:
                fallos.append("%s NO se puso en rojo" % nombre)
                print("[FAIL] %-24s dio VERDE con el sabotaje puesto (%s)" % (nombre, que))
                print(salida)

    # --- Y la excepcion declarada tiene que seguir en verde ---
    with tempfile.TemporaryDirectory() as tmp:
        raiz = Path(tmp)
        armar_copia(raiz)
        que = sabotaje_excepcion(raiz)
        if que is None:
            saltados.append("excepcion declarada")
            print("[----] %-24s SALTADO: todavia no hay modulos" % "excepcion declarada")
        else:
            codigo, salida = correr(raiz)
            if codigo == 0:
                print("[OK  ] %-24s sigue VERDE -- %s" % ("excepcion declarada", que))
            else:
                fallos.append("la excepcion declarada no fue respetada")
                print("[FAIL] %-24s la excepcion NO fue respetada" % "excepcion declarada")
                print(salida)

    print("")
    if saltados:
        print("SALTADOS (%d): %s" % (len(saltados), ", ".join(saltados)))
        print("Volver a correr este saboteador en cuanto haya un modulo escrito:")
        print("un chequeo saltado no es un chequeo aprobado.")
    if fallos:
        print("")
        print("SABOTEADOR EN ROJO: %d problema(s)." % len(fallos))
        for f in fallos:
            print("  - %s" % f)
        return 1
    if saltados:
        return 1
    print("SABOTEADOR EN VERDE: el verificador ve los tres fallos y respeta la excepcion.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
