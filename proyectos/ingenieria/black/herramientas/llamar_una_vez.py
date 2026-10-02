"""llamar_una_vez.py -- (110) hace que el EE llame UNA vez a una funcion del juego, f(a0, a1), desde un sitio por
cuadro que el pnach del coop NO usa: `0x001295D0: jal 0x001387C8` (dentro de FUN_00129360, el update del mundo).

El sitio se desvia a ONE (memoria libre 0x0046F200, fuera de coop-rangos y coop-plan-b): si la bandera esta en 1,
la baja y llama f(a0, a1); despues sigue a 0x001387C8 con los argumentos originales intactos. Al terminar se
devuelve el sitio a su palabra original. Para sondas («¿que hace el juego si...?»), no para el mod.

    python herramientas/llamar_una_vez.py <funcion_hex> <a0_hex> <a1_hex> [--mirar s]
    python herramientas/llamar_una_vez.py quitar            # devuelve el sitio (por si algo quedo a medias)
"""
import argparse
import json
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import jugador2 as j2  # noqa: E402
from mips import ensamblar  # noqa: E402

SITIO, ORIGINAL_TXT = 0x001295D0, "jal 0x1387c8"
BASE, FIN = 0x0046F200, 0x0046F2F0
BANDERA, ARG0, ARG1, FUNC, HECHAS = 0x0046F2F0, 0x0046F2F4, 0x0046F2F8, 0x0046F2FC, 0x0046F2EC

FUENTE = "\n".join([
    "ONE:", "addiu sp, sp, -0x30", "sw ra, 0(sp)", "sw a0, 4(sp)", "sw a1, 8(sp)", "sw a2, 0xc(sp)", "sw a3, 0x10(sp)",
    "lui t9, 0x47", "lw t8, -0xd10(t9)", "beq t8, zero, @OFIN", "nop",
    "sw zero, -0xd10(t9)", "lw a0, -0xd0c(t9)", "lw a1, -0xd08(t9)", "lw t7, -0xd04(t9)",
    "jalr t7", "nop",
    "lui t9, 0x47", "lw t8, -0xd14(t9)", "addiu t8, t8, 1", "sw t8, -0xd14(t9)",
    "OFIN:", "lw ra, 0(sp)", "lw a0, 4(sp)", "lw a1, 8(sp)", "lw a2, 0xc(sp)", "lw a3, 0x10(sp)",
    "j 0x1387c8", "addiu sp, sp, 0x30"])


class EnPausa:
    """(110) Escribir codigo con el EE corriendo tiro el fork («Impossible block clearing failure» del
    recompilador, al devolver el sitio): las escrituras de codigo se hacen con el EE en pausa."""

    def __enter__(self):
        from depurador import Depurador
        self.d = Depurador().conectar()
        if not self.d.estado().get("paused"):
            self.d.pausar()
            self.d.esperar_pausa(segundos=5)
        return self

    def __exit__(self, *_):
        try:
            self.d.continuar()
        finally:
            self.d.cerrar()


def main():
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("funcion")
    ap.add_argument("a0", nargs="?")
    ap.add_argument("a1", nargs="?")
    ap.add_argument("--mirar", type=float, default=2.0)
    a = ap.parse_args()
    original = ensamblar(ORIGINAL_TXT, SITIO)
    with Pine() as p:
        if a.funcion == "quitar":
            with EnPausa():
                p.escribir32(SITIO, original)
            print(json.dumps({"sitio": hex(SITIO), "palabra": hex(p.leer32(SITIO))}))
            return 0
        actual = p.leer32(SITIO)
        prog = j2.ensamblar_programa(FUENTE, BASE, FIN)
        if actual != original and actual != ensamblar("jal 0x%x" % BASE, SITIO):
            raise SystemExit("el sitio tiene %#x: no es el original ni el nuestro" % actual)
        with EnPausa():
            for pc, w, _t in prog:
                p.escribir32(pc, w)
            p.escribir32(BANDERA, 0)
            p.escribir32(HECHAS, 0)
            p.escribir32(ARG0, int(a.a0, 16))
            p.escribir32(ARG1, int(a.a1, 16))
            p.escribir32(FUNC, int(a.funcion, 16))
            p.escribir32(SITIO, ensamblar("jal 0x%x" % BASE, SITIO))
            p.escribir32(BANDERA, 1)
        t0 = time.time()
        while time.time() - t0 < a.mirar and p.leer32(HECHAS) == 0:
            time.sleep(0.05)
        hechas = p.leer32(HECHAS)
        # el sitio se queda desviado (la bandera ya esta en 0, ONE no hace nada mas): devolverlo es otra escritura
        # de codigo en el bloque caliente; se devuelve en pausa
        with EnPausa():
            p.escribir32(SITIO, original)
        print(json.dumps({"funcion": a.funcion, "a0": a.a0, "a1": a.a1, "llamadas": hechas,
                          "segundos": round(time.time() - t0, 2), "sitio_devuelto": p.leer32(SITIO) == original}))
    return 0


if __name__ == "__main__":
    sys.exit(main())
