#!/usr/bin/env python3
"""medir-reescritura.py -- leccion 293 a nivel herramienta (2026-10-19): reescribir un archivo entero desde la consola
cambia bytes FUERA del cambio, y no falla.

Dos recurrencias medidas: un .Replace + WriteAllText ASCII sobre verify-install.ps1 convirtio un caracter en '?'
(2026-09-28), y un Get-Content -Raw sin -Encoding (PS 5.1 lee cp1252) + Set-Content utf8 dejo 51 lineas del CLAUDE.md
del telescopio con los acentos dobles (2026-10-18). La regla escrita ('usar Edit; si no, mirar el git diff entero')
estaba en el nucleo las dos veces.

Esto no adivina por el comando (un guardia por patron frena tambien lo legitimo y no ve el caso que no imagino): mide
el EFECTO sobre el objeto. Hook PostToolUse de Bash y PowerShell: despues de cada comando, cada archivo de texto
trackeado que cambio contra HEAD en los ultimos minutos se compara con su version de HEAD, y se avisa si gano

  (a) mojibake: 'Ã¡', 'Â°', 'â€' que HEAD no tenia (UTF-8 leido como cp1252 y vuelto a escribir);
  (b) un '?' donde HEAD tenia un caracter no ASCII, en una linea que por lo demas es igual (escrito como ASCII);
  (c) un BOM que HEAD no tenia (Set-Content -Encoding utf8 de PS 5.1).

Avisa con decision 'block' (el comando ya corrio: el aviso le llega a la sesion, que restaura con git checkout y
rehace con Edit). Lo que ya estaba en HEAD no cuenta: un archivo que CITA mojibake a proposito no avisa. Mira el repo
raiz, perfil-global y el repo de la carpeta del comando; un repo de proyecto aparte que el comando toca desde otra
carpeta no lo ve (limite declarado). Si git falla, calla: es una alarma, no una puerta.

Uso: lo corre el harness (stdin = el evento).  python medir-reescritura.py --autotest
"""
import difflib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]
VENTANA_S = 600   # solo lo que cambio en los ultimos 10 minutos: el efecto del comando, no un estado viejo
TOPE_ARCHIVOS = 40
TEXTO = re.compile(r"\.(md|ps1|psm1|py|json|jsonl|typ|txt|sh|bat|cmd|yml|yaml|js|html|css|csv|toml|ini)$", re.I)
# UTF-8 leido como cp1252: el byte de arranque (C2, C3, E2) sale como 'Â', 'Ã', 'â' y el de continuacion como un
# caracter de cp1252 entre 0x80 y 0xBF.
CONT = "\u0080-¿ŒœŠšŸŽžƒˆ˜–—‘-„†-•…‰‹›€™"
MOJIBAKE = re.compile("[ÂÃ][%s]|â[%s][%s]" % (CONT, CONT, CONT))
BOM = b"\xef\xbb\xbf"


def git(repo: Path, *args, binario=False):
    r = subprocess.run(["git", "-C", str(repo)] + list(args), capture_output=True, timeout=20)
    if r.returncode != 0:
        raise RuntimeError(r.stderr.decode("utf-8", "replace")[:200])
    return r.stdout if binario else r.stdout.decode("utf-8", "replace")


def repos_de(ev: dict):
    if os.environ.get("MEDIR_REESCRITURA_REPOS"):   # la prueba aisla los repos
        return [Path(p) for p in os.environ["MEDIR_REESCRITURA_REPOS"].split(os.pathsep) if p]
    out = [RAIZ]
    if (RAIZ / "perfil-global" / ".git").exists():
        out.append(RAIZ / "perfil-global")
    try:
        top = Path(git(Path(ev.get("cwd") or RAIZ), "rev-parse", "--show-toplevel").strip())
        if top.resolve() not in [p.resolve() for p in out]:
            out.append(top)
    except Exception:
        pass
    return out


def defectos(viejo: bytes, nuevo: bytes):
    """Lo que el archivo gano contra HEAD: [(clase, detalle)]."""
    out = []
    if nuevo.startswith(BOM) and not viejo.startswith(BOM):
        out.append(("BOM", "el archivo gano un BOM (Set-Content -Encoding utf8 de PS 5.1)"))
    v, n = viejo.decode("utf-8", "replace"), nuevo.decode("utf-8", "replace")
    mv, mn = MOJIBAKE.findall(v), MOJIBAKE.findall(n)
    if len(mn) > len(mv):
        ej = next((l.strip()[:70] for l in n.splitlines() if MOJIBAKE.search(l) and l not in v), "")
        out.append(("MOJIBAKE", "%d secuencia(s) nuevas de acento doble (UTF-8 leido como cp1252), p. ej. %r"
                    % (len(mn) - len(mv), ej)))
    lv, ln = v.splitlines(), n.splitlines()
    preguntas = 0
    for op, a1, a2, b1, b2 in difflib.SequenceMatcher(None, lv, ln, autojunk=False).get_opcodes():
        if op != "replace":
            continue
        for x, y in zip(lv[a1:a2], ln[b1:b2]):
            # mismo largo y cada diferencia es un no ASCII que paso a '?' (WriteAllText ASCII: un '?' por caracter)
            if x != y and len(x) == len(y) and all(a == b or (b == "?" and ord(a) > 127) for a, b in zip(x, y)):
                preguntas += 1
    if preguntas:
        out.append(("ASCII", "%d linea(s) donde un caracter no ASCII paso a '?' (escrito como ASCII)" % preguntas))
    return out


def medir(ev: dict):
    hallazgos, ahora = [], time.time()
    for repo in repos_de(ev):
        try:
            nombres = [x for x in git(repo, "diff", "HEAD", "--name-only", "-z").split("\0") if x and TEXTO.search(x)]
        except Exception:
            continue
        for rel in nombres[:TOPE_ARCHIVOS]:
            f = repo / rel
            try:
                if ahora - f.stat().st_mtime > VENTANA_S:
                    continue
                nuevo = f.read_bytes()
                viejo = git(repo, "show", "HEAD:" + rel, binario=True)
            except Exception:
                continue
            for clase, det in defectos(viejo, nuevo):
                hallazgos.append("%s [%s] %s" % (f, clase, det))
    return hallazgos


def main() -> int:
    try:
        ev = json.loads(sys.stdin.buffer.read().decode("utf-8", "replace") or "{}")
    except Exception:
        return 0
    if ev.get("tool_name") not in ("Bash", "PowerShell"):
        return 0
    h = medir(ev)
    if h:
        print(json.dumps({"decision": "block", "reason": (
            "REESCRITURA QUE CAMBIO BYTES FUERA DEL CAMBIO (leccion 293, medido contra HEAD):\n  - " + "\n  - ".join(h)
            + "\nEl comando reescribio el archivo entero con otro encoding. Restaurarlo (git checkout -- <archivo>, o "
            "deshacer solo esas lineas) y rehacer el cambio con Edit, que preserva los bytes. Si el cambio era a "
            "proposito (un ejemplo de mojibake), commitearlo lo saca del aviso.")}, ensure_ascii=False))
    return 0


def autotest() -> int:
    tmp = Path(tempfile.mkdtemp(prefix="medir-reescritura-"))
    mal = 0
    try:
        repo = tmp / "repo"
        repo.mkdir()
        git(repo, "init", "-q")
        git(repo, "config", "user.email", "autotest@x.test")
        git(repo, "config", "user.name", "autotest")
        doc = "# Telescopio\n\nLa plataforma ecuatorial lleva acentos: rotación, ángulo, año.\nLinea ASCII.\n"
        cita = "# Mojibake a proposito\n\nEl ejemplo es Ã¡ en vez de á.\nOtra linea.\n"
        archivos = {"doc.md": doc, "cita.md": cita, "script.ps1": "# año\nWrite-Host 'hola'\n", "otro.md": doc}
        for k, t in archivos.items():
            (repo / k).write_bytes(t.encode("utf-8"))
        git(repo, "add", "-A")
        git(repo, "commit", "-q", "-m", "base")

        def correr(script=__file__):
            ev = {"hook_event_name": "PostToolUse", "tool_name": "PowerShell", "tool_input": {"command": "x"},
                  "cwd": str(repo)}
            r = subprocess.run([sys.executable, str(script)], input=json.dumps(ev).encode("utf-8"), capture_output=True,
                               env=dict(os.environ, MEDIR_REESCRITURA_REPOS=str(repo)))
            return r.stdout.decode("utf-8", "replace")

        def poner(nombre, data: bytes):
            for k, t in archivos.items():   # todo vuelve a HEAD: cada caso mide UNA cosa
                (repo / k).write_bytes(t.encode("utf-8"))
            (repo / nombre).write_bytes(data)

        casos = (   # (nombre, archivo, bytes, marca esperada o None)
            ("SABOTAJE: acentos dobles (el caso del telescopio)", "doc.md",
             doc.encode("utf-8").decode("cp1252", "replace").encode("utf-8"), "[MOJIBAKE]"),
            ("SABOTAJE: un acento pasado a '?' (el caso de verify-install)", "doc.md",
             doc.replace("rotación", "rotaci?n").encode("utf-8"), "[ASCII]"),
            ("SABOTAJE: BOM agregado (Set-Content utf8 de PS 5.1)", "doc.md", b"\xef\xbb\xbf" + doc.encode("utf-8"),
             "[BOM]"),
            ("CONTROL: un cambio legitimo con acentos bien escritos", "doc.md",
             (doc + "Línea nueva con eñe y acentos: órbita.\n").encode("utf-8"), None),
            ("CONTROL: archivo que CITA mojibake desde HEAD, editado en otra linea", "cita.md",
             cita.replace("Otra linea.", "Otra linea editada.").encode("utf-8"), None),
            ("CONTROL: archivo que no es de texto", "dibujo.png", b"\x89PNG\r\n\x1a\n\xc3\xa1", None),
            ("CONTROL: '?' que reemplaza un texto ASCII (no un acento)", "otro.md",
             doc.replace("Linea ASCII.", "Linea ASCII?").encode("utf-8"), None))
        sanos = {}
        for i, (nombre, arch, data, marca) in enumerate(casos):
            poner(arch, data)
            if arch == "dibujo.png":
                git(repo, "add", "dibujo.png")
            r = correr()
            ok = (marca in r) if marca else ('"block"' not in r)
            sanos[i] = ok
            mal += not ok
            print("%s  %-66s -> %s" % ("ok " if ok else "MAL", nombre, "avisa" if '"block"' in r else "calla"))
        for nombre, viejo, nuevo, i in (
                ("MUTANTE (sin contar mojibake) -> lo ve el sabotaje 1", "if len(mn) > len(mv):", "if False:", 0),
                ("MUTANTE (sin el chequeo del '?') -> lo ve el sabotaje 2", "if preguntas:", "if False:", 1),
                ("MUTANTE (sin el chequeo del BOM) -> lo ve el sabotaje 3",
                 "if nuevo.startswith(BOM) and not viejo.startswith(BOM):", "if False:", 2),
                ("MUTANTE (no resta lo que HEAD ya tenia) -> lo ve el control 5", "if len(mn) > len(mv):",
                 "if len(mn) > 0:", 4)):
            fuente = Path(__file__).read_text(encoding="utf-8")
            if not sanos.get(i):
                ok, r = False, "NO JUZGABLE: su caso no paso sano"
            elif viejo not in fuente:
                ok, r = False, "el mutante NO APLICA (el texto a reemplazar cambio)"
            else:
                m = tmp / ("mutante-%d.py" % i)
                m.write_text(fuente.replace(viejo, nuevo, 1), encoding="utf-8")
                poner(casos[i][1], casos[i][2])
                r = correr(m)
                ok = ('"block"' in r) == (casos[i][3] is None)   # el sabotaje deja de avisar; el control empieza
            mal += not ok
            print("%s  %-66s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE: %s" % r[:160]))
    finally:
        shutil.rmtree(tmp, ignore_errors=True)
    print("medir-reescritura autotest: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    sys.exit(autotest() if sys.argv[1:2] == ["--autotest"] else main())
