"""P2 (B2b): el aliado sigue a J2 (posicion + matriz) mientras J2 camina con el mando falso 2.
Uso: python herramientas/titere.py <indice_actor> <segundos_caminar> <prefijo_captura> [--control]
--control: J2 camina igual, pero el aliado NO se escribe (tiene que quedarse donde esta).
"""
import math, subprocess, sys, threading, time, json
sys.path.insert(0, str(__import__('pathlib').Path(__file__).resolve().parent))
from pine import Pine

if '--help' in sys.argv or len(sys.argv) < 4:
    print(__doc__)
    sys.exit(0)

CAP = str(__import__('pathlib').Path(__file__).resolve().parent / 'capturar-pantalla.ps1')
MIRA_YAW = 0x005A8FA8
CTRL2, FALSO2 = 0x00585A0C, 0x00472100
idx, seg, pref = int(sys.argv[1]), float(sys.argv[2]), sys.argv[3]
control = '--control' in sys.argv

def captura(nombre):
    subprocess.run(['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', CAP, '-Salida', nombre],
                   capture_output=True)

with Pine() as p:
    act = p.leer32(0x0040F514)
    a = act + 0x90 + idx * 0x3C0
    J = p.leer32(0x0040F4D0) + 0x30
    J2 = 0x0046CDF0
    pos = lambda o: [p.leer_f32(o + 0xA0 + 4 * k) for k in range(3)]
    ctrl2_fuente = p.leer32(CTRL2 + 0xC)
    # J mira hacia J2
    jp, j2p = pos(J), pos(J2)
    obj_ang = math.atan2(j2p[0] - jp[0], j2p[2] - jp[2])
    signo = 1.0
    for _ in range(5):
        fx, fz = p.leer_f32(J + 0x90), p.leer_f32(J + 0x98)
        err = math.remainder(obj_ang - math.atan2(fx, fz), math.tau)
        if abs(math.degrees(err)) < 2.0:
            break
        yaw = p.leer_f32(MIRA_YAW)
        p.escribir_f32(MIRA_YAW, yaw + signo * math.degrees(err))
        time.sleep(0.3)
        fx2, fz2 = p.leer_f32(J + 0x90), p.leer_f32(J + 0x98)
        if abs(math.remainder(obj_ang - math.atan2(fx2, fz2), math.tau)) > abs(err):
            signo = -signo
            p.escribir_f32(MIRA_YAW, yaw + signo * math.degrees(err))
            time.sleep(0.3)
    a_antes = pos(a)
    j2_antes = pos(J2)
    # J2 camina: el mando falso 2 empuja "adelante"
    if p.leer32(CTRL2 + 0xC) != FALSO2:
        raise SystemExit('CTRL2+0xC no apunta al falso 2 (%s): correr jugador2.py control2' % hex(ctrl2_fuente))
    giro = next((float(x.split('=')[1]) for x in sys.argv if x.startswith('--giro=')), 0.0)
    if giro:
        mira2 = p.leer32(J2 + 0x32C)
        p.escribir_f32(mira2 + 8, p.leer_f32(mira2 + 8) + giro)
        time.sleep(0.4)
    th = threading.Thread(target=lambda: (time.sleep(seg * 0.6), captura(pref + '-durante.png')))
    th.start()
    p.escribir_f32(FALSO2 + 0x8C, 0.0 if '--sin-caminar' in sys.argv else 0.8)
    fin = time.time() + seg
    n, dmax = 0, 0.0
    while time.time() < fin:
        if not control:
            m = p.leer_bloque(J2 + 0x70, 0x40)
            p.escribir_bloque(a + 0x70, m)
            n += 1
        ap_, j2_ = pos(a), pos(J2)
        dmax = max(dmax, math.dist(ap_, j2_)) if not control else dmax
    p.escribir_f32(FALSO2 + 0x8C, 0.0)
    th.join()
    # seguir sosteniendo 1 s quieto para la captura final
    fin = time.time() + 1.0
    while time.time() < fin and not control:
        p.escribir_bloque(a + 0x70, p.leer_bloque(J2 + 0x70, 0x40))
    print(json.dumps({'actor': hex(a), 'ctrl2_fuente': hex(ctrl2_fuente), 'control': control,
                      'aliado_antes': a_antes, 'aliado_despues': pos(a), 'j2_antes': j2_antes, 'j2_despues': pos(J2),
                      'j2_camino_m': round(math.dist(j2_antes, pos(J2)), 2), 'aliado_movido_m': round(math.dist(a_antes, pos(a)), 2),
                      'escrituras': n, 'max_dist_aliado_J2_m': round(dmax, 3)}, indent=1))
