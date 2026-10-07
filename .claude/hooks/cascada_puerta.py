#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
cascada_puerta.py -- T11 de arquitectura-se: LA CASCADA QUE SE EJECUTA (2026-10-02, pedido de Fran tras BLACK (110)).

Medido: de 113 entradas sesion x proyecto desde el 1/9, UNA leyo ESTADO + HANDOFF + PDP + contrato antes de su
primera accion; BLACK corrio su apertura 7 de 28 veces. La cascada estaba escrita, inyectada y en mayusculas, y no se
ejecutaba: "el mejor arquitecto del mundo que se olvida el libro en la casa" (Fran). Esto no la escribe mas fuerte:
es una PUERTA POR PERMISO (Saltzer) que mide el efecto -- el texto entro al contexto con la herramienta Read -- antes
de dejar actuar. Diseno: proyectos/ingenieria/arquitectura-se/docs/t11-cascada-obligatoria.md.

Un solo archivo, una sola implementacion de "que se exige":
  (hook PreToolUse)   Edit/Write/NotebookEdit/Bash/PowerShell que nombra un proyecto o dispara un concepto: DENY
                      con la lista exacta de lo que falta leer/correr, o silencio si esta todo.
  (hook PostToolUse)  Read -> registra el rango leido; Bash/PowerShell -> registra cascada.ps1 -Necesidad/-Excepcion
                      (o .claude/cascada.sh, donde no hay PowerShell: la nube) y los comandos de apertura.
  (hook SessionStart) compact -> lo leido antes deja de contar (un resumen no es una lectura).
  python cascada_puerta.py --exige <proyecto> [--necesidad a,b]   lo que se exige, con rangos (lo usa cascada.ps1)
  python cascada_puerta.py --verificar                            el catalogo contra el disco (rojo = exit 1)
  python cascada_puerta.py --autotest                             sabotajes en rojo + controles positivos

Falla CERRADO: un catalogo roto da deny (salvo para arreglar el catalogo o esta puerta, y para lecturas puras).
Se desinstala con .claude\\desinstalar-hooks.ps1. Sin acentos en la salida: la consola la lee como cp1252.
"""
from __future__ import annotations

import json
import os
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path

RAIZ = Path(os.environ.get("CASCADA_RAIZ") or Path(__file__).resolve().parents[2])
CATALOGO = Path(os.environ.get("CASCADA_CATALOGO") or RAIZ / ".claude" / "cascada.json")
ESTADO_DIR = Path(os.environ.get("CASCADA_ESTADO_DIR", Path(tempfile.gettempdir()) / "claude-cascada"))
LOG_EXC = Path(os.environ.get("CASCADA_LOG_EXC", Path.home() / ".claude" / "hooks" / "cascada-excepciones.log"))
PATRON_PROY = re.compile(r"proyectos[/\\]+(ingenieria|documentos|seguimiento)[/\\]+([A-Za-z0-9_.-]+)")
ACCIONES = {"Edit", "Write", "NotebookEdit", "Bash", "PowerShell"}
MAX_LINEAS_LECTURA = 2000      # lo que Read entrega sin limit
MAX_CHARS_RANGO = 60000        # un rango exigido tiene que entrar en UNA lectura
TOPE_SALIDA = 8500             # el harness corta a 10 000 por hook (T1)

# Lectura pura: empieza con una lectura conocida Y no encadena nada fuera de comillas. Todo camino de salida temprana
# de un freno es un fail-open hasta que se pruebe: un "Get-Content x; Remove-Item y" NO es lectura.
LECTURA = re.compile(
    r"""^\s*(&\s*)?["']?(\.[\\/])?("""
    r"""Get-Content|gc|cat|type|head|tail|less|more|sed\s+-n|Select-String|sls|grep|rg|ls|dir|Get-ChildItem|gci|"""
    r"""Get-Item|Test-Path|wc|git\s+(log|status|diff|show|rev-parse|ls-files|blame|branch)\b|"""
    r"""python\s+\S*cascada_puerta\.py\s+--(exige|estado|verificar)|"""
    r"""((ba)?sh\s+)?([\w.:\-]+[\\/])*cascada\.(ps1|sh)|([\w.:\-]+[\\/])*abrir-sesion\.ps1)""", re.I)
FILTRO = re.compile(r"^\s*(Select-Object|select|Select-String|sls|Where-Object|where|Measure-Object|measure|"
                    r"Sort-Object|sort|Format-\w+|ft|fl|Out-String|head|tail|grep|wc|uniq|findstr|more|less)\b", re.I)
REDIRS_INOCUAS = re.compile(r"\s[12]?>\s*(\$null|/dev/null|&1)", re.I)
# Los archivos de la propia puerta nunca los frena ella: es la salida de reparacion.
REPARACION = re.compile(r"[/\\]\.claude[/\\](hooks[/\\]cascada_puerta\.py|cascada\.json)$", re.I)


# --------------------------------------------------------------------------------------------------- utilidades
def norm(p) -> str:
    return os.path.normcase(os.path.normpath(os.path.abspath(os.path.expanduser(str(p)))))


def sin_comillas(s: str) -> str:
    """El comando con el contenido entre comillas en blanco: un '|' adentro de un patron no es un pipe."""
    out, q = [], None
    for ch in s:
        if q:
            out.append(" " if ch != q else ch)
            if ch == q:
                q = None
        else:
            if ch in "'\"":
                q = ch
            out.append(ch)
    return "".join(out)


def es_lectura_pura(cmd: str) -> bool:
    c = REDIRS_INOCUAS.sub(" ", sin_comillas(cmd))
    # git add/commit/push REGISTRAN lo que ya paso por la puerta; su mensaje NOMBRA proyectos sin tocarlos (un
    # guardia por patron de texto frena el texto que solo habla de lo protegido: lo dice chequeo-de-trabajo).
    if re.match(r"^\s*git\s+(add|commit|push)\b", c) and not re.search(r";|&&|\|\||\|", c):
        return True
    if not LECTURA.match(c):
        return False
    if re.search(r";|&&|\|\||>|`|\$\(|\n", c):
        return False
    partes = c.split("|")
    return all(FILTRO.match(p) for p in partes[1:])


def cargar_catalogo() -> dict:
    return json.loads(CATALOGO.read_text(encoding="utf-8"))


def proyectos_del_disco() -> dict:
    out = {}
    base = RAIZ / "proyectos"
    if base.is_dir():
        for nat in base.iterdir():
            if nat.is_dir():
                for p in nat.iterdir():
                    if p.is_dir():
                        out[p.name] = p
    return out


def resolver_proyecto(nombre: str):
    disco = proyectos_del_disco()
    if nombre in disco:
        return nombre
    cand = [n for n in disco if nombre.lower() in n.lower()]
    return cand[0] if len(cand) == 1 else None


def memoria_dir() -> Path:
    slug = re.sub(r"[:\\/]", "-", str(RAIZ))
    return Path.home() / ".claude" / "projects" / slug / "memory"


def handoff_de(p: Path):
    if (p / "HANDOFF.md").exists():
        return p / "HANDOFF.md"
    for h in sorted(p.rglob("HANDOFF.md")):
        return h
    return None


def expandir(ruta: str, proy: Path | None):
    if "{handoff}" in ruta:
        return handoff_de(proy) if proy else None
    if ("{proy}" in ruta or "{nat}" in ruta) and proy is None:
        return None
    r = ruta.replace("{memoria}", str(memoria_dir()))
    if proy is not None:
        r = r.replace("{proy}", str(proy)).replace("{nat}", proy.parent.name)
    r = os.path.expanduser(r)
    if os.path.isabs(r):
        return Path(r)
    # En la PC perfil-global vive ADENTRO del arbol (repo propio, ignorado); en la nube, al LADO (/home/user/
    # perfil-global, lo clona traer-perfil.sh). Sin esto, todo lo de perfil-global/ daba NO EXISTE en la nube y la
    # puerta lo salteaba en silencio: una sesion que declaraba 'diseno' no leia NASA ni Rechtin (T7, 2026-10-02).
    if re.match(r"perfil-global[/\\]", r) and not (RAIZ / r).exists():
        afuera = Path(os.environ.get("PERFIL_DIR") or RAIZ.parent / "perfil-global") / re.sub(r"^perfil-global[/\\]", "", r)
        if afuera.exists():
            return afuera
    return RAIZ / r


def rango(path: Path, spec: dict):
    """(a, b, motivo) 1-based inclusivo; None si la seccion no existe."""
    lineas = path.read_text(encoding="utf-8", errors="replace").splitlines()
    n = max(1, len(lineas))
    tope = spec.get("tope")
    if "vista_h2" in spec:
        k, vistos, fin = spec["vista_h2"], 0, n
        for i, l in enumerate(lineas):
            if l.startswith("## "):
                vistos += 1
                if vistos == k:
                    fin = i
                    break
        a, b = 1, max(1, fin)
    elif "desde" in spec:
        a = next((i + 1 for i, l in enumerate(lineas) if re.search(spec["desde"], l)), None)
        if a is None:
            return None
        hasta = re.compile(spec.get("hasta", r"^## "))
        b = next((i for i in range(a, len(lineas)) if hasta.search(lineas[i])), len(lineas))
        b = max(a, b)
    else:
        a, b = 1, n
    if tope and b - a + 1 > tope:
        b = a + tope - 1
    return a, b


# ------------------------------------------------------------------------------------------- lo que se exige
def exigido(cat: dict, proyecto: str | None, declaradas, conceptos):
    """Lista de items {ruta, a, b, por} y lista de comandos {sub, por}. Une rangos del mismo archivo."""
    items, comandos, notas = [], [], []
    proy = proyectos_del_disco().get(proyecto) if proyecto else None
    entrada = cat.get("proyectos", {}).get(proyecto, {}) if proyecto else {}

    def agregar(spec, por):
        p = expandir(spec["ruta"], proy)
        if p is None or not p.exists():
            if p is not None and "{proy}" not in spec["ruta"] and "{handoff}" not in spec["ruta"]:
                notas.append("NO EXISTE: %s (%s) -- el catalogo esta desactualizado" % (p, por))
            return
        s = dict(spec)
        if proy is not None and spec["ruta"].startswith("{proy}/"):
            s.update(entrada.get("vistas", {}).get(spec["ruta"][len("{proy}/"):], {}))
        r = rango(p, s)
        if r is None:
            notas.append("SECCION NO ENCONTRADA: %s desde /%s/ (%s)" % (p, s.get("desde"), por))
            r = (1, min(len(p.read_text(encoding="utf-8", errors="replace").splitlines()) or 1, 300))
        items.append({"ruta": norm(p), "ver": str(p), "a": r[0], "b": r[1], "por": por})

    if proy is not None:
        for spec in cat.get("base", []):
            agregar(spec, "base: " + spec.get("por", ""))
        # Los REQUISITOS del proyecto son base: es el papel que define el proyecto (Fran, 2026-10-07). Nueve sesiones
        # del telescopio disenaron sin un documento de requisitos y nada lo pedia: 'diseno' exigia indices y skills,
        # y un {proy}/... ausente se salteaba en silencio (agregar, arriba). Declarado y ausente NIEGA -- falla
        # cerrado --, salvo la accion que lo escribe (pre). Que un proyecto que disena lo declare: --verificar.
        req = entrada.get("requisitos")
        if req:
            pr = Path(req) if os.path.isabs(req) else proy / req
            if pr.exists():
                agregar({"ruta": str(pr)}, "base: los requisitos del proyecto (se disena contra esto)")
            else:
                notas.append("SIN REQUISITOS: %s -- el proyecto declara su documento de requisitos y no existe. Lo "
                             "primero es escribirlo (la puerta deja escribir ese archivo y el registro; hasta "
                             "entonces NIEGA todo Bash y PowerShell sobre el proyecto: mirar con Read, Glob y Grep; "
                             "apenas exista pasa a ser base, y se lee ENTERO con Read antes de la accion siguiente)"
                             % norm(pr))
        for c in entrada.get("comandos", []):
            comandos.append({"sub": c, "por": "apertura de " + proyecto})
        necs = list(dict.fromkeys(list(entrada.get("necesidades", [])) + list(declaradas or [])))
        for n in necs:
            nd = cat.get("necesidades", {}).get(n)
            if nd is None:
                notas.append("NECESIDAD DESCONOCIDA: %s" % n)
                continue
            for spec in nd.get("leer", []):
                agregar(spec, "necesidad %s: %s" % (n, spec.get("por", "")))
    for c in conceptos or []:
        cd = cat.get("conceptos", {}).get(c, {})
        for spec in cd.get("leer", []):
            agregar(spec, "concepto %s: %s" % (c, spec.get("por", "")))
        for sub in cd.get("comandos", []):
            comandos.append({"sub": sub, "por": "concepto " + c})
    # unir: mismo archivo -> se exige la union de rangos (se guardan por separado, se chequean por separado)
    vistos, unicos = set(), []
    for it in items:
        k = (it["ruta"], it["a"], it["b"])
        if k not in vistos:
            vistos.add(k)
            unicos.append(it)
    return unicos, comandos, notas


def conceptos_de(cat: dict, tool: str, inp: dict):
    cmd = str(inp.get("command", "")) if tool in ("Bash", "PowerShell") else ""
    arch = str(inp.get("file_path", inp.get("notebook_path", ""))) if tool in ("Edit", "Write", "NotebookEdit") else ""
    out = []
    for nombre, cd in cat.get("conceptos", {}).items():
        if cmd and cd.get("comando") and re.search(cd["comando"], cmd):
            out.append(nombre)
        elif arch and cd.get("archivo") and re.search(cd["archivo"], arch):
            out.append(nombre)
    return out


def locales_de(cat: dict):
    """Las carpetas LOCALES de cada proyecto, fuera del arbol (el material de una materia en el Escritorio). La mas
    larga primero: 'Software de Vuelo/TP Cohete de Agua' es de cohete-de-agua, no de software-de-vuelo.
    2026-10-02 (leccion 331): la puerta solo veia proyectos/<nat>/<p>, y un ejercicio de Software de Vuelo se
    escribio en Documentos sin que nada frenara: la ruta buena estaba en el contrato, que nadie leyo."""
    out = []
    for p, ent in cat.get("proyectos", {}).items():
        for loc in ent.get("locales", []):
            out.append((norm(loc), p))
    return sorted(out, key=lambda x: -len(x[0]))


def _cola_local(n: str) -> str:
    """La ruta sin el HOME: un comando la nombra con ~, $HOME, $env:USERPROFILE o entera."""
    h = norm(Path.home())
    return n[len(h):].lstrip("\\/") if n.startswith(h) else n


def proyecto_de(tool: str, inp: dict, cwd: str, cat: dict | None = None):
    """De la RUTA del archivo (Edit/Write: nunca del contenido) o del COMANDO; si no, del cwd. Primero el arbol
    (proyectos/<nat>/<p>), despues las carpetas locales que declara el catalogo."""
    if tool in ("Edit", "Write", "NotebookEdit"):
        textos = [str(inp.get("file_path", inp.get("notebook_path", "")))]
    else:
        textos = [str(inp.get("command", ""))]
    textos.append(str(cwd or ""))
    disco = proyectos_del_disco()
    for t in textos:
        m = PATRON_PROY.search(t.replace("\\\\", "\\"))
        if m and m.group(2) in disco:
            return m.group(2)
    # Un COMANDO puede llegar al proyecto sin nombrar 'proyectos/<nat>/<p>' de corrido (medido el 2026-10-07, tres
    # agujeros): 'cd .../proyectos/ingenieria && echo > telescopio/x', la ruta partida con comillas, y un comodin
    # 'proyectos/ing*/telescopio'. Sin comillas se reintenta el patron; y si el comando nombra 'proyectos', basta el
    # nombre de un proyecto como SEGMENTO de ruta ('telescopio/'). Lo construido con variables sigue sin verse: la
    # capa que lo mide es el efecto (git status del proyecto: 'AL DIA' de cascada.ps1), no esta.
    if tool in ("Bash", "PowerShell"):
        t = textos[0].replace("'", "").replace('"', "").replace("\\\\", "\\")
        m = PATRON_PROY.search(t)
        if m and m.group(2) in disco:
            return m.group(2)
        if re.search(r"(?i)\bproyectos\b", t):
            for n in sorted(disco, key=len, reverse=True):
                if re.search(r"(?<![\w.-])" + re.escape(n) + r"[/\\]", t):
                    return n
    locs = locales_de(cat or {})
    for i, t in enumerate(textos):
        if not t:
            continue
        es_ruta = tool in ("Edit", "Write", "NotebookEdit") or i == len(textos) - 1
        tn = norm(t) if es_ruta else t.lower().replace("/", "\\")
        for loc, p in locs:
            if p not in disco:
                continue
            if es_ruta and (tn == loc or tn.startswith(loc + os.sep)):
                return p
            if not es_ruta and _cola_local(loc) in tn:
                return p
    return None


def inferidos_de(cat: dict, texto: str):
    """Que proyectos NOMBRA el pedido de Fran, por las 'senales' de cada uno en el catalogo. La necesidad se
    reconoce en el PEDIDO, no en la primera ruta que se toca: una sesion que clasifica 'sin proyecto' nunca toca
    una ruta del arbol y la puerta no se enteraba (2026-10-02, leccion 331)."""
    out = []
    for p, ent in cat.get("proyectos", {}).items():
        for s in ent.get("senales", []):
            m = re.search(s, texto or "", re.I)
            if m:
                out.append((p, m.group(0)))
                break
    return out


# ------------------------------------------------------------------------------------------- estado de sesion
def archivo_estado(sid: str) -> Path:
    return ESTADO_DIR / ("%s.jsonl" % re.sub(r"[^A-Za-z0-9_.-]", "_", sid or "sin-sesion"))


def _candado(fh, tomar: bool):
    """Candado del SO sobre el byte 0 del .lock: se suelta solo si el proceso muere. Sin candado en ~2 s se escribe
    igual: un renglon pisado hace que la puerta frene de mas (falla cerrado), nunca que deje pasar."""
    if os.name == "nt":
        import msvcrt
        fh.seek(0)
        if not tomar:
            try:
                msvcrt.locking(fh.fileno(), msvcrt.LK_UNLCK, 1)
            except OSError:
                pass
            return
        for _ in range(200):
            try:
                msvcrt.locking(fh.fileno(), msvcrt.LK_NBLCK, 1)
                return
            except OSError:
                time.sleep(0.01)
    else:
        import fcntl
        fcntl.flock(fh.fileno(), fcntl.LOCK_EX if tomar else fcntl.LOCK_UN)


def anotar(sid: str, ev: dict):
    # Un hook por llamada, y las llamadas en paralelo corren hooks en paralelo. En Windows el modo "a" no es atomico
    # entre procesos (busca el final y despues escribe): dos renglones se pisan y una lectura se pierde. Medido el
    # 2026-10-02 en uso real (6 Read en paralelo, 2 renglones pisados) y en el autotest (1057 de 1200 sin candado).
    ESTADO_DIR.mkdir(parents=True, exist_ok=True)
    ev["ts"] = time.time()
    f = archivo_estado(sid)
    with open(str(f) + ".lock", "a+b") as lk:
        _candado(lk, True)
        try:
            with open(f, "ab") as fh:
                fh.write((json.dumps(ev, ensure_ascii=False) + "\n").encode("utf-8"))
        finally:
            _candado(lk, False)


def estado(sid: str) -> dict:
    st = {"lecturas": {}, "declaradas": {}, "excepciones": {}, "comandos": [], "inferidos": {}}
    f = archivo_estado(sid)
    if not f.exists():
        return st
    for linea in f.read_text(encoding="utf-8", errors="replace").splitlines():
        try:
            ev = json.loads(linea)
        except Exception:
            continue
        t = ev.get("t")
        if t == "reset":
            st["lecturas"] = {}
        elif t == "lee":
            st["lecturas"].setdefault(ev["ruta"], []).append((ev["a"], ev["b"]))
        elif t == "corre":
            d, k = ev["delta"], ev["desde"]
            st["lecturas"][ev["ruta"]] = [(x if x < k else x + d, y if y < k else y + d)
                                          for x, y in st["lecturas"].get(ev["ruta"], [])]
        elif t == "declara":
            st["declaradas"].setdefault(ev["proy"], set()).update(ev.get("nec", []))
        elif t == "excepcion":
            st["excepciones"][ev["proy"]] = ev.get("motivo", "")
        elif t == "cmd":
            st["comandos"].append(ev["cmd"])
        elif t == "infiere":
            st["inferidos"].setdefault(ev["proy"], ev.get("por", ""))
    return st


def cubierto(intervalos, a: int, b: int) -> bool:
    pos = a
    for x, y in sorted(intervalos):
        if x > pos:
            break
        pos = max(pos, y + 1)
        if pos > b:
            return True
    return pos > b


# ---------------------------------------------------------------------------------------------------- hooks
def rel(p: str) -> str:
    r = str(RAIZ)
    return p[len(r) + 1:] if p.lower().startswith(r.lower()) else p


def entrada() -> str:
    """El comando que declara, segun lo que hay en ESTA maquina: el mismo gate por capacidad que settings.json. En la
    nube no hay PowerShell, y pedir '.\\cascada.ps1' ahi es un freno sin salida."""
    import shutil
    return ".\\cascada.ps1" if shutil.which("powershell") else "bash .claude/cascada.sh"


def menu(cat: dict) -> str:
    return "\n".join("    %-19s %s" % (n, d.get("que", "")) for n, d in cat.get("necesidades", {}).items())


def deny(texto: str):
    if len(texto) > TOPE_SALIDA:
        texto = texto[:TOPE_SALIDA] + "\n  ... (cortado: correr la CLI --exige para la lista entera)"
    print(json.dumps({"hookSpecificOutput": {"hookEventName": "PreToolUse", "permissionDecision": "deny",
                                             "permissionDecisionReason": texto}}))
    return 0


def pre(ev: dict) -> int:
    tool, inp = ev.get("tool_name", ""), ev.get("tool_input", {}) or {}
    if tool not in ACCIONES:
        return 0
    arch = str(inp.get("file_path", inp.get("notebook_path", "")))
    if arch and REPARACION.search(arch.replace("/", "\\")):
        return 0
    cmd = str(inp.get("command", ""))
    if tool in ("Bash", "PowerShell"):
        try:
            registrar_comando(ev.get("session_id", ""), cmd)
        except Exception:
            pass
        if es_lectura_pura(cmd):
            return 0
    try:
        cat = cargar_catalogo()
    except Exception as e:  # falla CERRADO: sin catalogo no se sabe que exigir
        return deny("PUERTA DE LA CASCADA (T11): el catalogo .claude/cascada.json no se puede leer (%s). Sin "
                    "catalogo no se sabe que exigir, y la puerta falla cerrado. Arreglarlo (editarlo no lo frena "
                    "nadie) o, si hay que salir ya: .claude\\desinstalar-hooks.ps1" % e)
    proyecto = proyecto_de(tool, inp, ev.get("cwd", ""), cat)
    directo = bool(proyecto)   # la accion TOCA el proyecto (ruta, comando o cwd), no solo lo nombra el pedido
    conceptos = conceptos_de(cat, tool, inp)
    sid = ev.get("session_id", "")
    st = estado(sid)
    if not proyecto:
        # El pedido nombro un proyecto (UserPromptSubmit) y esta accion no cae en ninguno: manda el pedido. Sin
        # esto, guardar "en mis documentos" un ejercicio de una materia pasaba sin cascada (leccion 331).
        pend_inf = [p for p in st["inferidos"] if p not in st["excepciones"]]
        sin_decl = [p for p in pend_inf if p not in st["declaradas"]]
        if sin_decl or pend_inf:
            proyecto = (sin_decl or pend_inf)[0]
    if not proyecto and not conceptos:
        return 0
    faltan, cmds_faltan, notas = [], [], []
    if proyecto and proyecto not in st["excepciones"]:
        if proyecto not in st["declaradas"]:
            porque = ("\nEl PEDIDO de Fran lo nombra (senal '%s'): el contrato dice donde vive lo local y como se "
                      "trabaja, aunque sea un ejercicio de diez minutos." % st["inferidos"][proyecto]
                      if proyecto in st["inferidos"] else "")
            return deny(
                "PUERTA DE LA CASCADA (T11): vas a actuar sobre '%s' sin haber declarado la NECESIDAD.%s\n"
                "Clasifica el pedido de Fran (puede ser mas de una) y corre:\n"
                "    %s %s -Necesidad <a,b>\n  Necesidades:\n%s\n"
                "Despues lee con Read lo que imprima, con los rangos que diga. Solo si de verdad no corresponde: "
                "%s %s -Excepcion \"motivo\" (queda registrada)." % (proyecto, porque, entrada(), proyecto, menu(cat),
                                                                     entrada(), proyecto))
        it, cm, nt = exigido(cat, proyecto, st["declaradas"][proyecto], [])
        faltan += it
        cmds_faltan += cm
        notas += nt
    if conceptos:
        it, cm, nt = exigido(cat, None, [], conceptos)
        faltan += it
        cmds_faltan += cm
        notas += nt
    pend = [x for x in faltan if not cubierto(st["lecturas"].get(x["ruta"], []), x["a"], x["b"])]
    hechos = " || ".join(c.replace("\\", "/").lower() for c in st["comandos"])
    cpend = [c for c in cmds_faltan if c["sub"].lower() not in hechos]
    if any(n.startswith("NECESIDAD DESCONOCIDA") for n in notas):
        cpend.append({"sub": "%s %s -Necesidad <una del menu>" % (entrada(), proyecto), "por": "declarada una que no existe"})
    # Un exigido que NO EXISTE niega: antes solo se anotaba y, sin otra cosa pendiente, la puerta salia 0 -- un
    # return temprano que fallaba abierto en silencio (Saltzer). En la nube sin perfil eso salteaba las skills y las
    # fichas enteras. Lo legitimo no lo choca: en la PC --verificar ya da rojo en el arranque si el catalogo apunta
    # a un archivo que no esta.
    no_existe = [n for n in notas if n.startswith("NO EXISTE")]
    # SIN REQUISITOS niega todo menos ESCRIBIR ese archivo -- la unica salida, y tiene que estar abierta -- y el
    # registro del proyecto (ESTADO, HANDOFF, PDP): ahi se anota que faltan, y frenar el checkpoint empujaria a
    # saltearlo (un freno con falsos positivos es menos seguro, Saltzer). Lo que se frena es DISENAR sin requisitos.
    destino = norm(arch) if arch else ""
    # Y solo frena lo que TOCA el proyecto: si el proyecto sale del PEDIDO (leccion 331), la accion es de otra cosa
    # -- el metodo, otra carpeta -- y frenarla por los requisitos de un proyecto ajeno es un falso positivo (medido
    # en la sesion que lo construyo: no dejaba correr el autotest de esta misma puerta).
    registro = bool(arch) and os.path.basename(destino) in ("estado_actual.md", "handoff.md", "pdp.md")
    no_existe += [n for n in notas if n.startswith("SIN REQUISITOS: ") and directo and not registro
                  and n.split(": ", 1)[1].split(" -- ")[0] != destino]
    if not pend and not cpend and not no_existe:
        return 0
    lin = ["PUERTA DE LA CASCADA (T11): antes de esta accion (%s%s) falta LEER con la herramienta Read:" % (
        "proyecto " + proyecto if proyecto else "", ("; conceptos " + ", ".join(conceptos)) if conceptos else "")]
    for x in pend:
        lin.append("  - %s  offset=%d limit=%d   (%s)" % (rel(x["ver"]), x["a"], x["b"] - x["a"] + 1, x["por"][:90]))
    for c in cpend:
        lin.append("  - CORRER: %s   (%s)" % (c["sub"], c["por"]))
    for n in notas:
        lin.append("  ! " + n)
    if no_existe:
        lin.append("Un archivo EXIGIDO que no existe NIEGA (falla cerrado). Si es de ~/.claude o de perfil-global: "
                   "falta el libro -> bash .claude/nube/traer-perfil.sh (regla 16). Si no: corregir .claude/cascada.json "
                   "(editarlo no lo frena la puerta).")
    lin.append("Leer entero el rango (se puede en varias lecturas). La accion se reintenta despues.")
    return deny("\n".join(lin))


DECL = re.compile(r"cascada\.(?:ps1|sh)\W+([A-Za-z0-9_.-]+)(.*)", re.I | re.S)


def post(ev: dict) -> int:
    tool, inp, sid = ev.get("tool_name", ""), ev.get("tool_input", {}) or {}, ev.get("session_id", "")
    if tool == "Read":
        fp = inp.get("file_path")
        if not fp or inp.get("pages"):
            return 0
        a = max(1, int(inp.get("offset") or 1))
        b = a + int(inp.get("limit") or MAX_LINEAS_LECTURA) - 1
        anotar(sid, {"t": "lee", "ruta": norm(fp), "a": a, "b": b})
        return 0
    if tool in ("Edit", "Write"):
        # Lo que la sesion ESCRIBE ya esta en su contexto: cuenta como leido. Y una edicion corre las lineas de
        # abajo, asi que lo leido antes se desplaza con ella. Medido en la 1.a sesion real: agregar 20 lineas al
        # ESTADO agrando su vista y la puerta pidio leer lo que la sesion acababa de escribir (falso positivo).
        fp = inp.get("file_path")
        if not fp or not os.path.exists(fp):
            return 0
        lineas = Path(fp).read_text(encoding="utf-8", errors="replace").splitlines()
        if tool == "Write":
            anotar(sid, {"t": "lee", "ruta": norm(fp), "a": 1, "b": max(1, len(lineas))})
            return 0
        nuevo, viejo = str(inp.get("new_string", "")), str(inp.get("old_string", ""))
        texto = "\n".join(lineas)
        i = texto.find(nuevo) if nuevo else -1
        if i < 0 or inp.get("replace_all"):
            return 0
        desde = texto.count("\n", 0, i) + 1
        n_nuevo = nuevo.count("\n") + 1
        delta = n_nuevo - (viejo.count("\n") + 1)
        if delta:
            anotar(sid, {"t": "corre", "ruta": norm(fp), "desde": desde, "delta": delta})
        anotar(sid, {"t": "lee", "ruta": norm(fp), "a": desde, "b": desde + n_nuevo - 1})
        return 0
    if tool not in ("Bash", "PowerShell"):
        return 0
    registrar_comando(sid, str(inp.get("command", "")))
    return 0


def registrar_comando(sid: str, cmd: str):
    """Declaracion, excepcion y comandos de apertura. Se llama en PreToolUse Y en PostToolUse: medido en la primera
    sesion real, un cascada.ps1 que sale con codigo 1 (ESTADO atrasado) NO dispara PostToolUse, y la declaracion se
    perdia. El autotest llamaba al hook directo y no podia verlo: no cruzaba la misma frontera que el uso real.
    Solo cuenta una INVOCACION (un segmento del comando que EMPIEZA por el script), no un texto que lo nombra: si no,
    un 'echo abrir-sesion' o un script que edita este archivo satisfacian a la puerta."""
    # Se parte por los separadores que estan FUERA de comillas: un motivo con ';' adentro partia el comando y la
    # excepcion no quedaba registrada (medido en la 1.a sesion real).
    blanco, cortes, k = sin_comillas(cmd), [0], 0
    for m in re.finditer(r";|&&|\|\||\n", blanco):
        cortes += [m.start(), m.end()]
    cortes.append(len(cmd))
    segmentos = [cmd[cortes[i]:cortes[i + 1]] for i in range(0, len(cortes) - 1, 2)]
    for seg in segmentos:
        if re.match(r"""\s*(&\s*)?((ba)?sh\s+)?["']?[\w.:\\/\-]*(abrir-sesion\.ps1|cascada\.(ps1|sh))\b""", seg, re.I):
            registrar_invocacion(sid, seg)


def registrar_invocacion(sid: str, cmd: str):
    m = DECL.search(cmd)
    if m:
        proy = resolver_proyecto(m.group(1))
        resto = m.group(2)
        if proy:
            n = re.search(r"-Necesidad\s+[\"']?([A-Za-z-]+(?:\s*,\s*[A-Za-z-]+)*)", resto)
            if n:
                necs = [x.strip().lower() for x in n.group(1).split(",") if x.strip()]
                anotar(sid, {"t": "declara", "proy": proy, "nec": necs})
            e = re.search(r"-Excepcion\s+[\"']([^\"']+)[\"']", resto)
            if e:
                anotar(sid, {"t": "excepcion", "proy": proy, "motivo": e.group(1)})
                LOG_EXC.parent.mkdir(parents=True, exist_ok=True)
                with open(LOG_EXC, "a", encoding="utf-8") as fh:
                    fh.write("%s\t%s\t%s\t%s\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), sid, proy, e.group(1)))
    if re.search(r"abrir-sesion|cascada\.(ps1|sh)", cmd, re.I):
        anotar(sid, {"t": "cmd", "cmd": cmd.replace("\\", "/")})


def prompt(ev: dict) -> int:
    """UserPromptSubmit: reconoce en el PEDIDO que proyecto toca, lo anota (la puerta lo exige desde ahi) y lo dice
    en el contexto antes de que la sesion decida nada."""
    cat = cargar_catalogo()
    sid = ev.get("session_id", "")
    st = estado(sid)
    nuevos = []
    for p, por in inferidos_de(cat, str(ev.get("prompt", ""))):
        if p not in st["inferidos"]:
            anotar(sid, {"t": "infiere", "proy": p, "por": por})
        if p not in st["declaradas"] and p not in st["excepciones"]:
            nuevos.append((p, por))
    if nuevos:
        print("CASCADA: el pedido toca %s. Antes de actuar (escribir, guardar, correr), aunque sea un ejercicio "
              "chico: %s %s -Necesidad <a,b> y leer lo que imprima; donde se guarda lo local lo dice su contrato. "
              "La puerta lo exige. Hasta declararla NIEGA todo Bash, PowerShell, Write y Edit, AUNQUE NO TOQUEN el "
              "proyecto (la senal es el pedido, no la ruta): esa es la PRIMERA llamada, SOLA, sin nada en paralelo; "
              "mirar con Read, Glob y Grep si pasa (2026-10-07: cuatro llamadas negadas por no saberlo)." % (", ".join("%s (senal '%s')" % x for x in nuevos), entrada(), nuevos[0][0]))
    return 0


def registrar_decision(ev: dict, salida: str):
    """La CAJA NEGRA de la puerta (Fran, 2026-10-07: 'que la respuesta sea tan trazable a los hechos como un capacitor
    de la Voyager 1'). Cada accion que la puerta media queda anotada con su veredicto y su motivo, con hora: es lo que
    auditar-sesion.py lee para contestar si la arquitectura se cumplio, en vez de creerle a lo que la sesion dice de
    si misma. Falla abierto a proposito: perder un renglon de auditoria no puede frenar el trabajo."""
    try:
        tool, inp = ev.get("tool_name", ""), ev.get("tool_input", {}) or {}
        if tool not in ACCIONES:
            return
        obj = str(inp.get("file_path", inp.get("notebook_path", ""))) or str(inp.get("command", ""))
        niega = '"deny"' in salida
        motivo = ""
        if niega:
            try:
                motivo = json.loads(salida)["hookSpecificOutput"]["permissionDecisionReason"].splitlines()[0]
            except Exception:
                motivo = "deny (motivo ilegible)"
        anotar(ev.get("session_id", ""), {"t": "decide", "tool": tool, "obj": obj[:200], "cwd": ev.get("cwd", ""),
                                          "v": "niega" if niega else "pasa", "motivo": motivo[:200]})
    except Exception:
        pass


def hook() -> int:
    try:
        ev = json.loads(sys.stdin.buffer.read().decode("utf-8-sig") or "{}")
    except Exception:
        return 0
    nombre = ev.get("hook_event_name", "")
    if nombre == "PreToolUse":
        import contextlib
        import io
        buf = io.StringIO()
        try:
            with contextlib.redirect_stdout(buf):
                rc = pre(ev)
        except Exception as e:  # falla cerrado tambien ante un error propio, con el motivo a la vista
            with contextlib.redirect_stdout(buf):
                rc = deny("PUERTA DE LA CASCADA (T11): error interno (%s: %s). Falla cerrado. Arreglar "
                          ".claude/hooks/cascada_puerta.py (editarlo no lo frena) o .claude\\desinstalar-hooks.ps1"
                          % (type(e).__name__, e))
        sys.stdout.write(buf.getvalue())
        try:
            registrar_decision(ev, buf.getvalue())
        except Exception:
            pass  # la caja negra nunca frena (y si su nombre faltara, tampoco: medido el 2026-10-07)
        return rc
    try:
        if nombre == "UserPromptSubmit":
            return prompt(ev)
        if nombre == "PostToolUse":
            return post(ev)
        if nombre == "SessionStart" and ev.get("source") == "compact":
            anotar(ev.get("session_id", ""), {"t": "reset"})
    except Exception:
        return 0  # el registro falla abierto: lo peor es pedir de nuevo una lectura
    return 0


# ------------------------------------------------------------------------------------------------------ CLI
def cli_exige(proyecto: str, necs) -> int:
    cat = cargar_catalogo()
    p = resolver_proyecto(proyecto)
    if not p:
        print("  proyecto '%s' no resuelve a uno solo" % proyecto)
        return 1
    ent = cat.get("proyectos", {}).get(p)
    print("  EXIGIDO POR LA PUERTA (T11) para %s -- leer con Read, con estos rangos, ANTES de actuar:" % p)
    if ent is None:
        print("  ! %s no tiene entrada en .claude/cascada.json: solo la base" % p)
    items, cmds, notas = exigido(cat, p, necs, [])
    total = 0
    for x in items:
        txt = Path(x["ruta"]).read_text(encoding="utf-8", errors="replace").splitlines()[x["a"] - 1:x["b"]]
        ch = sum(len(l) + 1 for l in txt)
        total += ch
        print("    %-62s %5d-%-5d %6d ch  %s" % (rel(x["ver"])[-62:], x["a"], x["b"], ch, x["por"][:60]))
    for c in cmds:
        print("    CORRER: %s  (%s)" % (c["sub"], c["por"]))
    for n in notas:
        print("  ! " + n)
    todas = list((ent or {}).get("necesidades", [])) + list(necs or [])
    if "diseno" in todas and not (ent or {}).get("requisitos"):
        print("  ! DISENO SIN REQUISITOS: %s no declara su documento de requisitos ('requisitos' en .claude/cascada.json)."
              " Se disena contra los requisitos: lo primero es escribirlos (al tocarlos, el concepto 'requisitos' "
              "exige el GtWR, la catedra y NASA)." % p)
    print("  total: %d caracteres (~%d K tokens), una vez por sesion" % (total, total // 3500))
    # Herramientas y RESPALDO de cada necesidad (Fran, 2026-10-02: saber ir a buscar las herramientas y el backup
    # de cada tarea). Se imprimen, no se exigen: son el flujo de informacion, no la puerta.
    for n in dict.fromkeys(list((ent or {}).get("necesidades", [])) + list(necs or [])):
        hs = cat.get("necesidades", {}).get(n, {}).get("herramientas", [])
        if hs:
            print("  HERRAMIENTAS Y RESPALDO (%s): %s" % (n, " | ".join(hs)))
    # Las LECCIONES del proyecto (Fran, 2026-10-07: la apertura dispara lo pertinente 'con las lecciones aprendidas
    # relacionadas'). Se imprimen los titulos: la regla de cada una sale con 'aprender.py listar --proyecto'.
    apr = expandir("perfil-global/herramientas/aprender.py", None)
    if apr is not None and apr.exists():
        try:
            out = subprocess.run([sys.executable, str(apr), "listar", "--proyecto", p], capture_output=True,
                                 timeout=20).stdout.decode("utf-8", "replace").splitlines()
            tit = [l.strip() for l in out if l.lstrip().startswith("[")]
            tit = [re.sub(r"^\[[^\]]*\]\s+\S+\s+", "", t) for t in tit]   # sin la fecha ni el proyecto
            print("  LECCIONES DE %s (%d): %s" % (p, len(tit), " | ".join(tit[:12]) or "ninguna"))
            if tit:
                print("    la regla de cada una: python perfil-global/herramientas/aprender.py listar --proyecto %s" % p)
        except Exception as e:
            print("  ! LECCIONES: aprender.py no respondio (%s)" % e)
    else:
        print("  ! LECCIONES: no esta perfil-global/herramientas/aprender.py (falta el libro: traer-perfil.sh)")
    # None = no se paso -Necesidad; [] = se paso solo 'ninguna' (que el __main__ filtra), y eso SI declara: la puerta
    # la registra igual. Con 'if not necs' imprimia SIN DECLARAR a quien acababa de declarar (validaciones 4 y 5).
    if necs is None:
        print("  NECESIDAD SIN DECLARAR. La puerta no deja actuar hasta: %s %s -Necesidad <a,b>" % (entrada(), p))
        print(menu(cat))
    print("  PREGUNTA DE MARCO, antes de actuar: que tendria que ser verdad para que esto sea el problema "
          "equivocado? Si depende de lo que Fran quiere y no de lo tecnico, se le pregunta.")
    return 0


def cli_verificar() -> int:
    rojos = []
    try:
        cat = cargar_catalogo()
    except Exception as e:
        print("[FAIL] catalogo ilegible: %s" % e)
        return 1
    disco = proyectos_del_disco()
    ent = cat.get("proyectos", {})
    for n in sorted(disco):
        if n not in ent:
            rojos.append("proyecto del disco SIN entrada en el catalogo: %s" % n)
    for n in sorted(ent):
        if n not in disco:
            rojos.append("entrada de un proyecto que YA NO EXISTE: %s (sacarla)" % n)
        for nec in ent[n].get("necesidades", []):
            if nec not in cat.get("necesidades", {}):
                rojos.append("%s pide una necesidad que no existe: %s" % (n, nec))
        if "diseno" in ent[n].get("necesidades", []) and not ent[n].get("requisitos"):
            rojos.append("%s disena por defecto y no declara su documento de requisitos ('requisitos' en el catalogo): "
                         "se disenaria sin contra que verificar (Fran, 2026-10-07)" % n)
        for s in ent[n].get("senales", []):
            try:
                re.compile(s)
            except re.error as e:
                rojos.append("%s: senal con regex rota %r (%s)" % (n, s, e))
        for loc in ent[n].get("locales", []):
            if not (loc.startswith("~") or os.path.isabs(loc)):
                rojos.append("%s: carpeta local que no es absoluta ni empieza con ~: %s" % (n, loc))
    for nombre, cd in cat.get("conceptos", {}).items():
        for k in ("comando", "archivo"):
            if cd.get(k):
                try:
                    re.compile(cd[k])
                except re.error as e:
                    rojos.append("concepto %s: regex %s rota (%s)" % (nombre, k, e))
    # T11b (Fran, 2026-10-02: 'buscar las herramientas y el respaldo de cada tarea'): toda necesidad trae sus
    # herramientas y al menos una de RESPALDO. 'ninguna' es la unica que no tiene nada que respaldar.
    for nec, nd in cat.get("necesidades", {}).items():
        if nec == "ninguna":
            continue
        hs = nd.get("herramientas") or []
        if not hs:
            rojos.append("la necesidad %s no trae herramientas" % nec)
        elif not any(str(h).lower().startswith("respaldo") for h in hs):
            rojos.append("la necesidad %s no trae una herramienta de RESPALDO ('respaldo: ...')" % nec)
    # cada proyecto x sus necesidades por defecto + cada necesidad sola + cada concepto: rutas, secciones, tamanos
    casos = [(p, ent.get(p, {}).get("necesidades", []), []) for p in sorted(disco)]
    casos += [(None, [], [c]) for c in cat.get("conceptos", {})]
    for nec, nd in cat.get("necesidades", {}).items():
        for spec in nd.get("leer", []):
            if "{proy}" in spec["ruta"] or "{handoff}" in spec["ruta"]:
                rojos.append("la necesidad %s usa una ruta de proyecto: %s" % (nec, spec["ruta"]))
    vistos = set()
    for p, necs, cons in casos:
        items, _, notas = exigido(cat, p, list(cat.get("necesidades", {})) if p == "black" else necs, cons)
        rojos += [n for n in notas if n not in vistos]
        vistos.update(notas)
        for x in items:
            k = (x["ruta"], x["a"], x["b"])
            if k in vistos:
                continue
            vistos.add(k)
            txt = Path(x["ruta"]).read_text(encoding="utf-8", errors="replace").splitlines()[x["a"] - 1:x["b"]]
            ch = sum(len(l) + 1 for l in txt)
            if x["b"] - x["a"] + 1 > MAX_LINEAS_LECTURA or ch > MAX_CHARS_RANGO:
                rojos.append("rango que NO entra en una lectura: %s %d-%d (%d ch)" % (rel(x["ver"]), x["a"], x["b"], ch))
    # dejar de actuar (Leveson): la puerta desinstalada no avisa sola. Se mide el registro, en los tres eventos.
    try:
        hooks = json.loads((RAIZ / ".claude" / "settings.json").read_text(encoding="utf-8-sig")).get("hooks", {})
        for evento in ("PreToolUse", "PostToolUse", "SessionStart", "UserPromptSubmit"):
            # en PreToolUse la puerta corre por su LANZADOR (la politica de falla: 2026-10-07)
            esperado = "puerta-lanzador.py" if evento == "PreToolUse" else "cascada_puerta.py"
            if esperado not in json.dumps(hooks.get(evento, [])):
                rojos.append("%s NO esta registrado en %s de .claude/settings.json (.claude\\instalar-hooks.ps1)"
                             % (esperado, evento))
    except Exception as e:
        rojos.append(".claude/settings.json ilegible: %s" % e)
    # Las piezas de la puerta COMPILAN: un error de sintaxis en el lanzador lo dejaria fallar abierto sin que nadie lo
    # note (es la pieza que no tiene quien la repare). compile() no escribe nada en el disco.
    for pieza in ("cascada_puerta.py", "puerta-lanzador.py", "fase_activa.py"):
        f = Path(__file__).with_name(pieza)
        try:
            compile(f.read_text(encoding="utf-8"), str(f), "exec")
        except Exception as e:
            rojos.append("%s NO compila (%s): la puerta corre rota" % (pieza, e))
    for r in rojos:
        print("[FAIL] " + r)
    print("cascada.json: %s (%d proyectos, %d necesidades, %d conceptos)" % (
        "OK" if not rojos else "%d ROJO(S)" % len(rojos), len(ent), len(cat.get("necesidades", {})),
        len(cat.get("conceptos", {}))))
    return 1 if rojos else 0


def autotest() -> int:
    """Corre el hook como lo corre Claude Code (subproceso, JSON por stdin) con estado y log aislados."""
    global RAIZ  # el caso 10f lo cambia un momento (perfil-global al lado del arbol) y lo restaura
    import subprocess
    tmp = Path(tempfile.mkdtemp(prefix="cascada-autotest-"))
    env = dict(os.environ, CASCADA_ESTADO_DIR=str(tmp / "estado"), CASCADA_LOG_EXC=str(tmp / "exc.log"))
    black = RAIZ / "proyectos" / "ingenieria" / "black"
    sid = "autotest-%d" % os.getpid()
    mal = 0

    def correr(ev, cat_env=None):
        e = dict(env)
        if cat_env:
            e.update(cat_env)
        r = subprocess.run([sys.executable, __file__], input=json.dumps(ev).encode("utf-8"), capture_output=True,
                           env=e)
        return r.stdout.decode("utf-8", "replace")

    def pre_ev(tool, inp, s=sid, cwd=str(RAIZ)):
        return {"hook_event_name": "PreToolUse", "session_id": s, "tool_name": tool, "tool_input": inp, "cwd": cwd}

    def post_ev(tool, inp, s=sid):
        return {"hook_event_name": "PostToolUse", "session_id": s, "tool_name": tool, "tool_input": inp}

    def caso(nombre, salida, espera_deny, debe_contener=None):
        nonlocal mal
        es = '"deny"' in salida
        ok = es == espera_deny and (debe_contener is None or debe_contener in salida)
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", nombre, "DENY" if es else "pasa"))
        if not ok:
            print("       salida: %s" % salida[:300])

    edit_black = ("Edit", {"file_path": str(black / "docs" / "x.md"), "old_string": "a", "new_string": "b"})
    # 1. sabotaje: actuar sin declarar
    caso("sin declarar la necesidad -> deny con el menu", correr(pre_ev(*edit_black)), True, "-Necesidad")
    # 2. declarar sin leer
    correr(post_ev("PowerShell", {"command": ".\\cascada.ps1 black -Necesidad diseno"}))
    caso("declarado y sin leer -> deny con la lista", correr(pre_ev(*edit_black)), True, "ESTADO_ACTUAL.md")
    # 3. leer todo lo exigido salvo un rango a medias
    cat = cargar_catalogo()
    items, cmds, _ = exigido(cat, "black", ["diseno"], [])
    for x in items[:-1]:
        correr(post_ev("Read", {"file_path": x["ruta"], "offset": x["a"], "limit": x["b"] - x["a"] + 1}))
    ult = items[-1]
    correr(post_ev("Read", {"file_path": ult["ruta"], "offset": ult["a"], "limit": max(1, (ult["b"] - ult["a"]) // 2)}))
    caso("un rango leido a medias -> deny", correr(pre_ev(*edit_black)), True, "offset=")
    correr(post_ev("Read", {"file_path": ult["ruta"], "offset": ult["a"], "limit": ult["b"] - ult["a"] + 1}))
    # 4. leido todo pero sin el comando de apertura
    caso("todo leido, sin abrir-sesion -> deny", correr(pre_ev(*edit_black)), True, "abrir-sesion")
    correr(post_ev("PowerShell", {"command": ".\\proyectos\\ingenieria\\black\\abrir-sesion.ps1 -Rapido"}))
    # 5. control positivo: todo hecho
    caso("CONTROL: todo leido y corrido -> pasa", correr(pre_ev(*edit_black)), False)
    # 6. compactar borra lo leido
    correr({"hook_event_name": "SessionStart", "session_id": sid, "source": "compact"})
    caso("despues de compactar -> deny otra vez", correr(pre_ev(*edit_black)), True, "falta LEER")
    # 7. lectura pura pasa; compuesta con accion no
    s2 = sid + "-b"
    caso("CONTROL: lectura pura sobre black -> pasa",
         correr(pre_ev("PowerShell", {"command": "Get-Content proyectos\\ingenieria\\black\\PDP.md | Select-Object -First 5"}, s2)), False)
    caso("lectura con '|' adentro de comillas -> pasa",
         correr(pre_ev("PowerShell", {"command": "Select-String -Path proyectos\\ingenieria\\black\\PDP.md -Pattern 'a|b'"}, s2)), False)
    caso("lectura ENCADENADA con una accion -> deny",
         correr(pre_ev("PowerShell", {"command": "Get-Content proyectos\\ingenieria\\black\\PDP.md; Remove-Item proyectos\\ingenieria\\black\\x"}, s2)), True)
    caso("lectura con pipe a ForEach (puede actuar) -> deny",
         correr(pre_ev("PowerShell", {"command": "Get-ChildItem proyectos\\ingenieria\\black | ForEach-Object { Remove-Item $_ }"}, s2)), True)
    # 8. fuera de proyecto, sin concepto: pasa. Contenido que NOMBRA un proyecto no cuenta (solo la ruta)
    caso("CONTROL: Edit fuera de proyectos/ -> pasa",
         correr(pre_ev("Edit", {"file_path": str(RAIZ / "MAPA.md"), "old_string": "proyectos/ingenieria/black", "new_string": "x"}, s2)), False)
    # 9. concepto: typst sin leer la skill
    caso("concepto typst sin leer pdf-con-codigo -> deny",
         correr(pre_ev("Bash", {"command": "typst compile apunte.typ"}, s2)), True, "pdf-con-codigo")
    # 10c. lo que la sesion escribe cuenta como leido, y lo leido se corre con la edicion (falso positivo medido)
    s7 = sid + "-h"
    fx = tmp / "doc.md"
    fx.write_text("\n".join("linea %d" % k for k in range(1, 41)) + "\n", encoding="utf-8")
    correr(post_ev("Read", {"file_path": str(fx), "offset": 1, "limit": 40}, s7))
    fx.write_text("\n".join(["linea 1", "nueva A", "nueva B", "nueva C"] + ["linea %d" % k for k in range(2, 41)]) + "\n",
                  encoding="utf-8")
    correr(post_ev("Edit", {"file_path": str(fx), "old_string": "linea 1", "new_string": "linea 1\nnueva A\nnueva B\nnueva C"}, s7))
    env_e = dict(env)
    est = subprocess.run([sys.executable, __file__, "--estado", s7], capture_output=True, env=env_e).stdout.decode()
    ok = cubierto([tuple(x) for x in json.loads(est)["lecturas"].get(norm(fx), [])], 1, 43)
    mal += not ok
    print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "CONTROL: editar +3 lineas no deja huecos en lo leido", "si" if ok else "NO"))
    s6 = sid + "-g"
    correr(pre_ev("PowerShell", {"command": "Write-Output 'proyectos/ingenieria/black/abrir-sesion.ps1'"}, s6))
    caso("un texto que NOMBRA abrir-sesion no cuenta como correrlo",
         correr(pre_ev("PowerShell", {"command": "python C:\\x\\campana_coop.py lanzar"}, s6)), True, "abrir-sesion")
    caso("concepto pcsx2 exige abrir-sesion de BLACK",
         correr(pre_ev("PowerShell", {"command": "python C:\\x\\campana_coop.py lanzar"}, s2)), True, "abrir-sesion")
    # 10. excepcion explicita: pasa y queda en el log
    s3 = sid + "-c"
    correr(pre_ev("PowerShell", {"command": ".\\cascada.ps1 black -Excepcion \"autotest: consulta de un dato; con punto y coma\" *> $null; Get-Date"}, s3))
    caso("CONTROL: excepcion declarada -> pasa", correr(pre_ev(*edit_black, s=s3)), False)
    log = (tmp / "exc.log").read_text(encoding="utf-8") if (tmp / "exc.log").exists() else ""
    ok = "autotest: consulta de un dato" in log
    mal += not ok
    print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "la excepcion queda en el log con su motivo", "si" if ok else "NO"))
    # 10b. un cascada.ps1 que sale con codigo 1 no dispara PostToolUse (medido en la 1.a sesion real): la
    # declaracion tiene que quedar con el PreToolUse solo
    s5 = sid + "-f"
    correr(pre_ev("PowerShell", {"command": ".\\cascada.ps1 black -Necesidad ninguna"}, s5))
    caso("declaracion vista SOLO en PreToolUse -> ya no pide declarar", correr(pre_ev(*edit_black, s=s5)), True,
         "falta LEER")
    # 10d. la nube no tiene PowerShell: se declara con cascada.sh (T7 §3 punto 4), y tiene que contar igual. Un
    # texto que solo lo NOMBRA no declara.
    s9 = sid + "-sh"
    correr(pre_ev("Bash", {"command": "bash .claude/cascada.sh black -Necesidad diseno"}, s9))
    caso("declaracion por cascada.sh (la nube) -> ya no pide declarar", correr(pre_ev(*edit_black, s=s9)), True,
         "falta LEER")
    s10 = sid + "-sh-echo"
    correr(pre_ev("Bash", {"command": "echo bash .claude/cascada.sh black -Necesidad diseno"}, s10))
    caso("un echo que NOMBRA cascada.sh no declara -> sigue pidiendo", correr(pre_ev(*edit_black, s=s10)), True,
         "-Necesidad")
    s11 = sid + "-sh-exc"
    correr(pre_ev("Bash", {"command": ".claude/cascada.sh black -Excepcion \"autotest: la nube\""}, s11))
    caso("CONTROL: excepcion por cascada.sh -> pasa", correr(pre_ev(*edit_black, s=s11)), False)
    # 10e. un exigido que NO EXISTE niega (antes: pasaba en silencio; medido en WSL y por estructura en la nube)
    cat_f = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    cat_f.setdefault("conceptos", {})["fantasma"] = {"comando": r"\bfantasma-autotest\b",
                                                     "leer": [{"ruta": "~/.claude/no-existe-autotest-%d.md" % os.getpid(),
                                                               "por": "autotest"}]}
    fantasma = tmp / "fantasma.json"
    fantasma.write_text(json.dumps(cat_f, ensure_ascii=False), encoding="utf-8")
    caso("exigido que NO EXISTE -> deny y dice traer-perfil",
         correr(pre_ev("Bash", {"command": "fantasma-autotest x"}, sid + "-fan"), {"CASCADA_CATALOGO": str(fantasma)}),
         True, "traer-perfil")
    # 10f. perfil-global AL LADO del arbol (la nube: /home/user/perfil-global) resuelve igual que adentro (la PC)
    raiz_vieja = RAIZ
    (tmp / "arbol").mkdir()
    (tmp / "perfil-global" / "pilares").mkdir(parents=True)
    (tmp / "perfil-global" / "pilares" / "x.md").write_text("x\n", encoding="utf-8")
    RAIZ = tmp / "arbol"
    try:
        p_al_lado = expandir("perfil-global/pilares/x.md", None)
    finally:
        RAIZ = raiz_vieja
    ok = p_al_lado is not None and p_al_lado.exists()
    mal += not ok
    print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "perfil-global al lado del arbol (la nube) -> lo encuentra",
                               "si" if ok else "NO (%s)" % p_al_lado))
    # 10g. un Read hecho ANTES de declarar cuenta igual: lo que importa es que el texto entro al contexto
    s12 = sid + "-antes"
    for x in exigido(cat, "black", ["diseno"], [])[0]:
        correr(post_ev("Read", {"file_path": x["ruta"], "offset": x["a"], "limit": x["b"] - x["a"] + 1}, s12))
    correr(pre_ev("PowerShell", {"command": ".\\cascada.ps1 black -Necesidad diseno"}, s12))
    correr(pre_ev("PowerShell", {"command": ".\\proyectos\\ingenieria\\black\\abrir-sesion.ps1 -Rapido"}, s12))
    caso("CONTROL: leido ANTES de declarar -> cuenta, pasa", correr(pre_ev(*edit_black, s=s12)), False)
    # 10h. Bash de solo lectura, como lo escribe la nube: pasa. Encadenado a un cd, no (a proposito: un ';' o un '&&'
    # puede llevar cualquier cosa atras; para ubicar sin declarar estan Read y Grep)
    caso("CONTROL: grep | head por Bash sobre black -> pasa",
         correr(pre_ev("Bash", {"command": "grep -n '^## ' proyectos/ingenieria/black/PDP.md | head -20"}, s2)), False)
    caso("CONTROL: grep -rn con 2>/dev/null sobre black -> pasa",
         correr(pre_ev("Bash", {"command": "grep -rn 'Fase' proyectos/ingenieria/black 2>/dev/null"}, s2)), False)
    caso("cd X && grep (encadenado) sobre black -> deny",
         correr(pre_ev("Bash", {"command": "cd proyectos/ingenieria/black && grep -n x PDP.md"}, s2)), True)
    # 10i. REQUISITOS (2026-10-07: nueve sesiones del telescopio disenaron sin requisitos). Catalogo sintetico: black
    # declara un documento de requisitos que NO existe. Todo lo demas leido y corrido, asi el unico motivo posible
    # del deny es la falta del documento. cwd en black: si no, la escritura pasaria por no tener proyecto (motivo
    # equivocado).
    req_f = tmp / ("requisitos-autotest-%d.md" % os.getpid())
    cat_r = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    cat_r["proyectos"].setdefault("black", {})["requisitos"] = str(req_f)
    cr = tmp / "con-requisitos.json"
    cr.write_text(json.dumps(cat_r, ensure_ascii=False), encoding="utf-8")
    e_r = {"CASCADA_CATALOGO": str(cr)}
    sr = sid + "-req"
    for x in exigido(cat_r, "black", ["diseno"], [])[0]:
        correr(post_ev("Read", {"file_path": x["ruta"], "offset": x["a"], "limit": x["b"] - x["a"] + 1}, sr))
    correr(pre_ev("PowerShell", {"command": ".\\cascada.ps1 black -Necesidad diseno"}, sr))
    correr(pre_ev("PowerShell", {"command": ".\\proyectos\\ingenieria\\black\\abrir-sesion.ps1 -Rapido"}, sr))
    caso("requisitos declarados y AUSENTES -> deny 'SIN REQUISITOS'",
         correr(pre_ev(*edit_black, s=sr, cwd=str(black)), e_r), True, "SIN REQUISITOS")
    caso("CONTROL: sin requisitos, el checkpoint (HANDOFF) -> pasa",
         correr(pre_ev("Edit", {"file_path": str(black / "HANDOFF.md"), "old_string": "a", "new_string": "b"}, sr,
                       cwd=str(black)), e_r), False)
    caso("sin requisitos, un archivo que SOLO se llama parecido -> deny",
         correr(pre_ev("Edit", {"file_path": str(black / "docs" / "handoff-viejo.md"), "old_string": "a",
                                "new_string": "b"}, sr, cwd=str(black)), e_r), True, "SIN REQUISITOS")
    correr({"hook_event_name": "UserPromptSubmit", "session_id": sr, "prompt": "seguimos con BLACK y el metodo"}, e_r)
    caso("CONTROL: proyecto solo NOMBRADO en el pedido, accion fuera -> pasa",
         correr(pre_ev("Edit", {"file_path": str(RAIZ / "MAPA.md"), "old_string": "a", "new_string": "b"}, sr), e_r),
         False)
    w_req = ("Write", {"file_path": str(req_f), "content": "# Requisitos\n"})
    caso("escribir requisitos SIN los libros -> deny que exige el GtWR",
         correr(pre_ev(*w_req, s=sr, cwd=str(black)), e_r), True, "incose-gtwr")
    for x in exigido(cat_r, None, [], ["requisitos"])[0]:
        correr(post_ev("Read", {"file_path": x["ruta"], "offset": x["a"], "limit": x["b"] - x["a"] + 1}, sr))
    caso("CONTROL: con los libros leidos, ESCRIBIR los requisitos -> pasa",
         correr(pre_ev(*w_req, s=sr, cwd=str(black)), e_r), False)
    req_f.write_text("# Requisitos\n\n| ID | Requisito |\n|---|---|\n| L0-01 | x |\n", encoding="utf-8")
    caso("requisitos que EXISTEN y no se leyeron -> deny que los nombra",
         correr(pre_ev(*edit_black, s=sr, cwd=str(black)), e_r), True, req_f.name)
    correr(post_ev("Read", {"file_path": str(req_f)}, sr))
    caso("CONTROL: requisitos leidos -> pasa", correr(pre_ev(*edit_black, s=sr, cwd=str(black)), e_r), False)
    cat_s = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    p_dis = next((n for n, en in cat_s["proyectos"].items() if "diseno" in en.get("necesidades", [])), None)
    if p_dis:
        cat_s["proyectos"][p_dis].pop("requisitos", None)
        sq = tmp / "sin-requisitos.json"
        sq.write_text(json.dumps(cat_s, ensure_ascii=False), encoding="utf-8")
        r = subprocess.run([sys.executable, __file__, "--verificar"], capture_output=True,
                           env=dict(env, CASCADA_CATALOGO=str(sq)))
        sal = r.stdout.decode("utf-8", "replace")
        linea = next((l for l in sal.splitlines() if l.startswith("[FAIL]") and "no declara su documento de requisitos" in l), "")
        ok = r.returncode == 1 and p_dis in linea
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "proyecto que disena SIN requisitos -> --verificar en rojo",
                                   linea[:70] if ok else "NO"))
    else:
        print("SKIP  ningun proyecto disena por defecto: el caso de --verificar no tiene objeto")
    # 10j. comandos que llegan al proyecto sin nombrarlo de corrido (los tres agujeros del 2026-10-07)
    for k, (nombre, cmd) in enumerate([
            ("cd al padre y ruta relativa al hijo", "cd proyectos/ingenieria && echo x > black/docs/z.txt"),
            ("ruta partida con comillas", "echo x > proyectos/'ingenieria'/black/docs/z.txt"),
            ("comodin en la naturaleza", "echo x > proyectos/ing*/black/docs/z.txt")]):
        caso("%s -> deny (sin declarar)" % nombre, correr(pre_ev("Bash", {"command": cmd}, sid + "-hueco%d" % k)), True,
             "-Necesidad")
    caso("CONTROL: un comando que solo dice 'proyectos' -> pasa",
         correr(pre_ev("Bash", {"command": "echo proyectos > notas-autotest.txt"}, sid + "-hueco-ok")), False)
    # 11. otra sesion no hereda nada (A11: dos sesiones en el mismo arbol)
    caso("otra sesion no hereda lo leido por esta -> deny", correr(pre_ev(*edit_black, s=sid + "-d")), True)
    # 12. falla cerrado con catalogo roto; la salida de reparacion pasa igual
    roto = tmp / "roto.json"
    roto.write_text("{ esto no es json", encoding="utf-8")
    import shutil
    e_roto = {"CASCADA_CATALOGO": str(roto)}
    caso("catalogo corrupto -> deny (falla cerrado)", correr(pre_ev(*edit_black, s=s3), e_roto), True, "catalogo")
    caso("CONTROL: con el catalogo roto, editar el catalogo pasa", correr(pre_ev(
        "Edit", {"file_path": str(RAIZ / ".claude" / "cascada.json"), "old_string": "a", "new_string": "b"}, s3), e_roto), False)
    # 12c. el catalogo sin RESPALDO en una necesidad -> --verificar en rojo (T11b), nombrandola
    cat_mal = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    nec_mal = next(n for n in cat_mal["necesidades"] if n != "ninguna")
    cat_mal["necesidades"][nec_mal]["herramientas"] = [h for h in cat_mal["necesidades"][nec_mal].get("herramientas", [])
                                                       if not str(h).lower().startswith("respaldo")]
    sin_resp = tmp / "sin-respaldo.json"
    sin_resp.write_text(json.dumps(cat_mal, ensure_ascii=False), encoding="utf-8")
    r = subprocess.run([sys.executable, __file__, "--verificar"], capture_output=True,
                       env=dict(env, CASCADA_CATALOGO=str(sin_resp)))
    sal = r.stdout.decode("utf-8", "replace")
    ok = r.returncode == 1 and ("necesidad %s no trae una herramienta de RESPALDO" % nec_mal) in sal
    mal += not ok
    print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "necesidad sin respaldo -> --verificar en rojo y la nombra",
                               "rojo" if ok else "NO"))
    # 12d. el LANZADOR con un error de sintaxis (la pieza que no tiene quien la repare) -> --verificar en rojo, nombrado.
    # Sobre una COPIA de las tres piezas: la puerta copiada mira sus vecinas (Path(__file__).with_name).
    hk = tmp / "hooks-roto"
    hk.mkdir()
    for pieza in ("cascada_puerta.py", "fase_activa.py"):
        shutil_copy = (Path(__file__).with_name(pieza)).read_bytes()
        (hk / pieza).write_bytes(shutil_copy)
    (hk / "puerta-lanzador.py").write_text("def roto(:\n", encoding="utf-8")
    r = subprocess.run([sys.executable, str(hk / "cascada_puerta.py"), "--verificar"], capture_output=True,
                       env=dict(env, CASCADA_RAIZ=str(RAIZ)))
    linea = next((l for l in r.stdout.decode("utf-8", "replace").splitlines()
                  if l.startswith("[FAIL]") and "puerta-lanzador.py NO compila" in l), "")
    ok = r.returncode == 1 and bool(linea)
    mal += not ok
    print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "lanzador que NO compila -> --verificar en rojo, nombrado",
                               "rojo" if ok else "NO"))
    # 12b. lecturas en PARALELO: el harness corre un hook por llamada, en procesos paralelos, y todos anotan en el
    # mismo archivo. Medido el 2026-10-02 (1.a sesion de T12): 6 Read en paralelo, 2 renglones pisados y una lectura
    # perdida -- la puerta pidio releer el ESTADO ya leido. Se exige que las N queden.
    # Lanzar N hooks no alcanza: arrancan escalonados y la ventana del choque es de microsegundos (dio 24 de 24 con
    # el codigo roto). Se golpea la funcion que escribe: N procesos x M anotaciones a la vez.
    s8 = sid + "-par"
    n_proc, n_vez = 8, 150
    golpe = ("import importlib.util,sys; s=importlib.util.spec_from_file_location('p', sys.argv[1]); "
             "m=importlib.util.module_from_spec(s); s.loader.exec_module(m); "
             "[m.anotar(sys.argv[2], {'t': 'lee', 'ruta': 'par-%s-%d' % (sys.argv[3], i), 'a': 1, 'b': 9}) "
             "for i in range(int(sys.argv[4]))]")
    procs = [subprocess.Popen([sys.executable, "-c", golpe, __file__, s8, str(k), str(n_vez)], env=env)
             for k in range(n_proc)]
    for p in procs:
        p.wait()
    est = json.loads(subprocess.run([sys.executable, __file__, "--estado", s8], capture_output=True,
                                    env=env).stdout.decode() or "{}")
    quedan = sum(1 for r in est.get("lecturas", {}) if r.startswith("par-"))
    ok = quedan == n_proc * n_vez
    mal += not ok
    print("%s  %-62s -> %d de %d" % ("ok " if ok else "MAL", "%d procesos anotando a la vez -> no se pierde ninguna"
                                     % n_proc, quedan, n_proc * n_vez))
    # 13. mutacion: si 'cubierto' acepta cualquier cosa, tiene que dejar de exigir lecturas (el autotest no es ciego
    # a la funcion que decide). Se reemplaza SOLO la primera aparicion: la definicion, no este texto.
    mut = tmp / "mutante.py"
    firma = "def cubierto(intervalos, a: int, b: int) -> bool:" + "\n"
    mut.write_text(Path(__file__).read_text(encoding="utf-8").replace(firma, firma + "    return True\n", 1),
                   encoding="utf-8")
    env_m = dict(env, CASCADA_RAIZ=str(RAIZ))
    s4 = sid + "-e"
    subprocess.run([sys.executable, str(mut)], input=json.dumps(post_ev("PowerShell", {"command": ".\\cascada.ps1 black -Necesidad ninguna"}, s4)).encode(), capture_output=True, env=env_m)
    r = subprocess.run([sys.executable, str(mut)], input=json.dumps(pre_ev(*edit_black, s=s4)).encode(),
                       capture_output=True, env=env_m).stdout.decode("utf-8", "replace")
    ok = "abrir-sesion" in r and "ESTADO_ACTUAL" not in r
    mal += not ok
    print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "MUTANTE (cubierto=True) deja de exigir lecturas", "si" if ok else "NO"))
    # 14. leccion 331: la necesidad se reconoce en el PEDIDO y en las carpetas LOCALES. Catalogo sintetico (senal y
    # carpeta inventadas): el caso no se rompe cuando cambien las senales reales.
    cat_l = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    p_l = sorted(proyectos_del_disco())[0]
    loc_l = tmp / "Escritorio" / "01 - MATERIA"
    hijo_l = loc_l / "sub-de-otro"
    p_hijo = sorted(proyectos_del_disco())[1]
    cat_l["proyectos"].setdefault(p_l, {})["senales"] = [r"zz senal de prueba zz"]
    cat_l["proyectos"][p_l]["locales"] = [str(loc_l)]
    cat_l["proyectos"].setdefault(p_hijo, {})["locales"] = [str(hijo_l)]
    f_l = tmp / "cat-locales.json"
    f_l.write_text(json.dumps(cat_l, ensure_ascii=False), encoding="utf-8")
    e_l = {"CASCADA_CATALOGO": str(f_l)}
    afuera = ("Write", {"file_path": str(tmp / "Documentos" / "x.c"), "content": "int main(void){return 0;}"})
    s9 = sid + "-pedido"
    correr({"hook_event_name": "UserPromptSubmit", "session_id": s9, "prompt": "resolve la ZZ SENAL DE PRUEBA ZZ"}, e_l)
    caso("pedido con senal + Write FUERA de todo proyecto -> deny", correr(pre_ev(*afuera, s=s9), e_l), True,
         "El PEDIDO de Fran lo nombra")
    s10 = sid + "-sin-senal"
    correr({"hook_event_name": "UserPromptSubmit", "session_id": s10, "prompt": "un pedido cualquiera"}, e_l)
    caso("CONTROL: pedido sin senal + Write fuera -> pasa", correr(pre_ev(*afuera, s=s10), e_l), False)
    correr(post_ev("PowerShell", {"command": ".\\cascada.ps1 %s -Excepcion \"prueba\"" % p_l}, s9), e_l)
    caso("CONTROL: pedido con senal y -Excepcion -> pasa", correr(pre_ev(*afuera, s=s9), e_l), False)
    s11 = sid + "-local"
    w_loc = ("Write", {"file_path": str(loc_l / "clase" / "x.c"), "content": "x"})
    caso("Write en la carpeta LOCAL sin pedido ni declarar -> deny", correr(pre_ev(*w_loc, s=s11), e_l), True,
         "'%s'" % p_l)
    caso("la subcarpeta local de OTRO proyecto -> gana la mas larga",
         correr(pre_ev("Write", {"file_path": str(hijo_l / "x.c"), "content": "x"}, s=s11), e_l), True, "'%s'" % p_hijo)
    caso("comando que nombra la carpeta local -> deny",
         correr(pre_ev("PowerShell", {"command": "New-Item -ItemType File '%s'" % (loc_l / "y.c")}, s=s11), e_l), True,
         "'%s'" % p_l)
    caso("CONTROL: lectura pura de la carpeta local -> pasa",
         correr(pre_ev("PowerShell", {"command": "Get-ChildItem '%s'" % loc_l}, s=s11), e_l), False)
    shutil.rmtree(tmp, ignore_errors=True)
    print("autotest: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    a = sys.argv[1:]
    if a[:1] == ["--autotest"]:
        sys.exit(autotest())
    if a[:1] == ["--verificar"]:
        sys.exit(cli_verificar())
    if a[:1] == ["--exige"] and len(a) >= 2:
        necs = []
        if "--necesidad" in a:
            v = a[a.index("--necesidad") + 1] if a.index("--necesidad") + 1 < len(a) else ""
            necs = [x.strip().lower() for x in v.split(",") if x.strip() and x.strip().lower() != "ninguna"]
        sys.exit(cli_exige(a[1], necs if "--necesidad" in a else None))
    if a[:1] == ["--estado"] and len(a) >= 2:
        st = estado(a[1])
        print(json.dumps({k: (sorted(v) if isinstance(v, set) else v) for k, v in st.items()}, default=list, indent=1))
        sys.exit(0)
    sys.exit(hook())
