# verificar-requisitos.py -- certifica docs/10-requisitos.md (PDP sec. 4, punto 4).
#
# Uso:  python docs/verificar-requisitos.py [archivo.md]     (default: 10-requisitos.md)
#       python docs/verificar-requisitos.py --autotest
#
# Que mide, y por que cada cosa:
#   1. La TRAZA: cada L-xx tiene padre, el padre EXISTE y es del nivel de arriba
#      (L0 -> N, L1 -> L0, L2 -> L1). Un hijo sin padre es un huerfano (catedra,
#      m17); un padre de otro nivel salta un escalon.
#   2. La traza para abajo: cada N tiene al menos un L0. Una necesidad que no
#      baja a nada es una necesidad que nadie va a cumplir.
#   3. Los ATRIBUTOS que NASA pide al escribirlo (Tabla 4.2-2): tipo de los seis
#      de la catedra, metodo de verificacion de los cuatro, estado TBD/TBR/
#      definido. Un ID repetido es rojo.
#   4. La REDACCION: cada enunciado pasa por verificar-requisito.py (GtWR) en
#      espanol, las necesidades con --necesidades. Cero VIOLA.
# Lo que NO mide: si el requisito es el correcto (validacion, NASA pasos 2 y 3).
# Eso lo hace una persona.
#
# Sale 0 en verde, 1 con algun rojo, 2 si revienta. Imprime QUE linea dio cada rojo.
import re, sys, os, subprocess, tempfile, unicodedata
from pathlib import Path

AQUI = Path(__file__).resolve().parent
RAIZ = AQUI.parents[3]                       # docs -> telescopio -> ingenieria -> proyectos -> raiz
GTWR = RAIZ / "perfil-global" / "pilares" / "incose-gtwr" / "verificar-requisito.py"
ID = re.compile(r"^(?:N|L[0-6])-(?:[A-Z]{2,4}-)?\d{2}$")
TIPOS = ("funcional", "desempeno", "restriccion", "interfaz", "ambiental", "otros")
METODOS = ("ensayo", "analisis", "inspeccion", "demostracion")
ESTADOS = ("definido", "tbr", "tbd")


def plano(t):
    return "".join(c for c in unicodedata.normalize("NFD", t) if unicodedata.category(c) != "Mn").lower().strip()


def nivel(i):
    return "N" if i.startswith("N-") else i[:2]


def leer(md):
    """Filas de las tablas cuya primera celda es un ID. Las columnas salen del
    encabezado de CADA tabla (las de L1 tienen 'Asignado a' y las otras no)."""
    filas, cab = [], None
    for n, l in enumerate(md.splitlines(), 1):
        if not l.startswith("|"):
            cab = None
            continue
        c = [x.strip() for x in l.strip().strip("|").split("|")]
        if c and plano(c[0]) == "id":
            cab = [plano(x) for x in c]
            continue
        if cab and c and ID.match(c[0]):
            filas.append((n, dict(zip(cab, c))))
    return filas


def gtwr(textos, necesidades):
    if not textos:
        return 0, ""
    with tempfile.NamedTemporaryFile("w", suffix=".txt", delete=False, encoding="utf-8") as f:
        f.write("\n".join(textos) + "\n")
        tmp = f.name
    try:
        a = [sys.executable, str(GTWR), tmp, "--idioma", "es", "--solo-viola"] + (["--necesidades"] if necesidades else [])
        r = subprocess.run(a, capture_output=True, text=True, encoding="utf-8")
        m = re.search(r"TOTAL: (\d+) VIOLA", r.stdout)
        if not m:
            raise RuntimeError("el chequeo del GtWR no dio TOTAL:\n" + r.stdout + r.stderr)
        return int(m.group(1)), r.stdout
    finally:
        os.unlink(tmp)


def verificar(md, con_gtwr=True):
    rojos, filas = [], leer(md)
    if not filas:
        return ["no hay ninguna fila con ID: el documento no tiene requisitos"], {}
    ids = {}
    for n, f in filas:
        i = f["id"]
        if i in ids:
            rojos.append("linea %d: ID repetido %s (ya en la linea %d)" % (n, i, ids[i][0]))
        ids[i] = (n, f)
    hijos = {}
    for i, (n, f) in ids.items():
        if nivel(i) == "N":
            continue
        padres = [p.strip() for p in re.split(r"[,;]", f.get("padre", "")) if p.strip()]
        if not padres:
            rojos.append("linea %d: %s no tiene padre (huerfano)" % (n, i))
        arriba = {"L0": "N", "L1": "L0", "L2": "L1"}.get(nivel(i))
        for p in padres:
            if p not in ids:
                rojos.append("linea %d: %s cita al padre %s, que NO existe" % (n, i, p))
            elif arriba and nivel(p) != arriba:
                rojos.append("linea %d: %s cuelga de %s: el padre es del nivel %s" % (n, i, p, arriba))
            hijos.setdefault(p, []).append(i)
        if not plano(f.get("tipo", "")).startswith(TIPOS):
            rojos.append("linea %d: %s tiene tipo '%s', fuera de los seis de la catedra" % (n, i, f.get("tipo", "")))
        if plano(f.get("verificacion", "")) not in METODOS:
            rojos.append("linea %d: %s tiene verificacion '%s', fuera de ensayo, analisis, inspeccion y demostracion"
                         % (n, i, f.get("verificacion", "")))
        if plano(f.get("estado", "")) not in ESTADOS:
            rojos.append("linea %d: %s tiene estado '%s', fuera de definido, TBR y TBD" % (n, i, f.get("estado", "")))
    for i, (n, f) in ids.items():
        if nivel(i) == "N" and i not in hijos:
            rojos.append("linea %d: la necesidad %s no baja a ningun L0" % (n, i))
    cuenta = {k: sum(1 for i in ids if nivel(i) == k) for k in ("N", "L0", "L1", "L2")}
    if con_gtwr:
        nec = [f.get("necesidad", "") for i, (n, f) in ids.items() if nivel(i) == "N"]
        req = [f.get("enunciado", "") for i, (n, f) in ids.items() if nivel(i) != "N"]
        for textos, es_nec, que in ((nec, True, "necesidades"), (req, False, "requisitos")):
            v, sal = gtwr(textos, es_nec)
            if v:
                rojos.append("GtWR: %d VIOLA en las %s\n%s" % (v, que, sal))
    return rojos, cuenta


CASO_SANO = """| ID | Necesidad | Fuente |
|---|---|---|
| N-01 | Fran necesita una foto de una nebulosa. | x |

| ID | Enunciado | Tipo | Padre | Verificación | Estado | 3D |
|---|---|---|---|---|---|---|
| L0-01 | La misión deberá obtener una imagen apilada. | funcional | N-01 | inspección | definido | no |

| ID | Enunciado | Tipo | Padre | Asignado a | Verificación | Estado | 3D |
|---|---|---|---|---|---|---|---|
| L1-01 | El sistema deberá pesar no más de 20 kg. | restricción | L0-01 | PLT | inspección | TBR | no |

| ID | Enunciado | Tipo | Padre | Verificación | Estado | 3D |
|---|---|---|---|---|---|---|
| L2-PLT-01 | La plataforma deberá pesar no más de 12 kg. | restricción | L1-01 | inspección | TBR | no |
"""


def _cambio(viejo, nuevo, texto=CASO_SANO):
    """Cada sabotaje exige que su reemplazo APLIQUE: si el caso sano cambia y
    el reemplazo no encuentra el texto, el sabotaje no sabotea nada y daria
    un verde con toda la razon (leccion del dato literal)."""
    if viejo not in texto:
        raise AssertionError("el sabotaje no aplica: no esta %r" % viejo)
    return texto.replace(viejo, nuevo, 1)


def autotest():
    """Cada sabotaje exige SU rojo (el motivo), no un rojo cualquiera; y el
    control positivo exige verde. La redaccion (GtWR) va aparte, porque es la
    unica entrada que depende de otro programa."""
    casos = [
        ("CONTROL: un documento sano -> verde", CASO_SANO, None),
        ("padre que no existe -> rojo", _cambio("| restricción | L1-01 |", "| restricción | L1-09 |"), "NO existe"),
        ("L2 colgado de un L0 (salta un nivel) -> rojo", _cambio("| restricción | L1-01 |", "| restricción | L0-01 |"), "el padre es del nivel L1"),
        ("sin padre -> rojo", _cambio("| restricción | L1-01 |", "| restricción |  |"), "huerfano"),
        ("metodo de verificacion inventado -> rojo", _cambio("| N-01 | inspección |", "| N-01 | opinión |"), "fuera de ensayo"),
        ("estado fuera de la lista -> rojo", _cambio("| PLT | inspección | TBR |", "| PLT | inspección | quizás |"), "fuera de definido"),
        ("tipo fuera de los seis -> rojo", _cambio("| funcional | N-01 |", "| lindo | N-01 |"), "fuera de los seis"),
        ("necesidad que no baja a nada -> rojo", _cambio("| x |\n", "| x |\n| N-02 | Fran necesita otra cosa. | y |\n"), "N-02 no baja"),
        ("ID repetido -> rojo", CASO_SANO + "| L2-PLT-01 | La plataforma deberá pesar no más de 9 kg. | restricción | L1-01 | inspección | TBR | no |\n", "ID repetido"),
    ]
    mal = 0
    for nombre, md, motivo in casos:
        rojos, _ = verificar(md, con_gtwr=False)
        ok = (not rojos) if motivo is None else any(motivo in r for r in rojos)
        print("%s %-46s -> %s" % ("ok  " if ok else "FALLO", nombre, rojos[0].splitlines()[0] if rojos else "verde"))
        mal += not ok
    for nombre, md, quiere_rojo in (
            ("CONTROL: GtWR sobre el sano -> 0 VIOLA", CASO_SANO, False),
            ("enunciado inverificable -> GtWR rojo", _cambio("deberá pesar no más de 12 kg", "deberá ser rápida"), True)):
        rojos, _ = verificar(md)
        ok = any(r.startswith("GtWR:") for r in rojos) if quiere_rojo else not rojos
        print("%s %-46s -> %s" % ("ok  " if ok else "FALLO", nombre, rojos[0].splitlines()[0] if rojos else "verde"))
        mal += not ok
    print("autotest: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


def main():
    a = sys.argv[1:]
    if "--autotest" in a:
        return autotest()
    md = Path(a[0]) if a else AQUI / "10-requisitos.md"
    rojos, cuenta = verificar(md.read_text(encoding="utf-8"))
    print("%s: %s" % (md.name, ", ".join("%d %s" % (v, k) for k, v in cuenta.items())))
    for r in rojos:
        print("[FAIL] " + r)   # [FAIL]: el filtro con que chequeo-completo.ps1 muestra el detalle
    if rojos:
        print("%d rojo(s)." % len(rojos))
        return 1
    print("VERDE: la traza cierra (cada hijo con un padre del nivel de arriba, cada necesidad baja),"
          " cada requisito tiene tipo, metodo y estado, y el GtWR da 0 VIOLA.")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as ex:
        print("REVENTO: %r" % ex)
        sys.exit(2)
