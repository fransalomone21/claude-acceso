#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probar-verificar-cobertura.py -- el saboteador de verificar-cobertura.py.

Un verificador que nunca fallo esta sin verificar (regla 3 del perfil). Este
script rompe CADA UNO de los cuatro chequeos a proposito y exige ver el rojo,
y ademas corre el control positivo: sobre el arbol intacto tiene que dar
verde. Sin esa segunda mitad, un script que devolviera 1 siempre pasaria
esta prueba.

Y cada sabotaje exige ver el rojo DEL CHEQUEO QUE LE TOCA, no un rojo
cualquiera: se busca la marca `(a)`/`(b)`/`(c)`/`(d)` en la salida. Un
saboteador que solo mira el codigo de salida no distingue "el chequeo (c)
funciona" de "el script se cayo por otra cosa".

SE TRABAJA SOBRE UNA COPIA, NO SOBRE EL ARBOL REAL. Es la leccion de
`probar-chequeo-lecciones.ps1`, que restauraba el archivo fuente y dejaba la
copia instalada con el sabotaje adentro. Aca el arbol vivo no se toca en
ningun momento, asi que no hay nada que restaurar.

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
VERIFICADOR = AQUI / "verificar-cobertura.py"
BANCO = ("fuentes", "parcialitos.md")


def armar_copia(destino):
    """Copia lo unico que el verificador mira: el banco y los modulos."""
    (destino / "fuentes").mkdir(parents=True, exist_ok=True)
    shutil.copy2(AQUI / BANCO[0] / BANCO[1], destino / BANCO[0] / BANCO[1])
    shutil.copytree(AQUI / "apunte" / "modulos", destino / "apunte" / "modulos")


def correr(raiz):
    r = subprocess.run(
        [sys.executable, str(VERIFICADOR), "--raiz", str(raiz)],
        capture_output=True, text=True, encoding="utf-8", errors="replace",
    )
    return r.returncode, (r.stdout or "") + (r.stderr or "")


def banco_de(raiz):
    return raiz / BANCO[0] / BANCO[1]


def primera_fila(texto):
    """El indice de la primera fila de pregunta del banco, o None."""
    for i, linea in enumerate(texto.splitlines()):
        if re.match(r"^\|\s*\d+\s*\|.+\|.+\|\s*$", linea):
            return i
    return None


def sabotaje_a(raiz):
    """Una pregunta se queda sin ancla: tiene que saltar (a)."""
    p = banco_de(raiz)
    lineas = p.read_text(encoding="utf-8").splitlines()
    i = primera_fila("\n".join(lineas))
    partes = lineas[i].split("|")
    partes[3] = " (pendiente) "
    lineas[i] = "|".join(partes)
    p.write_text("\n".join(lineas) + "\n", encoding="utf-8")


def sabotaje_b(raiz):
    """Un ancla apunta a un modulo inexistente: tiene que saltar (b)."""
    p = banco_de(raiz)
    texto = p.read_text(encoding="utf-8")
    # OJO: el banco NOMBRA un ancla de ejemplo en la prosa de "Como se lee",
    # y esa linea no es una fila de tabla -- reemplazar la primera aparicion
    # saboteaba la PROSA, y el verificador daba verde con razon. Este
    # saboteador se comio ese falso agujero una vez. Se ancla a la fila.
    texto = texto.replace("M07 §La tabla N² · M27", "M99 §La tabla N² · M27", 1)
    p.write_text(texto, encoding="utf-8")


def sabotaje_c(raiz):
    """Un ancla apunta a una seccion que ese modulo no tiene -- el caso real
    que ya se cometio: modulo plausible, seccion equivocada. Tiene que
    saltar (c)."""
    p = banco_de(raiz)
    texto = p.read_text(encoding="utf-8")
    texto = texto.replace("M06 §Pensamiento holístico",
                          "M04 §Pensamiento holístico", 1)
    p.write_text(texto, encoding="utf-8")


def sabotaje_d(raiz):
    """El conteo declarado deja de coincidir con el contado: (d).

    El numero NO se escribe aca. La primera version lo tenia literal ('16
    preguntas') y el dia que el banco paso a 28 este sabotaje dejo de aplicarse
    en silencio: el saboteador se rompio solo y siguio diciendo que todo estaba
    bien --salvo que, por suerte, exigimos ver el rojo del chequeo (d) y no un
    rojo cualquiera, asi que lo dijo--. Ahora se lee el numero que haya y se le
    resta uno."""
    p = banco_de(raiz)
    texto = p.read_text(encoding="utf-8")
    m = re.search(r"\*\*(\d+) preguntas, (\d+) mapeadas", texto)
    if m is None:
        raise RuntimeError("el banco no declara su conteo: el sabotaje (d) no aplica")
    n = int(m.group(1))
    texto = texto[:m.start()] + ("**%d preguntas, %d mapeadas" % (n - 1, n - 1)) + texto[m.end():]
    p.write_text(texto, encoding="utf-8")


SABOTAJES = [
    ("(a) pregunta sin ancla", sabotaje_a, "(a)"),
    ("(b) ancla a un modulo inexistente", sabotaje_b, "(b)"),
    ("(c) ancla a una seccion que no esta en ese modulo", sabotaje_c, "(c)"),
    ("(d) conteo declarado distinto del contado", sabotaje_d, "(d)"),
]


def main():
    if not VERIFICADOR.exists():
        print("[FAIL] no existe %s" % VERIFICADOR)
        return 1

    fallos = 0
    with tempfile.TemporaryDirectory() as tmp:
        base = Path(tmp) / "intacto"
        armar_copia(base)

        # Control positivo primero: si el arbol intacto no da verde, los
        # sabotajes no prueban nada.
        codigo, salida = correr(base)
        if codigo == 0:
            print("[OK  ] control positivo: el arbol intacto da VERDE")
        else:
            fallos += 1
            print("[FAIL] control positivo: el arbol intacto da ROJO (%d)" % codigo)
            print(salida)

        for nombre, romper, marca in SABOTAJES:
            destino = Path(tmp) / re.sub(r"\W+", "_", nombre)
            armar_copia(destino)
            romper(destino)
            codigo, salida = correr(destino)
            vio_su_rojo = codigo != 0 and ("[FAIL] %s" % marca) in salida
            if vio_su_rojo:
                print("[OK  ] sabotaje %s -> el verificador lo ve" % nombre)
            else:
                fallos += 1
                print("[FAIL] sabotaje %s -> el verificador NO lo ve "
                      "(codigo %d)" % (nombre, codigo))
                print(salida)

    print("")
    if fallos:
        print("EL SABOTEADOR ENCONTRO %d AGUJERO(S) en verificar-cobertura.py."
              % fallos)
        return 1
    print("VERIFICADOR DE COBERTURA PROBADO: los %d sabotajes dan rojo y el "
          "control positivo da verde." % len(SABOTAJES))
    return 0


if __name__ == "__main__":
    sys.exit(main())
