"""El default.xbe adentro de una ISO Xbox (Redump), sin extraer la ISO a disco (sesion 132).

Lee el XDVDFS en flujo adentro del .zip (o de la .iso): la particion de juego de una imagen Redump completa empieza
en 0x18300000 (antes va la de video); el descriptor de volumen esta en el sector 32 de la particion
("MICROSOFT*XBOX*MEDIA"), con el sector y el tamano de la tabla raiz. Recorre el arbol binario de la raiz, encuentra
default.xbe y lo hashea (SHA-256).

    python herramientas/xbe_de_iso.py <archivo.zip|archivo.iso> [...]
    python herramientas/xbe_de_iso.py --autotest     # control: el XBE del paquete 0.2.0, hash conocido

Salida: codigo 0 = encontrado, 1 = no encontrado / no es XDVDFS, 2 = ENTORNO.
"""
from __future__ import annotations

import hashlib
import struct
import sys
import zipfile
from pathlib import Path

SECTOR = 2048
PARTICIONES = (0x18300000, 0)  # Redump completa; o solo la particion de juego
MAGIA = b"MICROSOFT*XBOX*MEDIA"
# SHA-256 que piden los dos ports (README de black-pc, lineas 51-52); se compara el hash ENTERO
NTSC_U = "df2739c372d254a90aeeccf5971d12097f22d89fbb90db021fda96dd4deb68f6"
PAL_EU = "67f35121ccf622e7a293c402219596fe6456ca4c3d27e6f8139e449264da30f0"


def abrir(ruta: Path):
    if ruta.suffix.lower() == ".zip":
        z = zipfile.ZipFile(ruta)
        iso = next((i for i in z.infolist() if i.filename.lower().endswith(".iso")), None)
        if iso is None:
            raise SystemExit(f"{ruta.name}: el zip no trae .iso")
        return z.open(iso)
    return open(ruta, "rb")


def leer(f, pos: int, n: int) -> bytes:
    f.seek(pos)
    return f.read(n)


def buscar_xbe(ruta: Path):
    f = abrir(ruta)
    for base in PARTICIONES:
        vd = leer(f, base + 32 * SECTOR, SECTOR)
        if vd[:20] == MAGIA:
            break
    else:
        return None, "no es XDVDFS en 0x18300000 ni en 0"
    raiz_sec, raiz_tam = struct.unpack_from("<II", vd, 0x14)
    tabla = leer(f, base + raiz_sec * SECTOR, raiz_tam)
    pila, vistos = [0], set()
    while pila:
        o = pila.pop()
        if o in vistos or o + 14 > len(tabla):
            continue
        vistos.add(o)
        izq, der, sec, tam, _attr, nl = struct.unpack_from("<HHIIBB", tabla, o)
        if izq == 0xFFFF:  # relleno
            continue
        nombre = tabla[o + 14: o + 14 + nl].decode("latin-1")
        if nombre.lower() == "default.xbe":
            h = hashlib.sha256()
            f.seek(base + sec * SECTOR)
            falta = tam
            while falta:
                b = f.read(min(falta, 1 << 20))
                if not b:
                    break
                h.update(b)
                falta -= len(b)
            return h.hexdigest(), f"base 0x{base:X}, sector {sec}, {tam} B"
        if izq:
            pila.append(izq * 4)
        if der:
            pila.append(der * 4)
    return None, "sin default.xbe en la raiz"


def veredicto(h: str) -> str:
    if h.startswith(NTSC_U):
        return "NTSC-U soportado por los dos ports"
    if h.startswith(PAL_EU):
        return "PAL Europa soportado por los dos ports"
    return "NO soportado por los ports"


def main(argv) -> int:
    if not argv:
        print(__doc__)
        return 0
    if argv[0] == "--autotest":
        sys.path.insert(0, str(Path(__file__).resolve().parent))
        import ubicaciones
        paq = Path(ubicaciones.cargar()["rutas"]["port_paquete_tercero"]["ruta"])
        if not paq.exists():
            print(f"ENTORNO: no esta {paq}")
            return 2
        with zipfile.ZipFile(paq) as z:
            n = next(x for x in z.namelist() if x.lower().endswith("game/default.xbe"))
            h = hashlib.sha256(z.read(n)).hexdigest()
        ok = h.startswith(NTSC_U)
        print(f"control positivo (XBE del paquete 0.2.0 = NTSC-U {NTSC_U}...): {h[:8]}...{h[-4:]} {'OK' if ok else 'MAL'}")
        return 0 if ok else 1
    rc = 0
    for a in argv:
        h, donde = buscar_xbe(Path(a))
        if h is None:
            print(f"{Path(a).name}: {donde}")
            rc = 1
        else:
            print(f"{Path(a).name}: {h[:8]}...{h[-4:]} ({donde}) -> {veredicto(h)}")
    return rc


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
