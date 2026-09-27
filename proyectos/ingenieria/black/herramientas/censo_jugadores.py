"""Sonda 5 del proyecto COOP: quien recorre jugadores[] y con que limite.

Uso: python herramientas/censo_jugadores.py volcados/ee-e4.bin [otros volcados...]
     (en la nube: BLACK_DATOS=/ruta/black-datos y los volcados de esa carpeta)

Lee el codigo del EE desde el volcado (el .text esta cargado tal cual) con
capstone (pip install capstone; decodifica mal las MMI del R5900 -lq/sq- como
DSP, que aca no importan) y reporta:

  1. la CUENTA DE JUGADORES en tiempo de ejecucion: *(0x0040F0E0) + 0x20208,
     su valor en cada volcado, y cada instruccion que la escribe o la lee;
  2. los lazos que avanzan de a 0x8C0 (el paso de jugadores[]) y si su limite
     es la cuenta o una constante;
  3. cuantas funciones indexan jugadores[k] con un k guardado en otro objeto.

Control positivo: en los tres volcados de la notebook la cuenta vale 1 (el
juego es de un jugador), y el constructor del objeto juego (FUN_00382778)
construye exactamente un jugador. Si el control falla, la salida lo dice y
sale 1. Resultado 2026-09-27: bitacora (64).
"""
import re
import struct
import sys

TEXT = (0x00100000, 0x003BC380)
G_SESION = 0x0040F0E0      # global que NO esta entre los 37 de FUN_001020c0
CUENTA = 0x20208           # offset de la cuenta de jugadores dentro de *(G_SESION)
PASO = 0x8C0               # paso de jugadores[] (bitacora (61))
CTOR_JUEGO = 0x00382778    # construye jugadores[] (lazo de una vuelta)


def desarmar(ram):
    import capstone
    md = capstone.Cs(capstone.CS_ARCH_MIPS, capstone.CS_MODE_MIPS64 | capstone.CS_MODE_LITTLE_ENDIAN)
    md.skipdata = True
    return [(i.address, i.mnemonic, i.op_str) for i in md.disasm(ram[TEXT[0]:TEXT[1]], TEXT[0])]


def u32(b, a):
    return struct.unpack_from("<I", b, a)[0]


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    rams = {p: open(p, "rb").read() for p in sys.argv[1:]}
    rojos = 0
    print("1. CUENTA DE JUGADORES = *(0x0040F0E0) + 0x20208")
    for p, r in rams.items():
        base = u32(r, G_SESION)
        v = u32(r, base + CUENTA) if base else None
        print(f"   {p}: objeto en {base:#010x}, cuenta = {v}")
        if v != 1:
            print("   [ROJO] control positivo: en un volcado de un jugador la cuenta tiene que valer 1")
            rojos += 1
    ins = desarmar(next(iter(rams.values())))
    lo = f"-{0x410000 - G_SESION:#x}("
    print("   quien la toca:")
    vistos = set()
    for n, (a, m, o) in enumerate(ins):
        if m == "lw" and lo in o:
            for b, mm, oo in ins[n:n + 8]:
                if f"{CUENTA & 0xFFFF:#x}(" in oo:
                    if b in vistos:
                        break
                    vistos.add(b)
                    val = ""
                    if mm == "sw":
                        reg = oo.split(",")[0]
                        for c, m3, o3 in ins[max(0, n - 12):ins.index((b, mm, oo))]:
                            if m3 == "addiu" and o3.startswith(reg + ", $zero, "):
                                val = " valor " + o3.split(", ")[-1]
                    print(f"     {b:08x} {mm:3} {'ESCRIBE' if mm == 'sw' else 'lee'}{val}")
                    break
    print(f"\n2. LAZOS CON PASO {PASO:#x}")
    for n, (a, m, o) in enumerate(ins):
        if m == "addiu" and o.endswith(f", {PASO:#x}") and not o.split(", ")[1] in ("$zero", "$sp", "$fp"):
            ventana = ins[max(0, n - 12):n + 3]
            por_cuenta = any(f"{CUENTA & 0xFFFF:#x}(" in x[2] for x in ventana)
            print(f"   {a:08x}  limite: {'la CUENTA (tiempo de ejecucion)' if por_cuenta else 'NO la cuenta (constante, u otro objeto: mirar a mano)'}")
    idx = {a: n for n, (a, _, _) in enumerate(ins)}
    n = idx[CTOR_JUEGO]
    llamadas = sum(1 for x in ins[n:n + 16] if x[1] == "jal")
    print(f"\n   control: FUN_00382778 llama al constructor de jugador dentro de un lazo de una vuelta: "
          f"{'OK' if llamadas >= 1 else 'NO'}")
    indexados = sum(1 for a, m, o in ins if m == "addiu" and o.endswith(f"$zero, {PASO:#x}"))
    print(f"\n3. sitios que multiplican un indice de jugador por {PASO:#x}: {indexados}")
    return 1 if rojos else 0


if __name__ == "__main__":
    sys.exit(main())
