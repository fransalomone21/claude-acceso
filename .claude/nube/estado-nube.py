#!/usr/bin/env python3
"""estado-nube.py -- puede una sesion en la NUBE seguir CUALQUIER proyecto, igual que en la PC?

Por que existe (2026-10-06, pedido de Fran): T7 dejo el libro y la puerta andando en la nube, pero nadie media
lo demas, y lo demas fallaba en silencio. Medido el dia que nacio: dos repos privados (catedras, clases-aed) con
commits sin subir; el nucleo de perfil-global regenerado y sin commitear; y la puerta exige leer seis memorias
para 'materia' que viven SOLO en ~/.claude de la PC -- en la nube toda sesion de materia quedaba trabada.

Lo que mide (la capa rapida, corre en el arranque):
  1. cada repo que la nube va a clonar (claude-acceso, perfil-global y los repos propios de MAPA.md seccion 2):
     sin cambios sin commitear y sin commits sin pushear. Lo que no esta en GitHub, en la nube no existe.
  2. la memoria: el espejo perfil-global/memoria igual a la de la PC (MD5 por archivo).
  3. los limites declarados de cada proyecto (lo que es SOLO de la PC: comandos .ps1, datos ignorados). No es rojo:
     es lo que la sesion de la nube tiene que saber que no va a tener.

--simular (la capa lenta): arma en una carpeta temporal lo que una sesion nueva de la nube ve -- claude-acceso,
perfil-global al lado y cada repo propio, TODOS desde lo que ya esta en GitHub (origin/*), y el perfil instalado
por traer-perfil.sh en un HOME falso -- y le pide a la puerta lo que exige para cada proyecto x cada necesidad.
Un exigido que NO EXISTE ahi es una sesion de la nube que la puerta va a frenar: rojo. Mide el EFECTO.

Uso:
  python .claude/nube/estado-nube.py                       la capa rapida (rojo = exit 1)
  python .claude/nube/estado-nube.py --simular             el simulacro de la nube
  python .claude/nube/estado-nube.py --sincronizar-memoria la memoria de la PC -> perfil-global/memoria (sin commit)
  python3 .claude/nube/estado-nube.py --traer <proyecto>   EN LA NUBE: clona el repo propio del proyecto en su lugar
  python .claude/nube/estado-nube.py --probar              el saboteador (lento: dos simulacros con compilacion)
  python .claude/nube/estado-nube.py --probar-compilados   DA-099, rapido: lee compilados, compara PC/nube, limites
  python .claude/nube/estado-nube.py --probar-memoria      DA-101, rapido: el espejo no pierde lo escrito afuera
  python .claude/nube/estado-nube.py --sabotaje            mutantes de DA-099 y DA-101: cada uno tiene que dar rojo

DA-099 (2026-11-05): --simular compila ademas cada entrada de cada proyecto documental aca y en el clon (con
--ignore-system-fonts y el perfil del HOME falso), y da ROJO lo que compila aca y no en la nube; limites() mira los
.bat, las rutas fuera del repo y los hooks locales. DA-101: --sincronizar-memoria no borra ni pisa lo que el espejo
trae de afuera: da ROJO y no toca nada.
"""
import hashlib
import json
import os
import re
import shutil
import stat
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(os.environ.get("ESTADO_NUBE_RAIZ") or Path(__file__).resolve().parents[2])
CUENTA = "fransalomone21"


def git(cwd, *args):
    r = subprocess.run(["git", "-C", str(cwd), *args], capture_output=True, text=True,
                       encoding="utf-8", errors="replace")
    return r.returncode, r.stdout.rstrip()


def perfil_dir(raiz=RAIZ) -> Path:
    if (raiz / "perfil-global" / ".git").exists():
        return raiz / "perfil-global"
    return Path(os.environ.get("PERFIL_DIR") or raiz.parent / "perfil-global")


def memoria_local(raiz=RAIZ) -> Path:
    # el mismo slug que usa la puerta (cascada_puerta.memoria_dir) y que traer-perfil.sh reproduce
    return Path.home() / ".claude" / "projects" / re.sub(r"[:\\/]", "-", str(raiz)) / "memory"


def repos_propios(raiz=RAIZ):
    """[(carpeta relativa, url)] de la tabla de duenos de MAPA.md seccion 2 (su unico dueno; verificar-estructura
    ya exige que coincida con el disco)."""
    texto = (raiz / "MAPA.md").read_text(encoding="utf-8")
    m = re.search(r"(?s)##\s*2\.[^\n]*\n(.*?)(?=\n##\s)", texto)
    out = []
    for fila in re.finditer(r"^\|\s*`([^`]+)/`\s*\|\s*`([^`]+)`\s*\|\s*`(github\.com/[^`]+)`", m.group(1) if m else "", re.M):
        if fila.group(1) in ("claude-acceso", "perfil-global"):
            continue
        out.append((fila.group(1), "https://" + fila.group(3)))
    return out


# ------------------------------------------------------------------------------------------- 1. repos subidos
def problemas_repo(path: Path):
    """Lo que hace que la nube NO reciba lo que esta en este repo. Lista vacia = al dia."""
    if not (path / ".git").exists():
        return ["no es un repo clonado aca"]
    p = []
    rc, sucio = git(path, "status", "--porcelain")
    if sucio:
        n = len(sucio.splitlines())
        p.append("%d archivo(s) sin commitear (%s)" % (n, ", ".join(l[3:] for l in sucio.splitlines()[:3])))
    return p + problema_push(path)


def problema_push(path: Path):
    """Lo que hace que HEAD no este en el remoto. Lista vacia = pusheado. Es la UNICA definicion de 'pusheado':
    auditar-sesion.py (P8, P11) la importa. Antes alla se leia solo la salida de rev-list, y sin upstream git
    falla con salida vacia -- que se leia como '0 sin pushear': verde silencioso (2026-10-09)."""
    rc, adelante = git(path, "rev-list", "--count", "@{u}..HEAD")
    if rc != 0:
        if not git(path, "remote")[1]:
            return ["el repo no tiene remote (sin upstream): sus commits no salen de esta maquina"]
        return ["la rama no sigue a ninguna de GitHub (sin upstream): nada de esto se pushea"]
    if adelante != "0":
        return ["%s commit(s) sin pushear" % adelante]
    return []


# ------------------------------------------------------------------------------------------- 2. la memoria
def md5s(d: Path):
    # sin los \r: git con autocrlf deja el espejo en CRLF al sacarlo, y eso no es un cambio de memoria
    return {f.name: hashlib.md5(f.read_bytes().replace(b"\r\n", b"\n")).hexdigest()
            for f in sorted(d.glob("*.md"))} if d.is_dir() else {}


def problemas_memoria(local: Path, espejo: Path, en_la_pc=True):
    if not local.is_dir():
        # En la nube no hay memoria de la PC que comparar. En la PC, que falte es un camino de salida temprana:
        # callar ahi seria un fail-open (Saltzer), asi que es rojo.
        return ["no encuentro la memoria de la PC en %s" % local] if en_la_pc else []
    a, b, man = md5s(local), md5s(espejo), manifiesto(espejo)
    p = []
    faltan = sorted(set(a) - set(b))
    sobran = sorted(set(b) - set(a))
    distintos = sorted(k for k in set(a) & set(b) if a[k] != b[k])
    if faltan:
        p.append("%d memoria(s) de la PC sin espejo (%s)" % (len(faltan), ", ".join(faltan[:3])))
    if distintos:
        p.append("%d memoria(s) cambiadas en la PC (%s)" % (len(distintos), ", ".join(distintos[:3])))
    borradas = [x for x in sobran if man is not None and x in man]
    ajenas = [x for x in sobran if man is None or x not in man]
    if borradas:
        p.append("%d memoria(s) en el espejo que la PC ya borro (%s)" % (len(borradas), ", ".join(borradas[:3])))
    if ajenas:
        p.append("%d memoria(s) en el espejo que la PC nunca tuvo (escritas afuera: %s): traerlas a la memoria de la "
                 "PC antes de sincronizar" % (len(ajenas), ", ".join(ajenas[:3])))
    return p


# DA-101 (2026-11-05): sincronizar borraba del espejo TODO lo que la PC no tenia, y una memoria escrita en la nube se
# perdia sola en la proxima sincronizacion. El espejo guarda ahora lo que la PC le dejo la ultima vez (el manifiesto,
# nombre -> MD5): lo que esta en el espejo y no en el manifiesto lo escribio otro, y no se borra ni se pisa: ROJO y se
# frena sin tocar nada. Lo que la PC tuvo y borro, se borra.
MANIFIESTO = ".sincronizado.json"
MUTANTE_DA101 = False    # lo prende --sabotaje: vuelve a la regla vieja; --probar-memoria tiene que verlo


def manifiesto(espejo: Path):
    f = espejo / MANIFIESTO
    if not f.exists():
        return None
    try:
        return json.loads(f.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}


def sincronizar_memoria(local: Path, espejo: Path):
    """(copiadas, rojos). Con un rojo no cambia NADA: ni borra, ni copia, ni escribe el manifiesto."""
    espejo.mkdir(parents=True, exist_ok=True)
    a, b, man = md5s(local), md5s(espejo), manifiesto(espejo)
    rojos = []
    if not MUTANTE_DA101:
        for nombre in sorted(set(b) - set(a)):
            if man is None or nombre not in man:
                rojos.append("%s esta en el espejo y la PC nunca lo tuvo (lo escribio la nube u otra maquina): "
                             "borrarlo lo pierde" % nombre)
        for nombre in sorted(set(b) & set(a)):
            if man is not None and nombre in man and b[nombre] != man[nombre] and b[nombre] != a[nombre]:
                rojos.append("%s cambio en el espejo desde la ultima sincronizacion (afuera de la PC) y la PC tiene "
                             "otra version: copiarla pisa lo de afuera" % nombre)
    if rojos:
        return 0, rojos
    for f in espejo.glob("*.md"):
        if f.name not in a:
            f.unlink()
    for nombre in a:
        shutil.copyfile(local / nombre, espejo / nombre)
    (espejo / MANIFIESTO).write_text(json.dumps(md5s(espejo), indent=0, sort_keys=True) + "\n", encoding="utf-8")
    return len(a), []


def probar_memoria():
    """DA-101, sobre carpetas sinteticas: lo que el espejo trae de afuera no se borra ni se pisa."""
    malos = 0

    def caso(ok, que):
        nonlocal malos
        print("%s  %s" % ("ok " if ok else "MAL", que))
        malos += 0 if ok else 1

    tmp = Path(tempfile.mkdtemp(prefix="probar-memoria-"))
    try:
        loc, esp = tmp / "pc", tmp / "espejo"
        loc.mkdir()
        (loc / "a.md").write_text("a\n", encoding="utf-8"); (loc / "b.md").write_text("b\n", encoding="utf-8")
        n, r = sincronizar_memoria(loc, esp)
        caso(n == 2 and r == [] and manifiesto(esp) is not None, "control: primera sincronizacion copia 2 y deja el manifiesto")
        (loc / "b.md").unlink()
        n, r = sincronizar_memoria(loc, esp)
        caso(r == [] and not (esp / "b.md").exists(), "control: lo que la PC tuvo y borro se borra del espejo")
        (esp / "nube.md").write_text("aprendido en la nube\n", encoding="utf-8")
        (loc / "a.md").write_text("a2\n", encoding="utf-8")
        p = problemas_memoria(loc, esp)
        caso(any("nunca tuvo" in x and "nube.md" in x for x in p), "el medidor dice que nube.md la PC nunca la tuvo: %s" % p)
        n, r = sincronizar_memoria(loc, esp)
        caso(any("nube.md" in x for x in r) and (esp / "nube.md").exists()
             and (esp / "a.md").read_text(encoding="utf-8") == "a\n",
             "SABOTAJE: una memoria escrita en la nube -> ROJO, sigue en el espejo y no se toco nada mas (%s)" % r[:1])
        (esp / "nube.md").unlink()
        (esp / "a.md").write_text("a editada en la nube\n", encoding="utf-8")
        n, r = sincronizar_memoria(loc, esp)
        caso(any("a.md" in x and "pisa" in x for x in r) and "nube" in (esp / "a.md").read_text(encoding="utf-8"),
             "SABOTAJE: una memoria cambiada afuera y en la PC -> ROJO y no se pisa (%s)" % r[:1])
        (esp / "a.md").write_text("a\n", encoding="utf-8")
        n, r = sincronizar_memoria(loc, esp)
        caso(r == [] and (esp / "a.md").read_text(encoding="utf-8") == "a2\n", "control: lo que solo cambio en la PC se copia")
        esp2 = tmp / "espejo-viejo"
        esp2.mkdir(); (esp2 / "x.md").write_text("x\n", encoding="utf-8")
        n, r = sincronizar_memoria(loc, esp2)
        caso(any("x.md" in x for x in r) and (esp2 / "x.md").exists(),
             "un espejo sin manifiesto con algo que la PC no tiene -> ROJO (no se adivina que la PC lo borro)")
    finally:
        _borrar(tmp)
    print("TODO BIEN" if malos == 0 else "%d caso(s) MAL" % malos)
    return 1 if malos else 0


# ------------------------------------------------------------------------------------------- 3. limites
SCRIPTS_WINDOWS = (".bat", ".cmd", ".ps1")
SCRIPTS = SCRIPTS_WINDOWS + (".py", ".sh")
# Una ruta que vive fuera de todo repo: la nube no la tiene. ~/.claude/herramientas NO cuenta: la instala traer-perfil.sh.
PAT_AFUERA = re.compile(r"(?i)(?:downloads|descargas|desktop|escritorio|onedrive|\b[a-z]:[\\/](?!\S*\.claude))")


def carpeta_proyecto(nombre: str, raiz=RAIZ):
    for d in sorted((raiz / "proyectos").glob("*/" + nombre)):
        if d.is_dir():
            return d
    return None


def _archivos(d: Path, sufijos):
    for f in sorted(d.rglob("*")):
        if f.suffix.lower() in sufijos and ".git" not in f.relative_to(d).parts and f.is_file():
            yield f


def hooks_locales(repo: Path):
    """Los hooks de git que viven en .git/hooks de ESTA maquina: no viajan con un clon ni corren con un pull (DA-103)."""
    h = repo / ".git" / "hooks"
    return sorted(f.name for f in h.glob("*") if f.is_file() and not f.name.endswith(".sample")) if h.is_dir() else []


def limites(raiz=RAIZ):
    """{proyecto: [lo que es solo de la PC]}. Informativo. DA-099 (2026-11-05): antes listaba solo los comandos .ps1 de
    cascada.json, y compilar.bat de electronica-analogica no figuraba. Ahora mira el DISCO del proyecto: cada script de
    Windows (.bat/.cmd/.ps1), cada ruta fuera del repo que un script usa (Descargas, Escritorio, C:\\...), las carpetas
    'locales' que el catalogo declara y los hooks locales de git del repo del proyecto."""
    cat = json.loads((raiz / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    out = {}
    for nombre, e in cat.get("proyectos", {}).items():
        l = ["comando de PowerShell: %s" % c for c in e.get("comandos", []) if c.endswith(".ps1")]
        l += ["carpeta local fuera del repo: %s" % c for c in e.get("locales", [])]
        d = carpeta_proyecto(nombre, raiz)
        if d is not None:
            for f in _archivos(d, SCRIPTS):
                rel = f.relative_to(d).as_posix()
                if f.suffix.lower() in SCRIPTS_WINDOWS and not any(rel in x for x in l):
                    l.append("script de Windows: %s" % rel)
                try:
                    texto = f.read_text(encoding="utf-8", errors="replace")
                except OSError:
                    continue
                vistas = sorted({m.group(0) for m in PAT_AFUERA.finditer(texto)})
                if vistas:
                    l.append("ruta fuera del repo: %s (%s)" % (rel, ", ".join(vistas[:3])))
            if (d / ".git").exists():
                l += ["hook local de git: %s (no corre en la nube ni con un pull)" % h for h in hooks_locales(d)]
        out[nombre] = l
    hl = hooks_locales(raiz)
    if hl:
        out["(claude-acceso)"] = ["hook local de git: %s (no corre en la nube ni con un pull)" % h for h in hl]
    return out


def resumen_limites(l, ejemplos=2):
    """Una linea corta por proyecto: la capa rapida sale en el arranque, y un hook se corta a 10 000 caracteres
    (DA-015). Por clase: cuantos y los primeros ejemplos; el detalle, con --limites."""
    clases = {}
    for x in l:
        c, _, resto = x.partition(": ")
        clases.setdefault(c, []).append(resto)
    partes = []
    for c, xs in clases.items():
        ej = ", ".join((x.split(" (")[0] if c == "ruta fuera del repo" else x.split(": ")[0]) for x in xs[:ejemplos])
        partes.append("%d %s (%s%s)" % (len(xs), c, ej, ", ..." if len(xs) > ejemplos else ""))
    return "; ".join(partes)


# ------------------------------------------------------------------------------------------- compilar (DA-099)
# Lo que el simulacro no medía: si en la nube se puede COMPILAR lo de cada proyecto documental. Se compila cada entrada
# dos veces -- en el arbol de la PC y en el clon armado desde GitHub, ahi con --ignore-system-fonts y el perfil del
# HOME falso -- y es ROJO lo que compila en la PC y no en la nube (un archivo que no viaja, un paquete que no se
# instala) o lo que en la nube pierde una tipografia. Lo que no compila ni en la PC no es de la nube: se informa aparte.
PAT_TYPST = re.compile(r"typst(?:\.exe)?[\"']?\s+(?:c|compile)\s+(?P<args>[^\r\n|;&]*)")
PAT_TYP_LITERAL = re.compile(r"[\"']([^\"'\s$%]+\.typ)[\"']")
PAT_FUENTE_FALTA = re.compile(r"unknown font family: (\S+)")


PAT_CD = re.compile(r"^\s*(?:cd(?:\s+/d)?|pushd|Push-Location|Set-Location)\s+[\"']?([^\"'\r\n;&]+?)[\"']?\s*(?:$|;|&&)",
                    re.I | re.M)
PAT_INPUT = re.compile(r"--input\s+[\"']?([A-Za-z0-9_-]+)=([^\s\"'$%]+)")


def _dir_de_cd(base: Path, script: Path, destino: str):
    d = destino.strip().replace("%~dp0", "").replace("\\", "/")
    if d.startswith("$") or "%" in d:                  # $aqui, $PSScriptRoot: el dir del script
        return script.parent
    return (script.parent / d).resolve() if not Path(d).is_absolute() else base


def entradas_compilado(raiz: Path, proyecto_dir: Path):
    """[(entrada, root, inputs)] de lo que el proyecto compila, con rutas absolutas. Dos fuentes: los compiladores
    envueltos (compilar.*: cada 'typst compile', desde el dir al que el script hizo cd; si la entrada es una variable,
    cada '*.typ' literal del script) y cada X.typ con su X.pdf al lado en el arbol de la PC (raiz: el proyecto). Los
    --input literales se toman del script o de cualquier texto del proyecto que compile esa entrada (apunte-tdc.typ
    exige --input materia=tdc). Devuelve tambien los scripts que no se pudieron leer."""
    out, ilegibles = [], []
    for s in _archivos(proyecto_dir, SCRIPTS):
        if not s.stem.lower().startswith("compilar"):
            continue
        texto = s.read_text(encoding="utf-8", errors="replace")
        for m in PAT_TYPST.finditer(texto):
            cwd = s.parent
            for c in PAT_CD.finditer(texto[:m.start()]):
                cwd = _dir_de_cd(raiz, s, c.group(1))
            toks = [t.strip("\"'") for t in m.group("args").split()]
            root = None
            if "--root" in toks and toks.index("--root") + 1 < len(toks):
                r = toks[toks.index("--root") + 1]
                root = None if ("$" in r or "%" in r) else (cwd / r.replace("\\", "/")).resolve()
            ins = dict(PAT_INPUT.findall(m.group(0)))
            libres = [t for t in toks if t.endswith(".typ") and "$" not in t and "%" not in t]
            if not libres:
                libres = PAT_TYP_LITERAL.findall(texto)
            if not libres:
                ilegibles.append(s)
            for t in libres:
                out.append([(cwd / t.replace("\\", "/")).resolve(), root, ins])
    for f in _archivos(proyecto_dir, (".typ",)):
        if f.with_suffix(".pdf").exists() and all(f.resolve() != e for e, _, _ in out):
            out.append([f.resolve(), proyecto_dir.resolve(), {}])
    textos = [t.read_text(encoding="utf-8", errors="replace") for t in _archivos(proyecto_dir, (".md",) + SCRIPTS)]
    vistos, unicas = set(), []
    for e, r, ins in out:
        if not ins:
            for t in textos:
                for m in PAT_TYPST.finditer(t):
                    if e.name in m.group(0) and PAT_INPUT.search(m.group(0)):
                        ins = dict(PAT_INPUT.findall(m.group(0)))
                        break
                if ins:
                    break
        clave = (e, r, tuple(sorted(ins.items())))
        if clave not in vistos:
            vistos.add(clave)
            unicas.append((e, r, ins))
    return unicas, ilegibles


COMPILAR = r"""
import json, shutil, subprocess, sys
entrada, root, salida, ignorar, cache = sys.argv[1], sys.argv[2] or None, sys.argv[3], sys.argv[4] == "1", sys.argv[5] or None
inputs = json.loads(sys.argv[6])
avisos, error = [], None
if shutil.which("typst"):
    cmd = ["typst", "compile", entrada, salida] + (["--root", root] if root else []) + (["--ignore-system-fonts"] if ignorar else []) + (["--package-cache-path", cache] if cache else [])
    for k, v in inputs.items():
        cmd += ["--input", "%s=%s" % (k, v)]
    r = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace")
    error = None if r.returncode == 0 else (r.stderr.strip() or "typst salio %d" % r.returncode)
    avisos = [l for l in r.stderr.splitlines() if l.startswith("warning")]
else:
    try:
        import typst
    except ImportError:
        print(json.dumps({"error": "SIN TYPST: no hay typst en el PATH ni el modulo de python", "avisos": []})); sys.exit(0)
    try:
        kw = dict(root=root, ignore_system_fonts=ignorar, sys_inputs=inputs)
        if cache: kw["package_cache_path"] = cache
        _, w = typst.compile_with_warnings(entrada, output=salida, **kw)
        avisos = [str(x.message) if hasattr(x, "message") else str(x) for x in (w or [])]
    except Exception as e:
        error = str(e)
print(json.dumps({"error": error, "avisos": avisos}))
"""


def compilar(entrada: Path, root, env: dict, ignorar_fuentes: bool, tmp: Path, inputs=None) -> dict:
    drv = tmp / "compilar.py"
    if not drv.exists():
        drv.write_text(COMPILAR, encoding="utf-8")
    salida = tmp / ("out-%d.pdf" % (len(list(tmp.glob("out-*.pdf"))) + 1))
    cache = env.get("TYPST_CACHE_DIR") or (str(Path(env["HOME"]) / ".cache" / "typst" / "packages") if env.get("HOME") else "")
    r = subprocess.run([sys.executable, str(drv), str(entrada), str(root or ""), str(salida),
                        "1" if ignorar_fuentes else "0", cache if ignorar_fuentes else "", json.dumps(inputs or {})],
                       env=env, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=600)
    try:
        return json.loads(r.stdout.strip().splitlines()[-1])
    except Exception:
        return {"error": "el compilador REVENTO: " + ((r.stderr or "?").strip().splitlines() or ["?"])[-1][:200], "avisos": []}


def comparar_compilados(arbol_pc: Path, arbol_nube: Path, proyectos, env_nube: dict, tmp: Path):
    """(rojos, avisos, cuenta): por cada entrada de cada proyecto, compila en la PC y en la nube y compara."""
    rojos, avisos, n = [], [], 0
    for nombre in proyectos:
        d_pc = carpeta_proyecto(nombre, arbol_pc)
        if d_pc is None:
            continue
        entradas, ilegibles = entradas_compilado(arbol_pc, d_pc)
        for s in ilegibles:
            rojos.append("%s: %s compila algo que no se puede leer del script: no se puede simular" % (nombre, s.name))
        for e, root, ins in entradas:
            rel = e.relative_to(arbol_pc.resolve()) if e.is_relative_to(arbol_pc.resolve()) else e
            e_nube = arbol_nube / rel
            r_nube = (arbol_nube / root.relative_to(arbol_pc.resolve())) if root else None
            pc = compilar(e, root, dict(os.environ), False, tmp, ins)
            if pc["error"] and pc["error"].startswith("SIN TYPST"):
                return [pc["error"] + ": el simulacro no puede medir si la nube compila"], avisos, n
            n += 1
            if pc["error"]:
                avisos.append("%s: %s no compila ni en este arbol (%s)" % (nombre, rel, pc["error"].splitlines()[0][:120]))
                continue
            if not e_nube.exists():
                rojos.append("%s: %s no esta en el clon de GitHub (no viaja)" % (nombre, rel))
                continue
            nu = compilar(e_nube, r_nube, env_nube, True, tmp, ins)
            if nu["error"]:
                primera = nu["error"].splitlines()[0][:200]
                m = re.search(r"searched at ([^)]+)\)", primera)
                falta = Path(m.group(1)) if m else None
                if falta and falta.is_relative_to(arbol_nube.resolve()):
                    rel_f = falta.relative_to(arbol_nube.resolve())
                    if subprocess.run(["git", "-C", str(arbol_pc), "check-ignore", "-q", str(rel_f)], capture_output=True).returncode == 0:
                        # Lo que .gitignore deja afuera no viaja por diseno (recortes de la guia de la catedra, PDF
                        # ajenos): es un limite declarado, no una divergencia. Se dice, con el archivo.
                        avisos.append("%s: %s no compila en la nube: %s esta en .gitignore (limite declarado)"
                                      % (nombre, rel, rel_f.as_posix()))
                        continue
                rojos.append("%s: %s compila aca y NO en la nube: %s" % (nombre, rel, primera))
                continue
            f_pc = set(PAT_FUENTE_FALTA.findall(" ".join(pc["avisos"])))
            f_nu = set(PAT_FUENTE_FALTA.findall(" ".join(nu["avisos"]))) - f_pc
            if f_nu:
                rojos.append("%s: %s en la nube pierde la tipografia %s (sale con otra)" % (nombre, rel, ", ".join(sorted(f_nu))))
    return rojos, avisos, n


# ------------------------------------------------------------------------------------------- el simulacro
def _borrar(d):
    def quitar_solo_lectura(func, path, _):
        os.chmod(path, stat.S_IWRITE)
        func(path)
    shutil.rmtree(d, onerror=quitar_solo_lectura)


def _clonar_desde_github(origen: Path, destino: Path):
    """Clona el repo LOCAL pero deja el arbol en lo que GitHub tiene (origin/<rama>): lo no pusheado no viaja."""
    rc, ref = git(origen, "rev-parse", "--abbrev-ref", "@{u}")
    if rc != 0:
        return "sin upstream"
    rc, sha = git(origen, "rev-parse", ref)
    subprocess.run(["git", "clone", "-q", "--no-checkout", str(origen), str(destino)], capture_output=True)
    rc, _ = git(destino, "checkout", "-q", sha)
    return None if rc == 0 else "no se pudo sacar %s" % ref


DRIVER = r"""
import importlib.util, json, sys
s = importlib.util.spec_from_file_location("puerta", sys.argv[1]); m = importlib.util.module_from_spec(s)
s.loader.exec_module(m)
cat = m.cargar_catalogo(); disco = m.proyectos_del_disco(); out = {}
for p in cat.get("proyectos", {}):
    if p not in disco:
        out[p] = ["la carpeta del proyecto no esta en el clon"]; continue
    rojos = []
    for n in list(cat.get("necesidades", {})) + ["ninguna"]:
        _, _, notas = m.exigido(cat, p, [n], [])
        for x in notas:
            if x.startswith("NO EXISTE"):
                ruta = x[len("NO EXISTE: "):].split(" (")[0].replace(str(m.RAIZ.parent), "<nube>").replace("\\", "/")
                if "[%s] %s" % (n, ruta) not in rojos:
                    rojos.append("[%s] %s" % (n, ruta))
    out[p] = rojos
print(json.dumps(out))
"""


PAT_INCLUYE = re.compile(r"#(?:include|import)\s+\"([^\"@][^\"]*)\"")


def documentales(raiz=RAIZ):
    cat = json.loads((raiz / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    return [p for p in cat.get("proyectos", {}) if (raiz / "proyectos" / "documentos" / p).is_dir()]


def primer_incluido(entrada: Path):
    """El primer archivo que la entrada incluye o importa por ruta: lo que el saboteador borra del clon."""
    for m in PAT_INCLUYE.finditer(entrada.read_text(encoding="utf-8", errors="replace")):
        f = (entrada.parent / m.group(1)).resolve()
        if f.is_file():
            return f
    return None


def simular(raiz=RAIZ, sabotear_memoria=False, compilar_docs=False, sabotear_compilado=False):
    """({proyecto: [rojos]}, [rojos del armado], compilados) de lo que una sesion NUEVA de la nube veria.
    compilados = (rojos, avisos, cuantos) de comparar_compilados, o None si no se pidio. sabotear_compilado borra del
    clon el primer archivo que incluye la primera entrada de un compilado: el simulacro TIENE que dar rojo por eso."""
    tmp = Path(tempfile.mkdtemp(prefix="nube-"))
    armado = []
    try:
        clon, perfil, home = tmp / "claude-acceso", tmp / "perfil-global", tmp / "home"
        e = _clonar_desde_github(raiz, clon)
        if e:
            return {}, ["claude-acceso: " + e], None
        e = _clonar_desde_github(perfil_dir(raiz), perfil)
        if e:
            armado.append("perfil-global: " + e)
        for rel, _url in repos_propios(raiz):
            if (raiz / rel / ".git").exists():
                e = _clonar_desde_github(raiz / rel, clon / rel)
                if e:
                    armado.append("%s: %s" % (rel, e))
            else:
                armado.append("%s: no esta clonado en la PC, no se puede simular" % rel)
        env = dict(os.environ, HOME=str(home), USERPROFILE=str(home), PERFIL_DIR=str(perfil),
                   CLAUDE_HOME_DIR=str(home / ".claude"), PYTHONUTF8="1")
        bash = shutil.which("bash") if os.name != "nt" else str(Path(os.environ.get("ProgramFiles", r"C:\Program Files")) / "Git" / "bin" / "bash.exe")
        r = subprocess.run([bash, ".claude/nube/traer-perfil.sh"], cwd=clon, env=env, capture_output=True,
                           text=True, encoding="utf-8", errors="replace")
        if "[OK]" not in r.stdout:
            armado.append("traer-perfil.sh no dio OK: " + (r.stdout + r.stderr).strip().splitlines()[0][:150])
        if sabotear_memoria:
            for d in (home / ".claude" / "projects").glob("*/memory"):
                _borrar(d)
        drv = tmp / "driver.py"
        drv.write_text(DRIVER, encoding="utf-8")
        r = subprocess.run([sys.executable, str(drv), str(clon / ".claude" / "hooks" / "cascada_puerta.py")],
                           env=env, capture_output=True, text=True, encoding="utf-8", errors="replace")
        try:
            res = json.loads(r.stdout.strip().splitlines()[-1])
        except Exception:
            return {}, armado + ["la puerta del clon REVENTO: " + (r.stderr.strip().splitlines() or ["?"])[-1][:200]], None
        comp = None
        if compilar_docs:
            docs = documentales(raiz)
            if sabotear_compilado:
                borrado = None
                for p in docs:
                    for e, _r, _i in entradas_compilado(raiz, carpeta_proyecto(p, raiz))[0]:
                        inc = primer_incluido(e)
                        if inc and inc.is_relative_to(raiz.resolve()):
                            borrado = inc.relative_to(raiz.resolve())
                            break
                    if borrado:
                        break
                if borrado is None:
                    return res, armado + ["sabotaje: ningun compilado incluye un archivo que se pueda borrar"], None
                (clon / borrado).unlink()
                armado_sab = "sabotaje: borrado del clon %s" % borrado.as_posix()
            comp_tmp = tmp / "compilados"
            comp_tmp.mkdir()
            comp = comparar_compilados(raiz, clon, docs, env, comp_tmp)
            if sabotear_compilado:
                comp = (comp[0], comp[1] + [armado_sab], comp[2])
        return res, armado, comp
    finally:
        _borrar(tmp)


# ------------------------------------------------------------------------------------------- en la nube
def traer(proyecto: str, raiz=RAIZ):
    for rel, url in repos_propios(raiz):
        if Path(rel).name == proyecto:
            destino = raiz / rel
            if (destino / ".git").exists():
                git(destino, "pull", "-q", "--ff-only")
                print("[OK] %s ya estaba clonado; actualizado" % rel)
                return 0
            r = subprocess.run(["git", "clone", "-q", url, str(destino)], capture_output=True, text=True)
            if r.returncode != 0 or not (destino / ".git").exists():
                print("[ROJO] no se pudo clonar %s (repo PRIVADO). Primero:" % url)
                print("  herramienta add_repo: owner %s, repo %s, access push" % (CUENTA, url.rstrip("/").split("/")[-1].removesuffix(".git")))
                print("  y volver a correr: python3 .claude/nube/estado-nube.py --traer %s" % proyecto)
                return 1
            print("[OK] %s clonado en %s. Ahora: bash .claude/cascada.sh %s -Necesidad <a,b>" % (url, rel, proyecto))
            return 0
    print("[OK] %s vive en claude-acceso: ya esta en el clon, no hay que traer nada" % proyecto)
    return 0


# ------------------------------------------------------------------------------------------- informe
def capa_rapida(raiz=RAIZ):
    rojos = 0
    print("LISTO PARA LA NUBE -- lo que una sesion nueva en la nube recibe de lo que hay en esta PC")
    propios = repos_propios(raiz)
    if not propios:
        # Fail cerrado: una tabla que no parsea daria "todo OK" mirando solo dos repos.
        print("  [ROJO] MAPA.md seccion 2 no dio ningun repo propio: no se puede medir lo que no se lista")
        rojos += 1
    repos = [("claude-acceso", raiz), ("perfil-global", perfil_dir(raiz))] + [(rel, raiz / rel) for rel, _ in propios]
    for nombre, path in repos:
        p = problemas_repo(path)
        rojos += len(p)
        print("  [%s] %s%s" % ("ROJO" if p else " OK ", nombre, (" -- " + "; ".join(p)) if p else ""))
    pm = problemas_memoria(memoria_local(raiz), perfil_dir(raiz) / "memoria",
                           en_la_pc=(raiz / "perfil-global" / ".git").exists())
    rojos += len(pm)
    print("  [%s] memoria de Fran en perfil-global/memoria%s" % ("ROJO" if pm else " OK ", (" -- " + "; ".join(pm)) if pm else ""))
    if pm:
        print("        arreglo: python .claude/nube/estado-nube.py --sincronizar-memoria, y commit + push de perfil-global")
    print("  Limites de la nube, declarados (no son rojo): sin PowerShell, sin Drive/rclone, sin lo que esta en .gitignore.")
    for p, l in limites(raiz).items():
        if l:
            print("    %s: %s" % (p, resumen_limites(l)))
    print("Listo para la nube." if rojos == 0 else "%d rojo(s): la nube arrancaria con algo viejo o sin algo." % rojos)
    return 1 if rojos else 0


def informe_simulacro(raiz=RAIZ):
    print("SIMULACRO DE LA NUBE -- clones desde GitHub (origin/*), perfil instalado por traer-perfil.sh en un HOME falso")
    res, armado, comp = simular(raiz, compilar_docs=True)
    for a in armado:
        print("  [ROJO] armado: %s" % a)
    # Agrupado por lo que FALTA: el mismo archivo ausente frena a muchos proyectos, y listarlo por proyecto
    # escondia todo detras de un '... y 45 mas'.
    faltas = {}
    for p, l in res.items():
        for x in l:
            n, _, ruta = x.partition("] ")
            f = faltas.setdefault(ruta or x, [set(), set()])
            f[0].add(p); f[1].add(n.lstrip("["))
    sanos = [p for p, l in res.items() if not l]
    print("  [ OK ] %d de %d proyectos: la puerta encuentra todo lo que exige, para toda necesidad" % (len(sanos), len(res)))
    for ruta, (ps, ns) in sorted(faltas.items(), key=lambda kv: -len(kv[1][0])):
        print("  [ROJO] falta %s" % ruta)
        print("         salta al declarar: %s -- en %s" % (", ".join(sorted(ns)), ", ".join(sorted(ps)) if len(ps) <= 4 else "%d proyectos" % len(ps)))
    rojos = len(armado) + len(faltas)
    if not res:
        print("  [ROJO] el simulacro no devolvio ningun proyecto: no midio nada")
        rojos += 1
    # DA-099: que la puerta encuentre sus lecturas no dice que se pueda COMPILAR. Se compila cada entrada de cada
    # proyecto documental aca y en el clon (--ignore-system-fonts), y rojo lo que diverge.
    c_rojos, c_avisos, c_n = comp if comp else (["el simulacro no compilo nada (sin resultado)"], [], 0)
    if c_n == 0 and not c_rojos:
        c_rojos = ["ningun compilado encontrado en los proyectos documentales: no se midio si la nube compila"]
    print("  [%s] compilar: %d entrada(s) de los proyectos documentales, aca y en el clon con --ignore-system-fonts"
          % ("ROJO" if c_rojos else " OK ", c_n))
    for x in c_rojos:
        print("  [ROJO] compilar: %s" % x)
    for x in c_avisos:
        print("  [aviso] compilar: %s" % x)
    rojos += len(c_rojos)
    print("  Limites que el simulacro no compila (solo de la PC, no son rojo): `python .claude/nube/estado-nube.py` los lista")
    print(("La nube puede seguir los %d proyectos: la puerta encuentra lo que exige y compila lo mismo que aca (%d entradas)."
           % (len(res), c_n)) if rojos == 0 else "%d rojo(s) en el simulacro." % rojos)
    return 1 if rojos else 0


# ------------------------------------------------------------------------------------------- saboteador
def probar():
    malos = 0

    def caso(ok, que):
        nonlocal malos
        print("%s  %s" % ("ok " if ok else "MAL", que))
        malos += 0 if ok else 1

    tmp = Path(tempfile.mkdtemp(prefix="probar-nube-"))
    try:
        remoto, w = tmp / "remoto.git", tmp / "w"
        subprocess.run(["git", "init", "-q", "--bare", str(remoto)], capture_output=True)
        subprocess.run(["git", "clone", "-q", str(remoto), str(w)], capture_output=True)
        for k, v in (("user.email", "p@p"), ("user.name", "p")):
            git(w, "config", k, v)
        (w / "a.md").write_text("a\n", encoding="utf-8")
        git(w, "add", "a.md"); git(w, "commit", "-q", "-m", "a"); git(w, "push", "-q", "-u", "origin", "HEAD")
        caso(problemas_repo(w) == [], "control positivo: repo limpio y pusheado -> sin problemas")
        (w / "a.md").write_text("b\n", encoding="utf-8")
        caso(any("sin commitear" in x for x in problemas_repo(w)), "archivo modificado -> rojo 'sin commitear'")
        git(w, "commit", "-q", "-am", "b")
        caso(any("sin pushear" in x for x in problemas_repo(w)), "commit sin pushear -> rojo 'sin pushear'")
        git(w, "checkout", "-q", "-b", "suelta")
        caso(any("sin upstream" in x for x in problemas_repo(w)), "rama sin upstream -> rojo")
        git(w, "remote", "remove", "origin")
        p = problemas_repo(w)
        caso(any("no tiene remote" in x for x in p), "repo sin remote -> rojo que lo dice (llego: %s)" % p)
        loc, esp = tmp / "loc", tmp / "esp"
        loc.mkdir(); (loc / "x.md").write_text("x", encoding="utf-8")
        caso(any("sin espejo" in x for x in problemas_memoria(loc, esp)), "memoria sin espejo -> rojo")
        sincronizar_memoria(loc, esp)
        caso(problemas_memoria(loc, esp) == [], "control positivo: espejo sincronizado -> sin problemas")
        (loc / "z.md").write_bytes(b"a\nb\n"); (esp / "z.md").write_bytes(b"a\r\nb\r\n")
        caso(problemas_memoria(loc, esp) == [], "control positivo: el espejo en CRLF (git autocrlf) no es un cambio")
        (loc / "z.md").unlink(); (esp / "z.md").unlink()
        (loc / "x.md").write_text("y", encoding="utf-8")
        caso(any("cambiadas" in x for x in problemas_memoria(loc, esp)), "memoria cambiada en la PC -> rojo")
        (loc / "x.md").unlink()
        caso(any("ya borro" in x for x in problemas_memoria(loc, esp)), "memoria borrada en la PC -> rojo")
        caso(any("no encuentro" in x for x in problemas_memoria(tmp / "nada", esp)), "sin memoria en la PC -> rojo, no silencio")
        caso(problemas_memoria(tmp / "nada", esp, en_la_pc=False) == [], "control positivo: en la nube no hay memoria de la PC que medir")
        (tmp / "MAPA.md").write_text("# m\n\n## 2. Quien es dueno\n\nsin tabla\n\n## 3. x\n", encoding="utf-8")
        caso(repos_propios(tmp) == [], "MAPA sin tabla -> ningun repo (y capa_rapida lo da rojo)")
        caso(len(repos_propios()) >= 1, "control positivo: el MAPA real da %d repos propios" % len(repos_propios()))
    finally:
        _borrar(tmp)
    # El simulacro sobre el arbol REAL: sin memoria instalada, 'materia' tiene que caer en NO EXISTE (el hallazgo
    # que hizo nacer esto); con ella, ninguno de esos. Las dos mitades: el rojo y que el rojo sea por la memoria.
    con, _, comp_sano = simular(compilar_docs=True)
    sin, _, comp_sab = simular(sabotear_memoria=True, compilar_docs=True, sabotear_compilado=True)
    de_memoria = lambda res: [x for l in res.values() for x in l if "/memory/" in x]
    caso(len(de_memoria(sin)) > 0, "simulacro sin la memoria -> la puerta pide memorias que NO EXISTEN (%d)" % len(de_memoria(sin)))
    caso(len(de_memoria(con)) == 0, "simulacro con la memoria -> ninguna memoria falta (%d)" % len(de_memoria(con)))
    # DA-099, sobre el arbol REAL: lo sano compila igual en la nube; borrar del clon un archivo que un compilado incluye
    # tiene que dar rojo, y por ESE archivo (la mitad que dice que el rojo es por lo que se rompio).
    r_sano, a_sano, n_sano = comp_sano or (["sin resultado"], [], 0)
    caso(n_sano > 0 and r_sano == [], "control positivo DA-099: lo sano compila aca y en la nube (%d entradas, rojos: %s)"
         % (n_sano, r_sano[:2]))
    r_sab, a_sab, _ = comp_sab or (["sin resultado"], [], 0)
    borrado = next((x.split("borrado del clon ")[1] for x in a_sab if "borrado del clon" in x), None)
    caso(borrado is not None and any(Path(borrado).name in x and "NO en la nube" in x for x in r_sab),
         "sabotaje DA-099: falta en el clon un archivo que un compilado necesita (%s) -> rojo que lo nombra (%s)"
         % (borrado, r_sab[:1]))
    caso(probar_memoria() == 0, "DA-101: --probar-memoria en verde (lo de afuera no se borra ni se pisa)")
    caso(probar_compilados() == 0, "DA-099: --probar-compilados en verde (lectura de compilados y limites)")
    print("TODO BIEN" if malos == 0 else "%d caso(s) MAL" % malos)
    return 1 if malos else 0


def probar_compilados():
    """DA-099 sin el arbol real: un proyecto sintetico con su compilar.bat. Mas barato que --probar; corre solo."""
    malos = 0

    def caso(ok, que):
        nonlocal malos
        print("%s  %s" % ("ok " if ok else "MAL", que))
        malos += 0 if ok else 1

    tmp = Path(tempfile.mkdtemp(prefix="probar-compilar-"))
    try:
        def arbol(nombre, con_parte=True, fuente=None):
            d = tmp / nombre / "proyectos" / "documentos" / "demo"
            d.mkdir(parents=True)
            (d / "compilar.bat").write_text("@echo off\r\ncopy \"%USERPROFILE%\\Downloads\\guia.pdf\" .\r\ntypst compile doc.typ doc.pdf\r\n", encoding="utf-8")
            pre = '#set text(font: "%s")\n' % fuente if fuente else ""
            (d / "doc.typ").write_text(pre + '= Demo\n#include "parte.typ"\n', encoding="utf-8")
            if con_parte:
                (d / "parte.typ").write_text("Texto de la parte.\n", encoding="utf-8")
            (tmp / nombre / ".claude").mkdir()
            (tmp / nombre / ".claude" / "cascada.json").write_text(json.dumps({"proyectos": {"demo": {}}}), encoding="utf-8")
            return tmp / nombre
        pc, nube_ok, nube_mal = arbol("pc"), arbol("nube-ok"), arbol("nube-mal", con_parte=False)
        env = dict(os.environ, HOME=str(tmp / "home"))
        ent, ileg = entradas_compilado(pc, pc / "proyectos" / "documentos" / "demo")
        caso([e.name for e, _, _ in ent] == ["doc.typ"] and not ileg, "lee la entrada del compilar.bat: %s" % [e.name for e, _, _ in ent])
        (tmp / "t1").mkdir(); (tmp / "t2").mkdir()
        r, a, n = comparar_compilados(pc, nube_ok, ["demo"], env, tmp / "t1")
        caso(n == 1 and r == [], "control positivo: lo mismo en la PC y en la nube -> verde (rojos: %s, avisos: %s)" % (r, a))
        r, a, n = comparar_compilados(pc, nube_mal, ["demo"], env, tmp / "t2")
        caso(any("parte.typ" in x and "NO en la nube" in x for x in r), "sabotaje: falta parte.typ en la nube -> rojo que lo nombra (%s)" % r[:1])
        lim = limites(pc).get("demo", [])
        caso(any("script de Windows: compilar.bat" in x for x in lim) and any("ruta fuera del repo" in x and "Downloads" in x for x in lim),
             "limites ve el .bat y la fuente fuera del repo: %s" % lim)
        (pc / ".git" / "hooks").mkdir(parents=True)
        (pc / ".git" / "hooks" / "post-commit").write_text("#!/bin/sh\n", encoding="utf-8")
        (pc / ".git" / "hooks" / "pre-commit.sample").write_text("#!/bin/sh\n", encoding="utf-8")
        hl = limites(pc).get("(claude-acceso)", [])
        caso(len(hl) == 1 and "post-commit" in hl[0], "limites ve el hook local de git y no el .sample: %s" % hl)
    finally:
        _borrar(tmp)
    print("TODO BIEN" if malos == 0 else "%d caso(s) MAL" % malos)
    return 1 if malos else 0



if __name__ == "__main__":
    a = sys.argv[1:]
    if a[:1] == ["--probar"]:
        sys.exit(probar())
    if a[:1] == ["--probar-compilados"]:
        sys.exit(probar_compilados())
    if a[:1] == ["--sabotaje"]:
        # Mutantes de lo que mide la nube (DA-099 y DA-101): cada uno tiene que poner en ROJO la prueba que lo mira.
        # Sale 0 si TODOS se ven. Rapido: corre --probar-compilados y --probar-memoria, no el simulacro entero.
        fuente = Path(__file__).read_text(encoding="utf-8")
        mutantes = [
            ("DA-099: la nube no compila (el simulacro viejo)", "            if nu[\"error\"]:\n                primera",
             "            if False:\n                primera", "--probar-compilados"),
            # armados por partes: si el texto estuviera literal aca, apareceria dos veces en la fuente
            ("DA-099: limites() sin los scripts de Windows", "if f.suffix.lower() in SCRIPTS_" + "WINDOWS and not any",
             "if False and not any", "--probar-compilados"),
            ("DA-101: sincronizar borra lo que la PC nunca tuvo", "MUTANTE_DA101 = " + "False    #",
             "MUTANTE_DA101 = " + "True    #", "--probar-memoria"),
        ]
        vistos = 0
        for nombre, viejo, nuevo, prueba in mutantes:
            if fuente.count(viejo) != 1:
                print("  [FALLA] no pude armar el mutante '%s' (el texto cambio)" % nombre)
                continue
            m = Path(tempfile.mkdtemp(prefix="mutante-nube-")) / "estado-nube.py"
            m.write_text(fuente.replace(viejo, nuevo), encoding="utf-8")
            r = subprocess.run([sys.executable, str(m), prueba], capture_output=True, text=True, cwd=str(RAIZ),
                               env=dict(os.environ, ESTADO_NUBE_RAIZ=str(RAIZ)))
            visto = r.returncode != 0
            vistos += visto
            print("  mutante '%s': %s" % (nombre, "DETECTADO (%s en rojo)" % prueba if visto else "NO detectado"))
            _borrar(m.parent)
        print("sabotaje DETECTADO: %d de %d" % (vistos, len(mutantes)) if vistos == len(mutantes)
              else "sabotaje NO detectado: %d de %d" % (vistos, len(mutantes)))
        sys.exit(0 if vistos == len(mutantes) else 1)
    if a[:1] == ["--simular"]:
        sys.exit(informe_simulacro())
    if a[:1] == ["--sincronizar-memoria"]:
        n, rojos = sincronizar_memoria(memoria_local(), perfil_dir() / "memoria")
        if rojos:
            for x in rojos:
                print("  [ROJO] %s" % x)
            print("No se sincronizo NADA (DA-101). Traer a la memoria de la PC lo escrito afuera (o, si se quiere tirar, "
                  "borrarlo a mano del espejo con git rm), y volver a correr.")
            sys.exit(1)
        print("%d memoria(s) copiadas a %s. Falta: commit + push de perfil-global (incluido %s)."
              % (n, perfil_dir() / "memoria", MANIFIESTO))
        sys.exit(0)
    if a[:1] == ["--probar-memoria"]:
        sys.exit(probar_memoria())
    if a[:1] == ["--limites"]:
        for p, l in limites().items():
            for x in l:
                print("%s: %s" % (p, x))
        sys.exit(0)
    if a[:1] == ["--traer"] and len(a) == 2:
        sys.exit(traer(a[1]))
    if a:
        print(__doc__)
        sys.exit(2)
    sys.exit(capa_rapida())
