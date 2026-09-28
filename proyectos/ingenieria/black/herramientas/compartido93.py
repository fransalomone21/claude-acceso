"""(93j) Los brazos de J2 con la pose de J: que comparte J2 con J hoy (con el mod de 530 palabras, por el pnach).
Lanza el fork, carga City Streets, y lista cada palabra de 0..0x8C0 donde J2 == J y el valor parece un puntero
(0x100000..0x2000000) fuera de los bloques de J y J2. Para cada uno, las 8 primeras palabras del destino.
Tambien: J+0x7C y +0x8C (instancia de animacion y parametros, (79)).
Salida: volcados/campana/compartido93.json"""
import json, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
from pine import Pine  # noqa: E402

LARGO = 0x8C0


def main():
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
    res = {}
    with Pine() as p:
        J = p.leer32(cj.JUEGO_PTR) + 0x30
        bj = p.leer_bloque(J, LARGO)
        b2 = p.leer_bloque(cj.J2, LARGO)
        w = lambda b, o: int.from_bytes(b[o:o + 4], "little")  # noqa: E731
        comp, propios = [], []
        for o in range(0, LARGO, 4):
            vj, v2 = w(bj, o), w(b2, o)
            if not (0x100000 <= vj < 0x2000000):
                continue
            fuera = not (J <= vj < J + LARGO or cj.J2 <= vj < cj.J2 + LARGO)
            if vj == v2 and fuera:
                comp.append({"off": hex(o), "ptr": hex(vj), "dest": [hex(p.leer32(vj + 4 * k)) for k in range(8)]})
            elif vj != v2 and fuera:
                propios.append({"off": hex(o), "J": hex(vj), "J2": hex(v2)})
        res = {"J": hex(J), "compartidos": comp, "distintos": propios}
    (cc.SAL / "compartido93.json").write_text(json.dumps(res, indent=1))
    print("compartidos", [(c["off"], c["ptr"]) for c in res["compartidos"]])
    print("distintos", [(c["off"], c["J"], c["J2"]) for c in res["distintos"]])
    cc.matar_fork()


if __name__ == "__main__":
    main()
