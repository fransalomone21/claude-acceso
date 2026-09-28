"""(93k) El parpadeo de la mitad de J2 (Fran: «se angosta y se reacomoda»): quien escribe R+0xD470 / R+0xD474
(ancho y proporcion de la vista, (89)) y cuantas veces por cuadro. Lanza el fork con el bloque del pnach, carga
City Streets, espera el juego y corre ritmo_vigilante.py (break, puesto en pausa) sobre las dos direcciones con
--ra. Esperado si no hay intruso: solo PCs del stub de la pantalla (0x0046F800..0x0046FAD4).
Salida: volcados/campana/parpadeo93.txt"""
import sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
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
    with Pine() as p:
        R = p.leer32(0x0040F4C0)
        vals = [(hex(R + o), hex(p.leer32(R + o))) for o in (0xD470, 0xD474)]
    out = ["R = %#x, valores %s" % (R, vals)]
    for o in (0xD470,):
        r = cc.run("ritmo_vigilante.py", "0x%08X" % (R + o), "--tipo", "write", "-n", "300", "--fps", "60", t=900)
        out.append("== R+%#x\n%s\n%s" % (o, r.stdout if r else None, r.stderr[-400:] if r else None))
    (cc.SAL / "parpadeo93.txt").write_text("\n".join(out), encoding="utf-8")
    print("\n".join(out))
    cc.matar_fork()


if __name__ == "__main__":
    main()
