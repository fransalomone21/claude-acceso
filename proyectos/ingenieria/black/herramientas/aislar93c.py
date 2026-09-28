"""(93l) Mientras J2 recarga, el arma de J pasa a estado 8 (+0xD8) sin que J haga nada (aislar93.py). Quien lo
escribe: vigilante de ESCRITURA (break en pausa, ritmo_vigilante --ra) sobre *(J+0x2A4)+0xD8 con J2 sosteniendo
«disparar» (vacia y recarga). Base: el mismo vigilante sin que nadie dispare.
Salida: volcados/campana/aislar93c.txt"""
import sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
from aislar93 import boton2, DISPARAR  # noqa: E402
from pine import Pine  # noqa: E402


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
    cc.run("coop_mod.py", "manos", "0.5")
    with Pine() as p:
        J = p.leer32(cj.JUEGO_PTR) + 0x30
        dj = p.leer32(J + 0x2A4) + 0xD8
        d2 = p.leer32(cj.J2 + 0x2A4) + 0xD8
    out = ["arma J +0xD8 = %#x, arma J2 +0xD8 = %#x" % (dj, d2)]
    r = cc.run("ritmo_vigilante.py", "0x%08X" % dj, "--tipo", "write", "-n", "10", "--ra", "--espera", "5", t=200)
    out.append("== BASE\n%s" % (r.stdout if r else None))
    with Pine() as p:
        boton2(p, DISPARAR, True)
    r = cc.run("ritmo_vigilante.py", "0x%08X" % dj, "--tipo", "write", "-n", "12", "--ra", "--espera", "10", t=300)
    out.append("== J2 DISPARA\n%s" % (r.stdout if r else None))
    with Pine() as p:
        boton2(p, DISPARAR, False)
    (cc.SAL / "aislar93c.txt").write_text("\n".join(out), encoding="utf-8")
    print("\n".join(out)[:3000])
    cc.matar_fork()


if __name__ == "__main__":
    main()
