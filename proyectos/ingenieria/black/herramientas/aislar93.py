"""(93l) La vista en primera persona aislada de J2. Lanza el fork con el bloque del pnach YA INSTALADO (prueba:
`coop_mod.py instalar`; control: `coop_mod.py instalar --sin-aislar`), carga City Streets y:
  1) J2 sostiene «disparar» (mando falso 2) hasta vaciar y recargar; capturas cada ~0,8 s (la mitad de J
     tiene que quedarse quieta en la prueba; en el control hace la recarga de J2, como en (93k)).
  2) J dispara 2 s con el mando falso 1 (sondas_coop boton): regresion, la mitad de J tiene que animarse.
Mide la municion de J y J2 antes y despues de cada fase y si el emulador sigue vivo.
Uso: python herramientas/aislar93.py <etiqueta>      Salida: volcados/campana/aislar93-<etiqueta>.json"""
import json, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
from pine import Pine  # noqa: E402

DISPARAR = 12


def boton2(p, i, apretado):
    p.escribir8(cj.FALSO2 + 0x0E + i, 0)
    p.escribir8(cj.FALSO2 + 0x2A + i, 1 if apretado else 0)
    p.escribir_f32(cj.FALSO2 + 0x4C + 4 * i, 1.0 if apretado else 0.0)


def municion(p, P):
    a = p.leer32(P + 0x2A4)
    t = p.leer32(p.leer32(a + 0xEC) + 0x64)
    return p.leer16(p.leer32(a + 0xF4) + 0x18), p.leer16(P + 0x280 + 2 * t), p.leer32(a + 0xD8)


def main():
    tag = sys.argv[1] if len(sys.argv) > 1 else "prueba"
    res = {"tag": tag}
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
        res["ganchos"] = [hex(p.leer32(f)) for f, _, _ in cm.FP_ENTRADAS]
        res["J2_antes"], res["J_antes"] = municion(p, cj.J2), municion(p, J)
        boton2(p, DISPARAR, True)
    serie = []
    for k in range(8):
        time.sleep(0.5)
        cc.cap("aislar93-%s-j2-%d.png" % (tag, k))
        with Pine() as p:
            serie.append({"k": k, "J2": municion(p, cj.J2), "J": municion(p, J), "cuentas": [p.leer32(cm.AISLAR_CUENTAS + 4 * i) for i in range(12)]})
    with Pine() as p:
        boton2(p, DISPARAR, False)
    res["serie_J2_dispara"] = serie
    time.sleep(3)
    with Pine() as p:
        res["J_antes_2"] = municion(p, J)
    r = cc.run("sondas_coop.py", "boton", "disparar", "2")
    cc.cap("aislar93-%s-j.png" % tag)
    with Pine() as p:
        res["J_despues_2"] = municion(p, J)
        res["cuentas_final"] = [p.leer32(cm.AISLAR_CUENTAS + 4 * i) for i in range(12)]
    r = cc.run("selector_depuracion.py", "vivo")
    res["vivo"] = r is not None and '"vivo": true' in r.stdout
    (cc.SAL / ("aislar93-%s.json" % tag)).write_text(json.dumps(res, indent=1))
    print(json.dumps({k: v for k, v in res.items() if k != "serie_J2_dispara"}))
    print([(s["k"], s["J2"], s["J"], s["cuentas"]) for s in serie])
    cc.matar_fork()


if __name__ == "__main__":
    main()
