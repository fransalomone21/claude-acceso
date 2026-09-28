"""(93i) Un titere donde no hay aliado: en un nivel sin aliado vivo (Wilderness por defecto), hacer nacer un
soldado con un spawner (83) en el punto de J2 y, cuando tiene alta (+0x38C = 0, +0xB4 != 0), ponerle bando 0
(+0x3A4). ELEGIR (93h) lo tendria que tomar solo y el titere seguir a J2.
CONTROL: el mismo soldado SIN cambiarle el bando (ELEGIR no lo toma: TITERE_ACT sigue en 0).
Prediccion: con bando 0, TITERE_ACT = el soldado en <= 1 cuadro y lo sigue a <= 0,4 m con `manos 2`.
Uso: python herramientas/titere_spawn93.py [nivel]     Salida: volcados/campana/titere_spawn93.json"""
import json, math, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
import sondas_spawn as ss  # noqa: E402
from enemigo93 import candidatos  # noqa: E402
from pine import Pine  # noqa: E402


def nacer(p, sp, xyz):
    punto = p.leer32(p.leer32(sp + 0x18) + 4)
    for k, v in enumerate(xyz):
        p.escribir_f32(punto + 0x10 + 4 * k, v)
    p.escribir8(sp + 0x28, 1)
    t0 = time.time()
    while time.time() - t0 < 10:
        a = p.leer32(sp + 0x24)
        if a and p.leer32(a + 0x38C) == 0 and p.leer32(a + 0xB4):
            return a, round(time.time() - t0, 2)
        time.sleep(0.05)
    return p.leer32(sp + 0x24), None


def main():
    n = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    res = {"nivel": cc.NOMBRES[n]}
    if not cc.lanzar():
        raise SystemExit("fork no vivo")
    cc.run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    cc.run("selector_depuracion.py", "elegir", str(n), "0")
    cc.run("selector_depuracion.py", "aceptar")
    t0 = time.time()
    while time.time() - t0 < 120:
        try:
            with Pine() as p:
                a = p.leer32(cm.CONTADOR)
            time.sleep(1.5)
            with Pine() as p:
                if p.leer32(cm.CONTADOR) - a > 5 and p.leer32(cm.FASE) == 2:
                    break
        except Exception:  # noqa: BLE001
            time.sleep(1)
    time.sleep(8)
    with Pine() as p:
        res["titere_act_inicial"] = hex(p.leer32(cm.TITERE_ACT))
        cands = candidatos(p)
        res["candidatos"] = len(cands)
        j2p = ss.pos(p, cj.J2 + 0xA0)
        # CONTROL: nace, bando sin tocar
        a, t = nacer(p, cands[0][2], [j2p[0], j2p[1], j2p[2] + 3.0])
        time.sleep(0.5)
        res["control"] = {"actor": hex(a), "alta_s": t, "bando": p.leer32(a + 0x3A4) if a else None,
                          "titere_act": hex(p.leer32(cm.TITERE_ACT)), "tipo": hex(p.leer32(a + 0x328)) if a else None}
        # PRUEBA: el mismo soldado con bando 0
        if a:
            p.escribir32(a + 0x3A4, 0)
            # (93i) el grupo de colision se fija al atar (FUN_0025CEF8: jugador 3, aliado 4, enemigo 6);
            # sin esto el soldado sigue chocando como enemigo y traba a J2. `--sin-grupo` es el control.
            g = p.leer32(p.leer32(a + 0xB4) + 0x34) + 0x18
            res["grupo_antes"] = p.leer32(g)
            if "--sin-grupo" not in sys.argv:
                p.escribir32(g, 4)
            time.sleep(0.5)
            res["prueba"] = {"titere_act": hex(p.leer32(cm.TITERE_ACT)), "d_J2": round(math.dist(
                ss.pos(p, a + 0xA0), ss.pos(p, cj.J2 + 0xA0)), 2), "vida": round(p.leer_f32(a + 0x2F8), 1)}
    print(json.dumps(res), flush=True)
    time.sleep(2)
    with Pine() as p:
        c1 = p.leer32(cm.CONTADOR)
    time.sleep(1)
    with Pine() as p:
        res["cuadros_1s_despues"] = p.leer32(cm.CONTADOR) - c1
    if res["cuadros_1s_despues"] < 5:
        pcs = []
        for _ in range(6):
            cc.run("depurador.py", "pausar")
            r = cc.run("depurador.py", "estado")
            pcs.append(r.stdout.strip()[-200:] if r is not None else None)
            cc.run("depurador.py", "continuar")
            time.sleep(0.3)
        res["pcs"] = pcs
        print("COLGADO", pcs, flush=True)
    cc.cap("titere93i-quieto.png")
    r = cc.run("coop_mod.py", "manos", "2")
    try:
        res["manos"] = json.loads(r.stdout.strip().splitlines()[-1])
    except Exception as ex:  # noqa: BLE001
        res["manos"] = "error: %s" % ex
    cc.cap("titere93i-camino.png")
    with Pine() as p:
        a = int(res["control"]["actor"], 16)
        res["despues"] = {"titere_act": hex(p.leer32(cm.TITERE_ACT)), "e38C": p.leer32(a + 0x38C),
                          "vida": round(p.leer_f32(a + 0x2F8), 1), "bando": p.leer32(a + 0x3A4),
                          "ocultos_p2": p.leer32(0x0046FBFC)}
    r = cc.run("selector_depuracion.py", "vivo")
    res["vivo"] = r is not None and '"vivo": true' in r.stdout
    (cc.SAL / "titere_spawn93.json").write_text(json.dumps(res, indent=1))
    print(json.dumps({k: v for k, v in res.items()}, default=str)[:1500], flush=True)
    cc.matar_fork()


if __name__ == "__main__":
    main()
