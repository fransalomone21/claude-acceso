"""Apunta la mira a un enemigo cada 50 ms y dispara con el mando falso hasta que muere.
Uso: python herramientas/matar_sin_manos.py <enemigo_hex> <bandera_D9A3 0|1>
Registra el estado de F504 antes, al morir y 3 s despues."""
import json, math, struct, sys, time
sys.path.insert(0, str(__import__("pathlib").Path(__file__).resolve().parent))
from pine import Pine
if "--help" in sys.argv or len(sys.argv) < 3:
    print(__doc__)
    sys.exit(0)
import sondas_coop as s

E = int(sys.argv[1], 16)
BANDERA = int(sys.argv[2])
J = s.JUGADOR
OJOS, PECHO = 1.6, 1.2


def f504(p):
    f = p.leer32(0x0040F504)
    return {"b0": p.leer8(f), "estado4": p.leer32(f + 4), "victima154": hex(p.leer32(f + 0x154)),
            "b15c": p.leer8(f + 0x15C), "b15d": p.leer8(f + 0x15D)}


def cargador(p):
    sub = p.leer32(p.leer32(J + 0x2A4) + 0xF4)
    return struct.unpack("<H", p.leer_bloque(sub + 0x18, 2))[0]


with Pine() as p:
    s.falso_poner(p)
    for i in range(16):
        s.poner_boton(p, i, False)
    p.escribir8(0x0040D9A3, BANDERA)
    reg = {"enemigo": hex(E), "bandera": BANDERA, "arma_id": p.leer8(p.leer32(J + 0x2A4)),
           "antes": f504(p)}
    t0 = time.time()
    disparando = False
    while time.time() - t0 < float(__import__("os").environ.get("MATAR_S", "12")):
        vida = p.leer_f32(E + 0x2F8)
        if vida <= 0:
            break
        jx, jy, jz = struct.unpack("<3f", p.leer_bloque(J + 0xA0, 12))
        ex, ey, ez = struct.unpack("<3f", p.leer_bloque(E + 0xA0, 12))
        dx, dz = ex - jx, ez - jz
        d = math.hypot(dx, dz)
        yaw = 90.0 - math.degrees(math.atan2(dz, dx))
        pitch = math.degrees(math.atan2((ey + PECHO) - (jy + OJOS), d))
        p.escribir_f32(s.MIRA_OBJ + 8, yaw)
        p.escribir_f32(s.MIRA_OBJ + 0xC, pitch)
        if cargador(p) == 0:
            s.poner_boton(p, 12, False)
            disparando = False
            s.poner_boton(p, 2, True)
            time.sleep(0.1)
            s.poner_boton(p, 2, False)
            time.sleep(1.5)
            continue
        if not disparando:
            s.poner_boton(p, 12, True)
            disparando = True
        time.sleep(0.05)
    s.poner_boton(p, 12, False)
    reg["segundos"] = round(time.time() - t0, 2)
    reg["vida_final"] = p.leer_f32(E + 0x2F8)
    reg["distancia"] = round(d, 1)
    reg["al_morir"] = f504(p)
    serie = []
    for _ in range(15):
        time.sleep(0.2)
        serie.append(f504(p)["estado4"])
    reg["estado4_3s"] = serie
    reg["despues"] = f504(p)
    reg["victima_8B2"] = p.leer8(E + 0x8B2)
    print(json.dumps(reg, ensure_ascii=False))
