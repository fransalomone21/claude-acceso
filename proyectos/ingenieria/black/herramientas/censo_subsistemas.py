"""El NIVEL 1 de BLACK: los subsistemas que construye el arranque (FUN_001020c0).

Uso: python herramientas/censo_subsistemas.py volcados/ee-e4.bin [--json kb/subsistemas.json]

Por cada singleton (global -> objeto de tamano fijo) da:
  - donde vive el objeto en el volcado,
  - cuantos sitios de codigo cargan el global (lui 0x41 + lw/addiu, y via $gp),
    y en cuantas funciones: es el tamano de su interfaz, no su importancia,
  - que direcciones YA CONOCIDAS del proyecto caen adentro del objeto.

La lista de globales y tamanos se leyo del decompilado de FUN_001020c0 el
2026-09-26 (bitacora (62)); no se deriva sola. Control positivo: el objeto
juego (0x0040F4D0) tiene que contener al jugador 0x005A8AB0 y el gestor de
entrada (0x0040F0E8) a los dos mandos.
"""
import collections
import json
import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ubicaciones  # noqa: E402

OFF = 0xFF000
TEXT = (0x00100000, 0x003BC380)
GP = 0x004157F0

# (global, tamano, constructor o vtable instalada) -- de FUN_001020c0
SINGLETONS = [
    (0x0040F548, 0x4, ""), (0x0040F4C0, 0xD600, ""), (0x0040F4D4, 0x22BF0, "FUN_00382838"),
    (0x0040F50C, 0x970, "FUN_00382d60"), (0x0040F4D8, 0x87400, "FUN_003828d8"),
    (0x0040F0E4, 0x102C0, "vt 0x003DB3B8@+0xA4"), (0x0040F0E8, 0x7C0, "2 x vt 0x003E2508"),
    (0x0040F4CC, 0x8B50, ""), (0x0040F4BC, 0x1680, "FUN_00382500"),
    (0x0040F514, 0x8530, "vt 0x003DCC60@+0x84"), (0x0040F4C4, 0xE18, ""),
    (0x0040F510, 0xCC08, "vt 0x003DB640@+0xCBA0"), (0x0040F508, 0x27A0, ""),
    (0x0040F518, 0x240, ""), (0x0040F51C, 0x1, ""), (0x0040F4F4, 0xD8, ""),
    (0x0040F4D0, 0x5CB0, "FUN_00382778"), (0x0040F4F8, 0x9C, ""), (0x0040F4E0, 0xFE0, ""),
    (0x0040F520, 0x3740, "FUN_00382e78"), (0x0040F4DC, 0x10, ""), (0x0040F4E8, 0x8, ""),
    (0x0040F524, 0x1C, ""), (0x0040F528, 0x140, ""), (0x0040F52C, 0xF0, ""),
    (0x0040F4E4, 0x5860, "64 x vt 0x003DCB38@+0x10"), (0x0040F544, 0x3960, "FUN_00382ee0"),
    (0x0040F530, 0x1A0, "vt 0x003DC2A8"), (0x0040F504, 0x170, "vt 0x003DC2A8@+0x40"),
    (0x0040F534, 0x10, ""), (0x0040F538, 0x10, ""), (0x0040F53C, 0x6B0, ""),
    (0x0040F4EC, 0x790, ""), (0x0040F4F0, 0x21B8, ""), (0x0040F4C8, 0xC, ""),
    (0x0040F540, 0xD0, ""), (0x0040F54C, 0x3000, "FUN_00107d20"),
]

CONOCIDAS = {
    0x005A8AB0: "jugador (vida en +0x2F8)",
    0x005AD410: "doble buffer del stage (7e)",
    0x005AD450: "P1: directorio de pools del stage (7e)",
    0x005856C0: "mando 0", 0x005857B0: "mando 1",
    0x0058FE90: "pool de 32 enemigos (paso 0x3C0)",
    0x006DE770: "objeto de arma por tirador (paso 0x110)",
    0x006E18B0: "array de IA de armas (50 x 0x24)",
    0x0065FD00: "registro de entidades (paso 0x80)",
    0x005AE880: "manager del pool de armas (7c)",
    0x004CB1C8: "registro de fisica del 0x2D (48 ranuras)",
    0x00414AD0: "cola de dano diferido",
}


def main():
    dump = open(sys.argv[1], "rb").read()
    u = lambda a: struct.unpack_from("<I", dump, a)[0]  # noqa: E731
    elf = open(ubicaciones.cargar()["rutas"]["elf_copia"]["ruta"], "rb").read()
    w = lambda a: struct.unpack_from("<I", elf, a - OFF)[0]  # noqa: E731

    sitios = collections.defaultdict(list)
    lo_a_glob = {g & 0xFFFF: g for g, _, _ in SINGLETONS}
    gp_a_glob = {(g - GP) & 0xFFFF: g for g, _, _ in SINGLETONS}
    for a in range(TEXT[0], TEXT[1], 4):
        x = w(a)
        op, rs, imm = x >> 26, (x >> 21) & 31, x & 0xFFFF
        if op not in (0x23, 0x2B, 0x09):
            continue
        if rs == 28 and imm in gp_a_glob:
            sitios[gp_a_glob[imm]].append(a)
        elif imm in lo_a_glob and any(
                w(b) >> 26 == 0x0F and (w(b) >> 16) & 31 == rs and w(b) & 0xFFFF == 0x41
                for b in range(a - 4, a - 40, -4)):
            sitios[lo_a_glob[imm]].append(a)

    def funcion(a):
        for b in range(a, max(TEXT[0], a - 0x6000), -4):
            y = w(b)
            if y >> 16 == 0x27BD and y & 0x8000:
                return b
        return None

    filas = []
    for g, tam, nota in SINGLETONS:
        obj = u(g)
        dentro = [f"{k:#010x} {v}" for k, v in CONOCIDAS.items() if obj <= k < obj + tam]
        fs = {funcion(a) for a in sitios[g]}
        filas.append({"global": f"{g:#010x}", "objeto": f"{obj:#010x}", "tam": tam,
                      "constructor": nota, "sitios": len(sitios[g]), "funciones": len(fs),
                      "contiene_conocidas": dentro})
    filas.sort(key=lambda f: -f["funciones"])
    for f in filas:
        print(f"{f['global']} -> {f['objeto']}  {f['tam']:>7} B  {f['sitios']:>4} sitios "
              f"{f['funciones']:>4} funciones  {f['constructor']}")
        for d in f["contiene_conocidas"]:
            print(f"        contiene {d}")
    ok = any(f["global"] == "0x0040f4d0" and any("jugador" in d for d in f["contiene_conocidas"])
             for f in filas) and any(
        f["global"] == "0x0040f0e8" and sum("mando" in d for d in f["contiene_conocidas"]) == 2
        for f in filas)
    print("control positivo (jugador en juego, 2 mandos en gestor):", "OK" if ok else "FALLA")
    if "--json" in sys.argv:
        ruta = sys.argv[sys.argv.index("--json") + 1]
        json.dump(filas, open(ruta, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
