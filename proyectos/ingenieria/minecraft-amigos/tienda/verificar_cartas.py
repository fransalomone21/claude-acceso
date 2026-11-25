"""L1-18 y L1-19: cada carta de la tienda esta en una subfamilia de su familia y tiene entre 2 y 3 fotos.

  python verificar_cartas.py              -> 0 todo bien; 1 nombra cada carta que falla
  python verificar_cartas.py --sabotaje   -> rompe una copia en memoria (una carta sin subfamilia, otra sin fotos)
                                             y exige el rojo nombrandolas; despues mide lo real
Lo que mira es lo que sirve la pagina (/api/catalogo, armado por tienda.catalogo()), no el archivo a mano.
"""
import copy, sys

import tienda as T


def problemas(cat):
    out = []
    for c in cat["cartas"]:
        subs = cat["subfamilias"].get(c["familia"], {})
        if c.get("sub") not in subs:
            out.append(f"L1-18 {c['id']}: subfamilia '{c.get('sub')}' no es de '{c['familia']}'")
        if not 2 <= len(c["fotos"]) <= 3:
            out.append(f"L1-19 {c['id']}: {len(c['fotos'])} foto(s)")
    return out


def main(argv):
    cat = T.catalogo()
    if "--sabotaje" in argv:
        roto = copy.deepcopy(cat)
        a, b = roto["cartas"][0], roto["cartas"][1]
        a["sub"] = "no-existe"; b["fotos"] = []
        p = problemas(roto)
        ok = any(a["id"] in x and "L1-18" in x for x in p) and any(b["id"] in x and "L1-19" in x for x in p)
        print(f"sabotaje: {'ROJO como debe' if ok else 'VERDE: el verificador esta ciego'} ({a['id']} sin subfamilia, {b['id']} sin fotos)")
        if not ok:
            return 2
    p = problemas(cat)
    for x in p:
        print("  " + x)
    print(f"cartas {len(cat['cartas'])}: {'VERDE' if not p else f'ROJO, {len(p)} problema(s)'}")
    return 1 if p else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
