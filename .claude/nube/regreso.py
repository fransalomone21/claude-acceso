#!/usr/bin/env python3
"""regreso.py -- lo que una sesion en la nube hizo vuelve a la PC, y se MIDE que no quede nada divergente (DA-105).

Fran, 2026-11-05: «que la proxima sesion local traiga todo de vuelta por si hace falta sincronizar o procesar nuevos
hallazgos; o si no es necesario, asegurarse de que hayan convergencias y 0 divergencias en la arquitectura global».

El contrato, de los dos lados:
  PC, antes de irse a la nube:  --marcar deja .claude/nube/en-la-nube.json (commiteado): que repos mirar y que PDF.
  Nube, al trabajar:            commit y push por paso. Lo que aprende de Fran NO va a memoria/ (el espejo lo pisa la PC,
                                DA-101): va a perfil-global/memoria-nube/. Al cerrar, un informe en
                                .claude/nube/regreso/AAAA-MM-DD-*.md con 'estado: pendiente'.
  PC, al volver:                un hook de SessionStart corre --aviso y lo dice solo. --traer trae, --medir mide,
                                y --cerrar saca la marca, SOLO si la medicion da 0 divergencias.

Uso:
  python .claude/nube/regreso.py --marcar "que se fue a hacer"
  python .claude/nube/regreso.py --aviso     (hook: callado si no hay marca)
  python .claude/nube/regreso.py --medir     (exit 1 si hay algo sin converger)
  python .claude/nube/regreso.py --traer     (pull, ramas de la nube por fast-forward, memoria-nube a la memoria)
  python .claude/nube/regreso.py --cerrar    (saca la marca; se niega si la medicion no da 0)
  python .claude/nube/regreso.py --probar    (repos sinteticos: cada caso divergente tiene que dar rojo, y lo limpio verde)

Salida en ASCII: la consola de Windows la lee como cp1252.
"""
import hashlib
import importlib.util
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
MARCA = Path(".claude/nube/en-la-nube.json")
INFORMES = Path(".claude/nube/regreso")
BANDEJA = "memoria-nube"
REPOS_FIJOS = [".", "perfil-global"]


def git(cwd, *a, timeout=60):
    try:
        p = subprocess.run(["git", "-C", str(cwd), *a], capture_output=True, text=True, encoding="utf-8",
                           errors="replace", timeout=timeout)
    except subprocess.TimeoutExpired:
        return 124, "", "timeout"
    return p.returncode, p.stdout.strip(), p.stderr.strip()


def rama_principal(repo):
    rc, out, _ = git(repo, "symbolic-ref", "--short", "HEAD")
    return out if rc == 0 and out else "main"


class Lugar:
    def __init__(self, raiz, perfil=None, memoria=None):
        self.raiz = Path(raiz)
        self.perfil = Path(perfil) if perfil else self.raiz / "perfil-global"
        self.memoria = Path(memoria) if memoria else None

    def repo(self, rel):
        if rel == "perfil-global":
            return self.perfil
        return self.raiz if rel == "." else self.raiz / rel


def marca(l):
    f = l.raiz / MARCA
    if not f.exists():
        return None
    return json.loads(f.read_text(encoding="utf-8"))


def repos_de(l, m):
    vistos = []
    for r in REPOS_FIJOS + list((m or {}).get("repos", [])):
        if r not in vistos:
            vistos.append(r)
    return vistos


def medir_repos(l, m, traer_remoto=True):
    """Lo que esta en GitHub y no en esta PC. Una rama claude/* con commits que main no tiene es trabajo sin integrar."""
    items = []
    for rel in repos_de(l, m):
        repo = l.repo(rel)
        if not (repo / ".git").exists():
            items.append("%s: no esta clonado en esta PC, y la nube pudo escribir ahi" % rel)
            continue
        if traer_remoto:
            rc, _, err = git(repo, "fetch", "-q", "--prune", "origin", timeout=25)
            if rc != 0:
                items.append("%s: no se pudo mirar GitHub (SIN MEDIR, no es verde): %s" % (rel, err[:90]))
                continue
        rama = rama_principal(repo)
        rc, atras, _ = git(repo, "rev-list", "--count", "HEAD..origin/%s" % rama)
        if rc == 0 and int(atras or 0):
            items.append("%s: la PC esta %s commit(s) atras de origin/%s" % (rel, atras, rama))
        rc, adelante, _ = git(repo, "rev-list", "--count", "origin/%s..HEAD" % rama)
        if rc == 0 and int(adelante or 0):
            items.append("%s: la PC tiene %s commit(s) sin pushear" % (rel, adelante))
        _, refs, _ = git(repo, "for-each-ref", "--format=%(refname:short)", "refs/remotes/origin/claude")
        for ref in refs.split():
            _, n, _ = git(repo, "rev-list", "--count", "HEAD..%s" % ref)
            if int(n or 0):
                items.append("%s: la rama %s tiene %s commit(s) que %s no tiene" % (rel, ref, n, rama))
    return items


def medir_bandeja(l):
    return ["memoria de la nube sin traer: %s" % f.name for f in sorted((l.perfil / BANDEJA).glob("*.md"))]


def medir_informes(l):
    out = []
    for f in sorted((l.raiz / INFORMES).glob("*.md")):
        if re.search(r"^estado:\s*pendiente\s*$", f.read_text(encoding="utf-8", errors="replace"), re.M):
            out.append("informe de la nube sin procesar: %s (leerlo, procesar lo que trae, y pasarlo a 'estado: procesado')" % f.name)
    return out


def medir_pdfs(l, m):
    """Un PDF publico cuyo fuente cambio despues que el: la nube no publica. Se compara por commit, no por fecha de disco."""
    out = []
    for p in (m or {}).get("pdfs", []):
        _, t_pdf, _ = git(l.raiz, "log", "-1", "--format=%ct", "--", p["pdf"])
        _, t_src, _ = git(l.raiz, "log", "-1", "--format=%ct", "--", p["fuentes"])
        if t_src and int(t_src) > int(t_pdf or 0):
            out.append("PDF publico atrasado: %s; regenerar y publicar: %s" % (p["pdf"], p.get("como", "su compilador")))
    return out


def medir_arquitectura(l):
    """La arquitectura global: el registro de defectos consistente, el perfil instalado igual al repo, la memoria espejada."""
    out = []
    t = l.perfil / "herramientas" / "defectos.py"
    for args, que in ((["verificar"], "el registro de defectos"), (["vista", "--check"], "la vista de los defectos")):
        p = subprocess.run([sys.executable, str(t), *args], capture_output=True, text=True, encoding="utf-8", errors="replace")
        if p.returncode != 0:
            out.append("%s no da verde: %s" % (que, (p.stdout + p.stderr).strip()[:120]))
    casa = Path.home() / ".claude"
    pares = [(l.perfil / "CLAUDE-global.md", casa / "CLAUDE.md")]
    pares += [(f, casa / "herramientas" / f.name) for f in sorted((l.perfil / "herramientas").glob("*.py"))
              if (casa / "herramientas" / f.name).exists()]
    h = lambda f: hashlib.md5(f.read_bytes().replace(b"\r\n", b"\n")).hexdigest()
    distintos = [b.name for a, b in pares if not b.exists() or h(a) != h(b)]
    if distintos:
        out.append("el perfil instalado no es el del repo (%s): correr perfil-global\\install.ps1" % ", ".join(distintos[:4]))
    spec = importlib.util.spec_from_file_location("estado_nube", str(l.raiz / ".claude" / "nube" / "estado-nube.py"))
    en = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(en)
    for x in en.problemas_memoria(en.memoria_local(l.raiz), l.perfil / "memoria"):
        out.append("memoria: %s" % x)
    return out


def medir(l, traer_remoto=True, arquitectura=True):
    m = marca(l)
    items = medir_repos(l, m, traer_remoto) + medir_bandeja(l) + medir_informes(l) + medir_pdfs(l, m)
    if arquitectura:
        items += medir_arquitectura(l)
    return items


def traer(l):
    m = marca(l)
    hecho = []
    for rel in repos_de(l, m):
        repo = l.repo(rel)
        if not (repo / ".git").exists():
            continue
        git(repo, "fetch", "-q", "--prune", "origin")
        rama = rama_principal(repo)
        rc, _, err = git(repo, "merge", "--ff-only", "origin/%s" % rama)
        if rc != 0:
            hecho.append("%s: NO se pudo traer origin/%s por fast-forward: %s" % (rel, rama, err[:100]))
        _, refs, _ = git(repo, "for-each-ref", "--format=%(refname:short)", "refs/remotes/origin/claude")
        for ref in refs.split():
            rc, _, err = git(repo, "merge", "--ff-only", ref)
            hecho.append("%s: %s %s" % (rel, ref, "integrada" if rc == 0 else "NO integrada, se resuelve a mano en la sesion: " + err[:80]))
    bandeja = l.perfil / BANDEJA
    if l.memoria and bandeja.is_dir():
        for f in sorted(bandeja.glob("*.md")):
            destino = l.memoria / f.name
            if destino.exists():
                hecho.append("memoria %s: ya existe en la PC, NO se pisa; se une a mano" % f.name)
                continue
            shutil.copyfile(f, destino)
            f.unlink()
            hecho.append("memoria %s: traida; falta su renglon en MEMORY.md y --sincronizar-memoria" % f.name)
    return hecho


def aviso(l):
    m = marca(l)
    if not m:
        return 0
    items = medir(l, traer_remoto=True, arquitectura=False)
    print("REGRESO DE LA NUBE -- hay una sesion marcada: %s (desde %s)" % (m.get("que", "?"), m.get("desde", "?")))
    if items:
        for x in items[:12]:
            print("  [ROJO] %s" % x)
        print("  ANTES DE LA TAREA: python .claude/nube/regreso.py --traer, y procesar lo que traiga.")
    else:
        print("  Nada nuevo de la nube todavia. Si la sesion ya termino: python .claude/nube/regreso.py --medir y --cerrar.")
    return 0


# ------------------------------------------------------------------------------------------------ la prueba
def _borrar(d):
    def quitar(func, path, _):
        os.chmod(path, stat.S_IWRITE)
        func(path)
    shutil.rmtree(d, onerror=quitar)


def probar():
    base = Path(tempfile.mkdtemp(prefix="regreso-"))
    fallos = []

    def caso(nombre, ok, detalle=""):
        print("  [%s] %s%s" % ("OK  " if ok else "ROJO", nombre, ("  -- " + str(detalle)[:110]) if detalle else ""))
        if not ok:
            fallos.append(nombre)

    def sh(cwd, *a):
        rc, out, err = git(cwd, *a)
        if rc:
            raise SystemExit("prueba: git %s -> %s" % (a, err))
        return out

    def nuevo(nombre):
        rem = base / (nombre + ".git")
        subprocess.run(["git", "init", "-q", "--bare", "-b", "main", str(rem)], check=True)
        pc, nube = base / nombre, base / (nombre + "-nube")
        for d in (pc, nube):
            if d == pc:
                subprocess.run(["git", "init", "-q", "-b", "main", str(d)], check=True)
                sh(d, "remote", "add", "origin", str(rem))
            else:
                subprocess.run(["git", "clone", "-q", str(rem), str(d)], check=True, capture_output=True)
            sh(d, "config", "user.email", "t@t")
            sh(d, "config", "user.name", "t")
            if d == pc:
                (d / "a.txt").write_text("a", encoding="utf-8")
                sh(d, "add", "a.txt")
                sh(d, "commit", "-q", "-m", "a")
                sh(d, "push", "-q", "origin", "main")
            else:
                sh(d, "pull", "-q", "origin", "main")
        return pc, nube

    try:
        raiz, raiz_nube = nuevo("acceso")
        perfil, perfil_nube = nuevo("perfil")
        memoria = base / "memoria-pc"
        memoria.mkdir()
        l = Lugar(raiz, perfil, memoria)
        M = lambda: medir(l, traer_remoto=True, arquitectura=False)
        caso("sin marca: --aviso calla", aviso(l) == 0 and marca(l) is None)
        (raiz / ".claude" / "nube").mkdir(parents=True)
        (raiz / MARCA).write_text(json.dumps({"que": "prueba", "desde": "hoy", "repos": [],
                                              "pdfs": [{"pdf": "a.pdf", "fuentes": "fuente.typ", "como": "compilar"}]}), encoding="utf-8")
        (raiz / "a.pdf").write_text("pdf", encoding="utf-8")
        (raiz / "fuente.typ").write_text("f", encoding="utf-8")
        sh(raiz, "add", "."); sh(raiz, "commit", "-q", "-m", "marca")
        sh(raiz, "push", "-q", "origin", "main")
        sh(raiz_nube, "pull", "-q", "origin", "main")
        caso("CONTROL: todo igual -> 0 divergencias", M() == [], M())

        (raiz_nube / "b.txt").write_text("b", encoding="utf-8")
        sh(raiz_nube, "add", "."); sh(raiz_nube, "commit", "-q", "-m", "b"); sh(raiz_nube, "push", "-q", "origin", "main")
        caso("la nube pusheo a main -> ROJO 'atras'", any("atras" in x for x in M()), M())
        traer(l)
        caso("--traer lo trae -> sin 'atras'", (raiz / "b.txt").exists() and not any("atras" in x for x in M()), M())

        sh(raiz_nube, "pull", "-q", "origin", "main")
        sh(raiz_nube, "checkout", "-q", "-b", "claude/trabajo")
        (raiz_nube / "c.txt").write_text("c", encoding="utf-8")
        sh(raiz_nube, "add", "."); sh(raiz_nube, "commit", "-q", "-m", "c"); sh(raiz_nube, "push", "-q", "origin", "claude/trabajo")
        caso("la nube trabajo en una rama claude/* -> ROJO", any("claude/trabajo" in x for x in M()), M())
        traer(l)
        caso("--traer la integra por fast-forward", (raiz / "c.txt").exists() and not any("claude/" in x for x in M()), M())
        sh(raiz, "push", "-q", "origin", "main")
        sh(raiz_nube, "checkout", "-q", "main"); sh(raiz_nube, "pull", "-q", "origin", "main")

        # dos ramas que no se pueden avanzar: se dice, no se pisa
        (raiz_nube / "a.txt").write_text("nube", encoding="utf-8")
        sh(raiz_nube, "checkout", "-q", "-b", "claude/choque")
        sh(raiz_nube, "add", "."); sh(raiz_nube, "commit", "-q", "-m", "n"); sh(raiz_nube, "push", "-q", "origin", "claude/choque")
        (raiz / "a.txt").write_text("pc", encoding="utf-8")
        sh(raiz, "add", "."); sh(raiz, "commit", "-q", "-m", "p"); sh(raiz, "push", "-q", "origin", "main")
        h = traer(l)
        caso("rama que choca con la PC -> NO se pisa, se avisa", any("NO integrada" in x for x in h) and (raiz / "a.txt").read_text(encoding="utf-8") == "pc", h)
        sh(raiz_nube, "push", "-q", "origin", "--delete", "claude/choque")
        sh(raiz_nube, "checkout", "-q", "main"); sh(raiz_nube, "pull", "-q", "origin", "main")

        (raiz / "fuente.typ").write_text("cambiado en la nube", encoding="utf-8")
        sh(raiz, "add", "."); sh(raiz, "commit", "-q", "--date=2099-01-01T00:00:00", "-m", "f")
        subprocess.run(["git", "-C", str(raiz), "commit", "-q", "--amend", "--no-edit"], env={**os.environ, "GIT_COMMITTER_DATE": "2099-01-01T00:00:00"}, check=True)
        sh(raiz, "push", "-q", "origin", "main")
        caso("fuente mas nuevo que su PDF publico -> ROJO", any("PDF publico" in x for x in M()), M())
        (raiz / "a.pdf").write_text("pdf nuevo", encoding="utf-8")
        sh(raiz, "add", ".")
        subprocess.run(["git", "-C", str(raiz), "commit", "-q", "-m", "pdf"], env={**os.environ, "GIT_COMMITTER_DATE": "2099-01-02T00:00:00"}, check=True)
        sh(raiz, "push", "-q", "origin", "main")
        caso("PDF regenerado -> sin rojo de PDF", not any("PDF publico" in x for x in M()), M())

        (raiz / INFORMES).mkdir(parents=True)
        inf = raiz / INFORMES / "2026-11-05-x.md"
        inf.write_text("estado: pendiente\n\nhallazgos\n", encoding="utf-8")
        caso("informe pendiente -> ROJO", any("sin procesar" in x for x in M()), M())
        inf.write_text("estado: procesado\n", encoding="utf-8")
        caso("informe procesado -> sin rojo", not any("sin procesar" in x for x in M()), M())

        (perfil / BANDEJA).mkdir()
        (perfil / BANDEJA / "nueva.md").write_text("algo de Fran", encoding="utf-8")
        caso("memoria en la bandeja -> ROJO", any("nueva.md" in x for x in M()), M())
        (memoria / "ya.md").write_text("la de la PC", encoding="utf-8")
        (perfil / BANDEJA / "ya.md").write_text("la de la nube", encoding="utf-8")
        h = traer(l)
        caso("--traer pasa la memoria a la PC", (memoria / "nueva.md").exists() and not (perfil / BANDEJA / "nueva.md").exists(), h)
        caso("una memoria que ya existe NO se pisa", (memoria / "ya.md").read_text(encoding="utf-8") == "la de la PC"
             and (perfil / BANDEJA / "ya.md").exists(), h)
        (perfil / BANDEJA / "ya.md").unlink()

        (perfil / "sin-push.txt").write_text("x", encoding="utf-8")
        sh(perfil, "add", "."); sh(perfil, "commit", "-q", "-m", "x")
        caso("commit local sin pushear -> ROJO", any("sin pushear" in x for x in M()), M())
        sh(perfil, "push", "-q", "origin", "main")
        for f in (raiz / INFORMES).glob("*"):
            pass
        sh(raiz, "add", "."); sh(raiz, "commit", "-q", "-m", "inf"); sh(raiz, "push", "-q", "origin", "main")
        caso("CONTROL: al final, 0 divergencias", M() == [], M())
        rem_roto = Lugar(raiz, perfil, memoria)
        sh(raiz, "remote", "set-url", "origin", str(base / "no-existe.git"))
        caso("GitHub inalcanzable -> SIN MEDIR, nunca verde", any("SIN MEDIR" in x for x in medir(rem_roto, True, False)))
    finally:
        _borrar(base)
    print("  regreso: %s" % ("VERDE" if not fallos else "ROJO (%d): %s" % (len(fallos), fallos)))
    return 0 if not fallos else 1


def lugar_real():
    spec = importlib.util.spec_from_file_location("estado_nube", str(Path(__file__).with_name("estado-nube.py")))
    en = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(en)
    return Lugar(RAIZ, en.perfil_dir(RAIZ), en.memoria_local(RAIZ))


def main(a):
    op = a[0] if a else "--medir"
    if op == "--probar":
        return probar()
    l = lugar_real()
    if op == "--aviso":
        return aviso(l)
    if op == "--marcar":
        f = RAIZ / MARCA
        datos = json.loads(f.read_text(encoding="utf-8")) if f.exists() else {}
        datos["que"] = a[1] if len(a) > 1 else datos.get("que", "?")
        f.write_text(json.dumps(datos, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print("marca escrita: %s (falta commit + push)" % f)
        return 0
    if op == "--traer":
        for x in traer(l):
            print("  " + x)
        op = "--medir"
    if op in ("--medir", "--cerrar"):
        items = medir(l)
        for x in items:
            print("  [ROJO] " + x)
        print("  regreso: %s" % ("0 divergencias" if not items else "%d cosa(s) sin converger" % len(items)))
        if op == "--cerrar" and not items:
            (RAIZ / MARCA).unlink(missing_ok=True)
            print("  marca sacada: falta commit + push")
        return 0 if not items else 1
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
