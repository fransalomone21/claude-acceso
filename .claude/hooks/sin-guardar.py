#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sin-guardar.py -- DA-094: al terminar cada turno, le dice a FRAN lo que todavia no salio de esta maquina.

POR QUE EXISTE (2026-11-03). En la notebook de Male, Fran valido las dos primeras paginas de Quimica y arranco el
modulo 0; se tuvieron que ir y lo validado y el retome quedaron solo en ese chat: GitHub decia «esperando a Fran». La
regla 5 (checkpoint antes de parar) supone que la sesion llega a cerrar. Esto no depende de que cierre: en cada turno
que termina con algo del proyecto sin commitear o sin pushear, el aviso va a Fran (systemMessage del hook Stop), no al
contexto de la sesion, que es la que se olvida (DA-043). Requisitos: L1-32, L2-SGU-01/02 en
proyectos/ingenieria/arquitectura-se/docs/10-requisitos.md §16; diseno y V: docs/da093-segunda-maquina.md.

Mide solo los proyectos que la sesion declaro (necesidad, excepcion o -Repo, leidos de la caja negra de la puerta): lo
sucio de otra sesion en el mismo arbol no es de esta (DA-088). Un aviso por sesion cada 30 min a lo sumo (L2-SGU-01),
y nunca bloquea el turno: cualquier falla sale 0 y calla (L2-SGU-02).

    (hook Stop)                 lee el evento por stdin
    python sin-guardar.py --autotest
    python sin-guardar.py --sabotaje

Se instala en .claude/settings.json (Stop) SOLO con el si de Fran: corre solo en cada turno.
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import time
from pathlib import Path

AQUI = Path(__file__).resolve().parent
ESPERA = int(os.environ.get("SIN_GUARDAR_ESPERA") or 1800)   # L2-SGU-01: 30 min (TBR)


def git(d, *a):
    r = subprocess.run(["git", "-C", str(d)] + list(a), capture_output=True, timeout=15)
    if r.returncode != 0:
        raise RuntimeError(r.stderr.decode("utf-8", "replace")[:200])
    return r.stdout.decode("utf-8", "replace")


def pendiente(proy: Path):
    """(sin commitear, sin pushear) del proyecto: los archivos de SU carpeta y los commits de su repo que no salieron."""
    sucio = [l for l in git(proy, "status", "--porcelain", "--", ".").splitlines() if l.strip()]
    try:
        sin_push = int(git(proy, "rev-list", "--count", "@{u}..HEAD", "--", ".").strip() or 0)
    except RuntimeError:   # sin remote: todo lo commiteado sigue en esta maquina
        sin_push = int(git(proy, "rev-list", "--count", "HEAD", "--", ".").strip() or 0)
    return len(sucio), sin_push


def aviso(ev: dict) -> str | None:
    sys.path.insert(0, str(AQUI))
    import cascada_puerta as cp   # la caja negra y la ubicacion de los proyectos tienen UN dueno: la puerta
    sid = ev.get("session_id", "")
    st = cp.estado(sid)
    nombres = list(dict.fromkeys(list(st["declaradas"]) + list(st["excepciones"]) + list(st.get("repos", {}))))
    disco = cp.proyectos_del_disco()
    partes = []
    for n in nombres:
        if n not in disco:
            continue
        s, p = pendiente(disco[n])
        if s or p:
            partes.append("%s: %s" % (n, ", ".join(x for x in (
                "%d archivo(s) sin commitear" % s if s else "", "%d commit(s) sin pushear" % p if p else "") if x)))
    if not partes:
        return None
    marca = cp.ESTADO_DIR / ("%s.sin-guardar" % sid)
    try:
        if time.time() - float(marca.read_text()) < ESPERA:
            return None
    except Exception:
        pass
    marca.parent.mkdir(parents=True, exist_ok=True)
    marca.write_text(str(time.time()))
    return ("SIN GUARDAR en esta maquina -- " + "; ".join(partes) +
            ". Si la sesion se corta aca, se pierde: cada si tuyo a un paso es un commit y un push (DA-094).")


def hook() -> int:
    try:
        ev = json.loads(sys.stdin.read() or "{}")
        t = aviso(ev)
        if t:
            print(json.dumps({"systemMessage": t}))
    except Exception:
        pass   # L2-SGU-02: un aviso roto no frena el turno
    return 0


# ------------------------------------------------------------------------------------------------ prueba
def autotest() -> int:
    tmp = Path(tempfile.mkdtemp(prefix="sin-guardar-autotest-"))
    raiz, remoto = tmp / "raiz", tmp / "remoto.git"
    pr = raiz / "proyectos" / "ingenieria" / "demo"
    pr.mkdir(parents=True)
    g = ["-c", "user.name=prueba", "-c", "user.email=prueba-sin-arroba"]
    subprocess.run(["git", "init", "-q", "--bare", str(remoto)], capture_output=True)
    subprocess.run(["git", "-C", str(raiz), "init", "-q", "-b", "main"], capture_output=True)
    (pr / "a.md").write_text("a\n", encoding="utf-8")
    (raiz / "fuera.md").write_text("de otra sesion\n", encoding="utf-8")
    subprocess.run(["git", "-C", str(raiz)] + g + ["add", "-A"], capture_output=True)
    subprocess.run(["git", "-C", str(raiz)] + g + ["commit", "-q", "-m", "x"], capture_output=True)
    subprocess.run(["git", "-C", str(raiz), "remote", "add", "origin", str(remoto)], capture_output=True)
    subprocess.run(["git", "-C", str(raiz), "push", "-q", "-u", "origin", "main"], capture_output=True)
    est = tmp / "caja"
    est.mkdir()
    env = dict(os.environ, CASCADA_RAIZ=str(raiz), CASCADA_ESTADO_DIR=str(est))
    mal = 0

    def correr(sid, espera=None, script=__file__):
        e = dict(env, SIN_GUARDAR_ESPERA=str(espera)) if espera is not None else env
        r = subprocess.run([sys.executable, str(script)], input=json.dumps({"session_id": sid}).encode(),
                           capture_output=True, env=e)
        return r.returncode, r.stdout.decode("utf-8", "replace")

    def caso(nombre, res, avisa, marca=None):
        nonlocal mal
        cod, out = res
        ok = cod == 0 and (("systemMessage" in out) == avisa) and (marca is None or marca in out)
        mal += not ok
        print("%s  %-60s -> %s" % ("ok " if ok else "MAL", nombre, (out.strip() or "calla")[:110]))

    def declarar(sid):
        (est / ("%s.jsonl" % sid)).write_text(json.dumps({"t": "declara", "proy": "demo", "nec": ["ninguna"]}) + "\n",
                                              encoding="utf-8")

    declarar("s1")
    caso("1 todo guardado -> calla", correr("s1", 0), False)
    (raiz / "fuera.md").write_text("cambio de otra sesion\n", encoding="utf-8")
    caso("2 sucio FUERA del proyecto (otra sesion) -> calla", correr("s1", 0), False)
    (pr / "a.md").write_text("a cambiado\n", encoding="utf-8")
    caso("3 un archivo del proyecto sin commitear -> avisa", correr("s1", 0), True, "1 archivo(s) sin commitear")
    caso("4 dentro de la espera, de nuevo -> calla", correr("s1"), False)
    subprocess.run(["git", "-C", str(raiz)] + g + ["commit", "-q", "-am", "y"], capture_output=True)
    declarar("s2")
    caso("5 commiteado y sin pushear -> avisa", correr("s2", 0), True, "commit(s) sin pushear")
    caso("6 una sesion que no declaro el proyecto -> calla", correr("s3", 0), False)
    declarar("s4")
    subprocess.run(["git", "-C", str(raiz), "remote", "set-url", "origin", str(tmp / "no-existe.git")],
                   capture_output=True)
    (raiz / ".git" / "HEAD").write_text("basura\n", encoding="utf-8")   # el repo roto: git falla
    caso("7 el repo roto -> sale 0 y calla (no frena el turno)", correr("s4", 0), False)
    import shutil
    shutil.rmtree(tmp, ignore_errors=True)
    print("autotest: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


def sabotaje() -> int:
    fuente = Path(__file__).read_text(encoding="utf-8")
    mutantes = (
        ("sin la espera (L2-SGU-01)", "        if time.time() - float(marca.read_text()) < ESPERA:",
         "        if False:", "MAL  4 "),
        ("mide todo el arbol, no el proyecto (DA-088)", 'git(proy, "status", "--porcelain", "--", ".")',
         'git(proy, "status", "--porcelain", "--", ":/")', "MAL  2 "),
        ("no mira lo sin pushear", '        if s or p:', '        if s:', "MAL  5 "),
        ("un repo roto revienta (L2-SGU-02)", "    except Exception:\n        pass   # L2-SGU-02",
         "    except ZeroDivisionError:\n        pass   # L2-SGU-02", "MAL  7 "))
    mal = 0
    for nombre, viejo, nuevo, marca in mutantes:
        if viejo not in fuente:
            print("MAL  mutante '%s': NO APLICA (el texto cambio)" % nombre)
            mal += 1
            continue
        d = Path(tempfile.mkdtemp(prefix="sin-guardar-mutante-"))
        m = d / "sin-guardar.py"
        m.write_text(fuente.replace(viejo, nuevo, 1), encoding="utf-8")
        # el mutante importa la puerta de AL LADO: se copia con el
        (d / "cascada_puerta.py").write_text((AQUI / "cascada_puerta.py").read_text(encoding="utf-8"), encoding="utf-8")
        r = subprocess.run([sys.executable, str(m), "--autotest"], capture_output=True)
        out = r.stdout.decode("utf-8", "replace")
        ok = r.returncode != 0 and marca in out
        mal += not ok
        print("%s  mutante: %-50s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE"))
        import shutil
        shutil.rmtree(d, ignore_errors=True)
    print("sabotaje: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    a = sys.argv[1:]
    if a[:1] == ["--autotest"]:
        sys.exit(autotest())
    if a[:1] == ["--sabotaje"]:
        sys.exit(sabotaje())
    sys.exit(hook())
