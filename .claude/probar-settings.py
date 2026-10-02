"""probar-settings.py -- prueba los COMANDOS de .claude/settings.json como los corre el harness.

Por que existe (2026-10-02, T7 de arquitectura-se): settings.json paso de generado por maquina
(rutas C:\\ absolutas, ignorado) a TRACKEADO con "$CLAUDE_PROJECT_DIR", para que los hooks lleguen
a cualquier clon -- la nube incluida. probar-hooks.ps1 llama a los scripts DIRECTO, asi que nunca
ejercio la linea de comando: un comando roto en settings.json daba verde ahi. Este cruza la misma
frontera que el uso real: Git Bash, 'bash -c "<comando>"', el payload por stdin, la variable puesta.

Medido el 2026-10-02 con claude.exe 2.1.286 (una sonda en un proyecto descartable): en Windows el
harness corre los hooks con /usr/bin/bash de Git (MSYSTEM=MINGW64) y CLAUDE_PROJECT_DIR llega con
barras '/'. Si eso cambia en una version nueva, ESTE es el que lo tiene que ver.

Casos (sabotajes y controles; cada uno reporta QUE linea lo satisfizo):
  1. ningun comando lleva una ruta absoluta de maquina, y cada script nombrado existe
  2. puerta: Edit sobre un proyecto sin declarar -> deny de la PUERTA (llego al codigo)
  3. puerta: Edit fuera de todo proyecto -> pasa en silencio (control positivo)
  4. SABOTAJE: CLAUDE_PROJECT_DIR roto -> la puerta NO pasa en silencio (rc 2: falla cerrado)
  5. guardia: Write sobre un archivo protegido -> deny del guardia
  6. sin PowerShell (la nube): la puerta FRENA y nombra .claude/cascada.sh, que corre y cuya declaracion
     cuenta; sin python ni python3 la puerta sale 2 (falla cerrado); el guardia calla (el ISO no esta);
     traer-perfil SI corre y dice ROJO + add_repo
  7. con PowerShell (la PC): traer-perfil no corre (el perfil lo instala install.ps1)

Uso:  python .claude/probar-settings.py      (sale 1 si algun caso falla; lo llama probar-hooks.ps1)
"""
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import uuid
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[1]
SETTINGS = Path(os.environ.get("PROBAR_SETTINGS") or RAIZ / ".claude" / "settings.json")  # un candidato, antes de instalarlo
malos = 0


def bash_exe() -> str:
    if os.name != "nt":
        return "bash"
    for c in (os.environ.get("SHELL", ""), r"C:\Program Files\Git\bin\bash.exe",
              r"C:\Program Files\Git\usr\bin\bash.exe"):
        if c and c.lower().endswith("bash.exe") and Path(c).exists():
            return c  # nunca shutil.which: en Windows puede devolver el bash de WSL
    sys.exit("[REVENTO] no hay bash de Git: el harness de Windows lo necesita para correr los hooks")


BASH = bash_exe()


def caso(ok: bool, etiqueta: str, evidencia: str):
    global malos
    if ok:
        print("  [OK]   %s\n         llego: %s" % (etiqueta, evidencia[:160].replace("\n", " ")))
    else:
        malos += 1
        print("  [FAIL] %s\n         salida: %s" % (etiqueta, evidencia[:400].replace("\n", " ")))


def comandos():
    hooks = json.loads(SETTINGS.read_text(encoding="utf-8-sig"))["hooks"]
    for evento, grupos in hooks.items():
        for g in grupos:
            for h in g["hooks"]:
                yield evento, g.get("matcher", ""), h["command"]


def cmd_de(script: str, evento: str) -> str:
    for ev, _, c in comandos():
        if ev == evento and script in c:
            return c
    raise SystemExit("[REVENTO] settings.json no tiene %s en %s" % (script, evento))


def dir_bash(p: str) -> str:
    """La carpeta de un ejecutable como la ve Git Bash (C:\\x\\y -> /c/x/y)."""
    d = os.path.dirname(p)
    if os.name == "nt" and len(d) > 1 and d[1] == ":":
        d = "/" + d[0].lower() + d[2:].replace("\\", "/")
    return d


def correr(cmd: str, payload, sin_powershell=False, sin_python=False, estado=None, **extra):
    tmp = Path(tempfile.mkdtemp(prefix="probar-settings-"))
    env = dict(os.environ, CLAUDE_PROJECT_DIR=str(RAIZ).replace("\\", "/"),
               CASCADA_ESTADO_DIR=str(estado or tmp / "estado"), CASCADA_LOG_EXC=str(tmp / "exc.log"))
    env.pop("CLAUDE_CODE_REMOTE", None)
    env.update({k: str(v) for k, v in extra.items()})
    if sin_powershell:
        # lo que tiene la nube: bash, git, grep y un python; ni powershell ni pwsh. sin_python: tampoco python.
        env["PATH"] = "/usr/bin:/bin" + ("" if sin_python else ":" + dir_bash(sys.executable))
    try:
        r = subprocess.run([BASH, "-c", cmd], input=json.dumps(payload or {}), capture_output=True,
                           text=True, encoding="utf-8", errors="replace", env=env, timeout=60)
        return r.returncode, r.stdout + r.stderr
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def ev(evento, tool, **inp):
    return {"hook_event_name": evento, "session_id": "probar-settings-" + uuid.uuid4().hex[:8],
            "tool_name": tool, "tool_input": inp, "cwd": str(RAIZ)}


print("=== probar-settings: los comandos de .claude/settings.json, por la frontera real (%s) ===" % BASH)

# 1. el impacto contra el que se diseno ignorar este archivo: rutas de UNA maquina
for evento, _, c in comandos():
    abs_ = re.search(r"[A-Za-z]:[\\/]|/home/|/Users/", c)
    scripts = re.findall(r"\$CLAUDE_PROJECT_DIR/([^\"' ;]+)", c)
    faltan = [s for s in scripts if not (RAIZ / s).exists()]
    caso(not abs_ and scripts and not faltan, "1. %s: sin ruta de maquina, y su script existe" % evento,
         "%s -> %s" % (c, faltan or abs_ and abs_.group(0) or scripts))

puerta = cmd_de("cascada_puerta.py", "PreToolUse")
guardia = cmd_de("guardia-iso.ps1", "PreToolUse")
perfil = cmd_de("traer-perfil.sh", "SessionStart")
pdp = str(RAIZ / "proyectos" / "ingenieria" / "arquitectura-se" / "PDP.md")

rc, out = correr(puerta, ev("PreToolUse", "Edit", file_path=pdp, old_string="a", new_string="b"))
caso(rc == 0 and '"deny"' in out and "PUERTA DE LA CASCADA" in out,
     "2. puerta: Edit sobre un proyecto sin declarar -> deny", "rc=%d %s" % (rc, out))

afuera = str(Path(tempfile.gettempdir()) / "probar-settings-afuera.txt")
rc, out = correr(puerta, ev("PreToolUse", "Write", file_path=afuera, content="x"))
caso(rc == 0 and not out.strip(), "3. CONTROL: puerta con un Write fuera de todo proyecto -> silencio",
     "rc=%d salida=%r" % (rc, out))

rc, out = correr(puerta, ev("PreToolUse", "Edit", file_path=pdp), CLAUDE_PROJECT_DIR="/no/existe")
caso(rc == 2, "4. SABOTAJE: CLAUDE_PROJECT_DIR roto -> rc 2 (bloquea), nunca 0 en silencio",
     "rc=%d %s" % (rc, out))

prot = json.loads((RAIZ / ".claude" / "protegidos.json").read_text(encoding="utf-8-sig"))["archivos"]
ruta = next(a["ruta"] for a in prot if a.get("se_puede_escribir") is not True)
rc, out = correr(guardia, ev("PreToolUse", "Write", file_path=ruta, content="x"))
caso('"deny"' in out, "5. guardia: Write sobre un archivo protegido -> deny", "rc=%d %s" % (rc, out))

# 6. la nube. Primero la PRECONDICION del entorno simulado: si powershell se cuela por el PATH, los casos de abajo
# miden la PC y dan verde por el motivo equivocado.
rc, out = correr("command -v powershell pwsh; echo PY=$(command -v python || command -v python3)", None,
                 sin_powershell=True)
caso("powershell" not in out.lower() and "PY=/" in out, "6. precondicion: el entorno simulado no tiene PowerShell y si python",
     out.strip())
rc, out = correr(puerta, ev("PreToolUse", "Edit", file_path=pdp, old_string="a", new_string="b"), sin_powershell=True)
caso(rc == 0 and '"deny"' in out and "bash .claude/cascada.sh" in out,
     "6. sin PowerShell (nube): la puerta FRENA y manda a declarar con cascada.sh", "rc=%d %s" % (rc, out))
rc, out = correr('bash "$CLAUDE_PROJECT_DIR/.claude/cascada.sh" arquitectura-se -Necesidad metodo', None,
                 sin_powershell=True)
caso(rc == 0 and "EXIGIDO POR LA PUERTA" in out, "6. sin PowerShell (nube): cascada.sh corre y lista lo exigido",
     "rc=%d %s" % (rc, out))
est = Path(tempfile.mkdtemp(prefix="probar-settings-est-"))
sid = "probar-settings-nube-" + uuid.uuid4().hex[:8]
decl = dict(ev("PreToolUse", "Bash", command="bash .claude/cascada.sh arquitectura-se -Necesidad metodo"), session_id=sid)
correr(puerta, decl, sin_powershell=True, estado=est)
rc, out = correr(puerta, dict(ev("PreToolUse", "Edit", file_path=pdp, old_string="a", new_string="b"), session_id=sid),
                 sin_powershell=True, estado=est)
shutil.rmtree(est, ignore_errors=True)
caso(rc == 0 and "falta LEER" in out and "-Necesidad <a,b>" not in out,
     "6. sin PowerShell (nube): declarar con cascada.sh cuenta (ya no pide declarar, pide leer)", "rc=%d %s" % (rc, out))
rc, out = correr(puerta, ev("PreToolUse", "Edit", file_path=pdp), sin_powershell=True, sin_python=True)
caso(rc == 2 and "falla cerrado" in out, "6. SABOTAJE: sin python ni python3 la puerta sale 2 (falla cerrado), nunca 0",
     "rc=%d %s" % (rc, out))
rc, out = correr(guardia, ev("PreToolUse", "Edit", file_path=pdp), sin_powershell=True)
caso(rc == 0 and not out.strip(), "6. sin PowerShell (nube): el guardia sale 0 sin decir nada (no hay ISO)",
     "rc=%d salida=%r" % (rc, out))

home = tempfile.mkdtemp(prefix="probar-settings-home-")
rc, out = correr(perfil, {"hook_event_name": "SessionStart"}, sin_powershell=True,
                 PERFIL_DIR="/no/existe/perfil-global", CLAUDE_HOME_DIR=home)
shutil.rmtree(home, ignore_errors=True)
caso(rc == 0 and "[ROJO]" in out and "add_repo" in out,
     "6. sin PowerShell (nube): traer-perfil corre, dice ROJO y add_repo, y sale 0 (llega al contexto)",
     "rc=%d %s" % (rc, out))

rc, out = correr(perfil, {"hook_event_name": "SessionStart"}, PERFIL_DIR="/no/existe/perfil-global")
caso(rc == 0 and not out.strip(), "7. CONTROL: con PowerShell (PC) traer-perfil no corre",
     "rc=%d salida=%r" % (rc, out))

print("TODO BIEN" if malos == 0 else "%d caso(s) en FAIL" % malos)
sys.exit(1 if malos else 0)
