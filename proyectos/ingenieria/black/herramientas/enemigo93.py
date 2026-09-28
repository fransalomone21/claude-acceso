"""(93g) B4/B5 en vivo -- un enemigo que nace junto a J2 (y lejos de J): le dispara? le baja la vida?
Lanza el fork con el bloque del pnach (campana_coop.lanzar), carga City Streets, espera el juego, aparta a
J2 con `coop_mod.py manos 3` y despues, con dos spawners candidatos distintos (sondas_spawn, (83)):
  PRUEBA  : punto a 5 m de J2, del lado opuesto a J  (d(J2) = 5, d(J) ~ 5 + |J-J2|)
  CONTROL : punto a 5 m de J, del lado opuesto a J2  (el control positivo: le dispara a J?)
En cada caso activa el spawner (+0x28 = 1) y registra 25 s cada 0,25 s: vida de J (+0x2F8), vida de J2,
el enemigo (posicion, vida, +0x38C) y las distancias. Captura al final.
Prediccion (93d): los enemigos no conocen a J2 -> en la PRUEBA la vida de J2 no baja y, si alguien recibe,
es J. En el CONTROL la vida de J baja (si no baja, la prueba no mide nada: es el caso de (88)).
Salida: volcados/campana/enemigo93.json"""
import json, math, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
import sondas_spawn as ss  # noqa: E402
from pine import Pine  # noqa: E402

VIDA = 0x2F8


def candidatos(p):
    out = []
    for lista, i, sp in ss.spawners(p):
        s = ss.leer_spawner(p, sp)
        if s["activo"] == 0 and s["restantes"] != 0 and s["b2A"] and s["b2B"] and s["actor"] == "0x00000000":
            out.append((lista, i, sp, s))
    return out


def correr(p, sp, punto_xyz, tag):
    J = p.leer32(cj.JUEGO_PTR) + 0x30
    punto = p.leer32(p.leer32(sp + 0x18) + 4)
    for k, v in enumerate(punto_xyz):
        p.escribir_f32(punto + 0x10 + 4 * k, v)
    p.escribir8(sp + 0x28, 1)
    serie, t0 = [], time.time()
    while time.time() - t0 < 25:
        a = p.leer32(sp + 0x24)
        jp, j2p = ss.pos(p, J + 0xA0), ss.pos(p, cj.J2 + 0xA0)
        f = {"t": round(time.time() - t0, 2), "vida_J": round(p.leer_f32(J + VIDA), 1),
             "vida_J2": round(p.leer_f32(cj.J2 + VIDA), 1), "enemigo": hex(a)}
        if a:
            ep = ss.pos(p, a + 0xA0)
            f.update({"e_vida": round(p.leer_f32(a + VIDA), 1), "e_38C": p.leer32(a + 0x38C),
                      "e_bando": p.leer32(a + 0x3A4), "d_J": round(math.dist(ep, jp), 2),
                      "d_J2": round(math.dist(ep, j2p), 2)})
        serie.append(f)
        time.sleep(0.25)
    cc.cap("enemigo93-%s.png" % tag)
    vj = [f["vida_J"] for f in serie]
    vj2 = [f["vida_J2"] for f in serie]
    return {"sp": hex(sp), "punto": [round(v, 2) for v in punto_xyz],
            "vida_J_min_max": [min(vj), max(vj)], "vida_J2_min_max": [min(vj2), max(vj2)],
            "bajadas_J": sum(1 for a, b in zip(vj, vj[1:]) if b < a - 0.5),
            "bajadas_J2": sum(1 for a, b in zip(vj2, vj2[1:]) if b < a - 0.5),
            "ultimo": serie[-1], "serie": serie}


def main():
    res = {}
    if not cc.lanzar():
        raise SystemExit("fork no vivo")
    cc.run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    cc.run("selector_depuracion.py", "elegir", "0", "0")
    cc.run("selector_depuracion.py", "aceptar")
    t0 = time.time()
    while time.time() - t0 < 90:
        with Pine() as p:
            a = p.leer32(cm.CONTADOR)
        time.sleep(1.5)
        with Pine() as p:
            if p.leer32(cm.CONTADOR) - a > 5:
                break
    time.sleep(8)
    r = cc.run("coop_mod.py", "manos", "3")
    res["manos"] = r.stdout.strip().splitlines()[-1] if r is not None and r.stdout.strip() else None
    time.sleep(1)
    with Pine() as p:
        J = p.leer32(cj.JUEGO_PTR) + 0x30
        jp, j2p = ss.pos(p, J + 0xA0), ss.pos(p, cj.J2 + 0xA0)
        dx, dz = j2p[0] - jp[0], j2p[2] - jp[2]
        n = math.hypot(dx, dz) or 1.0
        ux, uz = dx / n, dz / n
        res["J"], res["J2"], res["J_J2_m"] = jp, j2p, round(n, 2)
        cands = candidatos(p)
        res["candidatos"] = len(cands)
        print("candidatos", len(cands), "J-J2", round(n, 2), flush=True)
        if len(cands) < 2:
            raise SystemExit("faltan spawners candidatos")
        res["prueba"] = correr(p, cands[0][2], [j2p[0] + 5 * ux, j2p[1], j2p[2] + 5 * uz], "prueba")
        print("prueba", json.dumps({k: v for k, v in res["prueba"].items() if k != "serie"}), flush=True)
        jp = ss.pos(p, J + 0xA0)
        res["control"] = correr(p, cands[1][2], [jp[0] - 5 * ux, jp[1], jp[2] - 5 * uz], "control")
        print("control", json.dumps({k: v for k, v in res["control"].items() if k != "serie"}), flush=True)
    (cc.SAL / "enemigo93.json").write_text(json.dumps(res, indent=1))
    cc.matar_fork()


if __name__ == "__main__":
    main()
