"""(92) solo lectura: estado de la maquina del arma en la mano de J y J2 (arma+0xD8), cargador y banderas."""
import sys, time
from pathlib import Path
B = Path(r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black")
sys.path.insert(0, str(B / "herramientas"))
from pine import Pine
p = Pine(); p.conectar()
J = p.leer32(0x0040F4D0) + 0x30; J2 = 0x0046CDF0
V = p.leer32(p.leer32(0x0040F510) + 0xCBD8)
for _ in range(int(sys.argv[1]) if len(sys.argv) > 1 else 1):
    for nom, P in (("J", J), ("J2", J2)):
        a = p.leer32(P + 0x2A4)
        f4 = p.leer32(a + 0xF4)
        print(f"{nom} arma={a:08X} D8={p.leer32(a+0xD8):3d} cargador={p.leer16(f4+0x18,)} F4+14={p.leer32(f4+0x14)} "
              f"F4+20={p.leer8(f4+0x20)} 105..10B={p.leer_bloque(a+0x105,7).hex()} C4={p.leer32(P+0xC4)}")
    fp = p.leer32(V + 0xC)
    print(f"V={V:08X} V+C={fp:08X} 1BE0={p.leer32(fp+0x1BE0):08X} 1BE4={p.leer32(fp+0x1BE4):08X} 1BE8={p.leer32(fp+0x1BE8):08X} 1C44={p.leer8(fp+0x1C44)}")
    time.sleep(1)
p.cerrar()
