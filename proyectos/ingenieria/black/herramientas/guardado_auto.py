"""guardado_auto.py -- savestates automaticos mientras Fran juega (114), para no perder el recorrido.

Cada N segundos pide un savestate por PINE rotando los slots 5, 6 y 7 (el 3 es el del lanzador: NUNCA se pisa).
Anota en volcados/guardados.txt la hora, el slot, la posicion de J y si el bloque COOP estaba armado (FASE = 2),
porque un savestate tomado con el coop no sirve de control sin el coop y viceversa.

    python herramientas/guardado_auto.py [segundos_entre] [duracion]     # default 90 y 3600
    python herramientas/guardado_auto.py ahora <slot>                     # uno ya (slot 4..9)
"""
import sys, time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402

J, FASE = 0x005A8AB0, 0x0046D790
SLOTS = (5, 6, 7)
LOG = H.parent / "volcados" / "guardados.txt"


def guardar(slot):
    assert slot != 3 and 4 <= slot <= 9, "el slot 3 es del lanzador"
    with Pine() as p:
        pos = [round(p.leer_f32(J + 0xA0 + 4 * k), 1) for k in range(3)]
        coop = p.leer32(FASE) == 2
        p.guardar_estado(slot)
    linea = "%s slot %d J %s coop %s" % (time.strftime("%Y-%m-%d %H:%M:%S"), slot, pos, "si" if coop else "no")
    LOG.parent.mkdir(parents=True, exist_ok=True)
    with open(LOG, "a", encoding="utf-8") as f:
        f.write(linea + "\n")
    print(linea, flush=True)


def main():
    tolerar_salida_pobre()
    if "-h" in sys.argv or "--help" in sys.argv:
        print(__doc__); return 0
    if len(sys.argv) > 1 and sys.argv[1] == "ahora":
        guardar(int(sys.argv[2])); return 0
    cada = float(sys.argv[1]) if len(sys.argv) > 1 else 90
    dur = float(sys.argv[2]) if len(sys.argv) > 2 else 3600
    t0, i = time.time(), 0
    while time.time() - t0 < dur:
        time.sleep(cada)
        try:
            guardar(SLOTS[i % len(SLOTS)]); i += 1
        except Exception as ex:  # noqa: BLE001
            print("no se pudo guardar:", ex, flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
