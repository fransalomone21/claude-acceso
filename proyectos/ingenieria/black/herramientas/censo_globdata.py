"""Censo en frio de las secciones de GLOBDATA.BIN (fase 8b).

Lee el archivo por LBA desde el ISO ORIGINAL, en solo lectura, con el LBA de
kb/lbas-iso.json. No necesita montaje: el 2026-09-26 D: ya no tenia el ISO que
kb/ubicaciones.json declaraba montado.

El header es el del contenedor .BIN relocable (FUN_00105D48): u32[1..6] son
offsets de seccion. Imprime offset, tamano, primer byte y los primeros 16 B.
Control positivo: la seccion de 0x130C80 tiene que contener la tabla de armas
en 0x130E20 (confirmada por efecto el 2026-08-17).
"""
import json
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ubicaciones  # noqa: E402

RAIZ = Path(__file__).resolve().parent.parent


def leer_globdata():
    iso = ubicaciones.cargar()["rutas"]["iso_original"]["ruta"]
    tab = json.load(open(RAIZ / "kb" / "lbas-iso.json", encoding="utf-8"))
    ent = next(a for a in tab["archivos"] if a["ruta"].upper().startswith("/GLOBDATA.BIN"))
    with open(iso, "rb") as f:  # solo lectura
        f.seek(ent["lba"] * 2048)
        return f.read(ent["tam"])


def main():
    g = leer_globdata()
    print("GLOBDATA.BIN", len(g), "B")
    offs = [struct.unpack_from("<I", g, 4 * i)[0] for i in range(8)]
    print("header u32[0..7]:", [hex(x) for x in offs])
    secs = sorted(set(o for o in offs[1:7] if 0 < o < len(g)))
    secs.append(len(g))
    for a, b in zip(secs, secs[1:]):
        print(f"  seccion {a:#08x}  tam {b - a:>8}  {100 * (b - a) / len(g):5.1f} %"
              f"  u8[0]={g[a]:<3}  primeros: {g[a:a + 16].hex()}")
    armas = any(a <= 0x130E20 < b for a, b in zip(secs, secs[1:]) if a == 0x130C80)
    print("control positivo (armas en 0x130E20 dentro de 0x130C80):", "OK" if armas else "FALLA")
    return 0 if armas else 1


if __name__ == "__main__":
    sys.exit(main())
