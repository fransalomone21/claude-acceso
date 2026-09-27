"""Desensamblar un rango del ELF con capstone (R5900 como MIPS32 LE).

Uso: python herramientas/desensamblar.py 0x00382778 0x00382834

Existe para contrastar lo que dice Ghidra contra las INSTRUCCIONES: el
descompilado ya perdio un argumento una vez en este proyecto (delay slot en
0x001759A4). La ruta del ELF sale de kb/ubicaciones.json.
"""
import sys
from pathlib import Path

import capstone

sys.path.insert(0, str(Path(__file__).resolve().parent))
import ubicaciones  # noqa: E402

OFF = 0xFF000  # offset_archivo = vaddr - 0xFF000, un solo PT_LOAD (verificado 6/6)


def main():
    ini, fin = int(sys.argv[1], 16), int(sys.argv[2], 16)
    elf = open(ubicaciones.cargar()["rutas"]["elf_copia"]["ruta"], "rb").read()
    # MIPS64: el R5900 usa sd/ld. skipdata: las instrucciones propias del EE
    # (lq/sq, MMI) salen como .byte en vez de cortar el listado.
    md = capstone.Cs(capstone.CS_ARCH_MIPS, capstone.CS_MODE_MIPS64 + capstone.CS_MODE_LITTLE_ENDIAN)
    md.skipdata = True
    for i in md.disasm(elf[ini - OFF:fin - OFF], ini):
        print(f"{i.address:#010x}  {i.mnemonic:8s} {i.op_str}")


if __name__ == "__main__":
    main()
