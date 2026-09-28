"""(93q) Por donde se cuela la recarga de J2 a los brazos de J con la ranura 3 (en (93p): 2/8 -> 1/8, no 0).

Mide en RAM, no con capturas. Dos fases en la misma corrida (control: ranura compartida; prueba: ranura 3), y en
cada una 2,5 s con J2 quieto (base) y 4 s con J2 disparando (vacia y recarga). En cada muestra (~cada 60 ms):
  - el compañero de r0 (la pose de J, *(pers+0x470+0x54), 0x9D0 B) y el de R3 (la de J2),
  - la cola de eventos de la vista unica V (V+0xB80..+0xC00, V = *(*(*(0x0040F510)+0xCBD8)+0xC)),
  - los contadores del aislamiento y del filtro de eventos (coop_mod.AISLAR_CUENTAS, 12 palabras),
  - el estado del arma de J y de J2.
Prediccion (escrita antes): si la fuga es por V, en la prueba cambian palabras de la cola de V y algun contador de
PASADAS mientras J2 dispara; si es por el compañero de r0, cambian palabras suyas SOLO mientras J2 dispara (fuera
de las que cambian en la base, que son el balanceo de J quieto).
Salida: volcados/campana/ranura3b.json
  python herramientas/ranura3b.py
"""
import json, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import ranura3 as r3  # noqa: E402
from aislar93 import boton2, DISPARAR, municion  # noqa: E402
from mips import ensamblar  # noqa: E402
from pine import Pine  # noqa: E402

COLA = (0xB80, 0x80)


def palabras(b):
    return [int.from_bytes(b[i:i + 4], "little") for i in range(0, len(b), 4)]


def muestra(p, J, zonas):
    m = {"t": time.time()}
    for nombre, (dir_, tam) in zonas.items():
        m[nombre] = palabras(p.leer_bloque(dir_, tam))
    m["cuentas"] = [p.leer32(cm.AISLAR_CUENTAS + 4 * i) for i in range(12)]
    m["J"], m["J2"] = municion(p, J), municion(p, r3.J2)
    return m


def cambiadas(serie, nombre):
    """Offsets (en bytes) de las palabras de `nombre` que cambian entre muestras seguidas."""
    out = set()
    for a, b in zip(serie, serie[1:]):
        for i, (x, y) in enumerate(zip(a[nombre], b[nombre])):
            if x != y:
                out.add(4 * i)
    return out


def fase(nombre, J, zonas):
    with Pine() as p:
        r3.rellenar(p, r3.J2)
    time.sleep(0.5)
    base, fuego = [], []
    t0 = time.time()
    with Pine() as p:
        while time.time() - t0 < 2.5:
            base.append(muestra(p, J, zonas))
        boton2(p, DISPARAR, True)
        t0 = time.time()
        while time.time() - t0 < 4.0:
            fuego.append(muestra(p, J, zonas))
        boton2(p, DISPARAR, False)
    time.sleep(3)
    res = {"muestras_base": len(base), "muestras_fuego": len(fuego)}
    for z in zonas:
        cb, cf = cambiadas(base, z), cambiadas(fuego, z)
        res[z] = {"base": len(cb), "fuego": len(cf), "solo_fuego": ["+0x%X" % o for o in sorted(cf - cb)][:40],
                  "n_solo_fuego": len(cf - cb)}
    res["cuentas_delta_fuego"] = [b - a for a, b in zip(fuego[0]["cuentas"], fuego[-1]["cuentas"])]
    res["cuentas_delta_base"] = [b - a for a, b in zip(base[0]["cuentas"], base[-1]["cuentas"])]
    res["J_estados"] = sorted({m["J"][2] for m in base + fuego})
    res["J2_estados"] = sorted({m["J2"][2] for m in fuego})
    res["J2_cargador"] = [m["J2"][0] for m in fuego][::6]
    return res


def main():
    res = {}
    prog = r3.codigo(r3.UNA, r3.FUENTE)
    J = r3.arrancar()
    with Pine() as p:
        pers = p.leer32(r3.PERS_PTR)
        r0c = p.leer32(pers + 0x470 + 0x54)
        V = p.leer32(p.leer32(p.leer32(0x0040F510) + 0xCBD8) + 0xC)
        gancho = ensamblar("jal 0x%x" % r3.DESTINO3, r3.SITIO3)
        res["gancho_ok"] = p.leer32(r3.SITIO3) == gancho
    res["pers"], res["r0_comp"], res["V"] = hex(pers), hex(r0c), hex(V)
    zonas = {"r0_comp": (r0c, 0x9D0), "V_cola": (V + COLA[0], COLA[1])}
    if res["gancho_ok"]:
        res["control"] = fase("control", J, zonas)
        res.update(r3.armar(prog, gancho, J))
        if res["pedido"] == 2:
            with Pine() as p:
                zonas["R3_comp"] = (p.leer32(r3.R3 + 0x54), 0x9D0)
                res["r0_90"], res["R3_90"] = hex(p.leer32(pers + 0x470 + 0x90)), hex(p.leer32(r3.R3 + 0x90))
            res["prueba"] = fase("prueba", J, zonas)
    r = cc.run("selector_depuracion.py", "vivo")
    res["vivo"] = r is not None and '"vivo": true' in r.stdout
    (cc.SAL / "ranura3b.json").write_text(json.dumps(res, indent=1))
    print(json.dumps(res, indent=1)[:6000])
    cc.matar_fork()


if __name__ == "__main__":
    main()
