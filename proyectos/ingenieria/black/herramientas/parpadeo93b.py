"""(93k) El parpadeo con eventos: el mismo conteo de escritores de R+0xD470 (ritmo_vigilante, break en pausa)
mientras J2 apunta (zoom, boton 11, cada ~1 s) y dispara (boton 12) con el mando falso 2 (el que instala
`coop_mod.py manos`). Si aparece un PC fuera del stub de la pantalla (0x0046F800..0x0046FAD4), ese es el intruso.
Salida: volcados/campana/parpadeo93b.txt"""
import sys, threading, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
from pine import Pine  # noqa: E402

ZOOM, DISPARAR = 11, 12
fin = threading.Event()
eventos = {"zoom": 0, "errores": 0}


def boton(p, i, apretado):
    p.escribir8(cj.FALSO2 + 0x0E + i, 0)
    p.escribir8(cj.FALSO2 + 0x2A + i, 1 if apretado else 0)
    p.escribir_f32(cj.FALSO2 + 0x4C + 4 * i, 1.0 if apretado else 0.0)   # como tirador.py (85)


def manos_de_j2():
    while not fin.is_set():
        try:
            with Pine() as p:
                boton(p, DISPARAR, True)
                boton(p, ZOOM, True)
                time.sleep(0.05)
                boton(p, ZOOM, False)
                eventos["zoom"] += 1
        except Exception:  # noqa: BLE001
            eventos["errores"] += 1
        time.sleep(1.0)
    try:
        with Pine() as p:
            boton(p, DISPARAR, False)
            boton(p, ZOOM, False)
    except Exception:  # noqa: BLE001
        pass


def municion(p):
    """(cargador, reserva) del arma en la mano de J2 (como recarga92c.py): si cambian, J2 disparo."""
    a = p.leer32(cj.J2 + 0x2A4)
    t = p.leer32(p.leer32(a + 0xEC) + 0x64)
    return p.leer16(p.leer32(a + 0xF4) + 0x18), p.leer16(cj.J2 + 0x280 + 2 * t)


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
    cc.run("coop_mod.py", "manos", "0.5")          # instala el falso 2 como fuente del control de J2
    with Pine() as p:
        R = p.leer32(0x0040F4C0)
        car0 = municion(p)
    hilo = threading.Thread(target=manos_de_j2, daemon=True)
    hilo.start()
    time.sleep(2)
    cc.cap("parpadeo93b-antes.png")
    r = cc.run("ritmo_vigilante.py", "0x%08X" % (R + 0xD470), "--tipo", "write", "-n", "300", "--fps", "60", t=900)
    fin.set()
    hilo.join(5)
    with Pine() as p:
        car1 = municion(p)
    out = ["R = %#x; eventos %s; municion de J2 antes %s despues %s" % (R, eventos, car0, car1),
           r.stdout if r else None, r.stderr[-400:] if r else None]
    (cc.SAL / "parpadeo93b.txt").write_text("\n".join(str(x) for x in out), encoding="utf-8")
    print(out[0])
    cc.matar_fork()


if __name__ == "__main__":
    main()
