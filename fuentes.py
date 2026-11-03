#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fuentes.py -- DA-095: las fuentes de una materia, espejadas en Drive y medidas por MD5 en cada maquina.

POR QUE EXISTE (2026-11-03). Las fuentes de Quimica de Male (20 PDF de teoria, los parciales 2022-2026) vivian en
Descargas y Escritorio de su notebook. MATERIAL.md lo decia en prosa y nada lo media ni lo espejaba: desde la PC de
Fran el apunte compilaba y el modulo siguiente no se podia escribir. Requisitos: L1-33, L2-FUE-01..05 en
proyectos/ingenieria/arquitectura-se/docs/10-requisitos.md §16; diseno y V: docs/da093-segunda-maquina.md.

La declaracion vive EN el proyecto (fuentes.json en su raiz, repo privado), porque nombra carpetas de terceros:
    {"remote": "drive-personal",
     "materias": {"quimica-inorganica": {"espejo": "<carpeta en el remote>",
                                         "origenes": ["%USERPROFILE%/Downloads/<carpeta>", ...]}}}
La Copia_Local es ~/fuentes-espejo/<proyecto>/<materia>/: fuera de todo repo (los PDF de catedra no van a git) y
fuera del arbol (la puerta no la ve como el proyecto).

    python fuentes.py aviso <proyecto>     por materia: N de M en esta maquina (lo corre cascada.ps1); sin
                                           fuentes.json no imprime nada
    python fuentes.py traer <proyecto>     baja del espejo lo que falta o difiere (MD5)
    python fuentes.py subir <proyecto>     copia los origenes que existan a la Copia_Local y sube lo que falta o difiere
    python fuentes.py --autotest           casos sobre un espejo local sintetico (rclone con rutas locales)
    python fuentes.py --sabotaje           cada mutante tiene que poner su caso en MAL

Sin acentos en la salida: la consola de Windows la lee como cp1252.
"""
from __future__ import annotations

import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(os.environ.get("FUENTES_RAIZ") or Path(__file__).resolve().parent)
LOCAL = Path(os.environ.get("FUENTES_LOCAL") or Path.home() / "fuentes-espejo")
# El config de rclone vive en ~/.config y NO en %APPDATA%: sin --config, otra consola corta con 'empty token found'.
CONF = Path(os.environ.get("FUENTES_RCLONE_CONF") or Path.home() / ".config" / "rclone" / "rclone.conf")
PLAZO = int(os.environ.get("FUENTES_PLAZO") or 30)   # L2-FUE-02: segundos por listado del espejo


def rclone() -> str | None:
    r = shutil.which("rclone")
    if r:
        return r
    alt = Path(os.environ.get("LOCALAPPDATA", "")) / "Microsoft" / "WinGet" / "Links" / "rclone.exe"
    return str(alt) if alt.exists() else None


def rc(args, plazo=PLAZO):
    """(codigo, stdout). Codigo None = no hay rclone o paso el plazo: el llamador lo informa SIN MEDIR."""
    exe = rclone()
    if not exe:
        return None, ""
    pre = [exe, "--config", str(CONF)] if CONF.exists() else [exe]
    try:
        r = subprocess.run(pre + list(args), capture_output=True, timeout=plazo)
    except subprocess.TimeoutExpired:
        return None, ""
    return r.returncode, r.stdout.decode("utf-8", "replace")


def proyecto_dir(nombre: str) -> Path | None:
    base = RAIZ / "proyectos"
    for nat in (base.iterdir() if base.exists() else []):
        p = nat / nombre
        if p.is_dir():
            return p
    return None


def declaracion(nombre: str):
    p = proyecto_dir(nombre)
    if p is None or not (p / "fuentes.json").exists():
        return None
    return json.loads((p / "fuentes.json").read_text(encoding="utf-8-sig"))


def destino(decl: dict, mat: dict) -> str:
    rem = decl.get("remote", "")
    return ("%s:%s" % (rem, mat["espejo"])) if rem else mat["espejo"]


def md5(f: Path) -> str:
    h = hashlib.md5()
    with open(f, "rb") as fh:
        for b in iter(lambda: fh.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def locales(d: Path) -> dict:
    """{ruta relativa con '/': md5} de la Copia_Local."""
    if not d.exists():
        return {}
    return {f.relative_to(d).as_posix(): md5(f) for f in d.rglob("*") if f.is_file()}


def remotos(dest: str):
    """{ruta: md5 o None} del espejo, o None si no se pudo listar (sin red, sin acceso, plazo)."""
    cod, out = rc(["lsjson", "-R", "--files-only", "--hash", dest])
    if cod == 3:   # rclone: 'directory not found' -- el espejo todavia no se creo: vacio, no 'sin red'
        return {}
    if cod != 0:
        return None
    try:
        items = json.loads(out or "[]")
    except Exception:
        return None
    return {x["Path"]: (x.get("Hashes") or {}).get("md5") or (x.get("Hashes") or {}).get("MD5") for x in items}


def medir(nombre: str, mname: str, decl: dict):
    """(estado, texto). estado: ok | falta | vacio | sin-medir."""
    mat = decl["materias"][mname]
    loc = locales(LOCAL / nombre / mname)
    rem = remotos(destino(decl, mat))
    if rem is None:
        return "sin-medir", ("%s: el espejo no respondio (sin red, sin acceso o mas de %d s) -- SIN MEDIR, no es al dia"
                             % (mname, PLAZO))
    if not rem:   # L2-FUE-03: verde por vacio no
        return "vacio", ("%s: el ESPEJO ESTA VACIO (%d locales): subir desde la maquina que las tiene -> "
                         "python fuentes.py subir %s" % (mname, len(loc), nombre))
    # L2-FUE-01: por MD5, no por nombre ni por fecha
    iguales = [k for k, h in rem.items() if k in loc and h and loc[k] == h]
    distintos = [k for k, h in rem.items() if k in loc and h and loc[k] != h]
    faltan = [k for k in rem if k not in loc]
    sin_subir = [k for k in loc if k not in rem]
    txt = "%s: %d de %d en esta maquina" % (mname, len(iguales), len(rem))
    if faltan or distintos:
        txt += " (%d faltan, %d distintos) -> python fuentes.py traer %s" % (len(faltan), len(distintos), nombre)
    if sin_subir:
        txt += "; %d locales sin subir -> python fuentes.py subir %s" % (len(sin_subir), nombre)
    return ("ok" if not faltan and not distintos else "falta"), txt


def cmd_aviso(nombre: str) -> int:
    decl = declaracion(nombre)
    if decl is None:
        return 0
    print("  FUENTES (DA-095) de %s -- el espejo en Drive contra la Copia_Local %s:" % (nombre, LOCAL / nombre))
    for m in decl.get("materias", {}):
        e, t = medir(nombre, m, decl)
        marca = {"ok": "[x]", "falta": "[ ]", "vacio": "[~]", "sin-medir": "[~]"}[e]
        print("    %s %s" % (marca, t))
    return 0


def expandir(o: str) -> Path:
    return Path(os.path.expandvars(os.path.expanduser(o)))


def cmd_traer(nombre: str) -> int:
    decl = declaracion(nombre)
    if decl is None:
        print("  %s no declara fuentes (fuentes.json en su raiz)" % nombre)
        return 1
    mal = 0
    for m, mat in decl.get("materias", {}).items():
        d = LOCAL / nombre / m
        d.mkdir(parents=True, exist_ok=True)
        cod, _ = rc(["copy", "--checksum", destino(decl, mat), str(d)], plazo=max(PLAZO, 600))   # L2-FUE-04
        mal += cod != 0
        print("    %s" % medir(nombre, m, decl)[1])
    return 1 if mal else 0


def cmd_subir(nombre: str) -> int:
    decl = declaracion(nombre)
    if decl is None:
        print("  %s no declara fuentes (fuentes.json en su raiz)" % nombre)
        return 1
    mal = 0
    for m, mat in decl.get("materias", {}).items():
        d = LOCAL / nombre / m
        d.mkdir(parents=True, exist_ok=True)
        for o in mat.get("origenes", []):   # L2-FUE-05: lo que llego a Descargas o al Escritorio entra a la copia
            src = expandir(o)
            if src.is_dir():
                cod, _ = rc(["copy", "--checksum", str(src), str(d / src.name)], plazo=max(PLAZO, 600))
                mal += cod != 0
                print("    origen %s -> copia local" % src)
        cod, _ = rc(["copy", "--checksum", str(d), destino(decl, mat)], plazo=max(PLAZO, 1800))
        mal += cod != 0
        print("    %s" % medir(nombre, m, decl)[1])
    return 1 if mal else 0


# ------------------------------------------------------------------------------------------------ prueba
def autotest() -> int:
    """El espejo es una carpeta local (rclone acepta rutas locales como destino), la Copia_Local otra."""
    global RAIZ, LOCAL, CONF
    viejos = RAIZ, LOCAL, CONF
    tmp = Path(tempfile.mkdtemp(prefix="fuentes-autotest-"))
    RAIZ, LOCAL, CONF = tmp / "raiz", tmp / "local", tmp / "sin-config.conf"
    esp, ori = tmp / "espejo", tmp / "Descargas" / "TEORIA"
    pr = RAIZ / "proyectos" / "documentos" / "demo"
    pr.mkdir(parents=True)
    esp.mkdir()
    (pr / "fuentes.json").write_text(json.dumps({"remote": "", "materias": {"mat": {
        "espejo": str(esp), "origenes": [str(ori)]}}}), encoding="utf-8")
    decl = declaracion("demo")
    mal = 0

    def caso(nombre, estado, marca):
        nonlocal mal
        e, t = medir("demo", "mat", declaracion("demo"))
        ok = e == estado and marca in t
        mal += not ok
        print("%s  %-58s -> %s" % ("ok " if ok else "MAL", nombre, t[:110]))

    if not rclone():
        print("MAL  no hay rclone: la prueba no puede correr (no es verde)")
        return 1
    caso("1 el espejo vacio -> espejo vacio, no verde", "vacio", "ESPEJO ESTA VACIO")
    (esp / "a.pdf").write_bytes(b"uno")
    (esp / "sub").mkdir()
    (esp / "sub" / "b.pdf").write_bytes(b"dos")
    caso("2 dos en el espejo, ninguno aca -> 0 de 2", "falta", "0 de 2 en esta maquina (2 faltan")
    cmd_traer("demo")
    caso("3 traer -> 2 de 2", "ok", "2 de 2 en esta maquina")
    (LOCAL / "demo" / "mat" / "a.pdf").write_bytes(b"uno cambiado")
    caso("4 un archivo con otro MD5 -> distinto", "falta", "1 distintos")
    ori.mkdir(parents=True)
    (ori / "c.pdf").write_bytes(b"tres")
    cmd_subir("demo")
    caso("5 subir: el origen entra al espejo -> 3 de 3", "ok", "3 de 3 en esta maquina")
    decl["materias"]["mat"]["espejo"] = str(tmp / "no-existe" / "espejo")
    (pr / "fuentes.json").write_text(json.dumps(decl), encoding="utf-8")
    caso("6b la carpeta del espejo todavia no existe -> espejo vacio", "vacio", "ESPEJO ESTA VACIO")
    decl["remote"] = "remoto-que-no-esta-en-el-config"
    (pr / "fuentes.json").write_text(json.dumps(decl), encoding="utf-8")
    caso("6 el espejo no responde -> SIN MEDIR", "sin-medir", "SIN MEDIR")
    (pr / "fuentes.json").unlink()
    import io
    import contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        cmd_aviso("demo")
    ok = buf.getvalue() == ""
    mal += not ok
    print("%s  %-58s -> %s" % ("ok " if ok else "MAL", "7 sin fuentes.json -> no imprime nada", repr(buf.getvalue()[:60])))
    RAIZ, LOCAL, CONF = viejos
    shutil.rmtree(tmp, ignore_errors=True)
    print("autotest: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


def sabotaje() -> int:
    """Cada mutante tiene que poner en MAL el caso que le toca (y no por otro motivo: se busca su linea)."""
    fuente = Path(__file__).read_text(encoding="utf-8")
    mutantes = (
        ("compara solo nombres, no MD5 (L2-FUE-01)", "    distintos = [k for k, h in rem.items() if k in loc and h and loc[k] != h]",
         "    distintos = []", "MAL  4 "),
        ("el espejo vacio da verde (L2-FUE-03)", "    if not rem:   # L2-FUE-03", "    if False:   # L2-FUE-03", "MAL  1 "),
        ("sin red se lee como al dia (L2-FUE-02)", "    if rem is None:\n        return \"sin-medir\"",
         "    if rem is None:\n        rem = {}\n    if False:\n        return \"sin-medir\"", "MAL  6 "),
        ("subir ignora los origenes (L2-FUE-05)", "            if src.is_dir():", "            if False:", "MAL  5 "))
    mal = 0
    for nombre, viejo, nuevo, marca in mutantes:
        if viejo not in fuente:
            print("MAL  mutante '%s': NO APLICA (el texto cambio)" % nombre)
            mal += 1
            continue
        d = Path(tempfile.mkdtemp(prefix="fuentes-mutante-"))
        m = d / "fuentes.py"
        m.write_text(fuente.replace(viejo, nuevo, 1), encoding="utf-8")
        r = subprocess.run([sys.executable, str(m), "--autotest"], capture_output=True)
        out = r.stdout.decode("utf-8", "replace")
        ok = r.returncode != 0 and marca in out
        mal += not ok
        print("%s  mutante: %-50s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE"))
        shutil.rmtree(d, ignore_errors=True)
    print("sabotaje: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    a = sys.argv[1:]
    if a[:1] == ["--autotest"]:
        sys.exit(autotest())
    if a[:1] == ["--sabotaje"]:
        sys.exit(sabotaje())
    if len(a) == 2 and a[0] in ("aviso", "traer", "subir"):
        sys.exit({"aviso": cmd_aviso, "traer": cmd_traer, "subir": cmd_subir}[a[0]](a[1]))
    print(__doc__)
    sys.exit(2)
