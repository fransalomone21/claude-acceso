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
  python .claude/nube/estado-nube.py --probar              el saboteador
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

RAIZ = Path(__file__).resolve().parents[2]
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
    rc, adelante = git(path, "rev-list", "--count", "@{u}..HEAD")
    if rc != 0:
        p.append("la rama no sigue a ninguna de GitHub (sin upstream): nada de esto se pushea")
    elif adelante != "0":
        p.append("%s commit(s) sin pushear" % adelante)
    return p


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
    a, b = md5s(local), md5s(espejo)
    p = []
    faltan = sorted(set(a) - set(b))
    sobran = sorted(set(b) - set(a))
    distintos = sorted(k for k in set(a) & set(b) if a[k] != b[k])
    if faltan:
        p.append("%d memoria(s) de la PC sin espejo (%s)" % (len(faltan), ", ".join(faltan[:3])))
    if distintos:
        p.append("%d memoria(s) cambiadas en la PC (%s)" % (len(distintos), ", ".join(distintos[:3])))
    if sobran:
        p.append("%d memoria(s) en el espejo que la PC ya borro (%s)" % (len(sobran), ", ".join(sobran[:3])))
    return p


def sincronizar_memoria(local: Path, espejo: Path):
    espejo.mkdir(parents=True, exist_ok=True)
    a = md5s(local)
    for f in espejo.glob("*.md"):
        if f.name not in a:
            f.unlink()
    for nombre in a:
        shutil.copyfile(local / nombre, espejo / nombre)
    return len(a)


# ------------------------------------------------------------------------------------------- 3. limites
def limites(raiz=RAIZ):
    """{proyecto: [lo que es solo de la PC]}. Informativo."""
    cat = json.loads((raiz / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    out = {}
    for nombre, e in cat.get("proyectos", {}).items():
        l = ["comando de PowerShell: %s" % c for c in e.get("comandos", []) if c.endswith(".ps1")]
        out[nombre] = l
    return out


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


def simular(raiz=RAIZ, sabotear_memoria=False):
    """{proyecto: [rojos]} de lo que una sesion NUEVA de la nube veria, mas una lista de rojos del armado."""
    tmp = Path(tempfile.mkdtemp(prefix="nube-"))
    armado = []
    try:
        clon, perfil, home = tmp / "claude-acceso", tmp / "perfil-global", tmp / "home"
        e = _clonar_desde_github(raiz, clon)
        if e:
            return {}, ["claude-acceso: " + e]
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
            return {}, armado + ["la puerta del clon REVENTO: " + (r.stderr.strip().splitlines() or ["?"])[-1][:200]]
        return res, armado
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
            print("    %s: %s" % (p, "; ".join(l)))
    print("Listo para la nube." if rojos == 0 else "%d rojo(s): la nube arrancaria con algo viejo o sin algo." % rojos)
    return 1 if rojos else 0


def informe_simulacro(raiz=RAIZ):
    print("SIMULACRO DE LA NUBE -- clones desde GitHub (origin/*), perfil instalado por traer-perfil.sh en un HOME falso")
    res, armado = simular(raiz)
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
    print("La nube puede seguir los %d proyectos." % len(res) if rojos == 0 else "%d rojo(s) en el simulacro." % rojos)
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
    con, _ = simular()
    sin, _ = simular(sabotear_memoria=True)
    de_memoria = lambda res: [x for l in res.values() for x in l if "/memory/" in x]
    caso(len(de_memoria(sin)) > 0, "simulacro sin la memoria -> la puerta pide memorias que NO EXISTEN (%d)" % len(de_memoria(sin)))
    caso(len(de_memoria(con)) == 0, "simulacro con la memoria -> ninguna memoria falta (%d)" % len(de_memoria(con)))
    print("TODO BIEN" if malos == 0 else "%d caso(s) MAL" % malos)
    return 1 if malos else 0


if __name__ == "__main__":
    a = sys.argv[1:]
    if a[:1] == ["--probar"]:
        sys.exit(probar())
    if a[:1] == ["--simular"]:
        sys.exit(informe_simulacro())
    if a[:1] == ["--sincronizar-memoria"]:
        n = sincronizar_memoria(memoria_local(), perfil_dir() / "memoria")
        print("%d memoria(s) copiadas a %s. Falta: commit + push de perfil-global." % (n, perfil_dir() / "memoria"))
        sys.exit(0)
    if a[:1] == ["--traer"] and len(a) == 2:
        sys.exit(traer(a[1]))
    if a:
        print(__doc__)
        sys.exit(2)
    sys.exit(capa_rapida())
