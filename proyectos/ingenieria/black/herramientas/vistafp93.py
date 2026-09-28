"""(93m) Que cambia en la vista en primera persona cuando RECARGA J2 (y J esta quieto). Fotos del objeto de la vista
(V = *(*(*(0x0040F510)+0xCBD8)+0xC), 0x1C50 B) y de los tres bloques compartidos del arma (*(J+0x270/+0x274/+0x278),
0x20 B c/u): 6 en reposo (lo que cambia solo = relojes, se descarta) y despues, con J2 sosteniendo «disparar», una
foto cada ~0,25 s durante 5 s junto con el estado del arma de J2 y de J. Lista las palabras que cambian sólo con J2
y en que fotos. Salida: volcados/campana/vistafp93.json"""
import json, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
from aislar93 import boton2, DISPARAR, municion  # noqa: E402
from pine import Pine  # noqa: E402


def fotos(p, zonas):
    return {n: p.leer_bloque(d, l) for n, (d, l) in zonas.items()}


def palabras(b):
    return [int.from_bytes(b[i:i + 4], "little") for i in range(0, len(b), 4)]


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
        V = p.leer32(p.leer32(p.leer32(0x0040F510) + 0xCBD8) + 0xC)
        zonas = {"V": (V, 0x1C50)}
        for o in (0x270, 0x274, 0x278):
            zonas["J+%X" % o] = (p.leer32(J + o), 0x20)
        reposo = []
        for _ in range(6):
            reposo.append(fotos(p, zonas))
            time.sleep(0.25)
        ruido = {n: set() for n in zonas}
        for n in zonas:
            base = palabras(reposo[0][n])
            for f in reposo[1:]:
                for i, w in enumerate(palabras(f[n])):
                    if w != base[i]:
                        ruido[n].add(i)
        boton2(p, DISPARAR, True)
        serie, t1 = [], time.time()
        while time.time() - t1 < 5:
            serie.append((round(time.time() - t1, 2), municion(p, cj.J2), municion(p, J), fotos(p, zonas)))
            time.sleep(0.2)
        boton2(p, DISPARAR, False)
    res = {"V": hex(V), "zonas": {n: hex(d) for n, (d, _) in zonas.items()},
           "ruido": {n: len(s) for n, s in ruido.items()}, "cambios": {}}
    for n in zonas:
        base = palabras(reposo[0][n])
        ch = {}
        for t, m2, mj, f in serie:
            for i, w in enumerate(palabras(f[n])):
                if i not in ruido[n] and w != base[i]:
                    ch.setdefault("+0x%X" % (4 * i), []).append([t, m2[2], mj[2], hex(w)])
        res["cambios"][n] = ch
    res["estados"] = [(t, m2, mj) for t, m2, mj, _ in serie]
    (cc.SAL / "vistafp93.json").write_text(json.dumps(res, indent=1))
    print(json.dumps({"V": res["V"], "ruido": res["ruido"]}))
    for n, ch in res["cambios"].items():
        print(n, len(ch), "palabras:", {k: (len(v), v[0], v[-1]) for k, v in list(ch.items())[:25]})
    print(res["estados"])
    cc.matar_fork()


if __name__ == "__main__":
    main()
