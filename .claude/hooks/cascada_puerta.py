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

import hashlib
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

RAIZ = Path(os.environ.get("CASCADA_RAIZ") or Path(__file__).resolve().parents[2])
CATALOGO = Path(os.environ.get("CASCADA_CATALOGO") or RAIZ / ".claude" / "cascada.json")
# T15 (L2-PTA-18, DA-047): la Caja_Negra vivia en %TEMP%, purgable, y es la evidencia que lee la auditoria. Va a la
# carpeta del usuario: sobrevive al reinicio y queda fuera del repo, que es publico (guarda comandos enteros).
ESTADO_DIR = Path(os.environ.get("CASCADA_ESTADO_DIR") or Path.home() / ".claude" / "caja-negra")
# T15 (L2-PTA-19): donde vivia la caja negra antes. Una sesion que arranco antes del cambio declaro y leyo ahi; sin
# copiarla, la puerta viva negaria todo apenas se instala. Con CASCADA_ESTADO_DIR (las pruebas) no hay legado.
LEGADO_DIR = (Path(os.environ["CASCADA_ESTADO_LEGADO"]) if os.environ.get("CASCADA_ESTADO_LEGADO")
              else None if os.environ.get("CASCADA_ESTADO_DIR") else Path(tempfile.gettempdir()) / "claude-cascada")
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
    # la compuerta con una ruta solo IMPRIME la fase (sin marca ni estado); sin argumento lee stdin y con --autotest
    # escribe temporales: esos no. La auditoria de de44da9d la conto como accion sobre black (T14).
    r"""python\s+\S*fase_activa\.py\s+(?!-)\S|"""
    r"""((ba)?sh\s+)?([\w.:\-]+[\\/])*cascada\.(ps1|sh)|([\w.:\-]+[\\/])*abrir-sesion\.ps1)""", re.I)
# Lo que NO escribio Fran (T14, L2-PTA-04): un retome pegado, una notificacion automatica, un recordatorio del harness.
# Sin cierre no se recorta: un bloque truncado queda adentro y la puerta frena de mas (falla cerrado), nunca de menos.
AJENO = re.compile(r"<(pasted_content|task-notification|system-reminder)\b[^>]*>.*?</\1\s*>", re.I | re.S)
FILTRO = re.compile(r"^\s*(Select-Object|select|Select-String|sls|Where-Object|where|Measure-Object|measure|"
                    r"Sort-Object|sort|Format-\w+|ft|fl|Out-String|head|tail|grep|wc|uniq|findstr|more|less)\b", re.I)
REDIRS_INOCUAS = re.compile(r"\s[12]?>\s*(\$null|/dev/null|&1)", re.I)
# Los archivos de la propia puerta nunca los frena ella: es la salida de reparacion.
REPARACION = re.compile(r"[/\\]\.claude[/\\](hooks[/\\]cascada_puerta\.py|cascada\.json)$", re.I)
# T17 (L1-12, L2-PTA-07..17): los conectores de claude.ai (Drive, Docs...) bajo la puerta, por LISTA BLANCA (Saltzer).
# Antes, la estructura de control cubria Bash/PowerShell/Write/Edit y todo conector entraba sin freno (DA-046).
# Diseno: proyectos/ingenieria/arquitectura-se/docs/t17-conectores-bajo-la-puerta.md
CONECTORES = Path(os.environ.get("CASCADA_CONECTORES") or RAIZ / ".claude" / "conectores.json")
AUDIENCIA = Path(os.environ.get("CASCADA_AUDIENCIA") or RAIZ / ".claude" / "estructura-drive.json")
_ID_CONECTOR = r"[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
PATRON_CONECTOR = re.compile(r"^mcp__(" + _ID_CONECTOR + r")__(.+)$")
MATCHER_CONECTORES = "mcp__" + _ID_CONECTOR + "__.*"   # el que va en .claude/settings.json (L2-VER-03)
MUESTRA_CONECTOR = "mcp__094616df-b7ca-4cd7-8b66-355577c1f5f5__share_file"   # Drive, medido el 2026-10-16
ROLES = {"reader": 1, "commenter": 2, "writer": 3}
CLASES_PASAN = ("lectura", "privado", "papelera")
CLASES = CLASES_PASAN + ("comparte", "ubica")
_ULTIMA_CONECTOR = {}   # la decision de esta llamada, para la caja negra (un proceso por llamada)


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


def sin_ajeno(texto: str) -> str:
    """El pedido sin lo que no tipeo Fran (T14): lo pegado actua sobre rutas, y la puerta ya ve las rutas; lo
    automatico no es un pedido. Medido el 2026-10-12: 3 falsos frenos por un retome pegado y por notificaciones."""
    return AJENO.sub(" ", texto or "")


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


# T13, «la fase manda» (2026-10-12; requisitos L2-PTA-01..03 y L2-VER-01/02 de
# proyectos/ingenieria/arquitectura-se/docs/10-requisitos.md): en una fase NASA A-D el documento de requisitos se
# exige por la FASE del PDP, no porque el proyecto lo haya declarado (era opt-in: 1 de 22 lo declaraba y 6 estaban
# en A-D sin requisitos). La fase se tipa con las funciones de la compuerta (fase_activa.py): una sola tabla de tipos.
FASES_DESARROLLO = ("Fase A", "Fase B", "Fase C", "Fase D")
SIN_REQ_FASE = "SIN REQUISITOS EN FASE"
PAT_REQ_ARCHIVO = re.compile(r"(?i)(^|[-_])requisitos[^/\\]*\.(md|txt)$")


def escribe_requisitos(nota: str, destino: str) -> bool:
    """La accion escribe un archivo de requisitos ADENTRO del proyecto de la nota (la ruta normalizada que la nota
    lleva antes de ' -- ')."""
    proy = nota.split(": ", 1)[1].split(" -- ")[0]
    return bool(destino) and destino.startswith(proy + os.sep) and bool(PAT_REQ_ARCHIVO.search(os.path.basename(destino)))


# T19a (2026-10-12 noche; L1-04 acotado por N-09 de proyectos/ingenieria/arquitectura-se/docs/10-requisitos.md): el
# ciclo NASA completo se exige a los proyectos de ingenieria (BLACK, el telescopio...). Los de materia no se frenan por
# la fase: ahi el papel que manda es el criterio de la catedra. Fran: «es funcional y alcanza».
NATURALEZAS_NASA = ("ingenieria",)


def exige_requisitos(proy: Path, fase) -> bool:
    """La fase del proyecto exige documento de requisitos (T13 acotado por T19a): fase A-D Y naturaleza con ciclo
    NASA. La naturaleza es la carpeta madre del proyecto (proyectos/<nat>/<p>)."""
    return bool(fase) and fase[1] in FASES_DESARROLLO and proy.parent.name in NATURALEZAS_NASA


def fase_de(proy: Path):
    """(id, tipo corto) de la fase abierta del PDP: tipo 'Fase C', 'Pre-Fase A'... o None si no se tipa. None si no
    hay PDP o ninguna fase abierta. Revienta si el PDP o la compuerta no se pueden leer: quien llama falla cerrado."""
    aqui = str(Path(__file__).resolve().parent)
    if aqui not in sys.path:
        sys.path.insert(0, aqui)
    import fase_activa
    pdp = proy / "PDP.md"
    if not pdp.exists():
        return None
    f = fase_activa.fase_abierta(pdp)
    if not f or f[0] == "ninguna":
        return None
    t = fase_activa.tipo_de(f[2])
    return f[0], (t[0].split(" (")[0] if t else None)


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
        else:
            # T13: sin documento declarado, lo exige la FASE. Si la fase no se puede leer, se niega igual (falla
            # cerrado: un PDP ilegible no es un proyecto sin fase).
            try:
                fase = fase_de(proy)
            except Exception as e:  # noqa: BLE001
                notas.append("FASE ILEGIBLE: %s -- la fase del PDP no se pudo tipar (%s): la puerta niega como si "
                             "faltaran los requisitos. Arreglar el PDP o .claude/hooks/fase_activa.py" % (norm(proy), e))
            else:
                if exige_requisitos(proy, fase):
                    notas.append("%s: %s -- el PDP dice %s (%s) y el proyecto no tiene documento de requisitos. Lo "
                                 "primero es escribirlo: la puerta deja escribir un archivo del proyecto llamado "
                                 "requisitos*.md o *-requisitos.md (el concepto 'requisitos' exige el GtWR, la catedra y "
                                 "NASA) y el registro (ESTADO, HANDOFF, PDP); despues se declara en .claude/cascada.json "
                                 "(\"requisitos\": \"docs/10-requisitos.md\"). Hasta entonces niega todo Bash y "
                                 "PowerShell sobre el proyecto: mirar con Read, Glob y Grep (T13, decision de Fran del "
                                 "2026-10-12: frena al entrar)" % (SIN_REQ_FASE, norm(proy), fase[1], fase[0]))
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


# DA-064 (L2-PTA-20..23): un concepto dispara tambien por el ROL del texto que se escribe -- el titulo de la seccion --,
# no por una palabra. 'secciones' es una lista de {titulo: regex sobre el texto del titulo sin la numeracion; archivo:
# regex opcional de la ruta}. Write: los titulos del contenido. Edit: los del texto viejo y del nuevo, y el titulo que
# ENCIERRA el texto viejo en el archivo (reescribir la frase de la necesidad sin tocar su titulo es el caso que lo
# origino, 2026-10-19). La prosa que nombra 'la necesidad' no es un titulo y no dispara. Los titulos se leen solo en
# documentos (Markdown '#', Typst '='): en un .py, '# objetivo: ...' es un comentario, y adentro de un bloque de
# codigo de un .md tambien.
TITULO_DE = {".md": re.compile(r"^ {0,3}#{1,6}\s+(.+?)[\s#]*$"), ".markdown": re.compile(r"^ {0,3}#{1,6}\s+(.+?)[\s#]*$"),
             ".typ": re.compile(r"^\s*=+\s+(.+?)\s*$")}
NUMERACION = re.compile(r"^\d+[a-z]?(\.\d+[a-z]?)*\.?\s+")   # '1.1.', '3.', '3b.' (el libro de bolsillo numera asi)
VALLA = re.compile(r"^ {0,3}(```|~~~)")


def titulos_de(texto: str, ext: str):
    """[(indice de linea, texto del titulo sin numeracion)], salteando los bloques de codigo."""
    pat, out, en_valla = TITULO_DE.get(ext), [], False
    if pat is None:
        return out
    for i, l in enumerate(texto.splitlines()):
        if VALLA.match(l):
            en_valla = not en_valla
            continue
        m = None if en_valla else pat.match(l)
        if m:
            out.append((i, NUMERACION.sub("", m.group(1).strip())))
    return out


def titulos_tocados(tool: str, inp: dict, arch: str):
    """Los titulos que la accion escribe o dentro de los que escribe (DA-064)."""
    ext = os.path.splitext(arch)[1].lower()
    if ext not in TITULO_DE:
        return []
    if tool == "Write":
        return [t for _, t in titulos_de(str(inp.get("content", "")), ext)]
    if tool != "Edit":
        return []
    viejo = str(inp.get("old_string", ""))
    out = [t for _, t in titulos_de(viejo, ext) + titulos_de(str(inp.get("new_string", "")), ext)]
    try:
        p = Path(arch)
        texto = p.read_text(encoding="utf-8", errors="replace") if viejo and p.stat().st_size < 5_000_000 else ""
    except OSError:
        texto = ""   # un Edit sobre un archivo que no se lee falla solo: no hay seccion que mirar
    if texto:
        tits = titulos_de(texto, ext)
        poss = ([m.start() for m in re.finditer(re.escape(viejo), texto)] if inp.get("replace_all")
                else [texto.find(viejo)])
        for pos in poss:
            if pos < 0:
                continue
            linea = texto.count("\n", 0, pos)
            encierra = [t for i, t in tits if i <= linea]
            if encierra:
                out.append(encierra[-1])
    return out


def escribe_seccion(secciones, arch: str, titulos) -> bool:
    for s in secciones:
        if s.get("archivo") and not re.search(s["archivo"], arch):
            continue
        if s.get("excepto") and re.search(s["excepto"], arch):   # DA-067: el registro (ESTADO, HANDOFF) anota, no escribe
            continue
        if any(re.search(s["titulo"], t) for t in titulos):
            return True
    return False


def conceptos_de(cat: dict, tool: str, inp: dict):
    cmd = str(inp.get("command", "")) if tool in ("Bash", "PowerShell") else ""
    arch = str(inp.get("file_path", inp.get("notebook_path", ""))) if tool in ("Edit", "Write", "NotebookEdit") else ""
    out, tits = [], None
    for nombre, cd in cat.get("conceptos", {}).items():
        if cmd and cd.get("comando") and re.search(cd["comando"], cmd):
            out.append(nombre)
        elif arch and cd.get("archivo") and re.search(cd["archivo"], arch):
            out.append(nombre)
        elif arch and cd.get("secciones"):
            if tits is None:
                tits = titulos_tocados(tool, inp, arch)
            if escribe_seccion(cd["secciones"], arch, tits):
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


def proyectos_de(tool: str, inp: dict, cwd: str, cat: dict | None = None):
    """TODOS los proyectos que la accion toca, en orden de aparicion (DA-070, 2026-10-19: un Bash que hacia grep en
    cohete-de-agua y sed en catedras paso sin pedir cohete-de-agua, porque la puerta veia UN proyecto por comando y
    el primero ya estaba liberado; fail-open por salida temprana). Las mismas reglas que proyecto_de, sin cortar en
    la primera: el arbol en el texto de la accion, y si el texto no nombra ninguno, el cwd."""
    if tool in ("Edit", "Write", "NotebookEdit"):
        texto = str(inp.get("file_path", inp.get("notebook_path", "")))
    else:
        texto = str(inp.get("command", ""))
    disco, out = proyectos_del_disco(), []
    for t in dict.fromkeys((texto.replace("\\\\", "\\"), texto.replace("'", "").replace('"', "").replace("\\\\", "\\"))):
        out += [m.group(2) for m in PATRON_PROY.finditer(t) if m.group(2) in disco]
        if tool in ("Bash", "PowerShell") and re.search(r"(?i)\bproyectos\b", t):
            out += [n for n in disco if re.search(r"(?<![\w.-])" + re.escape(n) + r"[/\\]", t)]
    locs = locales_de(cat or {})
    if tool in ("Bash", "PowerShell"):
        tn = texto.lower().replace("/", "\\")
        out += [p for loc, p in locs if p in disco and _cola_local(loc) in tn]
    elif texto:
        tn = norm(texto)
        out += [p for loc, p in locs if p in disco and (tn == loc or tn.startswith(loc + os.sep))]
    # El de siempre va primero (los mensajes y lo que se exige al primero no cambian); los demas, detras.
    primero = proyecto_de(tool, inp, cwd, cat)
    return list(dict.fromkeys(([primero] if primero else []) + out))


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


def inferidos_de(cat: dict, texto: str, contexto=()):
    """Que proyectos NOMBRA el pedido de Fran, por las 'senales' de cada uno en el catalogo. La necesidad se
    reconoce en el PEDIDO, no en la primera ruta que se toca: una sesion que clasifica 'sin proyecto' nunca toca
    una ruta del arbol y la puerta no se enteraba (2026-10-02, leccion 331).
    Devuelve (inferidos, cedidos). Una senal FUERTE nombra el proyecto; una DEBIL ('senales_debiles') es vocabulario
    del tema ('punteros') y cede si el mismo pedido nombra OTRO proyecto con una fuerte o la sesion ya trabaja en
    otro ('contexto': declarados e inferidos por fuerte). Sin esto un retome de BLACK que hablaba de los punteros
    del jugador quedaba frenado por software-de-vuelo (2026-10-09, leccion 372).
    Inferidos: (p, senal, es_debil). Cedidos: (p, senal, otro)."""
    fuertes, debiles = [], []
    for p, ent in cat.get("proyectos", {}).items():
        for lista, out in (("senales", fuertes), ("senales_debiles", debiles)):
            m = next((m for m in (re.search(s, texto or "", re.I) for s in ent.get(lista, [])) if m), None)
            if m:
                out.append((p, m.group(0)))
                break
    nombrados = [p for p, _ in fuertes] + [p for p in contexto if p not in dict(fuertes)]
    inferidos, cedidos = [(p, por, False) for p, por in fuertes], []
    for p, por in debiles:
        otros = [q for q in nombrados if q != p]
        if otros:
            cedidos.append((p, por, otros[0]))
        else:
            inferidos.append((p, por, True))
    return inferidos, cedidos


# ------------------------------------------------------------------------------------------- estado de sesion
def archivo_estado(sid: str) -> Path:
    """La Caja_Negra de la sesion (L2-PTA-18). Si falta y esta en el Directorio_Legado, se copia primero (L2-PTA-19),
    con el mismo candado que anotar(): dos hooks en paralelo no pueden pisar la copia con un renglon ya escrito."""
    nombre = "%s.jsonl" % re.sub(r"[^A-Za-z0-9_.-]", "_", sid or "sin-sesion")
    f = ESTADO_DIR / nombre
    if LEGADO_DIR is not None and not f.exists() and Path(LEGADO_DIR).resolve() != ESTADO_DIR.resolve():
        viejo = Path(LEGADO_DIR) / nombre
        if viejo.exists():
            try:
                ESTADO_DIR.mkdir(parents=True, exist_ok=True)
                with open(str(f) + ".lock", "a+b") as lk:
                    _candado(lk, True)
                    try:
                        if not f.exists():
                            shutil.copyfile(viejo, f)
                    finally:
                        _candado(lk, False)
            except OSError:
                pass   # sin copia la puerta frena de mas (falla cerrado), nunca de menos
    return f


def migrar_legado() -> int:
    """Copia al Directorio_De_Caja_Negra cada caja del Directorio_Legado que falte. Lo corre --verificar (cada
    arranque) y la auditoria. Devuelve cuantas copio."""
    if LEGADO_DIR is None or not Path(LEGADO_DIR).is_dir():
        return 0
    n = 0
    for viejo in Path(LEGADO_DIR).glob("*.jsonl"):
        if not (ESTADO_DIR / viejo.name).exists():
            archivo_estado(viejo.stem)
            n += (ESTADO_DIR / viejo.name).exists()
    return n


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
    st = {"lecturas": {}, "huellas": {}, "declaradas": {}, "excepciones": {}, "menciones": {}, "comandos": [],
          "inferidos": {}, "por_debil": set(), "conectores": []}
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
            st["huellas"] = {}
        elif t == "lee":
            st["lecturas"].setdefault(ev["ruta"], []).append((ev["a"], ev["b"]))
            st["huellas"].setdefault(ev["ruta"], set()).update(ev.get("h", []))
        elif t == "corre":
            d, k = ev["delta"], ev["desde"]
            st["lecturas"][ev["ruta"]] = [(x if x < k else x + d, y if y < k else y + d)
                                          for x, y in st["lecturas"].get(ev["ruta"], [])]
        elif t == "declara":
            st["declaradas"].setdefault(ev["proy"], set()).update(ev.get("nec", []))
        elif t == "excepcion":
            st["excepciones"][ev["proy"]] = ev.get("motivo", "")
        elif t == "mencion":
            st["menciones"][ev["proy"]] = ev.get("motivo", "")
        elif t == "cmd":
            st["comandos"].append(ev["cmd"])
        elif t == "infiere":
            if ev.get("debil") and ev["proy"] not in st["inferidos"]:
                st["por_debil"].add(ev["proy"])
            elif not ev.get("debil"):
                st["por_debil"].discard(ev["proy"])
            st["inferidos"].setdefault(ev["proy"], ev.get("por", ""))
        elif t == "decide" and PATRON_CONECTOR.match(ev.get("tool", "")):   # T17: la caja negra a la vista (--estado)
            st["conectores"].append({k: ev.get(k) for k in ("tool", "obj", "v", "motivo")})
    return st


def huellas(path, a: int, b: int):
    """Huella corta de cada linea de un rango: lo leido se reconoce por CONTENIDO, no solo por numero de linea.
    Medido dos sesiones seguidas (2026-10-07): install.ps1 copia chequeo-de-trabajo.md con una vineta nueva, el
    rango de 'investigar' se corre 8 lineas y la puerta pide releer el MISMO texto que la sesion ya tenia."""
    try:
        lin = Path(path).read_text(encoding="utf-8", errors="replace").splitlines()[a - 1:b]
    except Exception:
        return []
    return [hashlib.md5(l.strip().encode("utf-8")).hexdigest()[:10] for l in lin]


def leido_por_contenido(st: dict, x: dict) -> bool:
    """El rango exigido cuenta como leido si CADA una de sus lineas (con texto) ya se vio en alguna lectura de ese
    archivo. Las lineas en blanco no cuentan: estan en todos lados y no prueban nada."""
    vistas = st.get("huellas", {}).get(x["ruta"])
    if not vistas:
        return False
    hs = [h for h, l in zip(huellas(x["ver"], x["a"], x["b"]), Path(x["ver"]).read_text(
        encoding="utf-8", errors="replace").splitlines()[x["a"] - 1:x["b"]]) if l.strip()]
    return bool(hs) and all(h in vistas for h in hs)


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


def hash_destinatario(quien: str) -> str:
    """La regla de verificar-drive.ps1: sha256 del mail recortado y en minusculas, 16 cifras. El repo es publico y los
    mails son de terceros: ni la declaracion ni la caja negra los llevan en claro."""
    return hashlib.sha256(quien.strip().lower().encode("utf-8")).hexdigest()[:16]


def audiencia() -> dict:
    """La Declaracion_De_Audiencia (.claude/estructura-drive.json). Ilegible = vacia: 'comparte' y 'ubica' niegan
    (falla cerrado). Solo cuentan los pares con 'id': la puerta ve el id del objeto, no su ruta."""
    try:
        d = json.loads(AUDIENCIA.read_text(encoding="utf-8-sig"))
    except Exception as e:  # noqa: BLE001
        return {"pares": [], "publica": None, "destinos": {}, "error": " (la declaracion no se puede leer: %s)" % e}
    pares = [x for x in d.get("compartido-con-nombre", {}).get("declarado", []) if x.get("id")]
    destinos = {x["id"]: x.get("carpeta", "") for x in d.get("destinos-del-conector", {}).get("privados", []) if x.get("id")}
    destinos.update({x["id"]: "compartida con nombre, declarada" for x in pares})
    return {"pares": pares, "publica": d.get("carpeta-publica", {}).get("id"), "destinos": destinos, "error": ""}


def decidir_conector(tool: str, inp: dict):
    """(veredicto, motivo) de una llamada a un conector. Por PERMISO: lo que no esta en la lista, niega."""
    m = PATRON_CONECTOR.match(tool)
    cid, herr = m.group(1).lower(), m.group(2)
    try:
        cat = json.loads(CONECTORES.read_text(encoding="utf-8-sig"))
    except Exception as e:  # noqa: BLE001
        return "niega", ("el Catalogo_De_Conectores (.claude/conectores.json) no se puede leer (%s): falla cerrado "
                         "(L2-PTA-16). Arreglarlo; editarlo no lo frena nadie" % e)
    srv = cat.get("servidores", {}).get(cid)
    if srv is None:
        return "niega", ("conector %s SIN CLASIFICAR en .claude/conectores.json (L2-PTA-07): un conector nuevo entra "
                         "frenado hasta clasificar cada herramienta (lectura, privado, comparte, ubica, papelera)" % cid)
    clase = srv.get("herramientas", {}).get(herr)
    if clase not in CLASES:
        return "niega", ("herramienta '%s' de %s SIN CLASE valida en .claude/conectores.json (L2-PTA-08): clasificarla"
                         % (herr, srv.get("nombre", cid)))
    if clase in CLASES_PASAN:
        return "pasa", "%s: clase %s" % (herr, clase)
    aud = audiencia()
    if clase == "comparte":
        quien = str(inp.get("emailAddress") or inp.get("chatSpaceId") or "")
        h = hash_destinatario(quien) if quien else "(sin destinatario)"
        fid, rol = str(inp.get("fileId", "")), str(inp.get("role", "")).lower()
        par = [x for x in aud["pares"] if x["id"] == fid and h in x.get("quien-sha256", [])]
        if not par:
            return "niega", ("COMPARTIR SIN DECLARAR (L2-PTA-10): el par objeto %s / destinatario sha %s no esta en "
                             "'compartido-con-nombre' de .claude/estructura-drive.json%s. Si Fran lo pidio: declararlo "
                             "ahi (id del objeto, hash del destinatario, rol) y reintentar" % (fid, h, aud["error"]))
        decl = max(ROLES.get(str(x.get("rol", "")).lower(), 0) for x in par)
        if ROLES.get(rol, 99) > decl:
            return "niega", ("ROL MAYOR QUE EL DECLARADO (L2-PTA-11): pide '%s' sobre el objeto %s para sha %s, y lo "
                             "declarado es menos" % (rol, fid, h))
        return "pasa", "compartir declarado (L2-PTA-12): objeto %s, sha %s, rol %s" % (fid, h, rol)
    destino = str(inp.get("parentId") or "")
    if not destino:
        return "pasa", "%s sin carpeta destino: la raiz privada, la carpeta del original o un renombre" % herr
    if destino == aud["publica"]:
        return "niega", ("CARPETA PUBLICA por conector (L2-PTA-13): lo publico sale solo por publicar-apuntes.ps1, con "
                         "su lista (.claude/apuntes-publicos.json); un archivo ahi hereda 'cualquiera con el link'")
    if destino in aud["destinos"]:
        return "pasa", "%s en destino declarado (L2-PTA-15): %s %s" % (herr, destino, aud["destinos"][destino][:60])
    return "niega", ("CARPETA SIN DECLARAR %s (L2-PTA-14): el objeto heredaria una audiencia que nadie eligio%s. Si "
                     "Fran lo pidio: declararla en 'destinos-del-conector' de .claude/estructura-drive.json (o con "
                     "su 'id' en 'compartido-con-nombre') y reintentar" % (destino, aud["error"]))


def pre(ev: dict) -> int:
    tool, inp = ev.get("tool_name", ""), ev.get("tool_input", {}) or {}
    if PATRON_CONECTOR.match(tool):   # T17: los conectores, por lista blanca
        v, motivo = decidir_conector(tool, inp)
        _ULTIMA_CONECTOR.update(v=v, motivo=motivo)
        return deny("PUERTA DE LOS CONECTORES (T17): " + motivo) if v == "niega" else 0
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
    tocados = proyectos_de(tool, inp, ev.get("cwd", ""), cat)
    sid = ev.get("session_id", "")
    st = estado(sid)
    # DA-070: si la accion toca varios proyectos, manda el primero que falte declarar (el que nadie libero); si estan
    # todos liberados, se exige lo de cada uno (abajo). Antes se miraba solo el primero y el resto pasaba.
    proyecto = next((p for p in tocados if p not in st["declaradas"] and p not in st["excepciones"]),
                    tocados[0] if tocados else None)
    directo = bool(proyecto)   # la accion TOCA el proyecto (ruta, comando o cwd), no solo lo nombra el pedido
    conceptos = conceptos_de(cat, tool, inp)
    if not proyecto:
        # El pedido nombro un proyecto (UserPromptSubmit) y esta accion no cae en ninguno: manda el pedido. Sin
        # esto, guardar "en mis documentos" un ejercicio de una materia pasaba sin cascada (leccion 331).
        pend_inf = [p for p in st["inferidos"] if p not in st["excepciones"] and p not in st["menciones"]]
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
                "Despues lee con Read lo que imprima, con los rangos que diga.%s Solo si de verdad no corresponde: "
                "%s %s -Excepcion \"motivo\" (queda registrada)." % (
                    proyecto, porque, entrada(), proyecto, menu(cat),
                    (" Si el pedido lo NOMBRA sin pedirlo (contexto, otra sesion, una palabra suelta): %s %s -Mencion "
                     "\"motivo\" -- libera lo de afuera, nunca su carpeta (T14b)." % (entrada(), proyecto))
                    if proyecto in st["inferidos"] and not directo else "", entrada(), proyecto))
        it, cm, nt = exigido(cat, proyecto, st["declaradas"][proyecto], [])
        faltan += it
        cmds_faltan += cm
        notas += nt
    for q in [x for x in tocados if x != proyecto and x in st["declaradas"] and x not in st["excepciones"]]:
        it, cm, nt = exigido(cat, q, st["declaradas"][q], [])   # DA-070: lo de cada proyecto que la accion toca
        faltan += it
        cmds_faltan += cm
        notas += nt
    if conceptos:
        it, cm, nt = exigido(cat, None, [], conceptos)
        faltan += it
        cmds_faltan += cm
        notas += nt
    pend = [x for x in faltan if not cubierto(st["lecturas"].get(x["ruta"], []), x["a"], x["b"])
            and not leido_por_contenido(st, x)]
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
    # T13 (L2-PTA-01..03): sin documento declarado y en fase A-D, la salida es escribir un archivo de requisitos DEL
    # proyecto (el nombre dispara el concepto 'requisitos', que exige los libros) o el registro.
    no_existe += [n for n in notas if n.startswith((SIN_REQ_FASE + ": ", "FASE ILEGIBLE: ")) and directo
                  and not registro and not escribe_requisitos(n, destino)]
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
        anotar(sid, {"t": "lee", "ruta": norm(fp), "a": a, "b": b, "h": huellas(fp, a, b)})
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
            # T14b (L2-PTA-05): la sesion registra que el pedido NOMBRA el proyecto sin pedirlo. No es una excepcion:
            # libera lo de afuera (el caso 331) y nunca la ruta del proyecto, que sigue pidiendo la necesidad.
            mn = re.search(r"-Mencion\s+[\"']([^\"']+)[\"']", resto)
            if mn:
                anotar(sid, {"t": "mencion", "proy": proy, "motivo": mn.group(1)})
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
    # Contexto de la sesion: lo que ya se declaro y lo inferido por una senal FUERTE. Un proyecto con excepcion o
    # mencion no cuenta: las dos dicen justamente que la sesion no es de ese proyecto.
    ctx = [p for p in list(st["declaradas"]) + [q for q in st["inferidos"] if q not in st["por_debil"]]
           if p not in st["excepciones"] and p not in st["menciones"]]
    inferidos, cedidos = inferidos_de(cat, sin_ajeno(str(ev.get("prompt", ""))), ctx)
    for p, por, debil in inferidos:
        if p not in st["inferidos"]:
            anotar(sid, {"t": "infiere", "proy": p, "por": por, "debil": debil})
        if p not in st["declaradas"] and p not in st["excepciones"] and p not in st["menciones"]:
            nuevos.append((p, por))
    if nuevos:
        print("CASCADA: el pedido toca %s. Antes de actuar (escribir, guardar, correr), aunque sea un ejercicio "
              "chico: %s %s -Necesidad <a,b> y leer lo que imprima; donde se guarda lo local lo dice su contrato. "
              "La puerta lo exige. Hasta declararla NIEGA todo Bash, PowerShell, Write y Edit, AUNQUE NO TOQUEN el "
              "proyecto (la senal es el pedido, no la ruta): esa es la PRIMERA llamada, SOLA, sin nada en paralelo; "
              "mirar con Read, Glob y Grep si pasa (2026-10-07: cuatro llamadas negadas por no saberlo). Si Fran lo "
              "NOMBRA sin pedirlo (contexto, otra sesion, una palabra suelta), la primera llamada es %s %s -Mencion "
              "\"motivo\": queda registrado y libera lo de afuera, nunca su carpeta (T14b)."
              % (", ".join("%s (senal '%s')" % x for x in nuevos), entrada(), nuevos[0][0], entrada(), nuevos[0][0]))
    for p, por, otro in cedidos:
        if p not in st["declaradas"] and p not in st["excepciones"] and p not in st["menciones"] \
                and p not in st["inferidos"]:
            print("CASCADA (aviso, sin freno): '%s' es vocabulario de %s, pero la sesion ya es de %s. Si el pedido "
                  "TAMBIEN es de %s: %s %s -Necesidad <a,b> (leccion 372)." % (por, p, otro, p, entrada(), p))
    return 0


def registrar_decision(ev: dict, salida: str):
    """La CAJA NEGRA de la puerta (Fran, 2026-10-07: 'que la respuesta sea tan trazable a los hechos como un capacitor
    de la Voyager 1'). Cada accion que la puerta media queda anotada con su veredicto y su motivo, con hora: es lo que
    auditar-sesion.py lee para contestar si la arquitectura se cumplio, en vez de creerle a lo que la sesion dice de
    si misma. Falla abierto a proposito: perder un renglon de auditoria no puede frenar el trabajo."""
    try:
        tool, inp = ev.get("tool_name", ""), ev.get("tool_input", {}) or {}
        conector = bool(PATRON_CONECTOR.match(tool))
        if tool not in ACCIONES and not conector:
            return
        obj = str(inp.get("file_path", inp.get("notebook_path", ""))) or str(inp.get("command", ""))
        if conector:   # T17 (L2-PTA-17): que objeto y a donde; el destinatario como hash, nunca en claro
            quien = str(inp.get("emailAddress") or inp.get("chatSpaceId") or "")
            obj = " ".join("%s=%s" % (k, inp[k]) for k in ("fileId", "parentId", "role") if inp.get(k))   # sin titulo: la auditoria se commitea
            obj += (" a=sha:" + hash_destinatario(quien)) if quien else ""
        niega = '"deny"' in salida
        motivo = _ULTIMA_CONECTOR.get("motivo", "") if conector else ""
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
    # Lo que la puerta va a exigir AL TOCAR los archivos que el proyecto declara: hoy, su documento de requisitos y
    # el concepto que dispara. Medido el 2026-10-07 (telescopio, duodecima sesion): cinco Edit a 10-requisitos.md
    # negados en paralelo, porque el concepto 'requisitos' (GtWR, catedra, NASA) no aparecia al declarar la necesidad
    # y recien lo nombraba la primera negacion. Se imprime con rangos, como la base, para leerlo ANTES de editar.
    req = (ent or {}).get("requisitos")
    cs = conceptos_de(cat, "Edit", {"file_path": req}) if req else []
    impresos = set(cs)
    if cs:
        citems, _, _ = exigido(cat, None, [], cs)
        print("  AL EDITAR %s la puerta exige ADEMAS (concepto %s) -- leer antes de la primera edicion, y la primera "
              "edicion SOLA (una negada en paralelo son N negadas):" % (req, ", ".join(cs)))
        for x in citems:
            print("    %-62s %5d-%-5d %s" % (rel(x["ver"])[-62:], x["a"], x["b"], x["por"][:60]))
    # DA-064 (L2-CAS-04): las necesidades (N-xx) viven en el documento de requisitos; editar esa seccion es escribir un
    # alcance, y el concepto que dispara por la SECCION se imprime aparte, porque no vale para todo el documento.
    pr = (proyectos_del_disco().get(p) or Path(".")) / req if req else None
    if pr is not None and pr.exists():
        cs2 = [c for c in conceptos_de(cat, "Write", {"file_path": str(pr), "content": pr.read_text(
            encoding="utf-8", errors="replace")}) if c not in impresos]
        if cs2:
            impresos.update(cs2)
            citems, _, _ = exigido(cat, None, [], cs2)
            print("  AL EDITAR las secciones de alcance de %s (necesidades, metas, objetivos) la puerta exige ADEMAS "
                  "(concepto %s):" % (req, ", ".join(cs2)))
            for x in citems:
                print("    %-62s %5d-%-5d %s" % (rel(x["ver"])[-62:], x["a"], x["b"], x["por"][:60]))
    # DA-058 (T15, recurrencia de la leccion 351 registrada con 'aprender.py repite'): lo mismo para los conceptos que
    # la NECESIDAD declarada va a tocar ('al_tocar' en el catalogo). Medido: 'metodo' edita frenos (hooks, guardias,
    # chequeo-completo) y el concepto freno lo nombraba recien la primera negacion -- tres en paralelo el 2026-10-16.
    for n in dict.fromkeys(list((ent or {}).get("necesidades", [])) + list(necs or [])):
        for c in cat.get("necesidades", {}).get(n, {}).get("al_tocar", []):
            cd = cat.get("conceptos", {}).get(c)
            if cd is None:
                print("  ! la necesidad %s declara al_tocar '%s', que no es un concepto del catalogo" % (n, c))
                continue
            if c in impresos:   # dos necesidades con el mismo al_tocar, o ya impreso con los requisitos
                continue
            impresos.add(c)
            citems, _, _ = exigido(cat, None, [], [c])
            print("  AL TOCAR %s (necesidad %s) la puerta exige ADEMAS (concepto %s) -- leer antes de la primera "
                  "accion, y la primera accion SOLA:" % (cd.get("que", c)[:70], n, c))
            for x in citems:
                print("    %-62s %5d-%-5d %s" % (rel(x["ver"])[-62:], x["a"], x["b"], x["por"][:60]))
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
        n = migrar_legado()   # T15: lo que quede en %TEMP% pasa a la caja negra persistente (L2-PTA-19)
        if n:
            print("[ok  ] caja negra: %d sesion(es) copiadas de %s a %s" % (n, LEGADO_DIR, ESTADO_DIR))
    except Exception as e:
        rojos.append("caja negra: la migracion del legado revento (%s)" % e)
    if Path(tempfile.gettempdir()).resolve() in ESTADO_DIR.resolve().parents and not os.environ.get("CASCADA_ESTADO_DIR"):
        rojos.append("caja negra en el directorio temporal: %s (L2-PTA-18)" % ESTADO_DIR)
    try:
        cat = cargar_catalogo()
    except Exception as e:
        print("[FAIL] catalogo ilegible: %s" % e)
        return 1
    for n, nd in cat.get("necesidades", {}).items():   # DA-058: un al_tocar que no resuelve no avisa nada
        for c in nd.get("al_tocar", []):
            if c not in cat.get("conceptos", {}):
                rojos.append("la necesidad %s declara al_tocar '%s', que no es un concepto" % (n, c))
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
        for s in ent[n].get("senales", []) + ent[n].get("senales_debiles", []):
            try:
                re.compile(s)
            except re.error as e:
                rojos.append("%s: senal con regex rota %r (%s)" % (n, s, e))
        for loc in ent[n].get("locales", []):
            if not (loc.startswith("~") or os.path.isabs(loc)):
                rojos.append("%s: carpeta local que no es absoluta ni empieza con ~: %s" % (n, loc))
    for nombre, cd in cat.get("conceptos", {}).items():
        pats = [(k, cd[k]) for k in ("comando", "archivo") if cd.get(k)]
        # DA-064 (L2-VER-04): un patron de titulo roto hace reventar la puerta en cada Edit: se ve aca, en el arranque
        for j, s in enumerate(cd.get("secciones", [])):
            if not isinstance(s, dict) or not s.get("titulo"):
                rojos.append("concepto %s: la seccion %d no trae 'titulo'" % (nombre, j))
                continue
            pats += [("secciones[%d].%s" % (j, k), s[k]) for k in ("titulo", "archivo", "excepto") if s.get(k)]
        for k, pat in pats:
            try:
                re.compile(pat)
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
        # T13: la exposicion por fase se LISTA abajo (L2-VER-01), no es un rojo: frena la puerta al entrar.
        rojos += [n for n in notas if n not in vistos and not n.startswith((SIN_REQ_FASE + ": ", "FASE ILEGIBLE: "))]
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
        reg = Path(os.environ.get("CASCADA_SETTINGS") or RAIZ / ".claude" / "settings.json")   # el saboteador lo cambia
        hooks = json.loads(reg.read_text(encoding="utf-8-sig")).get("hooks", {})
        for evento in ("PreToolUse", "PostToolUse", "SessionStart", "UserPromptSubmit"):
            # en PreToolUse la puerta corre por su LANZADOR (la politica de falla: 2026-10-07)
            esperado = "puerta-lanzador.py" if evento == "PreToolUse" else "cascada_puerta.py"
            if esperado not in json.dumps(hooks.get(evento, [])):
                rojos.append("%s NO esta registrado en %s de .claude/settings.json (.claude\\instalar-hooks.ps1)"
                             % (esperado, evento))
        # T17 (L2-VER-03): los CONECTORES pasan por la puerta. Se mide el matcher contra un nombre real de conector,
        # no que el texto del matcher este: un matcher que no atrapa es lo mismo que ninguno.
        lanz = [x.get("matcher", "") for x in hooks.get("PreToolUse", []) if "puerta-lanzador.py" in json.dumps(x)]
        if not any(re.search(mt, MUESTRA_CONECTOR) for mt in lanz if mt):
            rojos.append("los CONECTORES no pasan por la puerta: ningun matcher de PreToolUse con puerta-lanzador.py "
                         "atrapa %s (T17, L2-VER-03); agregar '%s'" % (MUESTRA_CONECTOR, MATCHER_CONECTORES))
    except Exception as e:
        rojos.append(".claude/settings.json ilegible: %s" % e)
    # T17: el Catalogo_De_Conectores parsea y cada clase es una que la puerta conoce (si no, esa herramienta niega
    # siempre: un falso positivo es combustible para que saquen el freno).
    try:
        for cid, srv in json.loads(CONECTORES.read_text(encoding="utf-8-sig")).get("servidores", {}).items():
            if not re.fullmatch(_ID_CONECTOR, cid):
                rojos.append("conectores.json: id de conector con otra forma: %s" % cid)
            for h, c in srv.get("herramientas", {}).items():
                if c not in CLASES:
                    rojos.append("conectores.json: %s/%s con clase desconocida '%s'" % (srv.get("nombre", cid), h, c))
    except Exception as e:  # noqa: BLE001
        rojos.append("conectores.json ilegible (%s): la puerta niega toda llamada de conector" % e)
    # Las piezas de la puerta COMPILAN: un error de sintaxis en el lanzador lo dejaria fallar abierto sin que nadie lo
    # note (es la pieza que no tiene quien la repare). compile() no escribe nada en el disco.
    for pieza in ("cascada_puerta.py", "puerta-lanzador.py", "fase_activa.py"):
        f = Path(__file__).with_name(pieza)
        try:
            compile(f.read_text(encoding="utf-8"), str(f), "exec")
        except Exception as e:
            rojos.append("%s NO compila (%s): la puerta corre rota" % (pieza, e))
    # T13 (L2-VER-01 y L2-VER-02): la fase de cada proyecto, tipada con la compuerta. Un PDP cuya fase no se puede
    # tipar es un rojo (el instrumento); un proyecto expuesto o sin tipo se lista, con su umbral escrito.
    expuestos, sin_tipo = [], []
    for n in sorted(disco):
        try:
            f = fase_de(disco[n])
        except Exception as e:  # noqa: BLE001
            rojos.append("FASE ILEGIBLE en %s: %s (la puerta niega sobre ese proyecto)" % (n, e))
            continue
        if not f:
            continue
        if f[1] is None:
            sin_tipo.append("%s (%s)" % (n, f[0]))
        elif exige_requisitos(disco[n], f) and not ent.get(n, {}).get("requisitos"):
            expuestos.append("%s (%s)" % (n, f[1]))
    for r in rojos:
        print("[FAIL] " + r)
    print("EXPUESTOS -- fase A-D sin documento de requisitos; la puerta los frena AL ENTRAR (T13, Fran 2026-10-12): "
          "%d -> %s" % (len(expuestos), ", ".join(expuestos) or "ninguno"))
    print("FASE SIN TIPO NASA -- la compuerta no sabe que NO se hace en ellas: %d -> %s"
          % (len(sin_tipo), ", ".join(sin_tipo) or "ninguno"))
    print("cascada.json: %s (%d proyectos, %d necesidades, %d conceptos)" % (
        "OK" if not rojos else "%d ROJO(S)" % len(rojos), len(ent), len(cat.get("necesidades", {})),
        len(cat.get("conceptos", {}))))
    return 1 if rojos else 0


def autotest() -> int:
    """Corre el hook como lo corre Claude Code (subproceso, JSON por stdin) con estado y log aislados."""
    global RAIZ  # el caso 10f lo cambia un momento (perfil-global al lado del arbol) y lo restaura
    import subprocess
    tmp = Path(tempfile.mkdtemp(prefix="cascada-autotest-"))
    black = RAIZ / "proyectos" / "ingenieria" / "black"
    # T13: black real esta en fase A-D sin requisitos y la puerta lo frena por eso. Los casos de la cascada (1-13) miden
    # OTRA cosa, asi que corren con un catalogo donde black declara un documento de requisitos que existe: si no, todo
    # control positivo daria deny por el motivo equivocado. T13 se prueba aparte, sobre un arbol sintetico (caso 16).
    req_base = tmp / "requisitos-base.md"
    req_base.write_text("# Requisitos (autotest)\n\n| ID | Requisito |\n|---|---|\n| L0-01 | x |\n", encoding="utf-8")
    cat_base = cargar_catalogo()
    cat_base["proyectos"].setdefault("black", {})["requisitos"] = str(req_base)
    f_base = tmp / "cat-base.json"
    f_base.write_text(json.dumps(cat_base, ensure_ascii=False), encoding="utf-8")
    env = dict(os.environ, CASCADA_ESTADO_DIR=str(tmp / "estado"), CASCADA_LOG_EXC=str(tmp / "exc.log"),
               CASCADA_CATALOGO=str(f_base))
    sid = "autotest-%d" % os.getpid()
    mal = 0

    def correr(ev, cat_env=None, script=__file__):
        e = dict(env)
        if cat_env:
            e.update(cat_env)
        r = subprocess.run([sys.executable, str(script)], input=json.dumps(ev).encode("utf-8"), capture_output=True,
                           env=e)
        return r.stdout.decode("utf-8", "replace")

    def pre_ev(tool, inp, s=sid, cwd=str(RAIZ)):
        return {"hook_event_name": "PreToolUse", "session_id": s, "tool_name": tool, "tool_input": inp, "cwd": cwd}

    def post_ev(tool, inp, s=sid):
        return {"hook_event_name": "PostToolUse", "session_id": s, "tool_name": tool, "tool_input": inp}

    def caso(nombre, salida, espera_deny, debe_contener=None, no_debe_contener=None):
        nonlocal mal
        es = '"deny"' in salida
        ok = (es == espera_deny and (debe_contener is None or debe_contener in salida)
              and (no_debe_contener is None or no_debe_contener not in salida))
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
    cat = cat_base
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
    # 10c2. lo leido se reconoce por CONTENIDO: otro proceso (install.ps1) corre las lineas del archivo exigido y el
    # mismo texto no se pide de nuevo; si el texto CAMBIA, si (medido dos sesiones seguidas, 2026-10-07)
    fc = tmp / "corrido.md"
    sec = ["## SECCION AUTOTEST"] + ["regla %d de la seccion" % k for k in range(1, 7)] + ["## OTRA"]
    fc.write_text("\n".join(["cabecera"] + sec + ["cola"]) + "\n", encoding="utf-8")
    cat_c = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    cat_c.setdefault("conceptos", {})["corrido"] = {"comando": r"\bcorrido-autotest\b", "leer": [
        {"ruta": str(fc), "desde": "^## SECCION AUTOTEST", "hasta": "^## OTRA", "por": "autotest"}]}
    fcat = tmp / "corrido.json"
    fcat.write_text(json.dumps(cat_c, ensure_ascii=False), encoding="utf-8")
    s12, ecat = sid + "-hu", {"CASCADA_CATALOGO": str(fcat)}
    correr(post_ev("Read", {"file_path": str(fc), "offset": 2, "limit": 7}, s12), ecat)
    caso("CONTROL: leido el rango -> pasa", correr(pre_ev("Bash", {"command": "corrido-autotest"}, s12), ecat), False)
    fc.write_text("\n".join(["cabecera", "nueva 1", "nueva 2", "nueva 3"] + sec + ["cola"]) + "\n", encoding="utf-8")
    caso("CONTROL: el mismo texto corrido 3 lineas -> pasa (contenido)",
         correr(pre_ev("Bash", {"command": "corrido-autotest"}, s12), ecat), False)
    fc.write_text("\n".join(["cabecera", "nueva 1", "nueva 2", "nueva 3"] + sec[:3] + ["regla CAMBIADA"] + sec[4:]
                            + ["cola"]) + "\n", encoding="utf-8")
    caso("una linea del rango CAMBIO -> deny (no basta haberlo visto antes)",
         correr(pre_ev("Bash", {"command": "corrido-autotest"}, s12), ecat), True, "falta LEER")
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
    # 15. leccion 372: una senal DEBIL (vocabulario del tema, como 'punteros') sigue frenando sola -- el caso 331 --
    # y cede si el pedido nombra OTRO proyecto con una FUERTE o la sesion ya esta en otro -- el retome de BLACK que
    # hablaba de los punteros del jugador. Catalogo sintetico, como el 14; los pedidos imitan los reales.
    cat_d = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    p_a, p_b = sorted(proyectos_del_disco())[:2]
    cat_d["proyectos"].setdefault(p_a, {}).update({"senales": [r"zz materia a zz"], "senales_debiles": [r"\bzzvocab\b"]})
    cat_d["proyectos"].setdefault(p_b, {}).update({"senales": [r"(?-i:ZZJUEGO)"], "senales_debiles": []})
    f_d = tmp / "cat-debiles.json"
    f_d.write_text(json.dumps(cat_d, ensure_ascii=False), encoding="utf-8")
    e_d = {"CASCADA_CATALOGO": str(f_d), "CASCADA_RAIZ": str(RAIZ)}

    def pedido(s, texto, script=__file__):
        return correr({"hook_event_name": "UserPromptSubmit", "session_id": s, "prompt": texto}, e_d, script)

    def caso_331(s, script=__file__):   # la debil SOLA: 'hace el ejercicio de punteros y guardalo en mis documentos'
        pedido(s, "hace el ejercicio de zzvocab a funcion y guardalo en mis documentos", script)
        return correr(pre_ev(*afuera, s=s), e_d, script)

    def caso_372(s, script=__file__):   # la debil con la FUERTE de otro, y ese otro ya resuelto (aca, por excepcion)
        out = pedido(s, "retome de ZZJUEGO (125): los zzvocab del jugador y su soporte de modelo", script)
        correr(post_ev("PowerShell", {"command": ".\\cascada.ps1 %s -Excepcion \"prueba\"" % p_b}, s), e_d, script)
        return out, correr(pre_ev(*afuera, s=s), e_d, script)

    caso("SABOTAJE 331: senal DEBIL sola + Write fuera -> deny", caso_331(sid + "-d331"), True, "'%s'" % p_a)
    out, w = caso_372(sid + "-d372")
    caso("CONTROL 372: debil + FUERTE de otro -> aviso sin freno", out, False, "sin freno", "toca %s" % p_a)
    caso("CONTROL 372: ... y el Write fuera pasa", w, False)
    s14 = sid + "-dturno"
    pedido(s14, "retome de ZZJUEGO")
    correr(post_ev("PowerShell", {"command": ".\\cascada.ps1 %s -Necesidad ninguna" % p_b}, s14), e_d)
    caso("CONTROL: turno siguiente sin nombrarlo, sesion ya declarada -> cede",
         pedido(s14, "mira los zzvocab del jugador"), False, "sin freno", "toca %s" % p_a)
    s15 = sid + "-dexc"
    pedido(s15, "retome de ZZJUEGO")
    correr(post_ev("PowerShell", {"command": ".\\cascada.ps1 %s -Excepcion \"prueba\"" % p_b}, s15), e_d)
    pedido(s15, "ahora hace el ejercicio de zzvocab")
    caso("SABOTAJE: un proyecto con EXCEPCION no es contexto -> deny",
         correr(pre_ev(*afuera, s=s15), e_d), True, "'%s'" % p_a)
    # Los dos mutantes, uno por mitad: cada uno tiene que caer en SU caso, no en uno cualquiera.
    fuente = Path(__file__).read_text(encoding="utf-8")
    for n, (nombre, viejo, nuevo) in enumerate((
            ("MUTANTE (la debil nunca cede) frena el retome 372", "        if otros:\n", "        if False:\n"),
            ("MUTANTE (no lee senales_debiles) deja pasar el 331", '("senales_debiles", debiles)',
             '("senales_nada", debiles)'))):
        m = tmp / ("mutante-debil-%d.py" % n)
        txt = fuente.replace(viejo, nuevo, 1)
        m.write_text(txt, encoding="utf-8")
        if txt == fuente:
            ok, r = False, "el mutante NO APLICA (el texto a reemplazar cambio)"
        elif n == 0:
            r = caso_372(sid + "-m0", m)[1]
            ok = '"deny"' in r and "'%s'" % p_a in r
        else:
            r = caso_331(sid + "-m1", m)
            ok = '"deny"' not in r
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE: %s" % r[:200]))
    # Una regex DEBIL rota tambien la ve --verificar (si no, inferidos_de revienta en UserPromptSubmit, que falla
    # abierto: la senal desapareceria en silencio).
    cat_d["proyectos"][p_a]["senales_debiles"] = [r"(zz rota"]
    f_d.write_text(json.dumps(cat_d, ensure_ascii=False), encoding="utf-8")
    r = subprocess.run([sys.executable, __file__, "--verificar"], capture_output=True,
                       env=dict(env, CASCADA_CATALOGO=str(f_d)))
    ok = r.returncode == 1 and "senal con regex rota" in r.stdout.decode("utf-8", "replace")
    mal += not ok
    print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "senal DEBIL con regex rota -> --verificar en rojo",
                               "rojo" if ok else "NO"))
    # 16. T13, «la fase manda» (L2-PTA-01..03, L2-VER-01/02). Arbol SINTETICO: el caso exacto no depende de la fase
    # de un proyecto vivo. Base y conceptos vacios: el unico motivo posible de un deny es la fase sin requisitos.
    r13 = tmp / "raiz13"
    pdp_t = ("# PDP\n\n## 2. Que NO es\n\nNo es un programa: es una pieza sola, con su alcance escrito aca.\n\n"
             "## 4. Las fases\n\n| # | Fase | Cierra | Estado |\n|---|---|---|---|\n"
             "| 3 | %s | CDR | **abierta** |\n\n**Fase en curso:** 3\n\n## 5. Riesgos\n\n| R1 | x |\n")

    def proyecto13(nombre, fila, nat="ingenieria"):
        d = r13 / "proyectos" / nat / nombre
        (d / "docs").mkdir(parents=True, exist_ok=True)
        (d / "PDP.md").write_text(pdp_t % fila, encoding="utf-8")
        for f in ("CLAUDE.md", "ESTADO_ACTUAL.md", "HANDOFF.md"):
            (d / f).write_text("# %s\n" % f, encoding="utf-8")
        return d

    d_c = proyecto13("demo-c", "Fase C: diseño final")
    d_a = proyecto13("demo-prea", "Pre-Fase A: estudio de conceptos")
    d_r = proyecto13("demo-req", "Fase D: integración y prueba")
    (d_r / "docs" / "10-requisitos.md").write_text("| L1-01 | x |\n", encoding="utf-8")
    # T19a (L1-04 acotado por N-09): el mismo PDP en Fase C, pero de un proyecto de materia
    d_ap = proyecto13("demo-apunte", "Fase C: diseño final", nat="documentos")
    c13 = {"base": [], "conceptos": {}, "necesidades": {"ninguna": {"que": "x", "leer": []}},
           "proyectos": {"demo-c": {}, "demo-prea": {}, "demo-req": {"requisitos": "docs/10-requisitos.md"},
                         "demo-apunte": {}}}
    f13 = tmp / "cat-t13.json"
    f13.write_text(json.dumps(c13, ensure_ascii=False), encoding="utf-8")
    e13 = {"CASCADA_CATALOGO": str(f13), "CASCADA_RAIZ": str(r13)}
    s16 = sid + "-t13"

    def t13(tool, inp, script=__file__, s=s16):
        return correr(pre_ev(tool, inp, s, cwd=str(r13)), e13, script)

    for n in ("demo-c", "demo-prea", "demo-req", "demo-apunte"):
        correr(post_ev("PowerShell", {"command": ".\\cascada.ps1 %s -Necesidad ninguna" % n}, s16), e13)
    correr(post_ev("Read", {"file_path": str(d_r / "docs" / "10-requisitos.md")}, s16), e13)
    ed = lambda d, f: ("Edit", {"file_path": str(d / f), "old_string": "a", "new_string": "b"})  # noqa: E731
    caso("T13 SABOTAJE: Fase C sin requisitos, editar diseno -> deny",
         t13(*ed(d_c, "docs/x.md")), True, SIN_REQ_FASE)
    caso("T13 SABOTAJE: Fase C sin requisitos, comando sobre el proyecto -> deny",
         t13("PowerShell", {"command": "New-Item -ItemType File '%s'" % (d_c / "docs" / "y.md")}), True, SIN_REQ_FASE)
    caso("T13 SABOTAJE: un archivo que SOLO se llama parecido -> deny",
         t13(*ed(d_c, "docs/handoff-viejo.md")), True, SIN_REQ_FASE)
    caso("T13 CONTROL: escribir docs/10-requisitos.md del proyecto -> pasa",
         t13("Write", {"file_path": str(d_c / "docs" / "10-requisitos.md"), "content": "# Requisitos\n"}), False)
    caso("T13 CONTROL: el registro (HANDOFF) -> pasa", t13(*ed(d_c, "HANDOFF.md")), False)
    caso("T13 CONTROL: lectura pura sobre el proyecto -> pasa",
         t13("PowerShell", {"command": "Get-Content '%s'" % (d_c / "PDP.md")}), False)
    caso("T13 CONTROL: Pre-Fase A sin requisitos -> pasa", t13(*ed(d_a, "docs/x.md")), False)
    caso("T13 CONTROL: Fase D CON requisitos leidos -> pasa", t13(*ed(d_r, "docs/x.md")), False)
    caso("T19a CONTROL: apunte (documentos) en Fase C sin requisitos -> pasa", t13(*ed(d_ap, "docs/x.md")), False)
    # el verificador LISTA (no frena) a los expuestos y a las fases sin tipo
    d_st = proyecto13("demo-sin-tipo", "una fase del apunte")
    c13["proyectos"]["demo-sin-tipo"] = {}
    f13.write_text(json.dumps(c13, ensure_ascii=False), encoding="utf-8")
    sal = subprocess.run([sys.executable, __file__, "--verificar"], capture_output=True,
                         env=dict(env, **e13)).stdout.decode("utf-8", "replace")
    lin_e = next((l for l in sal.splitlines() if l.startswith("EXPUESTOS")), "")
    lin_t = next((l for l in sal.splitlines() if l.startswith("FASE SIN TIPO")), "")
    fail_t13 = [l for l in sal.splitlines() if l.startswith("[FAIL]") and ("demo-c" in l or "demo-sin-tipo" in l)]
    ok = "demo-c (Fase C)" in lin_e and "demo-prea" not in lin_e and "demo-req" not in lin_e \
        and "demo-apunte" not in lin_e and "demo-sin-tipo" in lin_t and not fail_t13
    mal += not ok
    print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "T13 --verificar LISTA expuestos y sin tipo, sin [FAIL]",
                               lin_e[:60] if ok else "NO: %s | %s | %s" % (lin_e, lin_t, fail_t13)))
    # mutantes, uno por mecanismo, cada uno visto en SU caso (llego / cambio / salio). El mutante vive en tmp y
    # fase_de importa la compuerta de SU carpeta: sin la copia, todos reventarian por la razon equivocada (lo vio el
    # primer mutante: deny por FASE ILEGIBLE cuando esperaba que pasara).
    shutil.copy(Path(__file__).with_name("fase_activa.py"), tmp / "fase_activa.py")
    for n, (nombre, viejo, nuevo, espera_deny, d, f, s_m, motivo) in enumerate((
            ("MUTANTE (ninguna fase es de desarrollo) deja pasar la Fase C",
             'FASES_DESARROLLO = ("Fase A", "Fase B", "Fase C", "Fase D")', "FASES_DESARROLLO = ()",
             False, d_c, "docs/x.md", s16 + "-m0", None),
            ("MUTANTE (la fase revienta) NIEGA hasta la Pre-Fase A",
             "    import fase_activa\n", "    raise RuntimeError('fase rota')\n",
             True, d_a, "docs/x.md", s16 + "-m1", "fase rota"),
            ("MUTANTE (sin salida de requisitos) niega escribirlos",
             "and not escribe_requisitos(n, destino)]", "and not False]",
             True, d_c, "docs/10-requisitos.md", s16 + "-m2", SIN_REQ_FASE),
            ("MUTANTE T19a (documentos con ciclo NASA) frena el apunte",
             'NATURALEZAS_NASA = ("ingenieria",)', 'NATURALEZAS_NASA = ("ingenieria", "documentos")',
             True, d_ap, "docs/x.md", s16 + "-m3", SIN_REQ_FASE))):
        m = tmp / ("mutante-t13-%d.py" % n)
        txt = Path(__file__).read_text(encoding="utf-8").replace(viejo, nuevo, 1)
        if txt == Path(__file__).read_text(encoding="utf-8"):
            ok, r = False, "el mutante NO APLICA (el texto a reemplazar cambio)"
        else:
            m.write_text(txt, encoding="utf-8")
            correr(post_ev("PowerShell", {"command": ".\\cascada.ps1 %s -Necesidad ninguna" % d.name}, s_m), e13, m)
            tool_inp = ("Write", {"file_path": str(d / f), "content": "x"}) if f.endswith("requisitos.md") else ed(d, f)
            r = t13(*tool_inp, script=m, s=s_m)
            ok = ('"deny"' in r) == espera_deny and (motivo is None or motivo in r)
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE: %s" % r[:200]))
    # 17. T14 (L2-PTA-04): la puerta infiere SOLO de lo que tipea Fran. La misma senal FUERTE adentro de un retome
    # pegado, de una notificacion o de un recordatorio no frena; tipeada, si (el 331 sigue); afuera Y adentro manda lo
    # tipeado; un bloque sin cierre no se recorta (falla cerrado). Catalogo sintetico, como el 14 y el 15.
    cat_k = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    p_k = sorted(proyectos_del_disco())[0]
    # sinteticas de verdad: sin las senales reales de los otros proyectos, un pedido que imita uno real ('retomo el
    # metodo') no infiere a otro proyecto (paso el 2026-10-12 al darle senal propia a arquitectura-se, DA-054)
    for q, ent_q in cat_k["proyectos"].items():
        if q != p_k:
            ent_q.pop("senales", None)
            ent_q.pop("senales_debiles", None)
    cat_k["proyectos"].setdefault(p_k, {}).update({"senales": [r"zz proyecto pegado zz"], "senales_debiles": []})
    f_k = tmp / "cat-t14.json"
    f_k.write_text(json.dumps(cat_k, ensure_ascii=False), encoding="utf-8")
    e_k = {"CASCADA_CATALOGO": str(f_k), "CASCADA_RAIZ": str(RAIZ)}
    sen_k = "ZZ PROYECTO PEGADO ZZ"

    def bloque(etq, cuerpo, attrs=""):
        return "<%s%s>\n%s\n</%s>" % (etq, attrs, cuerpo, etq)

    pedidos_k = (   # (nombre, pedido, niega); los pedidos imitan los reales del 2026-10-12
        ("T14 CONTROL: senal en pasted_content + Write fuera -> pasa",
         "retomo el metodo:\n" + bloque("pasted_content", "1. LEER el retome de " + sen_k, ' id="a1b2c3"'), False),
        ("T14 CONTROL: senal en task-notification -> pasa",
         bloque("task-notification", "<summary>el mapa termino: " + sen_k + "</summary>"), False),
        ("T14 CONTROL: senal en system-reminder -> pasa", "segui\n" + bloque("system-reminder", sen_k), False),
        ("T14 SABOTAJE 331: la senal TIPEADA fuera -> deny", "hace el ejercicio de " + sen_k, True),
        ("T14 SABOTAJE: tipeada fuera Y pegada adentro -> deny",
         "y " + sen_k + " tambien\n" + bloque("pasted_content", sen_k), True),
        ("T14 SABOTAJE: bloque SIN cierre no se recorta -> deny", "<pasted_content>\n" + sen_k, True))

    def caso_k(n, script=__file__):   # sesion propia por script: lo inferido persiste y contaminaria al mutante
        s = "%s-t14-%d-%s" % (sid, n, Path(script).stem)
        correr({"hook_event_name": "UserPromptSubmit", "session_id": s, "prompt": pedidos_k[n][1]}, e_k, script)
        return correr(pre_ev(*afuera, s=s), e_k, script)

    for n, (nombre, _, niega) in enumerate(pedidos_k):
        caso(nombre, caso_k(n), niega, "'%s'" % p_k if niega else None)
    # mutantes, cada uno visto en SU caso: sin el recorte vuelve el falso freno del retome pegado; recortando un
    # bloque sin cierre, el truncado deja de frenar (fallaria abierto)
    for nombre, viejo, nuevo, n in (
            ("MUTANTE (sin el recorte) frena el retome pegado",
             'sin_ajeno(str(ev.get("prompt", "")))', 'str(ev.get("prompt", ""))', 0),
            ("MUTANTE (recorta sin cierre) deja pasar el truncado", r".*?</\1\s*>", r".*?(</\1\s*>|$)", 5)):
        m = tmp / ("mutante-t14-%d.py" % n)
        fuente = Path(__file__).read_text(encoding="utf-8")
        txt = fuente.replace(viejo, nuevo, 1)
        if txt == fuente:
            ok, r = False, "el mutante NO APLICA (el texto a reemplazar cambio)"
        else:
            m.write_text(txt, encoding="utf-8")
            r = caso_k(n, m)
            ok = ('"deny"' in r) != pedidos_k[n][2] and ('"deny"' not in r or "'%s'" % p_k in r)
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE: %s" % r[:200]))
    # la compuerta con una ruta es LECTURA pura (la auditoria de de44da9d la conto como accion sobre black)
    caso("T14 CONTROL: fase_activa.py <ruta de black> sin declarar -> pasa",
         correr(pre_ev("PowerShell", {"command": 'python .claude/hooks/fase_activa.py "%s"' % black}, sid + "-t14-fa")),
         False)
    caso("T14 SABOTAJE: fase_activa.py <ruta> encadenado a una accion -> deny",
         correr(pre_ev("PowerShell", {"command": 'python .claude/hooks/fase_activa.py "%s"; Remove-Item "%s"'
                                      % (black, black / "x")}, sid + "-t14-fa")), True)
    # 18. T14b (L2-PTA-05, L2-PTA-06): mencionar no es pedir. La senal TIPEADA infiere el proyecto (el 331 sigue
    # frenando); con la Mencion registrada lo de afuera pasa, y la carpeta del proyecto mencionado sigue pidiendo la
    # necesidad -- lo que separa la Mencion de la Excepcion. Mismo catalogo sintetico que el 17.
    dentro_k = ("Write", {"file_path": str(proyectos_del_disco()[p_k] / "zz-t14b.md"), "content": "x"})
    casos_m = (   # (nombre, registra la mencion, accion, niega, motivo esperado)
        ("T14b CONTROL: Mencion + Write FUERA -> pasa", True, afuera, False, None),
        ("T14b SABOTAJE 331: sin Mencion + Write FUERA -> deny", False, afuera, True, "-Mencion"),
        ("T14b SABOTAJE: Mencion + Write DENTRO del mencionado -> deny", True, dentro_k, True, "sin haber declarado"))

    def caso_m(n, script=__file__):
        s = "%s-t14b-%d-%s" % (sid, n, Path(script).stem)
        correr({"hook_event_name": "UserPromptSubmit", "session_id": s,
                "prompt": "ojo que otra sesion esta con " + sen_k}, e_k, script)
        if casos_m[n][1]:
            correr(post_ev("PowerShell", {"command": '.\\cascada.ps1 %s -Mencion "otra sesion en paralelo"' % p_k},
                           s=s), e_k, script)
        return correr(pre_ev(*casos_m[n][2], s=s), e_k, script)

    for n, (nombre, _, _, niega, motivo) in enumerate(casos_m):
        caso(nombre, caso_m(n), niega, motivo)
    # mutantes, cada uno visto en SU caso: la Mencion tratada como Excepcion abre la carpeta del proyecto; sin leer
    # -Mencion del comando, lo de afuera vuelve a frenar
    for nombre, viejo, nuevo, n in (
            ("MUTANTE (Mencion = Excepcion) deja tocar la carpeta mencionada",
             'st["menciones"][ev["proy"]] = ev.get("motivo", "")', 'st["excepciones"][ev["proy"]] = ""', 2),
            ("MUTANTE (no lee -Mencion) frena lo de afuera", r'r"-Mencion\s+', r'r"-NoMencion\s+', 0)):
        m = tmp / ("mutante-t14b-%d.py" % n)
        fuente = Path(__file__).read_text(encoding="utf-8")
        txt = fuente.replace(viejo, nuevo, 1)
        if txt == fuente:
            ok, r = False, "el mutante NO APLICA (el texto a reemplazar cambio)"
        else:
            m.write_text(txt, encoding="utf-8")
            r = caso_m(n, m)
            ok = ('"deny"' in r) != casos_m[n][3]
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE: %s" % r[:200]))
    # 19. T17 (L2-PTA-07..17): los conectores, por lista blanca. Catalogo y declaracion sinteticos: el caso mide la
    # REGLA, no los ids de hoy. La carpeta publica figura TAMBIEN como destino privado (una declaracion mal hecha): asi
    # su chequeo propio es el que frena, y su mutante se ve (si no, la lista blanca lo taparia y el sabotaje no
    # probaria nada).
    cid_d, cid_p = "094616df-b7ca-4cd7-8b66-355577c1f5f5", "1a59c906-04da-521d-bda7-7f71b9f9e01c"
    f_c, f_a, f_roto = tmp / "conectores.json", tmp / "audiencia.json", tmp / "roto.json"
    f_c.write_text(json.dumps({"servidores": {
        cid_d: {"nombre": "Drive", "herramientas": {"read_file_content": "lectura", "share_file": "comparte",
                                                     "create_file": "ubica", "copy_file": "ubica", "update_file": "ubica"}},
        cid_p: {"nombre": "Docs", "herramientas": {"update": "privado"}}}}), encoding="utf-8")
    arroba = chr(64)   # por partes: un mail literal en el repo publico lo marca la regla 5 (verificar-estructura)
    ana, otro = "ana" + arroba + "x.test", "otro" + arroba + "x.test"
    f_a.write_text(json.dumps({"carpeta-publica": {"id": "PUB"},
                               "destinos-del-conector": {"privados": [{"id": "PRIV"}, {"id": "PUB"}]},
                               "compartido-con-nombre": {"declarado": [
                                   {"id": "COMP", "rol": "writer", "quien-sha256": [hash_destinatario(ana)]},
                                   {"id": "LECT", "rol": "reader", "quien-sha256": [hash_destinatario(ana)]}]}}),
                   encoding="utf-8")
    f_roto.write_text("{ roto", encoding="utf-8")
    e_c = {"CASCADA_CONECTORES": str(f_c), "CASCADA_AUDIENCIA": str(f_a)}
    D = "mcp__%s__" % cid_d
    casos_c = (   # (nombre, tool, input, niega, motivo esperado, env extra)
        ("T17 CONTROL: lectura de Drive -> pasa", D + "read_file_content", {"fileId": "X"}, False, None, {}),
        ("T17 CONTROL: privado de Docs -> pasa", "mcp__%s__update" % cid_p, {"x": 1}, False, None, {}),
        ("T17 CONTROL: herramienta del harness (no conector) -> pasa", "mcp__ccd_turn__update_plan", {}, False, None, {}),
        ("T17 SABOTAJE: conector SIN CLASIFICAR -> deny",
         "mcp__aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee__send_email", {"to": "x"}, True, "SIN CLASIFICAR", {}),
        ("T17 SABOTAJE: herramienta SIN CLASE -> deny", D + "empty_trash", {}, True, "SIN CLASE", {}),
        ("T17 SABOTAJE: objeto declarado, destinatario NO -> deny", D + "share_file",
         {"fileId": "COMP", "emailAddress": otro, "role": "reader"}, True, "COMPARTIR SIN DECLARAR", {}),
        ("T17 SABOTAJE: objeto NO declarado -> deny", D + "share_file",
         {"fileId": "OTRO", "emailAddress": ana, "role": "reader"}, True, "COMPARTIR SIN DECLARAR", {}),
        ("T17 SABOTAJE: rol mayor que el declarado -> deny", D + "share_file",
         {"fileId": "LECT", "emailAddress": ana, "role": "writer"}, True, "ROL MAYOR", {}),
        ("T17 CONTROL: compartir lo declarado (mail con mayusculas) -> pasa", D + "share_file",
         {"fileId": "COMP", "emailAddress": " " + ana.upper() + " ", "role": "reader"}, False, None, {}),
        ("T17 SABOTAJE: crear en la carpeta PUBLICA -> deny", D + "create_file",
         {"title": "t", "parentId": "PUB"}, True, "CARPETA PUBLICA", {}),
        ("T17 SABOTAJE: copiar a una carpeta SIN DECLARAR -> deny", D + "copy_file",
         {"fileId": "X", "parentId": "NADA"}, True, "CARPETA SIN DECLARAR", {}),
        ("T17 CONTROL: crear en destino privado declarado -> pasa", D + "create_file",
         {"title": "t", "parentId": "PRIV"}, False, None, {}),
        ("T17 CONTROL: crear en carpeta compartida declarada -> pasa", D + "create_file",
         {"title": "t", "parentId": "COMP"}, False, None, {}),
        ("T17 CONTROL: crear sin carpeta destino (raiz privada) -> pasa", D + "create_file", {"title": "t"}, False,
         None, {}),
        ("T17 CONTROL: renombrar (update sin parentId) -> pasa", D + "update_file", {"fileId": "X", "title": "n"},
         False, None, {}),
        ("T17 SABOTAJE: catalogo de conectores ROTO -> deny", D + "read_file_content", {"fileId": "X"}, True,
         "falla cerrado", {"CASCADA_CONECTORES": str(f_roto)}),
        ("T17 SABOTAJE: declaracion ROTA + compartir lo declarado -> deny", D + "share_file",
         {"fileId": "COMP", "emailAddress": ana, "role": "reader"}, True, "no se puede leer",
         {"CASCADA_AUDIENCIA": str(f_roto)}))
    s19 = sid + "-t17"

    def caso_c(n, script=__file__, s=s19):
        _, tool, inp, _, _, extra = casos_c[n]
        return correr(pre_ev(tool, inp, s=s), dict(e_c, **extra), script)

    sanos = {}   # un mutante solo se juzga si SU caso paso sano en esta corrida (si no, 'visto' seria falso)
    for n, (nombre, _, _, niega, motivo, _) in enumerate(casos_c):
        r = caso_c(n)
        sanos[n] = ('"deny"' in r) == niega and (motivo is None or motivo in r)
        caso(nombre, r, niega, motivo)
    # la caja negra (L2-PTA-17): --estado muestra las decisiones de conector, con veredicto y motivo, y el estado no
    # lleva el mail en claro
    est = json.loads(subprocess.run([sys.executable, __file__, "--estado", s19], capture_output=True,
                                    env=env).stdout.decode("utf-8", "replace") or "{}")
    cs = est.get("conectores", [])
    crudo = ""
    try:
        crudo = (Path(env["CASCADA_ESTADO_DIR"]) / archivo_estado(s19).name).read_text(encoding="utf-8")
    except OSError:
        pass
    ok = (sum(c.get("v") == "niega" for c in cs) == sum(x[3] for x in casos_c[3:])
          and any(c.get("v") == "pasa" and "declarado" in c.get("motivo", "") for c in cs)
          and "@" not in crudo and hash_destinatario(ana) in crudo)
    mal += not ok
    print("%s  %-62s -> %s" % ("ok " if ok else "MAL", "T17 caja negra: --estado con las decisiones, sin el mail",
                               "si" if ok else "NO: %d decisiones, @ en claro=%s" % (len(cs), "@" in crudo)))
    # mutantes, cada uno visto en SU caso
    for nombre, viejo, nuevo, n in (
            ("MUTANTE (conector desconocido pasa) -> lo ve el caso 4",
             'if srv is None:\n        return "niega"', 'if srv is None:\n        return "pasa"', 3),
            ("MUTANTE (no compara el destinatario) -> lo ve el caso 6",
             'x["id"] == fid and h in x.get("quien-sha256", [])', 'x["id"] == fid', 5),
            ("MUTANTE (rol ignorado) -> lo ve el caso 8", "if ROLES.get(rol, 99) > decl:", "if False:", 7),
            ("MUTANTE (sin chequeo de la publica) -> lo ve el caso 10",
             'if destino == aud["publica"]:', "if False:", 9)):
        m = tmp / ("mutante-t17-%d.py" % n)
        fuente = Path(__file__).read_text(encoding="utf-8")
        txt = fuente.replace(viejo, nuevo, 1)
        if not sanos.get(n):
            ok, r = False, "NO JUZGABLE: su caso no paso sano en esta corrida"
        elif txt == fuente:
            ok, r = False, "el mutante NO APLICA (el texto a reemplazar cambio)"
        else:
            m.write_text(txt, encoding="utf-8")
            r = caso_c(n, m, s19 + "-m%d" % n)
            ok = '"deny"' not in r   # el caso que niega con la puerta sana, con el mutante PASA: el mutante se ve
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE: %s" % r[:200]))
    # 20. DA-064 (L2-PTA-20..23): el concepto 'alcance' dispara por el ROL del texto (un titulo de seccion del alcance
    # que se escribe o que encierra lo que se edita), no por la palabra. Archivos en tmp, fuera de todo proyecto: el
    # unico motivo posible de un deny es el concepto. Las formas son las del informe real (titulos numerados '1.1.',
    # un bloque de codigo, prosa que nombra 'la necesidad').
    d20 = tmp / "alcance"
    d20.mkdir()
    inf20, pdp20, notas20 = d20 / "seccion-1.md", d20 / "PDP.md", d20 / "notas.md"
    py20, typ20 = d20 / "herramienta.py", d20 / "m.typ"
    inf20.write_text("# Informe MCR\n\n## 1. Planteamiento de la mision\n\nAntecedentes de la catedra.\n\n"
                     "## 1.1. Necesidad\n\nFrase vieja de la necesidad.\n\n## 1.2. Metas\n\nUna meta.\n\n"
                     "## 2. Bibliografia\n\nAca se nombra la necesidad de citar bien.\n\n## 3. Anexo\n\n```bash\n"
                     "# Necesidad del script: limpiar\necho hola\n```\n\nLinea despues del bloque.\n", encoding="utf-8")
    pdp20.write_text("# PDP\n\n## 1. El problema\n\nUna frase.\n\n## 4. Las fases\n\nFase 1 abierta.\n", encoding="utf-8")
    notas20.write_text("# Notas\n\n## 1. El problema\n\nUna frase de un ejercicio.\n", encoding="utf-8")
    py20.write_text("# objetivo: limpiar la carpeta\nx = 1\n", encoding="utf-8")
    typ20.write_text("= Modulo\n\n== Objetivos\n\nTexto del objetivo.\n", encoding="utf-8")
    nuevo20 = "# Informe\n\n## 1.1. Necesidad\n\nUna frase.\n"

    def ed20(f, viejo, nuevo):
        return ("Edit", {"file_path": str(f), "old_string": viejo, "new_string": nuevo})
    alc = "alcance-como-se-escribe"
    casos20 = (   # (nombre, (tool, input), niega, motivo esperado)
        ("DA-064 SABOTAJE: Write con '## 1.1. Necesidad' -> deny",
         ("Write", {"file_path": str(d20 / "nuevo.md"), "content": nuevo20}), True, alc),
        ("DA-064 SABOTAJE: Edit de la frase BAJO 'Necesidad' (sin titulo) -> deny",
         ed20(inf20, "Frase vieja de la necesidad.", "Frase nueva."), True, alc),
        ("DA-064 SABOTAJE: Edit que AGREGA '## Objetivos' -> deny",
         ed20(inf20, "Linea despues del bloque.", "## Objetivos\n\nUno."), True, alc),
        ("DA-064 SABOTAJE: Edit bajo '1. El problema' de un PDP.md -> deny", ed20(pdp20, "Una frase.", "Otra."), True, alc),
        ("DA-064 SABOTAJE: Edit bajo '== Objetivos' de un .typ -> deny",
         ed20(typ20, "Texto del objetivo.", "Otro."), True, alc),
        ("DA-064 CONTROL: Edit de prosa que NOMBRA la necesidad -> pasa",
         ed20(inf20, "Aca se nombra la necesidad de citar bien.", "La necesidad y los objetivos, citados."), False, None),
        ("DA-064 CONTROL: Write con prosa sobre necesidad y metas -> pasa",
         ("Write", {"file_path": str(d20 / "prosa.md"), "content": "# Notas\n\nLa necesidad y las metas del TP.\n"}),
         False, None),
        ("DA-064 CONTROL: Edit de un .py bajo '# objetivo:' -> pasa", ed20(py20, "x = 1", "x = 2"), False, None),
        ("DA-064 CONTROL: Edit bajo un bloque de codigo con '# Necesidad' -> pasa",
         ed20(inf20, "Linea despues del bloque.", "Otra linea."), False, None),
        ("DA-064 CONTROL: '1. El problema' fuera de un PDP.md -> pasa",
         ed20(notas20, "Una frase de un ejercicio.", "Otra."), False, None),
        ("DA-064 CONTROL: Edit de la seccion 4 del PDP.md -> pasa", ed20(pdp20, "Fase 1 abierta.", "Fase 1 cerrada."),
         False, None),
        ("DA-064 SABOTAJE: Write con '## 3b. El alcance' (numeracion con letra) -> deny",
         ("Write", {"file_path": str(d20 / "libro.md"), "content": "# Libro\n\n## 3b. El alcance: necesidad\n\nx\n"}),
         True, alc))

    def caso20(n, script=__file__):
        s = "%s-da064-%d-%s" % (sid, n, Path(script).stem)
        return correr(pre_ev(*casos20[n][1], s=s), None, script)

    sanos20 = {}
    for n, (nombre, _, niega, motivo) in enumerate(casos20):
        r = caso20(n)
        sanos20[n] = ('"deny"' in r) == niega and (motivo is None or motivo in r)
        caso(nombre, r, niega, motivo)
    s20 = sid + "-da064-leido"
    for x in exigido(cat_base, None, [], ["alcance"])[0]:
        correr(post_ev("Read", {"file_path": x["ruta"], "offset": x["a"], "limit": x["b"] - x["a"] + 1}, s=s20))
    caso("DA-064 CONTROL: leidas las Lecturas_De_Alcance, el Write -> pasa", correr(pre_ev(*casos20[0][1], s=s20)), False)
    # mutantes, cada uno visto en SU caso y juzgado solo si ese caso paso sano en esta corrida
    for nombre, cambios, n in (
            ("MUTANTE (Write sin titulos) -> lo ve el caso 1",
             [('return [t for _, t in titulos_de(str(inp.get("content", "")), ext)]', "return []")], 0),
            ("MUTANTE (sin el titulo que ENCIERRA) -> lo ve el caso 2", [("out.append(encierra[-1])", "pass")], 1),
            ("MUTANTE (sin saltear los bloques de codigo) -> lo ve el caso 9", [("if VALLA.match(l):", "if False:")], 8),
            ("MUTANTE (titulos en cualquier extension) -> lo ve el caso 8",
             [("pat, out, en_valla = TITULO_DE.get(ext), [], False", 'pat, out, en_valla = TITULO_DE[".md"], [], False'),
              ("if ext not in TITULO_DE:\n        return []", "if False:\n        return []")], 7),
            ("MUTANTE (ignora el archivo de la seccion) -> lo ve el caso 10",
             [('if s.get("archivo") and not re.search(s["archivo"], arch):', "if False:")], 9)):
        fuente = Path(__file__).read_text(encoding="utf-8")
        txt = fuente
        for viejo, nuevo in cambios:
            txt = txt.replace(viejo, nuevo, 1)
        if not sanos20.get(n):
            ok, r = False, "NO JUZGABLE: su caso no paso sano en esta corrida"
        elif any(viejo not in fuente for viejo, _ in cambios):
            ok, r = False, "el mutante NO APLICA (el texto a reemplazar cambio)"
        else:
            m = tmp / ("mutante-da064-%d.py" % n)
            m.write_text(txt, encoding="utf-8")
            r = caso20(n, m)
            ok = ('"deny"' in r) != casos20[n][2]
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE: %s" % r[:200]))
    # 21. DA-067: el concepto 'requisitos' dispara tambien por el ROL (un titulo de requerimientos en CUALQUIER
    # documento, no solo en requisitos*.md), y 'alcance' por la mision, las restricciones y la autoridad. Archivos en
    # tmp, fuera de todo proyecto: el unico motivo posible de un deny es el concepto. La forma es la del informe real
    # del TP (titulos numerados '1.9.', la tabla de L0 debajo, prosa que nombra 'los requerimientos').
    d21 = tmp / "rol"
    d21.mkdir()
    inf21, hand21 = d21 / "seccion-1.md", d21 / "HANDOFF.md"
    inf21.write_text("# Informe MCR\n\n## 1.8. Restricciones\n\nUna restriccion vieja.\n\n## 1.9. Requerimientos\n\n"
                     "| ID | Requerimiento |\n|---|---|\n| L0-01 | La mision debera usar un CubeSat. |\n\n"
                     "## 2. Bibliografia\n\nLos requerimientos se citan aparte.\n", encoding="utf-8")
    hand21.write_text("# HANDOFF\n\n## Requisitos que faltan\n\nAnotar lo que falta.\n", encoding="utf-8")
    req_m, alc_m = "reglas.md", "alcance-como-se-escribe"   # cada motivo es de UN concepto: reglas.md solo lo pide requisitos
    casos21 = (
        ("DA-067 SABOTAJE: Write con '## 1.9. Requerimientos' en un informe -> deny",
         ("Write", {"file_path": str(d21 / "nuevo.md"), "content": "# Informe\n\n## 1.9. Requerimientos\n\nL0-01.\n"}),
         True, req_m),
        ("DA-067 SABOTAJE: Edit de la tabla BAJO '1.9. Requerimientos' -> deny",
         ed20(inf21, "La mision debera usar un CubeSat.", "La mision debera determinar X."), True, req_m),
        ("DA-067 SABOTAJE: Edit bajo '1.8. Restricciones' -> deny (alcance)",
         ed20(inf21, "Una restriccion vieja.", "Otra."), True, alc_m),
        ("DA-067 CONTROL: Edit de prosa que NOMBRA los requerimientos -> pasa",
         ed20(inf21, "Los requerimientos se citan aparte.", "Los requerimientos, citados."), False, None),
        ("DA-067 CONTROL: Edit bajo 'Requisitos que faltan' de un HANDOFF -> pasa",
         ed20(hand21, "Anotar lo que falta.", "Anotado."), False, None))

    def caso21(n, script=__file__):
        s = "%s-da067-%d-%s" % (sid, n, Path(script).stem)
        return correr(pre_ev(*casos21[n][1], s=s), None, script)

    sanos21 = {}
    for n, (nombre, _, niega, motivo) in enumerate(casos21):
        r = caso21(n)
        sanos21[n] = ('"deny"' in r) == niega and (motivo is None or motivo in r)
        caso(nombre, r, niega, motivo)
    s21 = sid + "-da067-leido"
    for x in exigido(cat_base, None, [], ["requisitos"])[0]:
        correr(post_ev("Read", {"file_path": x["ruta"], "offset": x["a"], "limit": x["b"] - x["a"] + 1}, s=s21))
    caso("DA-067 CONTROL: leido el concepto requisitos, el Write -> pasa", correr(pre_ev(*casos21[0][1], s=s21)), False)
    for nombre, cambios, n in (
            ("MUTANTE (requisitos sin disparo por seccion) -> lo ve el caso 1",
             [('elif arch and cd.get("secciones"):', "elif False:")], 0),
            ("MUTANTE (sin la excepcion del registro) -> lo ve el caso 5",
             [('if s.get("excepto") and re.search(s["excepto"], arch):', "if False:")], 4)):
        fuente = Path(__file__).read_text(encoding="utf-8")
        txt = fuente
        for viejo, nuevo in cambios:
            txt = txt.replace(viejo, nuevo, 1)
        if not sanos21.get(n):
            ok, r = False, "NO JUZGABLE: su caso no paso sano en esta corrida"
        elif any(viejo not in fuente for viejo, _ in cambios):
            ok, r = False, "el mutante NO APLICA (el texto a reemplazar cambio)"
        else:
            m = tmp / ("mutante-da067-%d.py" % n)
            m.write_text(txt, encoding="utf-8")
            r = caso21(n, m)
            ok = ('"deny"' in r) != casos21[n][2]
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE: %s" % r[:200]))
    # 22. DA-070: un comando que toca DOS proyectos exige declarar los dos. Antes la puerta veia uno por comando (el
    # primero) y, si ese estaba liberado, el resto pasaba: el 2026-10-19 un grep sobre cohete-de-agua junto a un sed
    # sobre catedras paso sin declarar cohete-de-agua. Proyectos reales del disco, rutas que no existen: el deny solo
    # puede venir de la declaracion.
    p_a, p_b = "black", "telescopio"
    r_a, r_b = "proyectos/ingenieria/%s/x-autotest.md" % p_a, "proyectos/ingenieria/%s/y-autotest.md" % p_b
    dos = ("Bash", {"command": "sed -i s/a/b/ %s %s" % (r_a, r_b)})
    uno = ("Bash", {"command": "sed -i s/a/b/ %s" % r_a})

    def caso22(n, script=__file__):
        s = "%s-da070-%d-%s" % (sid, n, Path(script).stem)
        correr(pre_ev("PowerShell", {"command": ".\\cascada.ps1 %s -Excepcion \"autotest DA-070\"" % p_a}, s), None, script)
        if n == 2:   # el segundo, declarado y sin leer su base: tiene que pedir la lectura del SEGUNDO
            correr(pre_ev("PowerShell", {"command": ".\\cascada.ps1 %s -Necesidad ninguna" % p_b}, s), None, script)
        return correr(pre_ev(*(uno if n == 1 else dos), s=s), None, script)

    casos22 = (("DA-070 SABOTAJE: un comando con dos proyectos, uno liberado -> deny por el OTRO", True,
                "vas a actuar sobre '%s'" % p_b),
               ("DA-070 CONTROL: el mismo comando con solo el liberado -> pasa", False, None),
               ("DA-070 SABOTAJE: el segundo declarado y sin leer -> deny por SU base", True, "falta LEER"))
    sanos22 = {}
    for n, (nombre, niega, motivo) in enumerate(casos22):
        r = caso22(n)
        sanos22[n] = ('"deny"' in r) == niega and (motivo is None or motivo in r)
        caso(nombre, r, niega, motivo)
    for nombre, cambios, n in (
            ("MUTANTE (un proyecto por comando, el primero) -> lo ve el caso 1",
             [('proyecto = next((p for p in tocados if p not in st["declaradas"] and p not in st["excepciones"]),\n'
               '                    tocados[0] if tocados else None)', "proyecto = tocados[0] if tocados else None")], 0),
            ("MUTANTE (sin exigir lo del segundo) -> lo ve el caso 3",
             [('for q in [x for x in tocados if x != proyecto and x in st["declaradas"] and x not in st["excepciones"]]:',
               "for q in []:")], 2)):
        fuente = Path(__file__).read_text(encoding="utf-8")
        txt = fuente
        for viejo, nuevo in cambios:
            txt = txt.replace(viejo, nuevo, 1)
        if not sanos22.get(n):
            ok, r = False, "NO JUZGABLE: su caso no paso sano en esta corrida"
        elif any(viejo not in fuente for viejo, _ in cambios):
            ok, r = False, "el mutante NO APLICA (el texto a reemplazar cambio)"
        else:
            m = tmp / ("mutante-da070-%d.py" % n)
            m.write_text(txt, encoding="utf-8")
            r = caso22(n, m)
            ok = ('"deny"' in r) != casos22[n][1]
        mal += not ok
        print("%s  %-62s -> %s" % ("ok " if ok else "MAL", nombre, "lo ve" if ok else "NO LO VE: %s" % r[:200]))
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
