"""(93l) Quien llama a las funciones de la vista FP mientras J2 dispara y recarga. Cada envoltorio lee la bandera
(0x0046DEF4) al entrar: un vigilante de LECTURA (break, puesto en pausa, ritmo_vigilante --ra) da el envoltorio
(pc) y el que llamo a la funcion (ra). Dos tandas: BASE (nadie dispara) y J2 (J2 sostiene «disparar»).
Con el bloque instalado con aislar. Salida: volcados/campana/aislar93b.txt"""
import sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
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
    out = []
    r = cc.run("ritmo_vigilante.py", "0x%08X" % cm.AISLAR_BANDERA, "--tipo", "read", "-n", "30", "--ra",
               "--espera", "6", t=300)
    out.append("== BASE\n%s\n%s" % (r.stdout if r else None, r.stderr[-300:] if r else None))
    with Pine() as p:
        boton2(p, DISPARAR, True)
    time.sleep(0.3)
    r = cc.run("ritmo_vigilante.py", "0x%08X" % cm.AISLAR_BANDERA, "--tipo", "read", "-n", "60", "--ra",
               "--espera", "6", t=400)
    out.append("== J2 DISPARA\n%s\n%s" % (r.stdout if r else None, r.stderr[-300:] if r else None))
    with Pine() as p:
        boton2(p, DISPARAR, False)
    (cc.SAL / "aislar93b.txt").write_text("\n".join(out), encoding="utf-8")
    cc.matar_fork()


if __name__ == "__main__":
    main()
