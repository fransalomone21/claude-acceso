# -*- coding: utf-8 -*-
"""puerta-lanzador.py -- corre la puerta de la cascada con UNA politica de falla, adentro y afuera del arbol.

POR QUE EXISTE (2026-10-07). La puerta (cascada_puerta.py) es codigo vivo que se edita seguido. Ese dia una edicion
quedo a medias (la llamada a una funcion entro antes que la funcion) y la puerta revento en CADA accion:
  - adentro del arbol el registro la corria directo: un proceso que sale 1 NO bloquea en Claude Code, asi que una
    puerta rota fallaba ABIERTO, en silencio;
  - afuera (perfil-global/hooks/puerta-afuera.py) fallaba CERRADO, pero sin salida de reparacion: negaba tambien la
    edicion que la arreglaba, y la sesion quedo encerrada hasta que Fran corrio un comando a mano.
Misma pieza, dos politicas, y las dos mal. Saltzer y Schroeder (fail-safe defaults): ante la duda se niega, por
PERMISO y no por exclusion -- y la salida de reparacion tiene que quedar abierta siempre, o un freno roto encierra.

LA POLITICA (este archivo es el unico dueno):
  1. La puerta responde (sale 0): lo que diga, tal cual.
  2. La puerta REVIENTA (sale distinto de 0, no existe, o no responde a tiempo) y el evento es PreToolUse:
     se NIEGA, salvo que la accion este en la LISTA DE REPARACION (por permiso, no por exclusion):
       - Edit/Write/NotebookEdit sobre la puerta, el catalogo, la compuerta de fase o este lanzador;
       - un comando git de solo mirar o de restaurar (status, diff, log, show, checkout, restore) que nombre
         alguno de esos archivos;
       - correr alguno de esos .py con --autotest, o compilarlo (py_compile).
  3. Otros eventos (PostToolUse, UserPromptSubmit, SessionStart): falla abierto. Son registro y contexto: lo peor
     es pedir de nuevo una lectura.
ESTE ARCHIVO NO SE EDITA EN CALIENTE sin correr antes su autotest sobre la copia nueva: es la pieza que no tiene
quien la repare. Que compile lo mide --verificar de la puerta en cada arranque.

Uso (lo llama el registro): python puerta-lanzador.py            -> evento por stdin
       autotest:            python puerta-lanzador.py --autotest
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
from pathlib import Path

AQUI = Path(__file__).resolve().parent
PUERTA = AQUI / "cascada_puerta.py"
TIMEOUT = 12

# La lista de reparacion: los archivos de los que depende la puerta, por nombre exacto.
_PIEZAS = r"(cascada_puerta\.py|fase_activa\.py|puerta-lanzador\.py|puerta-afuera\.py|cascada\.json)"
REPARA_ARCHIVO = re.compile(r"[/\\]" + _PIEZAS + r"$", re.I)
REPARA_GIT = re.compile(r"^\s*git(\s+-C\s+\S+)?\s+(status|diff|log|show|checkout|restore)\b[^;&|]*" + _PIEZAS, re.I)
REPARA_PY = re.compile(r"^\s*(\S*python\S*)\s+(-m\s+py_compile\s+)?\S*" + _PIEZAS + r"(\s+--autotest)?\s*$", re.I)


def es_reparacion(tool: str, inp: dict) -> bool:
    if tool in ("Edit", "Write", "NotebookEdit"):
        return bool(REPARA_ARCHIVO.search(str(inp.get("file_path", inp.get("notebook_path", "")))))
    if tool in ("Bash", "PowerShell"):
        cmd = str(inp.get("command", "")).strip().strip('"').replace('"', "")
        # una sola orden: nada encadenado (';', '&&', '||', '|') puede colarse detras de una reparacion
        if re.search(r";|&&|\|\||\||\n", cmd):
            return False
        if REPARA_GIT.search(cmd):
            return True
        m = REPARA_PY.search(cmd)
        return bool(m) and (bool(m.group(2)) or bool(m.group(4)))
    return False


def deny(texto: str):
    print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny",
                                             "permissionDecisionReason": texto}}))


def anotar_revento(ev: dict, error: str, v: str, motivo: str):
    """La caja negra no puede anotar su propia caida: la puerta rota no escribe. La anota el lanzador, en el MISMO
    estado de la sesion (misma regla de nombre que archivo_estado() de la puerta), para que auditar-sesion.py la vea.
    Medido el 2026-10-07: el primer audit de la sesion que revento dijo '0 negadas' -- ciego por construccion."""
    try:
        import tempfile
        import time
        d = Path(os.environ.get("CASCADA_ESTADO_DIR", Path(tempfile.gettempdir()) / "claude-cascada"))
        d.mkdir(parents=True, exist_ok=True)
        sid = re.sub(r"[^A-Za-z0-9_.-]", "_", ev.get("session_id") or "sin-sesion")
        inp = ev.get("tool_input", {}) or {}
        obj = str(inp.get("file_path", inp.get("notebook_path", ""))) or str(inp.get("command", ""))
        with open(d / ("%s.jsonl" % sid), "ab") as fh:
            for e in ({"t": "revento", "error": error[:200]},
                      {"t": "decide", "tool": ev.get("tool_name", ""), "obj": obj[:200], "cwd": ev.get("cwd", ""),
                       "v": v, "motivo": motivo[:200]}):
                e["ts"] = time.time()
                fh.write((json.dumps(e, ensure_ascii=False) + "\n").encode("utf-8"))
    except Exception:
        pass  # el registro nunca frena


def lanzar(raw: bytes, puerta: Path = PUERTA) -> int:
    try:
        ev = json.loads(raw.decode("utf-8-sig") or "{}")
    except ValueError:
        ev = {}
    evento = ev.get("hook_event_name", "")
    error = ""
    if not puerta.exists():
        error = "no existe %s" % puerta
    else:
        try:
            r = subprocess.run([sys.executable, str(puerta)], input=raw, capture_output=True, timeout=TIMEOUT)
            out = r.stdout.decode("utf-8", "replace")
            if r.returncode == 0:
                sys.stdout.write(out)
                return 0
            ultima = (r.stderr.decode("utf-8", "replace").strip().splitlines() or ["(sin stderr)"])[-1]
            error = "salio %d: %s" % (r.returncode, ultima[:200])
        except subprocess.TimeoutExpired:
            error = "no respondio en %d s" % TIMEOUT
        except Exception as e:  # el lanzador no revienta por la puerta: la reporta
            error = "%s: %s" % (type(e).__name__, e)
    if evento != "PreToolUse":
        return 0
    if es_reparacion(ev.get("tool_name", ""), ev.get("tool_input", {}) or {}):
        anotar_revento(ev, error, "pasa", "reparacion con la puerta rota (%s)" % error)
        return 0  # la salida de reparacion: siempre abierta
    anotar_revento(ev, error, "niega", "PUERTA DE LA CASCADA: la puerta REVENTO (%s)" % error)
    deny("PUERTA DE LA CASCADA: la puerta REVENTO (%s). Falla cerrado: no se actua hasta repararla. La salida de "
         "reparacion esta abierta: editar .claude/hooks/cascada_puerta.py o .claude/cascada.json (pasa), "
         "'git -C <raiz> diff .claude/hooks/cascada_puerta.py', 'git -C <raiz> checkout -- "
         ".claude/hooks/cascada_puerta.py' o 'python .claude/hooks/cascada_puerta.py --autotest'. Una orden por "
         "vez, sin encadenar." % error)
    return 0


def autotest() -> int:
    import tempfile
    mal = 0
    tmp = Path(tempfile.mkdtemp(prefix="puerta-lanzador-"))

    def caso(nombre, ok, sal):
        nonlocal mal
        mal += not ok
        print("%s  %-66s -> %s" % ("ok " if ok else "MAL", nombre, "si" if ok else (sal.strip()[:100] or "(silencio)")))

    def correr(puerta_src, ev):
        d = tmp / ("h%d" % len(list(tmp.iterdir())))
        d.mkdir()
        if puerta_src is not None:
            (d / "cascada_puerta.py").write_text(puerta_src, encoding="utf-8")
        import io
        import contextlib
        buf = io.StringIO()
        with contextlib.redirect_stdout(buf):
            lanzar(json.dumps(ev).encode("utf-8"), d / "cascada_puerta.py")
        return buf.getvalue()

    def pre(tool, **inp):
        return {"hook_event_name": "PreToolUse", "session_id": "lanzador", "tool_name": tool, "tool_input": inp}

    sana_niega = 'import json,sys; sys.stdin.read(); print(json.dumps({"hookSpecificOutput":{"permissionDecision":"deny","permissionDecisionReason":"sana"}}))\n'
    sana_pasa = "import sys; sys.stdin.read()\n"
    rota = "import sys\nsys.stdin.read()\nfuncion_que_no_existe()\n"
    sintaxis = "def roto(:\n"
    edit_proy = pre("Edit", file_path="C:/x/proyectos/ingenieria/telescopio/docs/a.md", old_string="a", new_string="b")
    edit_puerta = pre("Edit", file_path="C:/x/claude-acceso/.claude/hooks/cascada_puerta.py", old_string="a", new_string="b")
    caso("CONTROL: puerta sana que niega -> su deny, tal cual", "sana" in correr(sana_niega, edit_proy), "")
    caso("CONTROL: puerta sana que deja pasar -> silencio", correr(sana_pasa, edit_proy).strip() == "", "")
    s = correr(rota, edit_proy)
    caso("puerta que REVIENTA (NameError) + accion comun -> deny", '"deny"' in s and "REVENTO" in s, s)
    s = correr(sintaxis, edit_proy)
    caso("puerta con error de SINTAXIS + accion comun -> deny", '"deny"' in s and "REVENTO" in s, s)
    s = correr(None, edit_proy)
    caso("puerta que NO EXISTE + accion comun -> deny", '"deny"' in s and "no existe" in s, s)
    caso("CONTROL: puerta rota + editar la puerta -> pasa (reparacion)", correr(rota, edit_puerta).strip() == "", "")
    caso("CONTROL: puerta rota + editar cascada.json -> pasa",
         correr(rota, pre("Write", file_path="C:\\x\\.claude\\cascada.json", content="{}")).strip() == "", "")
    for cmd in ["git -C C:/x/claude-acceso checkout -- .claude/hooks/cascada_puerta.py",
                "git diff .claude/hooks/cascada_puerta.py", "python .claude/hooks/cascada_puerta.py --autotest",
                "python -m py_compile .claude/hooks/cascada_puerta.py"]:
        caso("CONTROL: puerta rota + '%s' -> pasa" % cmd[:44], correr(rota, pre("Bash", command=cmd)).strip() == "", "")
    for cmd, por in [("git checkout -- .claude/hooks/cascada_puerta.py; rm -rf proyectos", "encadenado con ';'"),
                     ("git status && echo x > proyectos/ingenieria/telescopio/a.md", "encadenado con '&&'"),
                     ("python .claude/hooks/cascada_puerta.py", "correr la puerta sin --autotest"),
                     ("echo x > .claude/hooks/cascada_puerta.py.bak", "un comando cualquiera que la nombra"),
                     ("python otra-cosa.py --autotest", "autotest de otro archivo")]:
        s = correr(rota, pre("Bash", command=cmd))
        caso("puerta rota + %s -> deny" % por, '"deny"' in s, s)
    caso("puerta rota + Edit de OTRO archivo que se llama parecido -> deny",
         '"deny"' in correr(rota, pre("Edit", file_path="C:/x/docs/cascada_puerta.py.md", old_string="a", new_string="b")), "")
    s = correr(rota, {"hook_event_name": "PostToolUse", "session_id": "l", "tool_name": "Read", "tool_input": {}})
    caso("CONTROL: puerta rota en PostToolUse -> silencio (registro, falla abierto)", s.strip() == "", s)
    # la caida queda en el estado de la sesion (la caja negra no puede anotar su propia caida)
    viejo = os.environ.get("CASCADA_ESTADO_DIR")
    os.environ["CASCADA_ESTADO_DIR"] = str(tmp / "estado")
    try:
        correr(rota, dict(edit_proy, session_id="caida"))
        correr(rota, dict(edit_puerta, session_id="caida"))
    finally:
        if viejo is None:
            os.environ.pop("CASCADA_ESTADO_DIR", None)
        else:
            os.environ["CASCADA_ESTADO_DIR"] = viejo
    f = tmp / "estado" / "caida.jsonl"
    evs = [json.loads(l) for l in f.read_text(encoding="utf-8").splitlines()] if f.exists() else []
    caso("la caida queda ANOTADA en el estado: revento + niega + la reparacion que paso",
         [e.get("t") for e in evs].count("revento") == 2 and any(e.get("v") == "niega" and "REVENTO" in e.get("motivo", "") for e in evs)
         and any(e.get("v") == "pasa" and "reparacion" in e.get("motivo", "") for e in evs), str(evs)[:200])
    print("autotest: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    if sys.argv[1:2] == ["--autotest"]:
        sys.exit(autotest())
    sys.exit(lanzar(sys.stdin.buffer.read()))
