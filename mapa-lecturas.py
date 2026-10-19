"""mapa-lecturas.py -- cada seccion de los destilados, contra el concepto de la puerta que la hace leer (DA-065).

QUE MIDE: que ninguna seccion de un destilado del libro (perfil-global/pilares/<carpeta>/*.md y la ficha del
alcance) que trata el TEMA de un concepto de .claude/cascada.json quede fuera de lo que ese concepto hace leer.
El caso que lo origino: el SEH App. C («free of implementation») estaba copiado entero en nasa-seh/glosario.md, el
concepto 'requisitos' hacia leer requisitos.md §5-14, y la seccion 1 del TP de IISE salio con L0 que nombraban el
detector y la plataforma (2026-10-19). La lectura estaba hecha y medida; vivia donde nadie la abria al escribir.

Como: cada concepto declara en el catalogo 'temas' (una regex sobre el TITULO de la seccion: el rol, no la
palabra suelta del cuerpo) y 'temas_fuera' (las secciones que caen en el tema y NO van, con su motivo; o con
'lo_lee': <otro concepto>, que se verifica). Una seccion del tema que no esta en ningun rango del concepto ni
declarada afuera es HUERFANA: rojo. Tambien rojo: un concepto con temas que no encuentra ninguna seccion (regex
ciega), una exclusion que ya no matchea nada (excepcion muerta) y un 'lo_lee' que el otro concepto no cubre.

Uso:
  python mapa-lecturas.py            el mapa contra el disco (rojo = exit 1)
  python mapa-lecturas.py -v         el mapa entero: cada seccion del tema y quien la hace leer
  python mapa-lecturas.py --autotest sabotajes en rojo + el control positivo sobre el catalogo real
"""
import copy, json, re, sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
sys.path.insert(0, str(RAIZ / ".claude" / "hooks"))
import cascada_puerta as P   # una sola regla de rutas y rangos: la de la puerta (expandir, rango)

TITULO = re.compile(r"^(#{2,3})\s+(.*\S)")
VALLA = re.compile(r"^\s*(```|~~~)")


def pilares() -> Path:
    p = P.expandir("perfil-global/pilares", None)
    return Path(p)


def destilados(pil: Path):
    """Las carpetas de destilados (todas las de pilares/ salvo fuentes/, asi una carpeta NUEVA entra sola: un
    verificador solo ve donde vive) y la ficha del alcance. El resto de la raiz de pilares/ son los fundamentos del
    metodo (Meadows, Saltzer...), no el libro de ingenieria de sistemas."""
    out = [pil / "alcance-como-se-escribe.md"]
    for d in sorted(x for x in pil.iterdir() if x.is_dir() and x.name != "fuentes"):
        out += sorted(d.glob("*.md"))
    return [f for f in out if f.exists()]


def secciones(f: Path):
    """[(linea 1-based, titulo)] de los ## y ###, salteando bloques de codigo."""
    out, valla = [], False
    for i, l in enumerate(f.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
        if VALLA.match(l):
            valla = not valla
            continue
        m = None if valla else TITULO.match(l)
        if m:
            out.append((i, m.group(2)))
    return out


def rangos(cd: dict):
    """{ruta resuelta: [(a, b)]} de lo que el concepto hace leer."""
    out = {}
    for spec in cd.get("leer", []):
        p = P.expandir(spec["ruta"], None)
        if p is None or not Path(p).exists():
            continue
        r = P.rango(Path(p), spec)
        if r:
            out.setdefault(str(Path(p).resolve()).lower(), []).append(r[:2])
    return out


def cubre(rg, f: Path, linea: int) -> bool:
    return any(a <= linea <= b for a, b in rg.get(str(f.resolve()).lower(), []))


def medir(cat: dict, pil: Path, verboso=False):
    rojos, lin = 0, []
    con = {n: cd for n, cd in cat.get("conceptos", {}).items() if cd.get("temas")}
    if not con:
        return 1, ["[ROJO] ningun concepto declara 'temas': el mapa no mide nada (falla cerrado)"]
    fich = destilados(pil)
    if not fich:
        return 1, ["[ROJO] no hay destilados bajo %s (falla cerrado)" % pil]
    rg = {n: rangos(cd) for n, cd in cat.get("conceptos", {}).items()}
    for n, cd in con.items():
        try:
            tema = re.compile(cd["temas"])
            fuera = [(re.compile(x["archivo"]), re.compile(x["titulo"]), x) for x in cd.get("temas_fuera", [])]
        except (re.error, KeyError) as e:
            rojos += 1
            lin.append("[ROJO] concepto %s: temas o temas_fuera mal declarados (%s)" % (n, e))
            continue
        usadas, n_tema, n_ok, n_fuera = set(), 0, 0, 0
        for f in fich:
            rel = str(f.relative_to(pil)).replace("\\", "/")
            for linea, t in secciones(f):
                if not tema.search(t):
                    continue
                n_tema += 1
                if cubre(rg[n], f, linea):
                    n_ok += 1
                    if verboso:
                        lin.append("  lee   %-10s %s:%d  %s" % (n, rel, linea, t[:80]))
                    continue
                k = next((j for j, (fa, ft, _) in enumerate(fuera) if fa.search(rel) and ft.search(t)), None)
                if k is None:
                    rojos += 1
                    lin.append("  HUERFANA %-10s %s:%d  %s" % (n, rel, linea, t[:90]))
                    continue
                usadas.add(k)
                n_fuera += 1
                x = fuera[k][2]
                otro = x.get("lo_lee")
                if otro and not cubre(rg.get(otro, {}), f, linea):
                    rojos += 1
                    lin.append("  [ROJO] %s: %s:%d dice que la lee '%s', y '%s' no la cubre" % (n, rel, linea, otro, otro))
                elif verboso:
                    lin.append("  fuera %-10s %s:%d  %s -- %s" % (n, rel, linea, t[:60], ("lo lee " + otro) if otro
                               else x.get("por", "")[:60]))
        if n_tema == 0:
            rojos += 1
            lin.append("[ROJO] concepto %s: 'temas' no encuentra ninguna seccion (regex ciega)" % n)
        for j, (_, _, x) in enumerate(fuera):
            if j not in usadas:
                rojos += 1
                lin.append("  [ROJO] %s: la exclusion %s / %s ya no matchea ninguna seccion (excepcion muerta: "
                           "sacarla)" % (n, x["archivo"], x["titulo"]))
        lin.append("%s: %d secciones del tema: %d las hace leer, %d declaradas afuera, %d huerfanas" % (
            n, n_tema, n_ok, n_fuera, n_tema - n_ok - n_fuera))
    lin.append("DESTILADOS: %d archivos bajo %s" % (len(fich), pil))
    return rojos, lin


def autotest() -> int:
    mal = 0
    cat = P.cargar_catalogo()
    pil = pilares()

    def caso(nombre, cond, llego):
        nonlocal mal
        mal += 0 if cond else 1
        print("%s  %-62s -> %s" % ("ok " if cond else "MAL", nombre, llego))

    r, lin = medir(cat, pil)
    rojas = " | ".join(l.strip() for l in lin if "HUERFANA" in l or "ROJO" in l)
    caso("el catalogo real -> verde", r == 0, "%d rojos %s" % (r, rojas[:150]))
    # 1. El caso de DA-065: el concepto requisitos SIN el App. C del glosario. Tiene que salir HUERFANA y por el
    #    glosario (el motivo, no solo el rojo). La entrada se busca en el catalogo, no se copia.
    c = copy.deepcopy(cat)
    lr = c["conceptos"]["requisitos"]["leer"]
    k = next((i for i, s in enumerate(lr) if s["ruta"].endswith("glosario.md") and "Apendice C" in s.get("desde", "")),
             None)
    if k is None:
        caso("el caso DA-065 (sin el App. C)", False, "el concepto requisitos no lee el App. C: el sabotaje no aplica")
    else:
        del lr[k]
        r, lin = medir(c, pil)
        h = [l for l in lin if "HUERFANA" in l and "glosario.md" in l and "Apendice C" in l]
        caso("requisitos sin el App. C del glosario -> HUERFANA en glosario.md", r >= 1 and bool(h),
             (h[0].strip() if h else "sin huerfana del glosario")[:110])
    # 2. Una exclusion declarada que se borra: la seccion que tapaba vuelve a ser huerfana.
    c = copy.deepcopy(cat)
    tf = c["conceptos"]["requisitos"].get("temas_fuera", [])
    if tf:
        quitada = tf.pop(0)
        r, lin = medir(c, pil)
        h = [l for l in lin if "HUERFANA" in l and re.search(quitada["archivo"], l)]
        caso("sin una exclusion declarada -> su seccion es HUERFANA", r >= 1 and bool(h), (h[0].strip() if h else
             "sin huerfana")[:110])
    # 3. Una exclusion muerta (no matchea nada) -> rojo: una excepcion que sobrevive a su caso tapa el proximo.
    c = copy.deepcopy(cat)
    c["conceptos"]["requisitos"].setdefault("temas_fuera", []).append(
        {"archivo": "nasa-seh/requisitos\\.md", "titulo": "^Seccion que no existe", "por": "sabotaje"})
    r, lin = medir(c, pil)
    m = [l for l in lin if "excepcion muerta" in l]
    caso("una exclusion que no matchea nada -> rojo", r >= 1 and bool(m), (m[0].strip() if m else "sin rojo")[:110])
    # 4. Un 'lo_lee' mentiroso: la seccion se declara leida por otro concepto que no la cubre.
    c = copy.deepcopy(cat)
    for x in c["conceptos"]["requisitos"].get("temas_fuera", []):
        if x.get("lo_lee"):
            x["lo_lee"] = "typst"
            break
    r, lin = medir(c, pil)
    m = [l for l in lin if "no la cubre" in l]
    caso("un lo_lee que el otro concepto no cubre -> rojo", r >= 1 and bool(m), (m[0].strip() if m else "sin rojo")[:110])
    # 5. Regex ciega: temas que no encuentra nada -> rojo, no verde de cero secciones.
    c = copy.deepcopy(cat)
    c["conceptos"]["alcance"]["temas"] = "(?!)"
    c["conceptos"]["alcance"]["temas_fuera"] = []
    r, lin = medir(c, pil)
    m = [l for l in lin if "regex ciega" in l]
    caso("temas que no encuentra ninguna seccion -> rojo", r >= 1 and bool(m), (m[0].strip() if m else "sin rojo")[:110])
    # 6. Falla cerrado: ningun concepto con temas.
    c = copy.deepcopy(cat)
    for cd in c["conceptos"].values():
        cd.pop("temas", None)
    r, lin = medir(c, pil)
    caso("ningun concepto con temas -> rojo", r >= 1 and "falla cerrado" in lin[0], lin[0][:100])
    print("AUTOTEST %s (%d mal)" % ("OK" if not mal else "EN ROJO", mal))
    return 1 if mal else 0


if __name__ == "__main__":
    a = sys.argv[1:]
    if a[:1] == ["--autotest"]:
        sys.exit(autotest())
    try:
        cat = P.cargar_catalogo()
    except Exception as e:
        print("[ROJO] el catalogo no se puede leer: %s" % e)
        sys.exit(1)
    r, lin = medir(cat, pilares(), verboso="-v" in a)
    print("\n".join(lin))
    print("MAPA %s" % ("OK: ninguna seccion del tema queda huerfana" if not r else "EN ROJO: %d" % r))
    sys.exit(1 if r else 0)
