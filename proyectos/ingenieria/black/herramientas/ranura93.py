"""(93m) J2 con la RANURA 1 propia (pers+0x470+0x240, dueno J2), por PINE, y el bloque del pnach con el filtro
de eventos. Hipotesis: los eventos de animacion de J2 salen por su ranura (a1 del callback FUN_001E80C0 =
J2+0x330); con la ranura compartida (dueno J) la vista unica hace la recarga de J2 y el arma de J pasa a 8.
Con la ranura propia, el filtro los saltea: la mitad de J queda quieta y el arma de J no pasa a 8.
Control: la corrida `aislar93.py prueba2` (ranura compartida, mismo bloque). Despues J cambia de arma (boton
arma_b) y se lee J+0x330: si J pasa a la ranura 1, la ranura no es por jugador sino por arma ((80)).
Salida: volcados/campana/ranura93.json"""
import json, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
from aislar93 import boton2, DISPARAR, municion  # noqa: E402
from pine import Pine  # noqa: E402


def main():
    res = {}
    if not cc.lanzar():
        raise SystemExit("fork no vivo")
    cc.run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    cc.run("selector_depuracion.py", "elegir", "0", "0")
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
    cc.run("coop_mod.py", "manos", "0.5")
    with Pine() as p:
        J = p.leer32(cj.JUEGO_PTR) + 0x30
        pers = p.leer32(0x0040F50C)
        r0, r1 = pers + 0x470, pers + 0x470 + 0x240
        res["antes"] = {"J_330": hex(p.leer32(J + 0x330)), "J2_330": hex(p.leer32(cj.J2 + 0x330)),
                        "r0": hex(r0), "r0_dueno": hex(p.leer32(r0)), "r1": hex(r1), "r1_dueno": hex(p.leer32(r1))}
        p.escribir32(r1, cj.J2)
        p.escribir32(cj.J2 + 0x330, r1)
        time.sleep(0.5)
        res["J2_antes"], res["J_antes"] = municion(p, cj.J2), municion(p, J)
        c0 = [p.leer32(cm.AISLAR_CUENTAS + 4 * i) for i in range(12)]
        boton2(p, DISPARAR, True)
    serie = []
    for k in range(8):
        time.sleep(0.5)
        cc.cap("ranura93-j2-%d.png" % k)
        with Pine() as p:
            serie.append({"k": k, "J2": municion(p, cj.J2), "J": municion(p, J),
                          "cuentas": [p.leer32(cm.AISLAR_CUENTAS + 4 * i) - c0[i] for i in range(12)]})
    with Pine() as p:
        boton2(p, DISPARAR, False)
        res["J2_330_despues"] = hex(p.leer32(cj.J2 + 0x330))
    res["serie"] = serie
    time.sleep(2)
    r = cc.run("sondas_coop.py", "boton", "arma_b", "1")
    time.sleep(1.5)
    with Pine() as p:
        res["J_cambia_arma"] = {"J_330": hex(p.leer32(J + 0x330)), "J_2A4": hex(p.leer32(J + 0x2A4)),
                                "r1_dueno": hex(p.leer32(r1)), "J2_330": hex(p.leer32(cj.J2 + 0x330))}
    cc.cap("ranura93-j-cambia.png")
    r = cc.run("sondas_coop.py", "boton", "disparar", "2")
    cc.cap("ranura93-j-dispara.png")
    r = cc.run("selector_depuracion.py", "vivo")
    res["vivo"] = r is not None and '"vivo": true' in r.stdout
    (cc.SAL / "ranura93.json").write_text(json.dumps(res, indent=1))
    print(json.dumps({k: v for k, v in res.items() if k != "serie"}))
    print([(s["k"], s["J2"], s["J"], s["cuentas"][8:]) for s in serie])
    cc.matar_fork()


if __name__ == "__main__":
    main()
