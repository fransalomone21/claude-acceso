#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probar-verificar-cobertura.py -- el saboteador de `verificar-cobertura.py`.

Regla 3 del perfil: toda alarma se prueba rompiendola. Un verificador que
nunca se vio en rojo esta sin verificar, y este nacio en verde el mismo dia
que se escribio -- que es justo el caso sospechoso.

Copia el arbol minimo a un temporal, le mete UN defecto por vez, y exige que
el medidor lo agarre. Incluye el CONTROL POSITIVO: la copia sin tocar tiene
que dar verde, porque si no, los rojos no prueban nada (podrian ser de la
copia y no del defecto).

Cada caso dice ademas QUE chequeo tiene que dispararse, no solo que el codigo
de salida sea 1: un defecto que se agarra por el chequeo equivocado es un
falso verde disfrazado.

Uso:
    python probar-verificar-cobertura.py
"""

import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

AQUI = Path(__file__).resolve().parent
MEDIDOR = AQUI / "verificar-cobertura.py"


def armar_copia(destino):
    """El arbol minimo que el medidor necesita."""
    (destino / "fuentes").mkdir(parents=True, exist_ok=True)
    shutil.copy2(AQUI / "fuentes" / "consignas-tp.md", destino / "fuentes")
    shutil.copytree(AQUI / "apunte" / "modulos", destino / "apunte" / "modulos")


def correr(raiz):
    p = subprocess.run(
        [sys.executable, str(MEDIDOR), "--raiz", str(raiz)],
        capture_output=True, text=True, encoding="utf-8", errors="replace")
    return p.returncode, (p.stdout or "") + (p.stderr or "")


def sub_banco(raiz, viejo, nuevo, cuenta=1):
    path = raiz / "fuentes" / "consignas-tp.md"
    s = path.read_text(encoding="utf-8")
    if s.count(viejo) < 1:
        raise SystemExit("el saboteador no encontro %r en el banco" % viejo[:50])
    path.write_text(s.replace(viejo, nuevo, cuenta), encoding="utf-8")


def sub_modulo(raiz, archivo, viejo, nuevo):
    path = raiz / "apunte" / "modulos" / archivo
    s = path.read_text(encoding="utf-8")
    if s.count(viejo) != 1:
        raise SystemExit("el saboteador no encontro %r en %s" % (viejo[:50], archivo))
    path.write_text(s.replace(viejo, nuevo), encoding="utf-8")


# --- los sabotajes: (nombre, funcion que rompe, marca que TIENE que salir) ---

def s_huerfana(raiz):
    """Vacia la celda de anclas de la consigna 9."""
    sub_banco(raiz,
              u"| 9 | Calcular $V_\"out\"$ para $V_\"in\" = 12 V_\"RMS\"$ con $R = 1$ kΩ "
              u"| M4 §Rectificador de media onda |",
              u"| 9 | Calcular $V_\"out\"$ para $V_\"in\" = 12 V_\"RMS\"$ con $R = 1$ kΩ |  |")


def s_modulo_inexistente(raiz):
    """Manda la consigna 7 a un modulo que no existe."""
    sub_banco(raiz,
              u"| 7 | Completar la tabla del datasheet del 1N4007",
              u"| 7 | XXX Completar la tabla del datasheet del 1N4007")
    sub_banco(raiz,
              u"XXX Completar la tabla del datasheet del 1N4007: VRRM, VR, IF, IFSM, "
              u"VF, IR, trr, Cj | M4 §Lectura del datasheet: el 1N4007 |",
              u"Completar la tabla del datasheet del 1N4007: VRRM, VR, IF, IFSM, "
              u"VF, IR, trr, Cj | M99 §Lectura del datasheet: el 1N4007 |")


def s_seccion_renombrada(raiz):
    """Le cambia el titulo a una seccion que el banco cita. Es el caso REAL:
    nadie edita el banco para romperlo, se renombra una seccion del apunte y
    el banco queda apuntando al vacio."""
    sub_modulo(raiz, "m5-fuentes.typ",
               u"=== Cuánto rizado queda después del zener",
               u"=== Rechazo de rizado del regulador")


def s_conteo_corrido(raiz):
    """El numero escrito a mano deja de ser el medido."""
    sub_banco(raiz,
              u"**43 consignas, 42 mapeadas, 1 diferida.**",
              u"**40 consignas, 40 mapeadas, 0 diferidas.**")


def s_pendiente_sin_motivo(raiz):
    """Una excepcion sin motivo escrito no es una excepcion: es un silencio."""
    sub_banco(raiz,
              u"| PENDIENTE — el anexo de informes técnicos es la fase 4 del "
              u"`PDP.md`, todavía sin abrir; hasta que exista, el formato lo da la "
              u"guía de la cátedra y no el apunte |",
              u"|  |")


CASOS = [
    (u"(a) consigna huerfana",        s_huerfana,             u"(a) consigna huerfana"),
    (u"(b) modulo inexistente",       s_modulo_inexistente,   u"(b) ancla a un modulo que no existe"),
    (u"(c) seccion renombrada",       s_seccion_renombrada,   u"(c) ancla a una seccion que no existe"),
    (u"(d) conteo corrido",           s_conteo_corrido,       u"(d) el conteo declarado no es el medido"),
    (u"(a) PENDIENTE sin motivo",     s_pendiente_sin_motivo, u"(a) consigna huerfana"),
]


def main():
    fallas = []
    base = Path(tempfile.mkdtemp(prefix="probar-cobertura-"))
    try:
        # --- control positivo ---
        limpio = base / "control"
        armar_copia(limpio)
        codigo, salida = correr(limpio)
        if codigo == 0:
            print("[OK  ] control positivo: la copia SIN TOCAR da verde")
        else:
            fallas.append(u"el control positivo dio ROJO -- los sabotajes no "
                          u"prueban nada:\n" + salida)
            print("[FAIL] control positivo: la copia sin tocar dio rojo")

        # --- los sabotajes ---
        for i, (nombre, romper, marca) in enumerate(CASOS):
            raiz = base / ("caso%d" % i)
            armar_copia(raiz)
            romper(raiz)
            codigo, salida = correr(raiz)
            if codigo == 0:
                fallas.append(u"%s: el medidor NO lo vio (dio verde)" % nombre)
                print("[FAIL] %s -- el medidor dio verde" % nombre)
            elif marca not in salida:
                fallas.append(u"%s: dio rojo, pero por otro chequeo. Esperaba %r"
                              % (nombre, marca))
                print("[FAIL] %s -- rojo por el chequeo equivocado" % nombre)
            else:
                print("[OK  ] %s -- rojo, y por el chequeo que corresponde" % nombre)
    finally:
        shutil.rmtree(base, ignore_errors=True)

    print("")
    if fallas:
        print("EL SABOTEADOR ENCONTRO %d PROBLEMA(S):" % len(fallas))
        for f in fallas:
            print("  - %s" % f)
        return 1
    print("Los %d sabotajes dieron rojo y el control positivo dio verde." % len(CASOS))
    return 0


if __name__ == "__main__":
    sys.exit(main())
