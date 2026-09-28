"""(93h) El titere por nivel: censo del pool de actores (32 bloques de 0x3C0 desde *(0x0040F514)+0x90) en
cada nivel pedido, para elegir un titere que sirva en los 8. Lanza el fork con el bloque del pnach
(campana_coop.lanzar) y carga los niveles en orden con el selector. Por actor: tipo (+0x328), bando (+0x3A4),
+0x38C, vida, posicion (+0xA0), distancia a J, las 4 primeras palabras (enlaces?) y si se mueve en 2 s.
Tambien las cabezas de la lista libre (mgr+0x7990) y viva (mgr+0x79A0).
Uso: python herramientas/censo_titere.py 0 1 2 3 7     Salida: volcados/campana/censo_titere.json"""
import json, math, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
import sondas_spawn as ss  # noqa: E402
from pine import Pine  # noqa: E402

N_POOL, PASO = 32, 0x3C0


def foto(p):
    mgr = p.leer32(0x0040F514)
    J = p.leer32(cj.JUEGO_PTR) + 0x30
    jp = ss.pos(p, J + 0xA0)
    filas = []
    for i in range(N_POOL):
        a = mgr + 0x90 + i * PASO
        f = {"i": i, "a": hex(a), "tipo": hex(p.leer32(a + 0x328)), "bando": p.leer32(a + 0x3A4),
             "e38C": p.leer32(a + 0x38C), "vida": round(p.leer_f32(a + 0x2F8), 1),
             "pos": ss.pos(p, a + 0xA0), "w0": [hex(p.leer32(a + 4 * k)) for k in range(4)],
             "B4": hex(p.leer32(a + 0xB4)), "x32C": hex(p.leer32(a + 0x32C))}
        f["d_J"] = round(math.dist(f["pos"], jp), 1)
        filas.append(f)
    return {"mgr": hex(mgr), "libre": [hex(p.leer32(mgr + 0x7990 + 4 * k)) for k in range(4)],
            "viva": [hex(p.leer32(mgr + 0x79A0 + 4 * k)) for k in range(4)], "J": jp, "actores": filas}


def nivel(n):
    cc.run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    cc.run("selector_depuracion.py", "elegir", str(n), "0")
    cc.run("selector_depuracion.py", "aceptar")
    t0 = time.time()
    while time.time() - t0 < 120:
        try:
            with Pine() as p:
                e = cm.leer_estado(p)
            if e.get("fase") == 2 and e.get("estado") == 3:
                break
        except Exception:  # noqa: BLE001
            pass
        time.sleep(1)
    t0 = time.time()
    while time.time() - t0 < 120:
        with Pine() as p:
            a = p.leer32(cm.CONTADOR)
        time.sleep(1.5)
        with Pine() as p:
            if p.leer32(cm.CONTADOR) - a > 5:
                break
    time.sleep(8)
    with Pine() as p:
        f1 = foto(p)
    time.sleep(2)
    with Pine() as p:
        f2 = foto(p)
    for a, b in zip(f1["actores"], f2["actores"]):
        a["se_mueve_2s"] = round(math.dist(a["pos"], b["pos"]), 2)
    f1["nombre"] = cc.NOMBRES[n]
    return f1


def main():
    niveles = [int(x) for x in sys.argv[1:]] or [0]
    if not cc.lanzar():
        raise SystemExit("fork no vivo")
    res = {}
    for n in niveles:
        res[n] = nivel(n)
        vivos = [a for a in res[n]["actores"] if a["tipo"] != "0x0"]
        print(n, cc.NOMBRES[n], "viva", res[n]["viva"], flush=True)
        for a in vivos:
            print("   ", a["i"], a["tipo"], "bando", a["bando"], "38C", a["e38C"], "vida", a["vida"], "dJ", a["d_J"],
                  "mueve", a["se_mueve_2s"], a["w0"], a["B4"], flush=True)
        (cc.SAL / "censo_titere.json").write_text(json.dumps(res, indent=1))
    cc.matar_fork()


if __name__ == "__main__":
    main()
