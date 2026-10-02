"""s0_ia.py -- sonda S0 de COOP-B (RETOME-LOCAL): ¿la IA ve a J2? (con el bloque --con-ia o sin el, que es el control)

Con un nivel cargado y J2 armado (FASE 2, ESTADO 3), en UNA conexion PINE. Dos modos:
  spawner (por defecto): J2 camina `--caminar` s; un spawner candidato se mueve a `--metros` delante de J2 y se
      activa. (Medido en (110): el enemigo nacido asi junto a J2 nace MUERTO, como en (93g): no sirve de banco.)
  --ir J|J2: el jugador camina hacia el enemigo EN PELEA (bando 1, vivo, con amenaza actual) mas cercano, con
      el yaw corregido en lazo cerrado, hasta `--cerca` m (o `--tope` s, o trabado), y se queda `--segundos`.
Se registra cada 0,1 s, por cada agente activo (fisica+0x2B00+i*0x1FD0, +0x78 != 0): la mascara de visibles
+0x274 (bit = 1 << id; J id 0, J2 id 1), las amenazas +0x150/+0x1B0/+0x210 (id en la primera palabra; vacia =
0xFFFFFFFF), la actual +0x270, el personaje +0x7C con bando (+0x3A4), id (+0x380), vida y posicion; ademas la
vida y posicion de J y J2 y el titere elegido (TITERE_ACT).
Prediccion (con la IA): bit 0x2 y/o id 1 en algun agente de bando 1. Control (sin la IA): 0x2 nunca, salvo por
dano de J2; y el control POSITIVO es el bit 0x1 (J) con J caminando al mismo lugar.

    python herramientas/s0_ia.py --etiqueta con-ia-j2 --ir J2 [--cerca 15] [--tope 30] [--segundos 15]
    python herramientas/s0_ia.py --etiqueta x [--caminar 2] [--metros 7] [--segundos 25] [--lista 12 --i N]
Salida: volcados/s0/<etiqueta>.json y un resumen en la ultima linea.
"""
import argparse
import json
import math
import struct
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import clon_jugador as cj  # noqa: E402
import coop_mod as cm  # noqa: E402
import sondas_spawn as ss  # noqa: E402

G_FISICA = 0x0040F4D4
AGENTES, PASO_AG = 0x2B00, 0x1FD0
SAL = H.parent / "volcados" / "s0"
MIRA_YAW = {"J": cj.J + 0x4F0 + 8, "J2": cj.J2 + 0x4F0 + 8}   # mira+8: yaw en grados (76)
FALSO = {"J": 0x00472000, "J2": cj.FALSO2}
CTRL1 = 0x005858A0                                             # sondas_coop.CTRL1


def f32(p, d):
    return struct.unpack("<f", struct.pack("<I", p.leer32(d)))[0]


def posa(p, b):           # posicion del personaje: +0xA0 (81)
    return [round(f32(p, b + 0xA0 + 4 * k), 2) for k in range(3)]


def agentes(p):
    fis = p.leer32(G_FISICA)
    out = []
    for i in range(16):
        a = fis + AGENTES + i * PASO_AG
        if not p.leer32(a + 0x78):
            continue
        pers = p.leer32(a + 0x7C)
        out.append({"i": i, "pers": pers, "bando": p.leer32(pers + 0x3A4) if pers else None,
                    "id": p.leer32(pers + 0x380) if pers else None,
                    "vida": round(f32(p, pers + 0x2F8), 1) if pers else None,
                    "est": p.leer32(pers + 0x38C) if pers else None,
                    "vis": p.leer32(a + 0x274), "am": [p.leer32(a + o) for o in (0x150, 0x1B0, 0x210)],
                    "act": p.leer32(a + 0x270), "pos": posa(p, pers) if pers else None})
    return out


def muestra(p, t0):
    return {"t": round(time.time() - t0, 2), "vJ": round(f32(p, cj.J + 0x2F8), 1),
            "vJ2": round(f32(p, cj.J2 + 0x2F8), 1), "tit": hex(p.leer32(cm.TITERE_ACT)),
            "eJ2": p.leer32(cj.J2 + 0x38C), "eJ": p.leer32(cj.J + 0x38C),   # (111) estado: 2 = muerto (110)
            "J": posa(p, cj.J), "J2": posa(p, cj.J2), "ag": agentes(p)}


def poner_falso(p, quien):
    ctrl = p.leer32(cj.J2 + 0x588) if quien == "J2" else CTRL1
    fuente = p.leer32(ctrl + 0xC)
    if fuente != FALSO[quien]:
        f2 = bytearray(p.leer_bloque(fuente, 0xF0))
        for o in range(0x8C, 0xCC, 4):
            f2[o:o + 4] = bytes(4)
        f2[0x0E:0x2A + 28] = bytes(0x2A + 28 - 0x0E)
        p.escribir_bloque(FALSO[quien], bytes(f2))
        p.escribir32(ctrl + 0xC, FALSO[quien])


def caminar(p, s):
    poner_falso(p, "J2")
    p.escribir_f32(cj.FALSO2 + 0x8C, 0.8)
    time.sleep(s)
    p.escribir_f32(cj.FALSO2 + 0x8C, 0.0)
    time.sleep(0.4)


def rumbo(p, base):
    """El 'adelante' de la matriz del personaje (+0x90, +0x98) como angulo en el plano xz."""
    return math.atan2(f32(p, base + 0x90), f32(p, base + 0x98))


def en_pelea(p):
    return [g for g in agentes(p) if g["bando"] == 1 and g["est"] == 0 and g["act"] != 0xFFFFFFFF and g["pos"]]


def ir(p, quien, cerca, tope, serie, t0, reg):
    base = cj.J if quien == "J" else cj.J2
    poner_falso(p, quien)
    signo, hist, motivo = None, [], "tope"
    tf = time.time() + tope
    while time.time() < tf:
        yo = posa(p, base)
        objs = en_pelea(p)
        if not objs:
            motivo = "sin pelea"
            break
        g = min(objs, key=lambda g: math.dist(g["pos"], yo))
        d = math.dist(g["pos"], yo)
        if d < cerca:
            motivo = "cerca: %.1f m del agente %d" % (d, g["i"])
            break
        obj = math.atan2(g["pos"][0] - yo[0], g["pos"][2] - yo[2])
        err = math.remainder(obj - rumbo(p, base), math.tau)
        yaw = f32(p, MIRA_YAW[quien])
        if signo is None:     # el signo del yaw se MIDE (como sondas_spawn apuntar)
            p.escribir_f32(MIRA_YAW[quien], yaw + 10.0)
            time.sleep(0.2)
            e2 = math.remainder(obj - rumbo(p, base), math.tau)
            signo = 1.0 if abs(e2) <= abs(err) else -1.0
            reg["signo_yaw_" + quien] = signo
            yaw, err = f32(p, MIRA_YAW[quien]), e2
        p.escribir_f32(MIRA_YAW[quien], yaw + signo * math.degrees(err))
        p.escribir_f32(FALSO[quien] + 0x8C, 0.8 if abs(math.degrees(err)) < 45 else 0.0)
        ahora = time.time()
        hist.append((ahora, yo))
        viejos = [h for h in hist if ahora - h[0] > 2.5]
        if viejos and math.dist(viejos[-1][1], yo) < 0.5:
            motivo = "trabado en %s" % yo
            break
        serie.append(muestra(p, t0))
        time.sleep(0.1)
    p.escribir_f32(FALSO[quien] + 0x8C, 0.0)
    return motivo


def elegir_spawner(p, lista, i):
    if lista is not None:
        return lista, i, ss.buscar(p, i, lista)
    for l, k, sp in ss.spawners(p):
        s = ss.leer_spawner(p, sp)
        if s["activo"] == 0 and s["restantes"] != 0 and s["b2A"] and s["b2B"] and s["actor"] == "0x00000000" \
                and s["punto"]:
            return l, k, sp
    raise SystemExit("ningun spawner candidato")


def modo_spawner(p, a, reg):
    if a.caminar > 0:
        caminar(p, a.caminar)
    jp, j2p = posa(p, cj.J), posa(p, cj.J2)
    reg["J_J2_m"] = round(math.dist(jp, j2p), 2)
    l, k, sp = elegir_spawner(p, a.lista, a.i)
    punto = p.leer32(p.leer32(sp + 0x18) + 4)
    if a.hacia_j:   # sobre el piso que J2 ya camino (110: el punto en el aire nace y cae muerto)
        fx, fz = jp[0] - j2p[0], jp[2] - j2p[2]
    elif a.lejos_j:  # (111) del lado de J2 opuesto a J: que el nacido vea primero a J2
        fx, fz = j2p[0] - jp[0], j2p[2] - jp[2]
    else:
        fx, fz = f32(p, cj.J2 + 0x90), f32(p, cj.J2 + 0x98)
    n = math.hypot(fx, fz) or 1.0
    nuevo = [j2p[0] + a.metros * fx / n, j2p[1], j2p[2] + a.metros * fz / n]
    for q, v in enumerate(nuevo):
        p.escribir_f32(punto + 0x10 + 4 * q, v)
    reg["spawner"] = {"lista": l, "i": k, "sp": hex(sp), "punto": [round(x, 2) for x in nuevo],
                      "a_J_m": round(math.dist(nuevo, jp), 2), "a_J2_m": round(math.dist(nuevo, j2p), 2)}
    p.escribir8(sp + 0x28, 1)
    t0, serie, nacido, t_nac = time.time(), [], 0, None
    while time.time() - t0 < a.segundos:
        if not nacido:
            nacido = p.leer32(sp + 0x24)
            if nacido:
                t_nac = round(time.time() - t0, 2)
        m = muestra(p, t0)
        if nacido:
            m["nac"] = {"d": hex(nacido), "bando": p.leer32(nacido + 0x3A4), "est": p.leer32(nacido + 0x38C),
                        "vida": round(f32(p, nacido + 0x2F8), 1), "pos": posa(p, nacido)}
        serie.append(m)
        time.sleep(0.1)
    reg["nacido"], reg["t_nacido"], reg["serie"] = hex(nacido), t_nac, serie


def modo_ir(p, a, reg):
    t0, serie = time.time(), []
    reg["ir_motivo"] = ir(p, a.ir, a.cerca, a.tope, serie, t0, reg)
    reg["t_llegada"] = round(time.time() - t0, 2)
    tq = time.time()
    while time.time() - tq < a.segundos:
        serie.append(muestra(p, t0))
        time.sleep(0.1)
    reg["serie"] = serie
    reg["J_J2_m"] = round(math.dist(posa(p, cj.J), posa(p, cj.J2)), 2)


def resumir(reg):
    serie = reg["serie"]
    res = {"bit1_J": None, "bit2_J2": None, "id1_J2": None, "id0_J": None, "agentes_b1": set(),
           "vJ_min": min(m["vJ"] for m in serie), "vJ2_min": min(m["vJ2"] for m in serie),
           "ir_motivo": reg.get("ir_motivo"), "t_llegada": reg.get("t_llegada"), "J_J2_m": reg.get("J_J2_m")}
    for m in serie:
        for g in m["ag"]:
            if g["bando"] != 1:
                continue
            res["agentes_b1"].add(g["i"])
            for clave, cond in (("bit1_J", g["vis"] & 1), ("bit2_J2", g["vis"] & 2),
                                ("id0_J", reg["ids"]["J"] in g["am"]), ("id1_J2", reg["ids"]["J2"] in g["am"])):
                if cond and res[clave] is None:
                    res[clave] = m["t"]
    # (111) la amenaza ACTUAL: +0x270 como indice de la lista (hipotesis; act_crudos dice si alguna vez salio de 0..2/-1)
    res["act_J2"], res["act_J"], crudos = None, None, set()
    for m in serie:
        for g in m["ag"]:
            if g["bando"] != 1:
                continue
            crudos.add(g["act"])
            blanco = g["am"][g["act"]] if g["act"] in (0, 1, 2) else None
            for clave, quien in (("act_J2", "J2"), ("act_J", "J")):
                if blanco == reg["ids"][quien] and res[clave] is None:
                    res[clave] = [m["t"], g["i"]]
    res["act_crudos"] = sorted(hex(x) for x in crudos)
    if reg.get("nacido"):
        nac = [m["nac"] for m in serie if m.get("nac")]
        res["nacido_vivo_final"] = nac[-1]["vida"] if nac else None
    res["agentes_b1"] = sorted(res["agentes_b1"])
    res["titere_tomo_nacido"] = any(m.get("nac") and m["tit"] == m["nac"]["d"] for m in serie)
    return res


def main():
    tolerar_salida_pobre()
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--etiqueta", required=True)
    ap.add_argument("--caminar", type=float, default=2.0)
    ap.add_argument("--metros", type=float, default=7.0)
    ap.add_argument("--segundos", type=float, default=25.0)
    ap.add_argument("--lista", type=int)
    ap.add_argument("--i", type=int)
    ap.add_argument("--hacia-j", action="store_true", help="el punto va de J2 hacia J, no adelante de J2")
    ap.add_argument("--lejos-j", action="store_true", help="(111) el punto del lado de J2 opuesto a J")
    ap.add_argument("--vida-j2", type=float, help="(111) vida de J2 al empezar (la muerte por dano real)")
    ap.add_argument("--ir", choices=("J", "J2"))
    ap.add_argument("--proto-percep", action="store_true", help="prototipo por PINE de la percepcion de J2 (110)")
    ap.add_argument("--vida-j", action="store_true", help="vida de J en 1e6 al empezar (J no muere)")
    ap.add_argument("--cerca", type=float, default=15.0)
    ap.add_argument("--tope", type=float, default=30.0)
    a = ap.parse_args()
    SAL.mkdir(parents=True, exist_ok=True)
    reg = {"etiqueta": a.etiqueta, "args": vars(a)}
    with Pine() as p:
        reg["fase_estado"] = [p.leer32(cm.FASE), p.leer32(cm.ESTADO)]
        if reg["fase_estado"] != [2, 3]:
            raise SystemExit("J2 no esta armado: %s" % reg["fase_estado"])
        reg["ids"] = {"J": p.leer32(cj.J + 0x380), "J2": p.leer32(cj.J2 + 0x380)}
        reg["ia_sitios"] = {hex(s): hex(p.leer32(s)) for s in (0x0018FC4C, 0x0019098C, 0x0018A8BC, 0x00184904)}
        reg["agentes_antes"] = agentes(p)
        if a.proto_percep:   # (110) J2 en la 5.a ranura del escuadron y el lazo de percepcion hasta 5
            esc = p.leer32(G_FISICA) + 0x22800
            p.escribir32(esc + 0x74, cj.J2)
            p.escribir32(0x00185184, 0x2A620005)          # slti v0, s3, 5 (original 0x2A620004)
            reg["proto_percep"] = [hex(p.leer32(esc + 0x74)), hex(p.leer32(0x00185184))]
        if a.vida_j:
            p.escribir_f32(cj.J + 0x2F8, 1.0e6)            # que J no muera durante la medicion
        if a.vida_j2 is not None:
            p.escribir_f32(cj.J2 + 0x2F8, a.vida_j2)
        (modo_ir if a.ir else modo_spawner)(p, a, reg)
    reg["resumen"] = res = resumir(reg)
    (SAL / ("%s.json" % a.etiqueta)).write_text(json.dumps(reg, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({k: reg.get(k) for k in ("fase_estado", "ids", "ia_sitios", "spawner", "nacido",
                                             "t_nacido", "signo_yaw_J", "signo_yaw_J2")}, ensure_ascii=False))
    print(json.dumps(res, ensure_ascii=False))


if __name__ == "__main__":
    main()
