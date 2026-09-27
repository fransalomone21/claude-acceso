"""sondas_spawn.py -- la sonda de `spawn` (fila 7 del PDP, COOP-A): una aparicion FUERA de la carga.

Lo que se leyo en frio (bitacora (83)) y esta herramienta pone a prueba:

  cada cuadro, FUN_00165F30(dt, *(0x0040F4F4)) recorre las listas 12 y 13 de la
  tabla de `disparadores` (cuenta u16 en tabla+2*i, array en tabla+0x48+4*i) y
  llama FUN_00174578(spawner) por cada entrada. Ese es un TEMPORIZADOR: si
      +0x28 activo, +0x2C restantes != 0, +0x2A y +0x2B, y el actor de +0x24 es 0
      o esta muerto (+0x38C no es 0 ni 1)
  descuenta dt de +0x30 y al llegar a 0 llama FUN_001746E0 -> FUN_00178408 (switch
  por el tipo del descriptor de +0x18) -> FUN_00178978/FUN_00178AE8 -> FUN_00178BC0
  -> FUN_00138C80, el spawner de `actores`: saca un bloque de la lista libre
  (mgr+0x7990) a la viva (mgr+0x79A0), le da cuerpo, cerebro, controlador de
  colision (FUN_0025C210) y enlace, y le pone la vida en 100.0 (+0x2F8).
  FUN_001746C8 es "activar" (+0x28 = 1) y FUN_001746D8 "desactivar".

  => activar un spawner es UN BYTE, y el que hace aparecer es el propio juego.

Uso (desde black/):
  python herramientas/sondas_spawn.py censo              # los spawners, con distancia a J
  python herramientas/sondas_spawn.py foto <i>           # JSON del spawner i y de los pools
  python herramientas/sondas_spawn.py mirar <i> <s>      # ACTIVA el i (+0x28 = 1) y registra s segundos
  python herramientas/sondas_spawn.py mirar <i> <s> --sin-activar   # el control: mismo registro, sin escribir
  python herramientas/sondas_spawn.py apuntar <i>        # gira la vista de J hacia el punto (el signo del yaw se mide)
  python herramientas/sondas_spawn.py punto-delante <i> <m>   # P17b: mueve el punto del spawner a m metros delante de J

Escriben: `mirar` sin --sin-activar (un byte), `apuntar` (el yaw de la vista) y
`punto-delante` (tres floats del punto). Confirmado en (83): 4 de 4 apariciones,
y con el punto movido el enemigo nace donde se lo puso y se ve.
"""
from __future__ import annotations

import argparse
import json
import math
import struct
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from pine import Pine  # noqa: E402

G_DISPARADORES = 0x0040F4F4
G_ACTORES = 0x0040F514
G_JUEGO = 0x0040F4D0
G_CUERPOS = 0x0040F4CC     # cuerpos de personaje (antes `ragdoll`): pool de 20 controladores
G_4D4 = 0x0040F4D4         # contador de apariciones en +0xFA4 (param_1 de FUN_00178BC0)
LISTAS = (12, 13)


def f32(p: Pine, d: int) -> float:
    return struct.unpack("<f", struct.pack("<I", p.leer32(d)))[0]


def pos(p: Pine, d: int) -> list[float]:
    return [round(f32(p, d + 4 * k), 3) for k in range(3)]


def spawners(p: Pine) -> list[tuple[int, int, int]]:
    """(lista, indice, direccion) de cada spawner vivo en la tabla."""
    tabla = p.leer32(G_DISPARADORES)
    out = []
    for lista in LISTAS:
        n = p.leer16(tabla + 2 * lista)
        arr = p.leer32(tabla + 0x48 + 4 * lista)
        for i in range(n if arr else 0):
            sp = p.leer32(arr + 4 * i)
            if sp:
                out.append((lista, i, sp))
    return out


def leer_spawner(p: Pine, sp: int) -> dict:
    desc = p.leer32(sp + 0x18)
    punto = p.leer32(desc + 4) if desc else 0
    actor = p.leer32(sp + 0x24)
    return {
        "sp": f"0x{sp:08X}",
        "tipo": p.leer32(desc) if desc else None,
        "punto": pos(p, punto + 0x10) if punto else None,
        "activo": p.leer8(sp + 0x28),
        "b2A": p.leer8(sp + 0x2A),
        "b2B": p.leer8(sp + 0x2B),
        "restantes": p.leer32(sp + 0x2C, con_signo=True),
        "t": round(f32(p, sp + 0x30), 3),
        "periodo": round(f32(p, sp + 0x34), 3),
        "modo": p.leer32(sp + 0x3C),
        "actor": f"0x{actor:08X}",
        "actor_estado": p.leer32(actor + 0x38C) if actor else None,
        "actor_vida": round(f32(p, actor + 0x2F8), 2) if actor else None,
    }


def pools(p: Pine) -> dict:
    mgr = p.leer32(G_ACTORES)
    cuerpos = p.leer32(G_CUERPOS)
    ocupados = sum(1 for k in range(20) if p.leer8(cuerpos + 0x2960 + k))
    return {
        "actores_7990": [p.leer32(mgr + 0x7990 + 4 * k) for k in range(3)],   # lista libre (cuenta en +8, hipotesis)
        "actores_79A0": [p.leer32(mgr + 0x79A0 + 4 * k) for k in range(3)],   # lista viva
        "contador_apariciones": p.leer32(p.leer32(G_4D4) + 0xFA4),
        "controladores_ocupados_de_20": ocupados,
    }


def jugador(p: Pine) -> list[float]:
    return pos(p, p.leer32(G_JUEGO) + 0x30 + 0xA0)


def cmd_censo(a) -> None:
    with Pine() as p:
        j = jugador(p)
        filas = []
        for lista, i, sp in spawners(p):
            s = leer_spawner(p, sp)
            d = math.dist(j, s["punto"]) if s["punto"] else float("inf")
            filas.append((d, lista, i, s))
        print(f"J en {j}; {len(filas)} spawners")
        for d, lista, i, s in sorted(filas, key=lambda x: x[0])[: a.n]:
            cand = s["activo"] == 0 and s["restantes"] != 0 and s["b2A"] and s["b2B"] and s["actor"] == "0x00000000"
            print(f"  L{lista}[{i}] d={d:6.1f} m  {'CANDIDATO ' if cand else ''}{json.dumps(s)}")
        print(json.dumps(pools(p)))


def buscar(p: Pine, i: int, lista: int) -> int:
    for l, k, sp in spawners(p):
        if l == lista and k == i:
            return sp
    raise SystemExit(f"no hay spawner L{lista}[{i}]")


def cmd_foto(a) -> None:
    with Pine() as p:
        sp = buscar(p, a.i, a.lista)
        print(json.dumps({"jugador": jugador(p), "spawner": leer_spawner(p, sp), "pools": pools(p)}))


def cmd_mirar(a) -> None:
    with Pine() as p:
        sp = buscar(p, a.i, a.lista)
        antes = {"spawner": leer_spawner(p, sp), "pools": pools(p)}
        print("ANTES", json.dumps(antes))
        if not a.sin_activar:
            p.escribir8(sp + 0x28, 1)
            print(f"escrito +0x28 = 1 en 0x{sp:08X}")
        else:
            print("CONTROL: no se escribe nada")
        t0 = time.time()
        ultimo = None
        while time.time() - t0 < a.segundos:
            s = leer_spawner(p, sp)
            q = pools(p)
            act = int(s["actor"], 16)
            a0 = pos(p, act + 0xA0) if act else None
            # la posicion entra redondeada a 0,5 m: registra si el actor nace en el punto y camina
            clave = (s["activo"], s["restantes"], s["actor"], s["actor_estado"], json.dumps(q),
                     tuple(round(v * 2) for v in a0) if a0 else None)
            if clave != ultimo:
                print(f"  t={time.time() - t0:5.2f}s A0={a0} {json.dumps(s)} {json.dumps(q)}")
                ultimo = clave
            time.sleep(0.1)
        s = leer_spawner(p, sp)
        res = {"spawner": s, "pools": pools(p), "jugador": jugador(p)}
        if s["actor"] != "0x00000000":
            act = int(s["actor"], 16)
            res["actor_pos_A0"] = pos(p, act + 0xA0)
            res["actor_B4"] = f"0x{p.leer32(act + 0xB4):08X}"
        print("DESPUES", json.dumps(res))


MIRA_YAW = 0x005A8FA8      # mira+8, el yaw en GRADOS que gobierna la vista (bitacora (76))


def adelante_xz(p: Pine) -> tuple[float, float]:
    # matriz de RenderWare: derecha +0x70, arriba +0x80, ADELANTE +0x90, posicion +0xA0
    j = p.leer32(G_JUEGO) + 0x30
    return f32(p, j + 0x90), f32(p, j + 0x98)


def cmd_apuntar(a) -> None:
    """Gira la vista de J hacia el punto del spawner i. El signo del yaw se MIDE, no se supone."""
    with Pine() as p:
        s = leer_spawner(p, buscar(p, a.i, a.lista))
        j = jugador(p)
        objetivo = math.atan2(s["punto"][0] - j[0], s["punto"][2] - j[2])
        signo = 1.0
        for paso in range(4):
            fx, fz = adelante_xz(p)
            err = math.remainder(objetivo - math.atan2(fx, fz), math.tau)
            print(f"  paso {paso}: yaw={f32(p, MIRA_YAW):8.2f} adelante=({fx:+.3f},{fz:+.3f}) error={math.degrees(err):+7.2f} grados")
            if abs(math.degrees(err)) < 2.0:
                break
            yaw = f32(p, MIRA_YAW)
            p.escribir_f32(MIRA_YAW, yaw + signo * math.degrees(err))
            time.sleep(0.3)
            fx2, fz2 = adelante_xz(p)
            err2 = math.remainder(objetivo - math.atan2(fx2, fz2), math.tau)
            if abs(err2) > abs(err):          # empeoro: el yaw va al reves
                signo = -signo
                p.escribir_f32(MIRA_YAW, yaw + signo * math.degrees(err))
                time.sleep(0.3)
        print(json.dumps({"jugador": j, "punto": s["punto"], "yaw": round(f32(p, MIRA_YAW), 2), "signo": signo}))


def cmd_punto_delante(a) -> None:
    """P17b: escribe el punto de aparicion del spawner i a `metros` delante de J, a la altura de sus pies."""
    with Pine() as p:
        sp = buscar(p, a.i, a.lista)
        punto = p.leer32(p.leer32(sp + 0x18) + 4)
        j = jugador(p)
        fx, fz = adelante_xz(p)
        n = math.hypot(fx, fz) or 1.0
        nuevo = [j[0] + a.metros * fx / n, j[1], j[2] + a.metros * fz / n]
        viejo = pos(p, punto + 0x10)
        for k, v in enumerate(nuevo):
            p.escribir_f32(punto + 0x10 + 4 * k, v)
        j2 = pos(p, 0x0046CDF0 + 0xA0)
        print(json.dumps({"punto": f"0x{punto:08X}", "viejo": viejo, "nuevo": pos(p, punto + 0x10),
                          "jugador": j, "j2": j2}))


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    c = sub.add_parser("censo")
    c.add_argument("--n", type=int, default=12)
    for nombre in ("foto", "mirar", "apuntar", "punto-delante"):
        s = sub.add_parser(nombre)
        s.add_argument("i", type=int)
        s.add_argument("--lista", type=int, default=12)
        if nombre == "mirar":
            s.add_argument("segundos", type=float)
            s.add_argument("--sin-activar", action="store_true")
        if nombre == "punto-delante":
            s.add_argument("metros", type=float)
    a = ap.parse_args()
    {"censo": cmd_censo, "foto": cmd_foto, "mirar": cmd_mirar, "apuntar": cmd_apuntar,
     "punto-delante": cmd_punto_delante}[a.cmd](a)


if __name__ == "__main__":
    main()
