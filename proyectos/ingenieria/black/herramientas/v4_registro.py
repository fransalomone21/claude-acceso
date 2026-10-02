"""v4_registro.py -- registro continuo para V4 (114): cambio de unidad real con J2 lejos y "continuar mision".

Fran juega a J con el bloque COOP prendido; nadie toca el mando 2, asi que J2 queda atras. Cada 0,5 s, por PINE
(solo lectura: no escribe nada), anota la posicion de J y J2 (+0xA0), la distancia, la vida (+0x2F8), el estado
(+0x38C; 2 = muerto, (111)), el controlador de J2 (+0xB4, el que ata FUN_0012BE80, (82)), FASE/ESTADO del mod y si
el contador por cuadro del mod sube (el mundo corre). Los EVENTOS (cambio de FASE/ESTADO/estado/controlador, la
distancia cruzando 15 y 50 m, J2 bajando > 3 m entre muestras, el mundo frenado o reanudado, saltos de J > 10 m) van
a la consola y a eventos.txt; todo a registro.csv.

    python herramientas/v4_registro.py [segundos]        # default 1800
    python herramientas/v4_registro.py --autotest        # el detector de eventos sobre muestras armadas
Salida: volcados/v4/<fecha-hora>/
"""
import csv, math, sys, time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from salida import tolerar_salida_pobre  # noqa: E402

J, J2 = 0x005A8AB0, 0x0046CDF0          # clon_jugador.py (J = sondas_coop.JUGADOR)
CONTADOR, ESTADO, FASE = 0x0046D780, 0x0046D784, 0x0046D790   # coop_mod.py


def muestra(p):
    def pos(b):
        return [p.leer_f32(b + 0xA0 + 4 * k) for k in range(3)]
    pj, pj2 = pos(J), pos(J2)
    return {"t": time.time(), "J": pj, "J2": pj2, "dist": math.dist(pj, pj2),
            "vidaJ": p.leer_f32(J + 0x2F8), "vidaJ2": p.leer_f32(J2 + 0x2F8),
            "estJ": p.leer32(J + 0x38C), "estJ2": p.leer32(J2 + 0x38C), "ctlJ2": p.leer32(J2 + 0xB4),
            "fase": p.leer32(FASE), "estado": p.leer32(ESTADO), "contador": p.leer32(CONTADOR)}


def eventos(a, b, corre_a, corre_b):
    """Lo que cambio entre dos muestras seguidas. Funcion pura (la prueba el autotest)."""
    ev = []
    for k in ("fase", "estado", "estJ", "estJ2"):
        if a[k] != b[k]:
            ev.append("%s %s -> %s" % (k, a[k], b[k]))
    if (a["ctlJ2"] == 0) != (b["ctlJ2"] == 0) or (a["ctlJ2"] and b["ctlJ2"] and a["ctlJ2"] != b["ctlJ2"]):
        ev.append("controlador J2 %#x -> %#x" % (a["ctlJ2"], b["ctlJ2"]))
    for u in (15, 50):
        if (a["dist"] < u) != (b["dist"] < u):
            ev.append("distancia cruza %d m (%.1f -> %.1f)" % (u, a["dist"], b["dist"]))
    if a["J2"][1] - b["J2"][1] > 3:
        ev.append("J2 baja %.1f m en altura (y %.1f -> %.1f)" % (a["J2"][1] - b["J2"][1], a["J2"][1], b["J2"][1]))
    if math.dist(a["J"], b["J"]) > 10:
        ev.append("J salta %.1f m" % math.dist(a["J"], b["J"]))
    if math.dist(a["J2"], b["J2"]) > 10:
        ev.append("J2 salta %.1f m" % math.dist(a["J2"], b["J2"]))
    if corre_a != corre_b:
        ev.append("el mundo %s" % ("corre" if corre_b else "FRENADO (contador quieto)"))
    return ev


def autotest():
    base = {"t": 0, "J": [0, 0, 0], "J2": [0, 0, 5], "dist": 5.0, "vidaJ": 100, "vidaJ2": 100, "estJ": 0,
            "estJ2": 0, "ctlJ2": 0x500000, "fase": 2, "estado": 3, "contador": 0}
    casos = [
        ({}, True, []),
        ({"fase": 0}, True, ["fase"]),
        ({"ctlJ2": 0}, True, ["controlador"]),
        ({"dist": 20.0}, True, ["cruza 15"]),
        ({"J2": [0, -4, 5]}, True, ["baja"]),
        ({"J": [11, 0, 0]}, True, ["J salta"]),
        ({}, False, ["FRENADO"]),
    ]
    mal = 0
    for cambio, corre, esperado in casos:
        b = dict(base, **cambio)
        ev = eventos(base, b, True, corre)
        ok = len(ev) == len(esperado) and all(any(e in x for x in ev) for e in esperado)
        mal += not ok
        print("%s %s -> %s" % ("OK  " if ok else "FALLA", cambio or "(igual)", ev))
    print("autotest:", "verde" if not mal else "%d en rojo" % mal)
    return 1 if mal else 0


def main():
    tolerar_salida_pobre()
    if "--autotest" in sys.argv:
        return autotest()
    if "-h" in sys.argv or "--help" in sys.argv:
        print(__doc__); return 0
    from pine import Pine
    dur = float(next((x for x in sys.argv[1:] if not x.startswith("-")), 1800))
    sal = H.parent / "volcados" / "v4" / time.strftime("%Y%m%d-%H%M%S")
    sal.mkdir(parents=True, exist_ok=True)
    fev = open(sal / "eventos.txt", "w", encoding="utf-8")
    fcsv = open(sal / "registro.csv", "w", newline="", encoding="utf-8")
    w = csv.writer(fcsv)
    w.writerow(["t", "Jx", "Jy", "Jz", "J2x", "J2y", "J2z", "dist", "vidaJ", "vidaJ2", "estJ", "estJ2", "ctlJ2",
                "fase", "estado", "contador"])
    t0, ant, corre_ant, ult_cont, ult_sube = time.time(), None, True, None, time.time()

    def nota(txt):
        linea = "[%6.1f s] %s" % (time.time() - t0, txt)
        print(linea, flush=True); fev.write(linea + "\n"); fev.flush()

    nota("registro en %s" % sal)
    while time.time() - t0 < dur:
        try:
            with Pine() as p:
                m = muestra(p)
        except Exception as ex:  # noqa: BLE001
            nota("PINE no contesta: %s" % ex); time.sleep(2); continue
        if ult_cont is None or m["contador"] != ult_cont:
            ult_sube = time.time()
        ult_cont = m["contador"]
        corre = time.time() - ult_sube < 2.0
        w.writerow(["%.2f" % (m["t"] - t0)] + ["%.2f" % v for v in m["J"] + m["J2"]] +
                   ["%.2f" % m["dist"], "%.1f" % m["vidaJ"], "%.1f" % m["vidaJ2"], m["estJ"], m["estJ2"],
                    "%#x" % m["ctlJ2"], m["fase"], m["estado"], m["contador"]])
        fcsv.flush()
        if ant is None:
            nota("inicio: dist %.1f m, vida J %.0f J2 %.0f, fase %d estado %d, ctlJ2 %#x"
                 % (m["dist"], m["vidaJ"], m["vidaJ2"], m["fase"], m["estado"], m["ctlJ2"]))
        else:
            for e in eventos(ant, m, corre_ant, corre):
                nota("%s | J %s J2 %s" % (e, [round(v, 1) for v in m["J"]], [round(v, 1) for v in m["J2"]]))
        if ant is None or int(m["t"] - t0) // 30 != int(ant["t"] - t0) // 30:
            nota("pulso: dist %.1f m, J2 y %.1f, vida J %.0f J2 %.0f, fase %d estado %d"
                 % (m["dist"], m["J2"][1], m["vidaJ"], m["vidaJ2"], m["fase"], m["estado"]))
        ant, corre_ant = m, corre
        time.sleep(0.5)
    nota("fin")
    return 0


if __name__ == "__main__":
    sys.exit(main())
