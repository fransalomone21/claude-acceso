#!/usr/bin/env python3
"""matriz-verificacion.py -- el medidor de verificacion de T16 (arquitectura-se, L1-11, L2-MVR-01..10).

Que mide: para cada Requisito_Del_Proyecto (L0 a L5 del documento de requisitos que el proyecto declara en
.claude/cascada.json), que resultado tiene HOY y con que grado:
  - verificado : una linea 'REQ <ID> PASA|FALLA <detalle>' de la prueba del proyecto, para un requisito cuyo metodo
                 de verificacion es ANALISIS (la cuenta es la verificacion); o una entrada del registro de evidencias
                 (verificaciones.jsonl, al lado del documento), para cualquier metodo. El registro gana.
  - predicho   : la misma linea, para un requisito de ensayo, inspeccion o demostracion: una cuenta del diseno no
                 es un ensayo del objeto (confirmado = intervine y vi el efecto).
  - sin resultado.
Y lo cuenta por NIVEL (la V de NASA: el verde de L2 no certifica L1).

Por que existe (DA-039, DA-053): los requisitos tenian columna Verificacion y ningun lugar que dijera cuales se
cumplian; el arranque media el metodo y nunca el producto. Diseno: proyectos/ingenieria/arquitectura-se/docs/
t16-estado-verificable.md. La columna pasa/falla vive en la VISTA generada (matriz-verificacion.md), nunca a mano (T20).

ROJO es la integridad de la cadena, no el diseno: un ID que no existe (en la prueba o en el registro), una evidencia sin
puntero, una prueba que revienta o que calla, y -- solo con --verificar -- la vista escrita desactualizada. Una FALLA de
diseno NO es rojo: en Pre-Fase A el diseno incumple requisitos legitimamente; se imprime al entrar, que es donde decide.

Uso:
  python matriz-verificacion.py aviso <proyecto>       lo que imprime cascada.ps1 al entrar (L2-CAS-01, -02)
  python matriz-verificacion.py ver <proyecto>         la matriz entera, sin escribirla
  python matriz-verificacion.py escribir <proyecto>    genera la vista matriz-verificacion.md (se commitea)
  python matriz-verificacion.py registrar <proyecto> <ID> pasa|falla --evidencia "<puntero>" [--nota "..."]
  python matriz-verificacion.py --verificar            cada proyecto con pruebas o registro: integridad + vista al dia
  python matriz-verificacion.py --autotest             un proyecto sintetico: controles y rojos, cada uno por su motivo

Sale 0 sin rojos (aunque haya FALLA), 1 con algun rojo, 2 si revienta. Salida en ASCII: la consola la lee como cp1252.
"""
import datetime
import json
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
import unicodedata
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
PAT_ID = re.compile(r"^(L[0-5])-(?:[A-Z]{2,4}-)?\d{2}$")
PAT_REQ = re.compile(r"^REQ\s+(\S+)\s+(PASA|FALLA)\b\s*(.*)$")
METODOS = ("ensayo", "analisis", "inspeccion", "demostracion")
VISTA = "matriz-verificacion.md"
REGISTRO = "verificaciones.jsonl"
SIN = ("-", "sin resultado")


def plano(t):
    return "".join(c for c in unicodedata.normalize("NFD", t or "") if unicodedata.category(c) != "Mn").lower().strip()


def ascii(t):
    return unicodedata.normalize("NFKD", t or "").encode("ascii", "replace").decode("ascii")


def carpeta_proyecto(raiz, nombre):
    hallados = [p for p in (raiz / "proyectos").glob("*/" + nombre) if p.is_dir()]
    return hallados[0] if len(hallados) == 1 else None


def catalogo(raiz):
    return json.loads((raiz / ".claude" / "cascada.json").read_text(encoding="utf-8")).get("proyectos", {})


def leer_requisitos(texto):
    """Filas de las tablas cuyo encabezado empieza con ID. El metodo es la primera palabra de la columna
    Verificacion ('ensayo: caso del autotest' -> ensayo). Las necesidades (N-xx) no entran: se validan."""
    reqs, cab = {}, None
    for n, l in enumerate(texto.splitlines(), 1):
        if not l.startswith("|"):
            cab = None
            continue
        c = [x.strip() for x in l.strip().strip("|").split("|")]
        if c and plano(c[0]) == "id":
            cab = [plano(x) for x in c]
            continue
        if not cab or not c:
            continue
        m = PAT_ID.match(c[0])
        if not m or c[0] in reqs:
            continue
        iv = next((k for k, h in enumerate(cab) if h.startswith("verificacion")), None)
        cel = plano(c[iv]) if iv is not None and iv < len(c) else ""
        primera = re.split(r"[^a-z]+", cel)[0] if cel else ""
        reqs[c[0]] = {"nivel": m.group(1), "metodo": primera if primera in METODOS else "?", "linea": n}
    return reqs


def correr_prueba(carpeta, cmd, rojos):
    args = shlex.split(cmd)
    if args and args[0] in ("python", "python3"):
        args[0] = sys.executable          # el alias fantasma de WindowsApps no
    try:
        p = subprocess.run(args, cwd=str(carpeta), capture_output=True, text=True, encoding="utf-8",
                           errors="replace", timeout=180)
    except (OSError, subprocess.TimeoutExpired) as ex:
        rojos.append("la prueba '%s' no corrio: %s" % (cmd, ascii(str(ex))))
        return []
    if p.returncode != 0:                 # MVR-07
        cola = (p.stderr or p.stdout or "").strip().splitlines()[-3:]
        rojos.append("la prueba '%s' salio con codigo %d (L2-MVR-07): %s" % (cmd, p.returncode, ascii(" | ".join(cola))))
        return []
    lineas = []
    for l in p.stdout.splitlines():
        m = PAT_REQ.match(l.strip())
        if m:
            lineas.append((m.group(1), m.group(2), m.group(3).strip(), cmd))
    if not lineas:                        # MVR-08
        rojos.append("la prueba '%s' no imprimio ninguna linea REQ (L2-MVR-08)" % cmd)
    return lineas


def leer_registro(ruta, rojos):
    entradas = []
    if not ruta.is_file():
        return entradas
    for n, l in enumerate(ruta.read_text(encoding="utf-8").splitlines(), 1):
        if not l.strip():
            continue
        try:
            e = json.loads(l)
        except ValueError:
            rojos.append("%s linea %d: no es JSON" % (ruta.name, n))
            continue
        if str(e.get("resultado", "")).upper() not in ("PASA", "FALLA"):
            rojos.append("%s linea %d: resultado '%s' fuera de PASA y FALLA" % (ruta.name, n, e.get("resultado")))
            continue
        if not str(e.get("evidencia", "")).strip():          # MVR-06
            rojos.append("%s linea %d: %s sin evidencia (L2-MVR-06)" % (ruta.name, n, e.get("id")))
            continue
        entradas.append((n, e))
    return entradas


def armar(raiz, nombre, entrada):
    """(reqs, filas, rojos, rutas). filas: id -> (resultado, grado, detalle)."""
    rojos = []
    carpeta = carpeta_proyecto(raiz, nombre)
    if carpeta is None or not entrada.get("requisitos"):
        return {}, {}, ["%s: sin carpeta o sin documento de requisitos declarado" % nombre], None
    doc = carpeta / entrada["requisitos"]
    if not doc.is_file():
        return {}, {}, ["%s: el documento de requisitos %s no existe" % (nombre, entrada["requisitos"])], None
    reqs = leer_requisitos(doc.read_text(encoding="utf-8"))
    if not reqs:
        rojos.append("%s: %s no tiene ninguna fila de requisito con ID" % (nombre, entrada["requisitos"]))
    filas = {}
    for i, res, det, cmd in [x for cmd in entrada.get("pruebas", []) for x in correr_prueba(carpeta, cmd, rojos)]:
        if i not in reqs:  # MVR-04
            rojos.append("la prueba '%s' informa %s, que NO existe en %s (L2-MVR-04)" % (cmd, i, entrada["requisitos"]))
            continue
        grado = "verificado" if reqs[i]["metodo"] == "analisis" else "predicho"
        viejo = filas.get(i)
        if viejo:                         # varias lineas del mismo requisito: FALLA gana, el detalle se junta
            res = "FALLA" if "FALLA" in (res, viejo[0]) else "PASA"
            det = viejo[2] + "; " + det
        filas[i] = (res, grado, det)
    for n, e in sorted(leer_registro(doc.parent / REGISTRO, rojos), key=lambda x: (str(x[1].get("fecha", "")), x[0])):
        i = e.get("id")
        if i not in reqs:                 # MVR-05
            rojos.append("%s linea %d: %s NO existe en %s (L2-MVR-05)" % (REGISTRO, n, i, entrada["requisitos"]))
            continue
        filas[i] = (e["resultado"].upper(), "verificado",
                    "evidencia %s: %s" % (e.get("fecha", "?"), e["evidencia"]))      # MVR-03: el registro gana
    return reqs, filas, rojos, doc.parent


def conteo(reqs, filas):
    """MVR-09: por nivel, cuantos verificados, predichos y sin resultado, y cuantos de esos fallan."""
    c = {}
    for i, r in reqs.items():
        k = c.setdefault(r["nivel"], {"total": 0, "verificado": 0, "predicho": 0, "sin": 0, "falla": 0})
        k["total"] += 1
        res, grado, _ = filas.get(i, SIN + ("",))
        k["sin" if grado == "sin resultado" else grado] += 1
        k["falla"] += res == "FALLA"
    return dict(sorted(c.items()))


def vista_texto(nombre, reqs, filas):
    """Funcion pura de los datos: sin fecha, para que comparar la vista no compare el reloj."""
    out = ["# Matriz de verificacion -- %s" % nombre, "",
           "**Generada por `matriz-verificacion.py escribir %s`: no se edita a mano** (T16; el dueno de cada" % nombre,
           "enunciado es el documento de requisitos, el del resultado es su prueba o el registro de evidencias).",
           "verificado = por el metodo del propio requisito; predicho = una cuenta del diseno para un ensayo, una",
           "inspeccion o una demostracion.", "",
           "| Nivel | Total | Verificados | Predichos | Sin resultado | Con FALLA |", "|---|---|---|---|---|---|"]
    for niv, k in conteo(reqs, filas).items():
        out.append("| %s | %d | %d | %d | %d | %d |" % (niv, k["total"], k["verificado"], k["predicho"], k["sin"], k["falla"]))
    out += ["", "| ID | Nivel | Metodo | Resultado | Grado | Detalle |", "|---|---|---|---|---|---|"]
    for i, r in sorted(reqs.items(), key=lambda x: x[1]["linea"]):
        res, grado, det = filas.get(i, SIN + ("",))
        out.append("| %s | %s | %s | %s | %s | %s |" % (i, r["nivel"], r["metodo"], res, grado, ascii(det).replace("|", "/")))
    return "\n".join(out) + "\n"


def leer_vista(ruta):
    vieja = {}
    if ruta is None or not ruta.is_file():
        return None
    for l in ruta.read_text(encoding="utf-8").splitlines():
        c = [x.strip() for x in l.strip().strip("|").split("|")]
        if len(c) >= 5 and PAT_ID.match(c[0]):
            vieja[c[0]] = (c[3], c[4])
    return vieja


def cambios(vieja, reqs, filas):
    """MVR-10: (id, antes, ahora) por cada requisito cuyo resultado o grado cambio contra la vista escrita."""
    if vieja is None:
        return []
    out = []
    for i in list(reqs) + [j for j in vieja if j not in reqs]:
        ahora = filas.get(i, SIN + ("",))[:2] if i in reqs else ("(ya no existe)", "")
        antes = vieja.get(i, SIN)
        if tuple(antes) != tuple(ahora):
            out.append((i, "%s %s" % antes, "%s %s" % ahora))
    return out


def aplica(raiz, nombre, entrada):
    """Proyecto_Con_Ciclo_NASA con Documento_De_Requisitos (L1-11)."""
    c = carpeta_proyecto(raiz, nombre)
    return c is not None and c.parent.name == "ingenieria" and bool(entrada.get("requisitos"))


def cmd_aviso(raiz, nombre):
    entrada = catalogo(raiz).get(nombre, {})
    if not aplica(raiz, nombre, entrada):
        return 0
    reqs, filas, rojos, dirdoc = armar(raiz, nombre, entrada)
    print("  VERIFICACION DE REQUISITOS (T16) -- %s: %d requisitos, la V por nivel:" % (nombre, len(reqs)))
    for niv, k in conteo(reqs, filas).items():
        print("    %s: %d verificados, %d predichos, %d sin resultado (de %d)%s"
              % (niv, k["verificado"], k["predicho"], k["sin"], k["total"], ", %d con FALLA" % k["falla"] if k["falla"] else ""))
    if not entrada.get("pruebas") and not (dirdoc and (dirdoc / REGISTRO).is_file()):
        print("    sin prueba de requisitos ni registro de evidencias: nada se verifica al entrar (\"pruebas\" en cascada.json)")
    for i, r in sorted(reqs.items(), key=lambda x: x[1]["linea"]):
        res, grado, det = filas.get(i, SIN + ("",))
        if res == "FALLA":
            print("    FALLA %s (%s): %s" % (i, grado, ascii(det)[:150]))
    vieja = leer_vista(dirdoc / VISTA if dirdoc else None)
    for i, antes, ahora in cambios(vieja, reqs, filas):
        print("    CAMBIO desde la matriz escrita: %s  %s -> %s" % (i, antes, ahora))
    if vieja is None and entrada.get("pruebas"):
        print("    sin matriz escrita: python matriz-verificacion.py escribir %s" % nombre)
    for r in rojos:
        print("    [ROJO] " + ascii(r))
    return 1 if rojos else 0


def cmd_ver(raiz, nombre):
    entrada = catalogo(raiz).get(nombre, {})
    reqs, filas, rojos, _ = armar(raiz, nombre, entrada)
    print(ascii(vista_texto(nombre, reqs, filas)))
    for r in rojos:
        print("[FAIL] " + ascii(r))
    return 1 if rojos else 0


def cmd_escribir(raiz, nombre):
    entrada = catalogo(raiz).get(nombre, {})
    reqs, filas, rojos, dirdoc = armar(raiz, nombre, entrada)
    if rojos:                             # una vista armada sobre una cadena rota no se escribe
        for r in rojos:
            print("[FAIL] " + ascii(r))
        return 1
    (dirdoc / VISTA).write_text(vista_texto(nombre, reqs, filas), encoding="utf-8", newline="\n")
    k = conteo(reqs, filas)
    print("escrita %s: %s" % ((dirdoc / VISTA).relative_to(raiz), ", ".join(
        "%s %d/%d verif." % (n, v["verificado"], v["total"]) for n, v in k.items())))
    return 0


def cmd_registrar(raiz, nombre, args):
    if len(args) < 2 or "--evidencia" not in args:
        print("uso: registrar <proyecto> <ID> pasa|falla --evidencia \"<puntero>\" [--nota \"...\"]")
        return 2
    i, res = args[0], args[1].upper()
    ev = args[args.index("--evidencia") + 1] if args.index("--evidencia") + 1 < len(args) else ""
    nota = args[args.index("--nota") + 1] if "--nota" in args and args.index("--nota") + 1 < len(args) else ""
    entrada = catalogo(raiz).get(nombre, {})
    carpeta = carpeta_proyecto(raiz, nombre)
    if carpeta is None or not entrada.get("requisitos"):
        print("[FAIL] %s sin carpeta o sin documento de requisitos" % nombre)
        return 1
    doc = carpeta / entrada["requisitos"]
    if i not in leer_requisitos(doc.read_text(encoding="utf-8")):
        print("[FAIL] %s no existe en %s (L2-MVR-05)" % (i, entrada["requisitos"]))
        return 1
    if res not in ("PASA", "FALLA") or not ev.strip():
        print("[FAIL] hace falta PASA o FALLA y una evidencia no vacia (L2-MVR-06)")
        return 1
    e = {"id": i, "resultado": res, "fecha": datetime.date.today().isoformat(), "evidencia": ev, "nota": nota}
    with (doc.parent / REGISTRO).open("a", encoding="utf-8", newline="\n") as f:
        f.write(json.dumps(e, ensure_ascii=False) + "\n")
    print("registrado %s %s en %s; regenerar la vista: escribir %s" % (i, res, REGISTRO, nombre))
    return 0


def cmd_verificar(raiz):
    rojos, vistos = [], 0
    for nombre, entrada in sorted(catalogo(raiz).items()):
        if not aplica(raiz, nombre, entrada):
            continue
        carpeta = carpeta_proyecto(raiz, nombre)
        dirdoc = (carpeta / entrada["requisitos"]).parent
        if not entrada.get("pruebas") and not (dirdoc / REGISTRO).is_file():
            continue
        vistos += 1
        reqs, filas, r, dirdoc = armar(raiz, nombre, entrada)
        rojos += ["%s: %s" % (nombre, x) for x in r]
        vieja = leer_vista(dirdoc / VISTA if dirdoc else None)
        if vieja is None:
            rojos.append("%s: falta la matriz escrita (python matriz-verificacion.py escribir %s)" % (nombre, nombre))
        else:
            for i, antes, ahora in cambios(vieja, reqs, filas):
                rojos.append("%s: la matriz escrita esta desactualizada en %s (%s -> %s): escribir %s y commitear"
                             % (nombre, i, antes, ahora, nombre))
        k = conteo(reqs, filas)
        print("%s: %s" % (nombre, ", ".join("%s %d/%d verif. %d pred." % (n, v["verificado"], v["total"], v["predicho"])
                                            for n, v in k.items())))
    for r in rojos:
        print("[FAIL] " + ascii(r))
    if rojos:
        print("%d rojo(s)." % len(rojos))
        return 1
    print("VERDE: %d proyecto(s) con prueba de requisitos; la cadena cierra y cada matriz escrita esta al dia." % vistos)
    return 0


# ------------------------------------------------------------------ autotest
DOC = """| ID | Padre | Requisito | Verificacion |
|---|---|---|---|
| L0-01 | N-01 | La mision debera obtener la foto. | inspeccion |
| L1-01 | L0-01 | El sistema debera pesar no mas de 20 kg. | analisis |
| L1-02 | L0-01 | El sistema debera seguir 60 min. | ensayo: la carrera |
| L2-PLT-01 | L1-01 | La plataforma debera pesar no mas de 12 kg. | analisis |
"""


def _demo(raiz, prueba=None, registro=None, pruebas=None):
    """Un repo sintetico con un proyecto de ingenieria 'demo'. prueba: el texto de prueba.py."""
    if raiz.exists():
        shutil.rmtree(raiz)
    d = raiz / "proyectos" / "ingenieria" / "demo" / "docs"
    d.mkdir(parents=True)
    (d / "10-requisitos.md").write_text(DOC, encoding="utf-8")
    ent = {"requisitos": "docs/10-requisitos.md"}
    if prueba is not None:
        (raiz / "proyectos" / "ingenieria" / "demo" / "prueba.py").write_text(prueba, encoding="utf-8")
        ent["pruebas"] = pruebas or ["python prueba.py"]
    if registro is not None:
        (d / REGISTRO).write_text(registro, encoding="utf-8")
    (raiz / ".claude").mkdir()
    (raiz / ".claude" / "cascada.json").write_text(json.dumps({"proyectos": {"demo": ent}}), encoding="utf-8")
    return ent


def _p(*lineas, codigo=0):
    return "import sys\n" + "".join("print(%r)\n" % l for l in lineas) + "sys.exit(%d)\n" % codigo


def autotest():
    tmp = Path(tempfile.mkdtemp(prefix="mvr-"))
    raiz = tmp / "repo"
    sano = _p("REQ L1-01 PASA 18 kg <= 20", "REQ L1-02 PASA 90 min >= 60", "otra linea que no es REQ")
    reg_ok = json.dumps({"id": "L1-02", "resultado": "FALLA", "fecha": "2026-10-16", "evidencia": "fotos/deriva.jpg"}) + "\n"

    def caso(prueba=None, registro=None, pruebas=None):
        ent = _demo(raiz, prueba, registro, pruebas)
        return armar(raiz, "demo", ent)

    def rojo_con(rojos, motivo):
        return any(motivo in r for r in rojos)

    casos = []
    reqs, filas, rojos, _ = caso(sano)
    casos.append(("L2-MVR-01 analisis -> verificado", filas.get("L1-01", SIN)[:2] == ("PASA", "verificado") and not rojos))
    casos.append(("L2-MVR-02 ensayo -> predicho", filas.get("L1-02", SIN)[:2] == ("PASA", "predicho")))
    reqs, filas, rojos, _ = caso(sano, reg_ok)
    casos.append(("L2-MVR-03 el registro gana -> verificado", filas.get("L1-02", SIN)[:2] == ("FALLA", "verificado") and not rojos))
    reqs, filas, rojos, _ = caso(_p("REQ L1-01 PASA x", "REQ L9-99 PASA x"))
    casos.append(("L2-MVR-04 ID inexistente en la prueba -> rojo", rojo_con(rojos, "L2-MVR-04")))
    reqs, filas, rojos, _ = caso(sano, reg_ok.replace("L1-02", "L1-77"))
    casos.append(("L2-MVR-05 ID inexistente en el registro -> rojo", rojo_con(rojos, "L2-MVR-05")))
    reqs, filas, rojos, _ = caso(sano, reg_ok.replace("fotos/deriva.jpg", " "))
    casos.append(("L2-MVR-06 evidencia vacia -> rojo", rojo_con(rojos, "L2-MVR-06")))
    reqs, filas, rojos, _ = caso(_p("REQ L1-01 PASA x", codigo=3))
    casos.append(("L2-MVR-07 la prueba revienta -> rojo", rojo_con(rojos, "L2-MVR-07")))
    reqs, filas, rojos, _ = caso(_p("nada que ver"))
    casos.append(("L2-MVR-08 la prueba calla -> rojo", rojo_con(rojos, "L2-MVR-08")))
    reqs, filas, rojos, _ = caso(sano)
    k = conteo(reqs, filas)
    casos.append(("L2-MVR-09 conteo por nivel", k.get("L0", {}).get("sin") == 1 and k.get("L1", {}).get("verificado") == 1
                  and k.get("L1", {}).get("predicho") == 1 and k.get("L2", {}).get("sin") == 1 and "N" not in k))
    # MVR-10: se escribe la vista con el sano y despues la prueba cambia L1-01 a FALLA
    _demo(raiz, sano)
    cmd_escribir_q = armar(raiz, "demo", catalogo(raiz)["demo"])
    (raiz / "proyectos" / "ingenieria" / "demo" / "docs" / VISTA).write_text(
        vista_texto("demo", cmd_escribir_q[0], cmd_escribir_q[1]), encoding="utf-8")
    (raiz / "proyectos" / "ingenieria" / "demo" / "prueba.py").write_text(
        _p("REQ L1-01 FALLA 25 kg > 20", "REQ L1-02 PASA 90 min"), encoding="utf-8")
    reqs, filas, rojos, dirdoc = armar(raiz, "demo", catalogo(raiz)["demo"])
    ch = cambios(leer_vista(dirdoc / VISTA), reqs, filas)
    casos.append(("L2-MVR-10 cambio contra la vista escrita", [c[0] for c in ch] == ["L1-01"] and "PASA" in ch[0][1] and "FALLA" in ch[0][2]))
    casos.append(("CONTROL: una FALLA de diseno no es rojo", not rojos and filas["L1-01"][0] == "FALLA"))
    # el mismo cambio, por --verificar: la vista desactualizada es rojo ahi (T20), y con la vista al dia, verde
    import io
    import contextlib
    with contextlib.redirect_stdout(io.StringIO()) as buf:
        v1 = cmd_verificar(raiz)
        (dirdoc / VISTA).write_text(vista_texto("demo", reqs, filas), encoding="utf-8")
        v2 = cmd_verificar(raiz)
    casos.append(("--verificar: vista desactualizada -> rojo; al dia -> verde", v1 == 1 and v2 == 0 and "desactualizada" in buf.getvalue()))
    with contextlib.redirect_stdout(io.StringIO()) as buf:
        cmd_aviso(raiz, "demo")
    sal = buf.getvalue()
    casos.append(("L2-CAS-01/02 el aviso trae el conteo y cada FALLA", "L1: 1 verificados, 1 predichos" in sal and "FALLA L1-01" in sal))
    with contextlib.redirect_stdout(io.StringIO()) as buf:
        _demo(raiz)                        # sin pruebas ni registro: lo dice, no calla
        cmd_aviso(raiz, "demo")
    casos.append(("CONTROL: sin prueba lo dice (no es un verde mudo)", "sin prueba de requisitos" in buf.getvalue()))
    shutil.rmtree(tmp, ignore_errors=True)
    mal = 0
    for nombre, ok in casos:
        print("%s %s" % ("ok  " if ok else "MAL ", nombre))
        mal += not ok
    print("autotest: %s" % ("BIEN, %d casos" % len(casos) if not mal else "%d MAL" % mal))
    return 1 if mal else 0


def main():
    a = sys.argv[1:]
    if not a:
        print(__doc__)
        return 2
    if a[0] == "--autotest":
        return autotest()
    if a[0] == "--verificar":
        return cmd_verificar(RAIZ)
    if a[0] in ("aviso", "ver", "escribir", "registrar") and len(a) >= 2:
        if a[0] == "registrar":
            return cmd_registrar(RAIZ, a[1], a[2:])
        return {"aviso": cmd_aviso, "ver": cmd_ver, "escribir": cmd_escribir}[a[0]](RAIZ, a[1])
    print(__doc__)
    return 2


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as ex:
        print("REVENTO: %r" % ex)
        sys.exit(2)
