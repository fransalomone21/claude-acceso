"""Fuego amigo (85): un tirador (J o J2) apunta su MIRA (yaw +8 / pitch +0xC, como matar_sin_manos) a un blanco
cada vuelta y mantiene 'disparar' en su mando falso. Mide vida del blanco y cargador del tirador.
OJO: un enemigo recien nacido por spawner no recibe dano los primeros segundos: esperar >= 12 s.
Uso: python herramientas/tirador.py <J|J2> <blanco_hex> <segundos> [--cargar] [--acercar=<m>]
--cargar: pone el cargador del tirador en 15 antes. --acercar=m: sostiene al blanco a m metros del tirador,
en la direccion en que ya esta (misma altura del tirador). --pitch-invertido: escribe el cabeceo con el signo
cambiado (la matriz de vista de J2, +0xD0, tiene el cabeceo al reves de su mira: bitacora (85)).
--titere=<i>: en cada vuelta copia la matriz de J2 al aliado i del pool (el cuerpo de J2 puesto).
--traza (88c): registra cada cambio de (cargador del tirador, vida del blanco) con su tiempo, para ver si la
vida baja cuando dispara el tirador o cuando no (un aliado cerca tambien le tira)."""
import math, struct, sys, time, json
sys.path.insert(0, str(__import__('pathlib').Path(__file__).resolve().parent))
from pine import Pine

if '--help' in sys.argv or len(sys.argv) < 4:
    print(__doc__)
    sys.exit(0)
J, J2 = 0x005A8AB0, 0x0046CDF0
FALSO = {'J': 0x00472000, 'J2': 0x00472100}
OJOS, PECHO = 1.6, 1.2
quien, E, seg = sys.argv[1], int(sys.argv[2], 16), float(sys.argv[3])
T = J if quien == 'J' else J2
F = FALSO[quien]
signo_pitch = -1.0 if '--pitch-invertido' in sys.argv else 1.0
acercar = next((float(x.split('=')[1]) for x in sys.argv if x.startswith('--acercar=')), None)

def boton(p, i, v):
    p.escribir8(F + 0x0E + i, 0)
    p.escribir8(F + 0x2A + i, 1 if v else 0)
    p.escribir_f32(F + 0x4C + 4 * i, 1.0 if v else 0.0)

with Pine() as p:
    if quien == 'J':
        import sondas_coop as s
        if p.leer32(s.CTRL1 + 0xC) != s.FALSO:
            s.falso_poner(p)
    mira = p.leer32(T + 0x32C)
    sub = p.leer32(p.leer32(T + 0x2A4) + 0xF4)
    carg = lambda: struct.unpack('<H', p.leer_bloque(sub + 0x18, 2))[0]
    if '--cargar' in sys.argv:
        p.escribir16(sub + 0x18, 15)
    c0 = carg()
    hp0 = p.leer_f32(E + 0x2F8)
    pos = lambda o: struct.unpack('<3f', p.leer_bloque(o + 0xA0, 12))
    tx, ty, tz = pos(T)
    ex, ey, ez = pos(E)
    punto = None
    if acercar:
        d = math.hypot(ex - tx, ez - tz) or 1.0
        punto = (tx + acercar * (ex - tx) / d, ty, tz + acercar * (ez - tz) / d)
    t0 = time.time()
    for i in range(16):
        boton(p, i, False)
    apretado = False
    titere = next((int(x.split('=')[1]) for x in sys.argv if x.startswith('--titere=')), None)
    A = p.leer32(0x0040F514) + 0x90 + titere * 0x3C0 if titere is not None else None
    traza, ult = [], (c0, hp0)       # --traza (88c): cada cambio de (cargador, vida) con su tiempo
    while time.time() - t0 < seg:
        if '--traza' in sys.argv:
            ahora = (carg(), p.leer_f32(E + 0x2F8))
            if ahora != ult:
                traza.append([round(time.time() - t0, 2), ahora[0], round(ahora[1], 1)])
                ult = ahora
        if punto:
            p.escribir_bloque(E + 0xA0, struct.pack('<3f', *punto))
        if A:                        # el titere (un aliado) pegado a J2, como titere.py
            p.escribir_bloque(A + 0x70, p.leer_bloque(J2 + 0x70, 0x40))
        tx, ty, tz = pos(T)
        ex, ey, ez = pos(E)
        dx, dz = ex - tx, ez - tz
        d = math.hypot(dx, dz)
        p.escribir_f32(mira + 8, 90.0 - math.degrees(math.atan2(dz, dx)))
        p.escribir_f32(mira + 0xC, signo_pitch * math.degrees(math.atan2((ey + PECHO) - (ty + OJOS), d)))
        if time.time() - t0 > 0.4 and not apretado:
            boton(p, 12, True)       # UNA vez y se sostiene, como matar_sin_manos
            apretado = True
        time.sleep(0.03)
    boton(p, 12, False)
    time.sleep(0.5)
    print(json.dumps({'tirador': quien, 'blanco': hex(E), 'distancia_m': round(d, 2), 'cargador': [c0, carg()],
                      'hp_blanco': [hp0, p.leer_f32(E + 0x2F8)], 'bando_blanco': p.leer32(E + 0x3A4),
                      **({'traza_t_cargador_vida': traza} if '--traza' in sys.argv else {})}))
