"""Convencion del cuaternion de la vista: J con cabeceo p (grados) -> gestor+0x710 contra candidatos."""
import json, math, struct, sys, time
sys.path.insert(0, r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\herramientas")
from pine import Pine


def cands(y, p):
    sy, cy, sp, cp = math.sin(y / 2), math.cos(y / 2), math.sin(p / 2), math.cos(p / 2)
    out = {}
    for s in (1, -1):
        out["qy*qp s=%d" % s] = [cy * s * sp, sy * cp, -sy * s * sp, cy * cp]
        out["qp*qy s=%d" % s] = [s * sp * cy, cp * sy, s * sp * sy, cp * cy]
    return out


res = []
with Pine() as p:
    J = p.leer32(0x0040F4D0) + 0x30
    m = p.leer32(J + 0x32C)
    g = p.leer32(0x0040F4BC)
    if len(sys.argv) > 1:
        p.escribir_f32(m + 8, float(sys.argv[1]))
    for pitch in (0.0, -25.0, 30.0):
        p.escribir_f32(m + 0xC, pitch)
        time.sleep(0.3)
        y, pc = math.radians(p.leer_f32(m + 8)), math.radians(p.leer_f32(m + 0xC))
        q = list(struct.unpack("<4f", p.leer_bloque(g + 0x710, 16)))
        err = {}
        for k, c in cands(y, pc).items():
            e1 = max(abs(a - b) for a, b in zip(q, c))
            e2 = max(abs(a + b) for a, b in zip(q, c))       # -q es la misma rotacion
            err[k] = round(min(e1, e2), 4)
        res.append({"pitch": pitch, "yaw": round(math.degrees(y), 2), "q_juego": [round(x, 4) for x in q],
                    "error": err})
    p.escribir_f32(m + 0xC, 0.0)
print(json.dumps(res, indent=1))
