"""(93m) La ranura 0 (de J, inicializada) contra la ranura 1 (la que se le da a J2): 0x240 B cada una desde
pers+0x470 / pers+0x6B0 (pers = *(0x0040F50C)), con el nivel andando. Lista las palabras distintas y, para los
punteros de la 0 cuyo par en la 1 es 0, las 8 primeras palabras del destino. Salida: volcados/campana/ranuras93.json"""
import json, sys, time
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
        pers = p.leer32(0x0040F50C)
        r0, r1 = pers + 0x470, pers + 0x6B0
        b0, b1 = p.leer_bloque(r0, 0x240), p.leer_bloque(r1, 0x240)
        w = lambda b, o: int.from_bytes(b[o:o + 4], "little")  # noqa: E731
        dif = []
        for o in range(0, 0x240, 4):
            v0, v1 = w(b0, o), w(b1, o)
            if v0 != v1:
                d = {"off": "+0x%X" % o, "r0": "%08x" % v0, "r1": "%08x" % v1}
                if 0x100000 <= v0 < 0x2000000 and v1 == 0:
                    d["dest_r0"] = ["%08x" % p.leer32(v0 + 4 * k) for k in range(8)]
                dif.append(d)
    res = {"pers": hex(pers), "r0": hex(r0), "r1": hex(r1), "distintas": dif}
    (cc.SAL / "ranuras93.json").write_text(json.dumps(res, indent=1))
    for d in dif:
        print(d)
    cc.matar_fork()


if __name__ == "__main__":
    main()
