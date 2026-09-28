"""(92) datos en caliente: llena el cargador de J2 desde su reserva y pone el estado del arma en 0.
Despues lee 6 s: si el estado vuelve a 4 solo, el estado trabado no era lo unico."""
import sys, time
from pathlib import Path
B = Path(r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black")
sys.path.insert(0, str(B / "herramientas"))
from pine import Pine
p = Pine(); p.conectar()
J2 = 0x0046CDF0
a = p.leer32(J2 + 0x2A4); f4 = p.leer32(a + 0xF4); ec = p.leer32(a + 0xEC)
cap, t = p.leer32(ec + 0x60), p.leer32(ec + 0x64)
res_d = J2 + 0x280 + 2 * t
res = p.leer16(res_d)
print(f"antes: D8={p.leer32(a+0xD8)} cargador={p.leer16(f4+0x18)} cap={cap} tipo={t} reserva={res}")
if cap < 1 or cap > 200 or t > 9:
    print("valores fuera de rango, no escribo"); sys.exit(1)
n = min(cap, res)
p.escribir16(f4 + 0x18, n); p.escribir16(res_d, res - n); p.escribir32(a + 0xD8, 0)
for i in range(6):
    time.sleep(1)
    print(f"+{i+1}s D8={p.leer32(a+0xD8)} cargador={p.leer16(f4+0x18)} reserva={p.leer16(res_d)}")
p.cerrar()
