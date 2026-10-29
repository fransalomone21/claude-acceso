"""Ningun simbolo en el aire: cada simbolo de una formula se presenta donde aparece por primera vez.

Fran, 2026-10-29, sobre la guia del parcialito 5: «me tiraste esa v_A y v_B de la
nada; que no se repita con ningun otro tema, que no quede nada en el aire». La regla
propia 4 del proyecto (presentar en palabras antes de la primera ecuacion) ya existia
y no frenaba nada: ningun paso de la escritura listaba los simbolos nuevos.

Este verificador recorre la matematica del documento ($...$, en linea y en bloque),
normaliza cada simbolo (bold(H)_G -> H_G, dot(phi) -> phidot, overline(v) -> vbar,
hat(K) -> Khat, I'_O queda I'_O) y exige que su PRIMERA aparicion tenga, a no mas de
VENTANA renglones, una declaracion

    // simbolos: H_G, phidot, vbar

que es la firma del que escribe: «aca, en palabras, digo que es cada uno». Da rojo si:
  - un simbolo aparece por primera vez sin declaracion cerca (SIN PRESENTAR);
  - se declara lejos de donde aparece primero (LEJOS);
  - se declara un simbolo que no aparece en ninguna formula (DECLARACION MUERTA).

Lo que NO ve (escrito para que nadie le crea mas de lo que mide):
  - si las palabras de al lado de verdad dicen que es el simbolo: eso lo firma el autor;
  - las letras dibujadas dentro de las figuras: las presenta su epigrafe, que si se mide;
  - CONOCIDOS: x, y, z, t (coordenadas y tiempo), ihat, jhat, khat (sus versores) y
    'd', que es diferencial y distancia a la vez: una distancia d se presenta igual,
    pero esto no la exige.

Uso:
  python verificar-simbolos.py              # los documentos de OBLIGADOS
  python verificar-simbolos.py archivo.typ  # uno suelto
  python verificar-simbolos.py --listar archivo.typ   # primeras apariciones, para auditar
  python verificar-simbolos.py --sabotaje   # rompe a proposito y exige el rojo por su motivo
"""
import contextlib
import io
import os
import re
import shutil
import sys
import tempfile

AQUI = os.path.dirname(os.path.abspath(__file__))
OBLIGADOS = ["resumen-cuerpo-rigido.typ"]
VENTANA = 12

CONOCIDOS = {"x", "y", "z", "t", "d", "ihat", "jhat", "khat"}
# funciones y operadores de Typst que quedan sueltos en la matematica
NO_SIMBOLOS = {
    "sum", "integral", "sin", "cos", "tan", "arctan", "thin", "quad", "mat", "abs",
    "degree", "times", "perp", "parallel", "approx", "diag", "dif", "oo", "frac",
    "sqrt", "lr", "op", "max", "min", "ln", "log", "exp", "infinity",
}
DECORA = re.compile(r"\b(bold|upright|dot\.double|dot|hat|overline)\(([^()]*)\)")
SUFIJO = {"bold": "", "upright": "", "dot.double": "ddot", "dot": "dot",
          "hat": "hat", "overline": "bar"}
DECL = re.compile(r"//\s*s[ií]mbolos:\s*(.*)$")
TOKEN = re.compile(r"(?<![\w'])([A-Za-z]+'*)(_(\([^()]*\)|[^\W_]+))?")


def decorar(m):
    interior = m.group(2).strip()
    suf = SUFIJO[m.group(1)]
    if not suf:
        return interior
    # dot(H_G) -> Hdot_G: el sufijo va pegado a la base, antes del subindice
    base, _, sub = interior.partition("_")
    return base + suf + ("_" + sub if sub else "")


def normalizar(expr):
    expr = expr.replace("\\/", "/")
    prev = None
    while prev != expr:                                   # primero dot.double( y compania
        prev = expr
        expr = DECORA.sub(decorar, expr)
    expr = re.sub(r"(?<![A-Za-z])[a-z]+(\.[a-z]+)+(?![A-Za-z])", " ", expr)  # arrow.r, dot.op, bar.v
    expr = re.sub(r'_"([^"]*)"', r"_\1", expr)          # subindice con string
    expr = re.sub(r'"[^"]*"', " ", expr)                 # textos sueltos
    expr = re.sub(r"\^(\([^()]*\)|[A-Za-z0-9+\-]+)", " ", expr)
    return expr


def tokens(expr):
    for m in TOKEN.finditer(normalizar(expr)):
        base, sub = m.group(1), m.group(3)
        if base in NO_SIMBOLOS:
            continue
        if sub and sub.startswith("("):
            sub = sub[1:-1].replace(" ", "")
        yield base + ("_" + sub if sub else "")


def analizar(texto):
    """Devuelve (primeras: {tok: (renglon, formula)}, decl: {tok: [renglones]})."""
    decl, limpio = {}, []
    for i, ln in enumerate(texto.split("\n"), 1):
        m = DECL.search(ln)
        if m:
            for tok in re.split(r"[,\s]+", m.group(1).strip()):
                if tok:
                    decl.setdefault(tok, []).append(i)
        # saca el comentario conservando el largo (las posiciones dan el renglon)
        c = re.search(r"(^|\s)//", ln)
        limpio.append(ln[:c.start()] + " " * (len(ln) - c.start()) if c else ln)
    cuerpo = "\n".join(limpio)
    primeras = {}
    for m in re.finditer(r"(?<!\\)\$(.*?)(?<!\\)\$", cuerpo, re.S):
        renglon = cuerpo.count("\n", 0, m.start()) + 1
        for tok in tokens(m.group(1)):
            if tok not in primeras and tok not in CONOCIDOS:
                primeras[tok] = (renglon, " ".join(m.group(1).split())[:70])
    return primeras, decl


def errores_de(texto):
    primeras, decl = analizar(texto)
    errores = []
    for tok, (ln, ctx) in sorted(primeras.items(), key=lambda kv: kv[1][0]):
        if tok not in decl:
            errores.append(f"SIN PRESENTAR  {tok}  (renglon {ln}: ${ctx}$)")
        elif min(abs(d - ln) for d in decl[tok]) > VENTANA:
            errores.append(f"LEJOS  {tok}  aparece en {ln}, declarado en {decl[tok]}")
    for tok, lns in decl.items():
        if tok not in primeras and tok not in CONOCIDOS:
            errores.append(f"DECLARACION MUERTA  {tok}  (renglon {lns}): no esta en ninguna formula")
    return primeras, errores


def verificar(ruta, listar=False):
    texto = io.open(ruta, encoding="utf-8").read()
    if listar:
        primeras, decl = analizar(texto)
        for tok, (ln, ctx) in sorted(primeras.items(), key=lambda kv: kv[1][0]):
            print(f"{'ok' if tok in decl else '--'} {ln:5d}  {tok:14s} {ctx}")
        return 0
    primeras, errores = errores_de(texto)
    nombre = os.path.basename(ruta)
    if errores:
        print(f"[ROJO] {nombre}: {len(errores)} simbolo(s) en el aire")
        for e in errores:
            print("   " + e)
        return 1
    print(f"[OK] {nombre}: {len(primeras)} simbolos, cada uno presentado donde aparece primero")
    return 0


def sabotaje():
    """Control positivo y cuatro mutantes; cada mutante tiene que dar rojo POR SU MOTIVO."""
    original = io.open(os.path.join(AQUI, OBLIGADOS[0]), encoding="utf-8").read()
    primeras, decl = analizar(original)
    fallas = 0

    def correr(texto, esperado, nombre):
        nonlocal fallas
        if esperado is not None and texto == original:
            print(f"  [FALLA] {nombre}: el mutante NO SE APLICO (el texto que buscaba ya no esta)")
            fallas += 1
            return
        d = tempfile.mkdtemp()
        p = os.path.join(d, "mutante.typ")
        io.open(p, "w", encoding="utf-8").write(texto)
        buf = io.StringIO()
        try:
            with contextlib.redirect_stdout(buf):
                rc = verificar(p)
        except Exception as e:  # revento: no es ni verde ni rojo
            print(f"  [FALLA] {nombre}: REVENTO ({e!r})")
            fallas += 1
            return
        finally:
            shutil.rmtree(d)
        rojas = [l.strip() for l in buf.getvalue().splitlines() if l.startswith("   ")]
        if esperado is None:
            bien, prueba = rc == 0, buf.getvalue().strip()
        else:
            hit = [l for l in rojas if l.startswith(esperado)]
            bien, prueba = rc == 1 and bool(hit), (hit[0] if hit else "ninguna linea roja de su motivo")
        print(f"  [{'ok' if bien else 'FALLA'}] {nombre} -> {prueba}")
        if not bien:
            fallas += 1

    correr(original, None, "control positivo: el documento real da verde")
    # 1. el caso que denuncio Fran: sacar la declaracion de v_B
    mut = re.sub(r"(//\s*s[ií]mbolos:[^\n]*?)\bv_B\b,?\s*", r"\1", original)
    correr(mut, "SIN PRESENTAR  v_B", "sin la declaracion de v_B")
    # 2. otro, derivado del archivo: el ultimo simbolo declarado
    if decl:
        ult = max(decl, key=lambda t: max(decl[t]))
        mut = re.sub(r"(//\s*s[ií]mbolos:[^\n]*?)(?<![\w'])" + re.escape(ult) + r"(?![\w'])", r"\1", original)
        correr(mut, f"SIN PRESENTAR  {ult}", f"sin la declaracion de {ult} (derivado del archivo)")
    # 3. un simbolo nuevo en la primera formula en bloque (renglon que empieza con "$ "), sin presentar
    mut = re.sub(r"(?m)^\$ ", "$ bold(Q)_w + ", original, count=1)
    correr(mut, "SIN PRESENTAR  Q_w", "un simbolo nuevo sin presentar")
    # 4. declarar algo que no esta en ninguna formula
    mut = re.sub(r"//\s*s[ií]mbolos:", "// simbolos: Zfantasma,", original, count=1)
    correr(mut, "DECLARACION MUERTA  Zfantasma", "una declaracion muerta")
    # 5. declarar lejos: mover la primera declaracion al final del archivo
    m = re.search(r"[^\n]*//\s*s[ií]mbolos:[^\n]*\n", original)
    mut = original[:m.start()] + original[m.end():] + "\n" + m.group(0) if m else original
    correr(mut, "LEJOS", "una declaracion lejos de su simbolo")
    print(f"sabotaje: {'cada mutante en rojo por su motivo' if not fallas else str(fallas) + ' FALLA(S)'}")
    return 1 if fallas else 0


if __name__ == "__main__":
    args = sys.argv[1:]
    if args and args[0] == "--sabotaje":
        sys.exit(sabotaje())
    if args and args[0] == "--listar":
        sys.exit(verificar(args[1], listar=True))
    archivos = args or [os.path.join(AQUI, f) for f in OBLIGADOS]
    sys.exit(max(verificar(a) for a in archivos))
