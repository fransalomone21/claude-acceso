# -*- coding: utf-8 -*-
"""auditar-sesion.py -- contesta, DESDE LOS REGISTROS, si la arquitectura se cumplio en una sesion.

Fran (2026-10-07): "preguntas que verifiquen que la arquitectura se implemento correctamente en cada sesion, y que la
respuesta sea tan trazable a los hechos como un capacitor en la sonda Voyager 1". Un capacitor de vuelo se traza por
su lote, su ensayo y su inspeccion -- no por lo que dice el que lo monto. Aca igual: cada respuesta sale de un
REGISTRO y cita de donde, con renglon, hora o hash. Lo que no sale de un registro se marca 'declarado', no 'medido'.

LAS PREGUNTAS (y de que registro sale cada respuesta)
  P1  Corrio la puerta en esta sesion?                          la caja negra: el estado de la sesion
  P2  Se declaro la necesidad ANTES de la primera accion sobre cada proyecto?   'declara' antes de la 1.a 'pasa'
  P3  Se leyo el libro de bolsillo entero antes de esa accion?  'lee' de nucleo-ise.md antes de la 1.a 'pasa'
  P4  Quedo leido todo lo exigido (base, necesidades, requisitos)?            exigido() de la puerta, contra lo leido
  P5  Hubo excepciones a la puerta?                             'excepcion', con su motivo
  P6  Cuantas veces freno la puerta, por que, y revento alguna vez?           'decide' con 'niega'
  P7  Cada commit de DISENO cita requisitos que EXISTEN?        git + el documento de requisitos del proyecto
  P8  Quedo el checkpoint (ESTADO + HANDOFF + commit + push)?   git del repo DONDE VIVE el proyecto (el propio, si
                                                                tiene .git: claude-acceso no ve adentro de esos)
  P9  Lo que dependia de Fran quedo confirmado con evidencia?   --de-fran (declarado: no hay registro que lo mida)
  P10 Si algo fallo (revento, excepcion), quedo su leccion?     perfil-global/aprendizaje/lecciones.jsonl
  P11 Quedaron claude-acceso y perfil-global commiteados y pusheados?        git de cada repo
  P12 Se contrasto cada procedimiento con lo que pide su necesidad?          --procedimiento (declarado), cruzado con
                                                                los scripts que la caja negra vio repetirse (T19, E)
  P13 Que lecturas exigidas uso la sesion para decidir?          --uso (declarado) contra lo exigido; la muestra va a
                                                                .claude/auditorias/uso-lecturas.jsonl (T19, pieza D)

Uso:
  python auditar-sesion.py                        la sesion mas reciente (el estado modificado ultimo)
  python auditar-sesion.py --sesion <id>          una sesion dada
  python auditar-sesion.py --de-fran "que | evidencia"   (repetible; 'ninguno' si no hubo nada del lado de Fran)
  python auditar-sesion.py --procedimiento "que | que tiene que producir | produce / corregido: que / preguntado: que"
                                                  (repetible; 'ninguno' si no se corrio ninguno)
  python auditar-sesion.py --uso "archivo[, archivo] | para que decision"   (repetible; 'ninguna' si no se uso ninguna)
  python auditar-sesion.py --escribir             deja el informe en .claude/auditorias/ (va al commit) y la muestra
                                                  de uso en .claude/auditorias/uso-lecturas.jsonl
  python auditar-sesion.py --autotest
Sale 1 si alguna respuesta es ROJO. El formato de ID de requisito lo fija el libro de bolsillo (nucleo-ise.md, sec. 4).
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import re
import subprocess
import sys
import time
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
ID_REQ = re.compile(r"\b(?:N|L[0-6])-(?:[A-Z]{2,4}-)?\d{2}\b")   # N-01, L0-01, L1-03, L2-PLT-05 (nucleo-ise.md sec. 4)
REGISTRO = {"estado_actual.md", "handoff.md", "pdp.md", "bitacora.md"}
NUCLEO = "perfil-global/pilares/nucleo-ise.md"


def cargar_puerta(raiz: Path = RAIZ):
    """La logica de la puerta es UNA (exigido_de_sesion, proyecto_de, cubierto): se importa, no se copia.
    CASCADA_PUERTA la reemplaza por otra copia: es por donde el saboteador (probar-t19de.py) le da a la auditoria una
    puerta mutada (DA-078, L2-AUD-13)."""
    ruta = os.environ.get("CASCADA_PUERTA") or raiz / ".claude" / "hooks" / "cascada_puerta.py"
    spec = importlib.util.spec_from_file_location("cascada_puerta_aud", ruta)
    g = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(g)
    return g


def cargar_nube(raiz: Path = RAIZ):
    """Que es 'pusheado' lo define estado-nube.py (problema_push): se importa, no se copia."""
    spec = importlib.util.spec_from_file_location("estado_nube_aud", raiz / ".claude" / "nube" / "estado-nube.py")
    n = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(n)
    return n


def repo_de(raiz: Path, pr: Path) -> tuple:
    """(repo, ruta del proyecto adentro de ese repo). Un proyecto con .git propio (el mismo criterio que
    estado-nube.py) vive en SU repo, ignorado por claude-acceso: medirlo desde arriba es ceguera por construccion
    (2026-10-09: P8 dio NO APLICA a teoria-circuitos con el commit 43a4417 hecho y pusheado en su repo)."""
    if (pr / ".git").exists():
        return pr, "."
    return raiz, pr.relative_to(raiz).as_posix()


def hora(ts) -> str:
    return time.strftime("%H:%M:%S", time.localtime(ts)) if ts else "?"


def eventos(f: Path) -> list:
    out = []
    for n, linea in enumerate(f.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
        try:
            e = json.loads(linea)
        except ValueError:
            continue
        e["_n"] = n
        out.append(e)
    return out


def git(repo: Path, *a) -> str:
    r = subprocess.run(["git", "-C", str(repo)] + list(a), capture_output=True, timeout=60)
    return r.stdout.decode("utf-8", "replace")


def R(pid, pregunta, veredicto, grado, evidencia):
    return {"id": pid, "pregunta": pregunta, "veredicto": veredicto, "grado": grado,
            "evidencia": evidencia if isinstance(evidencia, list) else [evidencia]}


# ------------------------------------------------------------------------------------------- las preguntas
def proyecto_de_decision(g, cat, e):
    """El proyecto que una accion TOCA (ruta, comando o cwd). Las lecturas puras no cuentan como accion."""
    tool, obj = e.get("tool", ""), e.get("obj", "")
    if tool in ("Bash", "PowerShell") and g.es_lectura_pura(obj):
        return None
    inp = {"file_path": obj} if tool in ("Edit", "Write", "NotebookEdit") else {"command": obj}
    return g.proyecto_de(tool, inp, e.get("cwd", ""), cat)


def preguntas_de_estado(g, cat, f: Path, evs: list) -> tuple:
    """P1-P6: todo sale del estado de la sesion (la caja negra de la puerta)."""
    res = []
    sha = hashlib.sha256(f.read_bytes()).hexdigest()[:12] if f.exists() else "-"
    dec = [e for e in evs if e.get("t") == "decide"]
    if not evs:
        res.append(R("P1", "Corrio la puerta en esta sesion?", "ROJO", "medido",
                     "no hay estado de la sesion (%s): la puerta no corrio, o el estado se borro" % f.name))
    elif not dec:
        res.append(R("P1", "Corrio la puerta en esta sesion?", "AMARILLO", "medido",
                     "%s (sha256 %s): %d eventos y NINGUNA decision anotada (la caja negra existe desde el "
                     "2026-10-07; una sesion anterior no la tiene)" % (f.name, sha, len(evs))))
    else:
        res.append(R("P1", "Corrio la puerta en esta sesion?", "VERDE", "medido",
                     "%s (sha256 %s): %d eventos, %d decisiones, de %s a %s"
                     % (f.name, sha, len(evs), len(dec), hora(evs[0].get("ts")), hora(evs[-1].get("ts")))))
    toc, decl, exc = {}, {}, {}
    for e in evs:
        t = e.get("t")
        if t == "decide" and e.get("v") == "pasa":
            p = proyecto_de_decision(g, cat, e)
            if p and p not in toc:
                toc[p] = e
        elif t == "declara" and e.get("proy") not in decl:
            decl[e["proy"]] = e
        elif t == "excepcion":
            exc.setdefault(e.get("proy"), e)
    proyectos = sorted(set(toc) | set(decl))
    # P2
    if not proyectos:
        res.append(R("P2", "Se declaro la necesidad antes de actuar sobre cada proyecto?", "NO APLICA", "medido",
                     "la sesion no declaro ni toco ningun proyecto"))
    for p in proyectos:
        q = "Se declaro la necesidad de %s antes de la primera accion sobre el?" % p
        if p not in toc:
            res.append(R("P2", q, "NO APLICA", "medido", "declarado en #L%d (%s), sin acciones directas sobre el"
                         % (decl[p]["_n"], hora(decl[p].get("ts")))))
        elif p in exc and exc[p]["_n"] < toc[p]["_n"]:
            res.append(R("P2", q, "AMARILLO", "medido", "por EXCEPCION #L%d: %s" % (exc[p]["_n"], exc[p].get("motivo"))))
        elif p in decl and decl[p]["_n"] < toc[p]["_n"]:
            res.append(R("P2", q, "VERDE", "medido", "#L%d declara %s (%s) antes de #L%d, la 1.a accion: %s %s (%s)"
                         % (decl[p]["_n"], ",".join(decl[p].get("nec", [])), hora(decl[p].get("ts")), toc[p]["_n"],
                            toc[p].get("tool"), toc[p].get("obj", "")[:80], hora(toc[p].get("ts")))))
        else:
            res.append(R("P2", q, "ROJO", "medido", "#L%d actuo sobre %s (%s %s) sin declaracion previa"
                         % (toc[p]["_n"], p, toc[p].get("tool"), toc[p].get("obj", "")[:80])))
    # P3
    q3 = "Se leyo el libro de bolsillo entero antes de la primera accion sobre un proyecto?"
    if not toc:
        res.append(R("P3", q3, "NO APLICA", "medido", "no hubo acciones directas sobre un proyecto"))
    else:
        primera = min(toc.values(), key=lambda e: e["_n"])
        nuc = g.expandir(NUCLEO, None)
        if nuc is None or not nuc.exists():
            res.append(R("P3", q3, "ROJO", "medido", "el libro de bolsillo no esta en esta maquina (%s)" % nuc))
        else:
            total = len(nuc.read_text(encoding="utf-8", errors="replace").splitlines())
            ruta, tramos, ult_reset = g.norm(nuc), [], 0
            for e in evs:
                if e["_n"] >= primera["_n"]:
                    break
                if e.get("t") == "reset":
                    tramos, ult_reset = [], e["_n"]
                elif e.get("t") == "lee" and e.get("ruta") == ruta:
                    tramos.append((e["a"], e["b"], e["_n"]))
            ok = g.cubierto([(a, b) for a, b, _ in tramos], 1, total)
            ev3 = ("lecturas %s cubren 1-%d antes de #L%d (%s %s)" % (", ".join("#L%d %d-%d" % (n, a, b) for a, b, n in tramos),
                                                                      total, primera["_n"], primera.get("tool"),
                                                                      primera.get("obj", "")[:60])) if ok else \
                  ("antes de #L%d (%s) el libro (1-%d) NO esta leido entero: %s"
                   % (primera["_n"], hora(primera.get("ts")), total,
                      ", ".join("#L%d %d-%d" % (n, a, b) for a, b, n in tramos) or "ninguna lectura"))
            res.append(R("P3", q3, "VERDE" if ok else "ROJO", "medido", ev3))
    # P4
    g.ESTADO_DIR = f.parent
    st = g.estado(f.stem)
    for p in sorted(decl):
        q = "Quedo leido todo lo exigido para %s?" % p
        if p in exc:
            res.append(R("P4", q, "NO APLICA", "medido", "por excepcion: %s" % exc[p].get("motivo")))
            continue
        # lo exigido sale de la MISMA funcion que usa la puerta (DA-078, L2-AUD-13): la pieza C sumo los temas a la
        # puerta, esta llamada propia siguio sin ellos y dio AMARILLO «TEMA SIN DECLARAR» con el tema declarado (125f02e6)
        items, _, notas = g.exigido_de_sesion(cat, st, p)
        huecos = [x for x in items if not g.cubierto(st["lecturas"].get(x["ruta"], []), x["a"], x["b"])]
        ev4 = ["%d de %d tramos exigidos, cubiertos (medido con el catalogo de HOY: si cambio durante la sesion, lo "
               "exigido entonces pudo ser otro)" % (len(items) - len(huecos), len(items))]
        ev4 += ["falta: %s %d-%d" % (g.rel(x["ver"]), x["a"], x["b"]) for x in huecos]
        ev4 += ["nota: " + n for n in notas]
        v = "VERDE" if not huecos and not notas else "AMARILLO"
        res.append(R("P4", q, v, "medido", ev4))
    # P5
    excs = [e for e in evs if e.get("t") == "excepcion"]
    # T14b (L2-AUD-02): la Mencion (el pedido NOMBRA un proyecto sin pedirlo) va como dato, sin color: 8 de 10
    # excepciones eran eso, y el canal dejo de discriminar las salidas de verdad
    mencs = [e for e in evs if e.get("t") == "mencion"]
    res.append(R("P5", "Hubo excepciones a la puerta?", "AMARILLO" if excs else "VERDE", "medido",
                 (["#L%d %s (%s): %s" % (e["_n"], e.get("proy"), hora(e.get("ts")), e.get("motivo")) for e in excs]
                  or ["ninguna"]) +
                 ["mencion (no es excepcion) #L%d %s (%s): %s" % (e["_n"], e.get("proy"), hora(e.get("ts")),
                                                                 e.get("motivo")) for e in mencs]))
    # P6
    nieg = [e for e in dec if e.get("v") == "niega"]
    # la caida la anota el lanzador (o la puerta de afuera): la caja negra no puede anotar la suya
    revento = [e for e in evs if e.get("t") == "revento"] or \
              [e for e in nieg if "REVENTO" in e.get("motivo", "") or "no respondio" in e.get("motivo", "")]
    grupos = {}
    for e in nieg:
        grupos.setdefault(e.get("motivo", "")[:90], []).append(e["_n"])
    ev6 = ["%d decisiones, %d negadas, %d caida(s) de la puerta" % (len(dec), len(nieg), len(revento))]
    ev6 += ["#L%d REVENTO (%s): %s" % (e["_n"], hora(e.get("ts")), e.get("error", e.get("motivo", ""))[:120])
            for e in revento[:5]]
    ev6 += ["%dx '%s' (#L%s)" % (len(ns), m, ",".join(map(str, ns[:6]))) for m, ns in grupos.items()]
    res.append(R("P6", "Cuantas veces freno la puerta, por que, y revento alguna vez?",
                 "NO APLICA" if not dec else ("AMARILLO" if revento else "VERDE"), "medido", ev6))
    return res, toc, decl, excs, revento


def p7_commit(repo: Path, h: str, rel: str, doc: Path | None) -> tuple:
    """(veredicto, evidencia) de UN commit sobre un proyecto: si toca diseno, tiene que citar requisitos que existen."""
    archivos = [a for a in git(repo, "show", "--name-only", "--format=", h, "--", rel).splitlines() if a.strip()]
    doc_rel = doc.relative_to(repo).as_posix() if doc is not None and doc.is_relative_to(repo) else ""
    diseno = [a for a in archivos if Path(a).name.lower() not in REGISTRO and a != doc_rel]
    if not diseno:
        return "NO APLICA", "%s toca solo el registro o los requisitos" % h[:8]
    if doc is None or not doc.exists():
        return "ROJO", "%s toca diseno (%s) y el proyecto NO tiene su documento de requisitos" % (h[:8], ", ".join(diseno[:3]))
    texto = git(repo, "show", "-s", "--format=%B", h)
    texto += "\n".join(l for l in git(repo, "show", "-U0", "--format=", h, "--", *diseno).splitlines()
                       if l.startswith("+") and not l.startswith("+++"))
    citados = set(ID_REQ.findall(texto))
    lineas_doc = doc.read_text(encoding="utf-8", errors="replace").splitlines()
    existen = {i: n for n, l in enumerate(lineas_doc, 1) for i in ID_REQ.findall(l)}
    validos, invalidos = sorted(citados & set(existen)), sorted(citados - set(existen))
    if invalidos:
        return "ROJO", "%s cita requisitos que NO existen en %s: %s" % (h[:8], doc.name, ", ".join(invalidos))
    if not validos:
        return "ROJO", "%s toca diseno (%s) sin citar ningun requisito" % (h[:8], ", ".join(diseno[:3]))
    return "VERDE", "%s traza a %s" % (h[:8], ", ".join("%s (%s:%d)" % (i, doc.name, existen[i]) for i in validos))


def p7_de(g, p: str, ent: dict, pr: Path, repo: Path, rel: str, desde: str, raiz: Path) -> list:
    """P7 de UN proyecto tocado. Sin documento de requisitos declarado, decide la FASE del PDP (T13, L2-AUD-01 de
    proyectos/ingenieria/arquitectura-se/docs/10-requisitos.md): en A-D es ROJO. Antes daba NO APLICA por exclusion
    -- la ausencia del dato apagaba el chequeo (DA-028) -- y BLACK (128) y (129) pasaron asi en Fase C."""
    q = "Los commits de diseno de %s trazan a requisitos que existen?" % p
    if not ent.get("requisitos"):
        try:
            fase = g.fase_de(pr)
        except Exception as e:  # noqa: BLE001 -- un PDP ilegible no es un proyecto sin fase
            return [R("P7", q, "ROJO", "medido", "la fase del PDP de %s no se pudo tipar (%s)" % (p, e))]
        if g.exige_requisitos(pr, fase):
            return [R("P7", q, "ROJO", "medido", "%s esta en %s (fase %s) sin documento de requisitos: se trabajo sin "
                      "contra que verificar (T13, L2-AUD-01)" % (p, fase[1], fase[0]))]
        return [R("P7", q, "NO APLICA", "medido", "%s no declara documento de requisitos y su fase no lo exige (%s)"
                  % (p, ("%s, fase %s" % (fase[1] or "sin tipo NASA", fase[0])) if fase else "ninguna abierta"))]
    doc = pr / ent["requisitos"]
    commits = [h for h in git(repo, "log", "--since=" + desde, "--format=%H", "--", rel).splitlines() if h]
    if not commits:
        return [R("P7", q, "NO APLICA", "medido",
                  "sin commits sobre %s desde %s" % (rel if repo == raiz else repo.name, desde))]
    out = []
    for h in commits:
        v, e = p7_commit(repo, h, rel, doc)
        out.append(R("P7", "El commit %s de %s traza a requisitos que existen?" % (h[:8], p), v, "medido", e))
    return out


def p8_checkpoint(repo: Path, rel: str, handoff_rel: str, desde: str, nube=None) -> tuple:
    """rel '.' = el proyecto ES el repo (repo propio): ahi todo el repo cuenta, tambien lo atrasado de antes."""
    nube = nube or cargar_nube()
    donde = "el repo propio %s" % repo.name if rel == "." else rel
    sucio = [l for l in git(repo, "status", "--porcelain", "--", rel).splitlines() if l.strip()]
    commits = [h for h in git(repo, "log", "--since=" + desde, "--format=%H", "--", rel).splitlines() if h.strip()]
    push = nube.problema_push(repo)
    if not commits and not sucio:
        if rel == "." and push:
            return "AMARILLO", "%s: sin commits de la sesion desde %s, pero el repo no esta en su remoto: %s" % (
                donde, desde, "; ".join(push))
        return "NO APLICA", "sin commits ni cambios en %s desde %s" % (donde, desde)
    falta = []
    if sucio:
        falta.append("sin commitear: " + ", ".join(l[3:] for l in sucio[:4]))
    if commits and not git(repo, "log", "--since=" + desde, "--format=%H", "--", rel + "/ESTADO_ACTUAL.md").strip():
        falta.append("ningun commit de la sesion toco ESTADO_ACTUAL.md")
    if commits and not git(repo, "log", "--since=" + desde, "--format=%H", "--", handoff_rel).strip():
        falta.append("ningun commit de la sesion toco %s" % handoff_rel)
    falta += push
    if falta:
        return "ROJO", "%s: %s" % (donde, "; ".join(falta))
    return "VERDE", "%d commit(s) en %s desde %s (el ultimo %s), con ESTADO y HANDOFF, y pusheado a %s" % (
        len(commits), donde, desde, commits[0][:8], git(repo, "rev-parse", "--abbrev-ref", "@{u}").strip())


def p8_de(g, nube, raiz: Path, pr: Path, desde: str) -> tuple:
    """P8 de un proyecto, medido en el repo donde vive (repo_de)."""
    repo, rel = repo_de(raiz, pr)
    ho = g.handoff_de(pr)
    ho_rel = ho.relative_to(repo).as_posix() if ho else rel + "/HANDOFF.md"
    return p8_checkpoint(repo, rel, ho_rel, desde, nube)


def lecciones_nuevas(raiz: Path, desde: str) -> tuple:
    """Las lineas de lecciones.jsonl que NO estaban en el ultimo commit de perfil-global anterior a 'desde'."""
    pg, rel = raiz / "perfil-global", "aprendizaje/lecciones.jsonl"
    f = pg / rel
    if not f.exists():
        return [], ""
    base = git(pg, "rev-list", "-1", "--before=" + desde, "HEAD").strip()
    viejas = set(git(pg, "show", "%s:%s" % (base, rel)).splitlines()) if base else set()
    out = []
    for n, l in enumerate(f.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
        if l.strip() and l not in viejas:
            try:
                out.append((n, json.loads(l)))
            except ValueError:
                continue
    return out, base


def repo_al_dia(repo: Path, nube=None) -> tuple:
    # el informe de la auditoria es su SALIDA, no trabajo de la sesion: va en un commit propio despues (si contara,
    # ninguna auditoria con --escribir podria salir verde)
    sucio = [l[3:] for l in git(repo, "status", "--porcelain", "--untracked-files=all").splitlines()
             if l.strip() and not l[3:].strip('"').startswith(".claude/auditorias/")]   # -uall: sin colapsar carpetas
    falta = []
    if sucio:
        falta.append("%d sin commitear: %s" % (len(sucio), ", ".join(sucio[:5])))
    falta += (nube or cargar_nube()).problema_push(repo)
    if falta:
        return "ROJO", "; ".join(falta)
    return "VERDE", "limpio y pusheado (HEAD %s)" % git(repo, "rev-parse", "--short", "HEAD").strip()


# ------------------------------------------------------------------- T19, piezas E y D: las preguntas P12 y P13
# Requisitos: L2-AUD-04..12 de proyectos/ingenieria/arquitectura-se/docs/10-requisitos.md sec. 13; diseno en
# docs/t19-arbol-de-conocimiento.md sec. 8-9. P12 es la quinta pregunta del libro de bolsillo (sec. 7): ¿cada
# procedimiento produce lo que la necesidad pide? La contesta la sesion (declarado), y la caja negra cruza lo declarado
# con los scripts que se repitieron (medido). P13 es el sensor del lazo de uso: que lecturas exigidas uso la sesion.
INVOCA = re.compile(r"""^\s*(?:&\s*)?(?:(?:python3?|py|pwsh|powershell(?:\.exe)?|bash|sh)\s+(?:-{1,2}[\w-]+\s+)*)?"""
                    r"""(?:["'][^"']*[\\/]|["']|[^\s"';|&]*[\\/])?([\w.\-]+\.(?:py|ps1|sh|bat|cmd))(?![\w.\-])""",
                    re.I)   # la ruta entre comillas puede tener espacios ("01 - UNSAM"): medido con el control positivo
NO_PROCEDIMIENTO = re.compile(r"^(cascada|auditar-sesion)\.", re.I)   # declarar y cerrar no son procedimientos
REPETIDO = 3   # TBR (L2-AUD-06): medido el 2026-10-19, 32 de 60 cajas negras con scripts tienen uno; mediana 1
RESULTADOS = ("produce", "corregido", "preguntado")   # la decision de Fran (t19 sec. 4)
FORMA_P12 = ('--procedimiento "<que se corrio> | <que tiene que producir para la necesidad> | produce / corregido: '
             '<que> / preguntado: <que>"  (uno por procedimiento; --procedimiento ninguno si no se corrio ninguno)')
FORMA_P13 = ('--uso "<archivo>[, <archivo>] | <para que decision>"  (uno por decision; --uso ninguna si no se uso '
             'ninguna lectura exigida)')
REG_USO = Path(".claude") / "auditorias" / "uso-lecturas.jsonl"


def tramos(g, cmd: str) -> list:
    """Los tramos de un comando, partido por ; && || | y salto FUERA de comillas (la regla de registrar_comando)."""
    blanco, cortes = g.sin_comillas(cmd), [0]
    for m in re.finditer(r";|&&|\|\||\||\n", blanco):
        cortes += [m.start(), m.end()]
    cortes.append(len(cmd))
    return [cmd[cortes[i]:cortes[i + 1]] for i in range(0, len(cortes) - 1, 2)]


def procedimientos_corridos(g, evs: list) -> dict:
    """{Clave_De_Procedimiento: veces que la puerta la dejo pasar}. Cuenta el script INVOCADO al principio de un tramo
    (no el que nombra un echo o un mensaje), mas su primer argumento si es un subcomando o una opcion."""
    c = {}
    for e in evs:
        if e.get("t") != "decide" or e.get("tool") not in ("Bash", "PowerShell") or e.get("v") != "pasa":
            continue
        cmd = e.get("obj", "")
        if g.es_lectura_pura(cmd):
            continue
        for t in tramos(g, cmd):
            m = INVOCA.match(t)
            if not m or NO_PROCEDIMIENTO.match(m.group(1)):
                continue
            resto = re.sub(r"^[\"']", "", t[m.end():].strip()).split()
            sub = resto[0] if resto and re.match(r"^(--?)?[a-z][a-z\-]+$", resto[0], re.I) else ""
            k = (m.group(1) + (" " + sub if sub else "")).lower()
            c[k] = c.get(k, 0) + 1
    return c


def p12(g, evs: list, declaradas) -> dict:
    """L2-AUD-04..08. Grado 'declarado': el contraste lo dice la sesion; lo repetido sale de la caja negra."""
    q = "Se contrasto cada procedimiento con lo que pide su necesidad? (libro de bolsillo, sec. 7, quinta pregunta)"
    rep = {k: n for k, n in procedimientos_corridos(g, evs).items() if n >= REPETIDO}
    ev_rep = ["repetido en la caja negra: %s x%d" % kv for kv in sorted(rep.items(), key=lambda kv: (-kv[1], kv[0]))]
    if not declaradas:
        return R("P12", q, "ROJO", "declarado", ["sin declaracion de contraste (L2-AUD-04). Forma: " + FORMA_P12] + ev_rep)
    llenas = [d for d in declaradas if d.strip().lower() != "ninguno"]
    malas = [d for d in llenas if len(d.split("|")) < 3 or not all(x.strip() for x in d.split("|")[:3])
             or not d.split("|")[2].strip().lower().startswith(RESULTADOS)]
    if malas:
        return R("P12", q, "ROJO", "declarado", ["incompleta (L2-AUD-05: que, necesidad y un resultado que empieza con "
                                                  "produce, corregido o preguntado): %s" % d for d in malas]
                 + ["forma: " + FORMA_P12])
    nombres = [d.split("|")[0].lower() for d in llenas]
    sin = [k for k in rep if not any(k.split()[0] in n for n in nombres)]
    ev = llenas or ["la sesion declara que no corrio ningun procedimiento"]
    if sin:
        return R("P12", q, "AMARILLO", "declarado", ev + ev_rep + ["SIN contraste declarado (L2-AUD-06): %s x%d"
                                                                    % (k, rep[k]) for k in sin])
    return R("P12", q, "VERDE", "declarado", ev + ev_rep)


def clave_ruta(ver, raiz: Path) -> str:
    """Una lectura como la guarda el Registro_De_Uso, la misma en la PC y en la nube: perfil-global vive adentro del
    arbol en la PC y al lado en la nube (se ancla en su nombre); lo de la carpeta del usuario va con ~/."""
    bajo = str(ver).replace("\\", "/").lower()
    r = str(raiz).replace("\\", "/").lower().rstrip("/") + "/"
    h = str(Path.home()).replace("\\", "/").lower().rstrip("/") + "/"
    i = bajo.find("/perfil-global/")
    if i >= 0:
        return bajo[i + 1:]
    if bajo.startswith(r):
        return bajo[len(r):]
    if bajo.startswith(h):
        return "~/" + bajo[len(h):]
    return bajo


def lecturas_por_clase(g, cat, st: dict, raiz: Path) -> dict:
    """{Clase_De_Uso: [{ruta, por}]}: las Lectura_Exigida de la sesion, por archivo (los rangos de un archivo son una
    lectura). Los conceptos que dispara una accion (freno, typst) no entran: ya se activan por el rol de la accion."""
    out = {}

    def sumar(clase, items):
        ls = out.setdefault(clase, {})
        for x in items:
            ls.setdefault(clave_ruta(x["ver"], raiz), x["por"][:120])
    disco = g.proyectos_del_disco()
    for p in sorted(st["declaradas"]):
        pr = disco.get(p)
        if pr is None or p in st["excepciones"]:
            continue
        sumar("proyecto:" + pr.parent.name,
              g.exigido_de_sesion(cat, st, p)[0])   # DA-078: la funcion de la puerta, no una llamada propia
    if "ingenieria" in st["clases"]:
        sumar("ingenieria", g.exigido_de_sesion(cat, st)[0])
    return {c: [{"ruta": r, "por": por} for r, por in sorted(ls.items())] for c, ls in out.items() if ls}


def coincide(ruta: str, nombre: str) -> bool:
    """El nombre declarado coincide con la lectura si la ruta termina con el: 'readme.md' marca todos los README
    exigidos (la direccion segura: de mas usado, nunca de mas propuesto)."""
    n = nombre.strip().strip("`\"'").lower().replace("\\", "/")
    n = n[2:] if n.startswith("./") else n
    return bool(n) and (ruta == n or ruta.endswith("/" + n))


def p13(lecturas: dict, usos) -> tuple:
    """L2-AUD-09..11. (respuesta, {clase: usadas}); None si no hay muestra que escribir (sin declaracion valida)."""
    q = "Que lecturas exigidas uso la sesion para decidir? (T19, pieza D: el lazo de uso)"
    if not lecturas:
        return R("P13", q, "NO APLICA", "medido", "la sesion no tuvo lecturas exigidas (suelta, o ningun proyecto "
                 "declarado)"), None
    n = sum(len(v) for v in lecturas.values())
    if not usos:
        return R("P13", q, "ROJO", "declarado", "sin declaracion de uso sobre %d lecturas exigidas (L2-AUD-09). "
                 "Forma: %s" % (n, FORMA_P13)), None
    llenas = [u for u in usos if u.strip().lower() != "ninguna"]
    malas = [u for u in llenas if "|" not in u or not u.split("|", 1)[0].strip() or not u.split("|", 1)[1].strip()]
    if malas:
        return R("P13", q, "ROJO", "declarado", ["sin el archivo o la decision (L2-AUD-10): %s" % u for u in malas]
                 + ["forma: " + FORMA_P13]), None
    usadas, fuera = {c: set() for c in lecturas}, []
    for u in llenas:
        for nombre in [x for x in u.split("|", 1)[0].split(",") if x.strip()]:
            hits = [(c, x["ruta"]) for c, ls in lecturas.items() for x in ls if coincide(x["ruta"], nombre)]
            for c, r in hits:
                usadas[c].add(r)
            if not hits:
                fuera.append(nombre.strip())
    ev = ["%s: %d de %d lecturas exigidas usadas" % (c, len(usadas[c]), len(lecturas[c])) for c in sorted(lecturas)]
    ev += llenas or ["la sesion declara que no uso ninguna lectura exigida"]
    if fuera:
        return R("P13", q, "AMARILLO", "declarado", ev + ["no es lectura exigida de la sesion (L2-AUD-11: mal escrito, o "
                                                          "si sirvio, falta en la rama): %s" % f for f in fuera]), usadas
    return R("P13", q, "VERDE", "declarado", ev), usadas


def escribir_muestras(a: dict, raiz: Path = RAIZ):
    """L2-AUD-12: una Muestra_De_Uso por Clase_De_Uso de la sesion, al lado del informe. La misma sesion auditada dos
    veces reemplaza su muestra; un renglon ilegible se conserva (lo ve el medidor del lazo, no se borra en silencio)."""
    uso = a.get("uso")
    if not uso:
        return None
    f = raiz / REG_USO
    f.parent.mkdir(parents=True, exist_ok=True)
    quedan = []
    if f.exists():
        for l in f.read_text(encoding="utf-8").splitlines():
            if not l.strip():
                continue
            try:
                if json.loads(l).get("sesion") == a["sesion"]:
                    continue
            except (ValueError, AttributeError):
                pass
            quedan.append(l)
    for c in sorted(uso["lecturas"]):
        quedan.append(json.dumps({"sesion": a["sesion"], "fecha": a["desde"], "clase": c,
                                  "exigidas": uso["lecturas"][c], "usadas": sorted(uso["usadas"][c])},
                                 ensure_ascii=False))
    salida = ("\n".join(quedan) + "\n").encode("utf-8")   # preparado entero ANTES de abrir: open(wb) trunca
    with open(f, "wb") as fh:
        fh.write(salida)
    return f


def auditar(sesion: str | None, de_fran: list, raiz: Path = RAIZ, procedimientos=None, usos=None) -> dict:
    g = cargar_puerta(raiz)
    cat = g.cargar_catalogo()
    # L2-AUD-03 (T15): la ubicacion la decide la puerta (archivo_estado copia del legado si hace falta); antes se armaba
    # la ruta aca y era una segunda regla que podia divergir.
    if hasattr(g, "migrar_legado"):
        g.migrar_legado()
    d = Path(g.ESTADO_DIR)
    if sesion:
        f = g.archivo_estado(sesion)
    else:
        cand = sorted(d.glob("*.jsonl"), key=lambda p: p.stat().st_mtime)
        f = cand[-1] if cand else d / "sin-sesion.jsonl"
    evs = eventos(f) if f.exists() else []
    res, toc, decl, excs, revento = preguntas_de_estado(g, cat, f, evs)
    t0 = evs[0].get("ts") if evs else time.time()
    desde = time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(t0))
    disco = g.proyectos_del_disco()
    nube = cargar_nube(raiz)
    tocados = sorted(set(toc) | set(decl))
    for p in tocados:
        ent = cat.get("proyectos", {}).get(p, {})
        pr = disco.get(p)
        if pr is None:
            continue
        repo, rel = repo_de(raiz, pr)   # P7 y P8 miran el repo donde VIVE el proyecto
        res += p7_de(g, p, ent, pr, repo, rel, desde, raiz)
        # P8
        v, e = p8_de(g, nube, raiz, pr, desde)
        res.append(R("P8", "Quedo el checkpoint de %s (ESTADO + HANDOFF + commit + push)?" % p, v, "medido", e))
    # P9
    if not de_fran:
        res.append(R("P9", "Lo que dependia de Fran quedo confirmado con evidencia?", "AMARILLO", "declarado",
                     "no se declaro (--de-fran 'que | evidencia', o --de-fran ninguno)"))
    elif [x.lower() for x in de_fran] == ["ninguno"]:
        res.append(R("P9", "Lo que dependia de Fran quedo confirmado con evidencia?", "VERDE", "declarado",
                     "la sesion declara que no hubo nada del lado de Fran"))
    else:
        sin = [x for x in de_fran if "|" not in x or not x.split("|", 1)[1].strip()]
        res.append(R("P9", "Lo que dependia de Fran quedo confirmado con evidencia?", "ROJO" if sin else "VERDE",
                     "declarado", de_fran + (["SIN evidencia: " + ", ".join(sin)] if sin else [])))
    # P10 -- solo las lecciones NUEVAS de la sesion: las lineas que no estaban en el ultimo commit ANTERIOR a ella (una
    # leccion de otra sesion del mismo dia no cuenta; medido el 2026-10-07: la primera version aceptaba la de la manana)
    nuevas, base = lecciones_nuevas(raiz, desde)
    algo_fallo = bool(revento or excs)
    ev10 = ["lecciones.jsonl:%d [%s] %s" % (n, x.get("nivel", "?"), x.get("titulo", "")[:80]) for n, x in nuevas]
    ev10 = ev10 or ["ninguna leccion nueva desde %s" % (base[:8] if base else "el principio del registro")]
    if algo_fallo:
        ev10.append("fallo: %d caida(s) de la puerta, %d excepcion(es)" % (len(revento), len(excs)))
    res.append(R("P10", "Si algo fallo (revento, excepcion), quedo su leccion?",
                 "ROJO" if algo_fallo and not nuevas else "VERDE", "medido", ev10))
    # P11 -- el METODO tambien es memoria: una sesion que lo cambia lo deja commiteado y pusheado, en los dos repos
    for nombre, repo in (("claude-acceso", raiz), ("perfil-global", raiz / "perfil-global")):
        if not (repo / ".git").exists():
            continue
        v, e = repo_al_dia(repo, nube)
        res.append(R("P11", "Quedo %s commiteado y pusheado?" % nombre, v, "medido", e))
    # P12 y P13 (T19, piezas E y D): sin la opcion, ROJO; los llamadores viejos (probar-t15) no la pasan y no la miran
    res.append(p12(g, evs, procedimientos or []))
    g.ESTADO_DIR = f.parent
    lect = lecturas_por_clase(g, cat, g.estado(f.stem), raiz)
    r13, usadas = p13(lect, usos or [])
    res.append(r13)
    return {"sesion": f.stem, "estado": str(f), "desde": desde, "proyectos": tocados, "respuestas": res,
            "sha": hashlib.sha256(f.read_bytes()).hexdigest() if f.exists() else "",
            "uso": {"lecturas": lect, "usadas": usadas} if usadas is not None else None}


def imprimir(a: dict) -> int:
    print("AUDITORIA DE SESION %s  (desde %s; proyectos: %s)" % (a["sesion"], a["desde"], ", ".join(a["proyectos"]) or "ninguno"))
    rojos = 0
    for r in a["respuestas"]:
        rojos += r["veredicto"] == "ROJO"
        print("  %-4s %-9s %-9s %s" % (r["id"], r["veredicto"], "(%s)" % r["grado"], r["pregunta"]))
        for e in r["evidencia"]:
            print("                            %s" % e)
    print("  -> %s" % ("%d ROJO(S)" % rojos if rojos else "sin rojos"))
    return 1 if rojos else 0


def escribir(a: dict, raiz: Path = RAIZ) -> Path:
    d = raiz / ".claude" / "auditorias"
    d.mkdir(parents=True, exist_ok=True)
    f = d / ("%s-%s.md" % (a["desde"][:10], a["sesion"][:8]))
    L = ["# Auditoria de la sesion %s" % a["sesion"], "",
         "Generada por `auditar-sesion.py` el %s. Desde %s. Estado: `%s`, sha256 `%s`." % (
             time.strftime("%Y-%m-%d %H:%M:%S"), a["desde"], Path(a["estado"]).name, a["sha"][:16]),
         "Proyectos: %s." % (", ".join(a["proyectos"]) or "ninguno"), "",
         "| P | Veredicto | Grado | Pregunta | Evidencia |", "|---|---|---|---|---|"]
    for r in a["respuestas"]:
        L.append("| %s | %s | %s | %s | %s |" % (r["id"], r["veredicto"], r["grado"], r["pregunta"],
                                                  "<br>".join(e.replace("|", "/") for e in r["evidencia"])))
    if a.get("notas"):
        # lo que los registros NO pueden mostrar (p. ej. algo que paso antes de que existiera el registro): se dice,
        # con su referencia, y con grado 'declarado' -- nunca se agrega a la caja negra a mano
        L += ["", "## Notas de la sesion (declarado: no salen de un registro)", ""] + ["- " + n for n in a["notas"]]
    f.write_text("\n".join(L) + "\n", encoding="utf-8")
    escribir_muestras(a, raiz)   # L2-AUD-12: la muestra del lazo de uso, al lado del informe y en su mismo commit
    return f


# ------------------------------------------------------------------------------------------------ autotest
def autotest() -> int:
    import shutil
    import tempfile
    mal = 0
    tmp = Path(tempfile.mkdtemp(prefix="auditar-"))
    g = cargar_puerta()
    cat = g.cargar_catalogo()
    tel = RAIZ / "proyectos" / "ingenieria" / "telescopio"
    nuc = g.expandir(NUCLEO, None)
    n_nuc = len(nuc.read_text(encoding="utf-8").splitlines())

    def caso(nombre, ok, detalle="", ver=False):
        nonlocal mal
        mal += not ok
        print("%s  %-70s %s" % ("ok " if ok else "MAL", nombre, "" if ok else "-> " + str(detalle)[:160]))
        if ver and ok:   # lo que LLEGO, no solo el veredicto: un rojo por el motivo equivocado se ve igual
            print("       llego: %s" % str(detalle)[:200])

    def sesion(nombre, evs):
        f = tmp / ("%s.jsonl" % nombre)
        f.write_text("\n".join(json.dumps(e) for e in evs) + "\n", encoding="utf-8")
        return f

    def vered(res, pid):
        return [r["veredicto"] for r in res if r["id"] == pid]

    lee_nuc = {"t": "lee", "ruta": g.norm(nuc), "a": 1, "b": n_nuc, "ts": 2}
    declara = {"t": "declara", "proy": "telescopio", "nec": ["diseno"], "ts": 1}
    edit = {"t": "decide", "tool": "Edit", "obj": str(tel / "docs" / "x.md"), "cwd": "", "v": "pasa", "motivo": "", "ts": 3}
    grep = {"t": "decide", "tool": "Bash", "obj": "grep -n Fase %s" % (tel / "PDP.md").as_posix(), "cwd": "", "v": "pasa",
            "motivo": "", "ts": 0.5}
    # A: el orden correcto
    f = sesion("A", [declara, lee_nuc, edit])
    res = preguntas_de_estado(g, cat, f, eventos(f))[0]
    caso("CONTROL: declara + lee el libro + actua -> P2 y P3 VERDE", vered(res, "P2") == ["VERDE"] and vered(res, "P3") == ["VERDE"], res)
    # B: actua antes de declarar y sin leer
    f = sesion("B", [edit, declara])
    res = preguntas_de_estado(g, cat, f, eventos(f))[0]
    caso("actua ANTES de declarar -> P2 ROJO", vered(res, "P2") == ["ROJO"], res)
    caso("actua sin leer el libro -> P3 ROJO", vered(res, "P3") == ["ROJO"], res)
    # C: libro leido a medias
    f = sesion("C", [declara, dict(lee_nuc, b=max(1, n_nuc // 2)), edit])
    res = preguntas_de_estado(g, cat, f, eventos(f))[0]
    caso("libro leido A MEDIAS antes de actuar -> P3 ROJO", vered(res, "P3") == ["ROJO"], res)
    # D: una lectura pura antes de declarar no es 'actuar'
    f = sesion("D", [grep, declara, lee_nuc, edit])
    res = preguntas_de_estado(g, cat, f, eventos(f))[0]
    caso("CONTROL: un grep (lectura pura) antes de declarar -> P2 VERDE", vered(res, "P2") == ["VERDE"], res)
    # E: compactar borra lo leido
    f = sesion("E", [declara, lee_nuc, {"t": "reset", "ts": 2.5}, edit])
    res = preguntas_de_estado(g, cat, f, eventos(f))[0]
    caso("leido, COMPACTADO y despues actua -> P3 ROJO", vered(res, "P3") == ["ROJO"], res)
    # F: revento y excepcion
    f = sesion("F", [declara, {"t": "excepcion", "proy": "telescopio", "motivo": "prueba", "ts": 1.5},
                     {"t": "decide", "tool": "Edit", "obj": "x", "cwd": "", "v": "niega",
                      "motivo": "PUERTA DE LA CASCADA: la puerta REVENTO (salio 1)", "ts": 2}])
    res, _, _, excs, rev = preguntas_de_estado(g, cat, f, eventos(f))
    caso("una excepcion -> P5 AMARILLO", vered(res, "P5") == ["AMARILLO"], res)
    # T14b (L2-AUD-02): una Mencion sola no pinta P5, y queda nombrada en la evidencia
    f_m = sesion("F3", [declara, {"t": "mencion", "proy": "black", "motivo": "otra sesion en paralelo", "ts": 1.5},
                        lee_nuc, edit])
    res_m = preguntas_de_estado(g, cat, f_m, eventos(f_m))[0]   # nombres propios: el caso de abajo usa res y rev de F
    p5 = [r for r in res_m if r["id"] == "P5"]
    caso("T14b: una MENCION sola -> P5 VERDE y nombrada", vered(res_m, "P5") == ["VERDE"]
         and "otra sesion en paralelo" in str(p5), res_m)
    caso("un reventon de la puerta -> P6 AMARILLO", vered(res, "P6") == ["AMARILLO"] and len(rev) == 1, res)
    f = sesion("F2", [declara, {"t": "revento", "error": "salio 1: NameError", "ts": 2},
                      {"t": "decide", "tool": "Edit", "obj": "x", "cwd": "", "v": "niega",
                       "motivo": "PUERTA AFUERA: la puerta no respondio", "ts": 2}])
    res, _, _, _, rev = preguntas_de_estado(g, cat, f, eventos(f))
    caso("una caida anotada por el LANZADOR ('revento') -> P6 AMARILLO", vered(res, "P6") == ["AMARILLO"] and len(rev) == 1, res)
    # G: sin estado
    f = tmp / "no-existe.jsonl"
    res = preguntas_de_estado(g, cat, f, [])[0]
    caso("sin estado de la sesion -> P1 ROJO", vered(res, "P1") == ["ROJO"], res)
    # P7 y P8 sobre un repo SINTETICO con remoto propio
    rem, repo = tmp / "remoto.git", tmp / "repo"
    subprocess.run(["git", "init", "-q", "--bare", str(rem)], capture_output=True)
    subprocess.run(["git", "init", "-q", "-b", "main", str(repo)], capture_output=True)
    fecha = {"v": "2026-01-01T10:00:00"}   # la base ANTES de la sesion; lo de la sesion, despues (ver 'desde')

    def G(*a):
        env = dict(os.environ, GIT_AUTHOR_DATE=fecha["v"], GIT_COMMITTER_DATE=fecha["v"])
        return subprocess.run(["git", "-C", str(repo), "-c", "user.name=prueba", "-c", "user.email=prueba-sin-arroba",
                               "-c", "core.autocrlf=false"] + list(a), capture_output=True, env=env)
    pr = repo / "proyectos" / "ingenieria" / "demo"
    (pr / "docs").mkdir(parents=True)
    (pr / "docs" / "10-requisitos.md").write_text("| L1-01 | el sistema debera seguir el cielo |\n| L2-PLT-01 | x |\n",
                                                   encoding="utf-8")
    for nombre in ("ESTADO_ACTUAL.md", "HANDOFF.md"):
        (pr / nombre).write_text("# x\n", encoding="utf-8")
    G("add", "-A"); G("commit", "-q", "-m", "base"); G("remote", "add", "origin", str(rem)); G("push", "-q", "-u", "origin", "main")
    fecha["v"] = "2026-02-01T10:00:00"
    doc, rel = pr / "docs" / "10-requisitos.md", "proyectos/ingenieria/demo"

    def commit(msg, contenido):
        (pr / "docs" / "x.md").write_text(contenido, encoding="utf-8")
        G("add", "-A"); G("commit", "-q", "-m", msg)
        return git(repo, "rev-parse", "HEAD").strip()

    v, e = p7_commit(repo, commit("diseno del rodillo [L2-PLT-01]", "rodillo\n"), rel, doc)
    caso("CONTROL: commit de diseno que cita un requisito que existe -> P7 VERDE", v == "VERDE", e)
    v, e = p7_commit(repo, commit("diseno sin requisito", "otra cosa\n"), rel, doc)
    caso("commit de diseno SIN citar requisito -> P7 ROJO", v == "ROJO" and "sin citar" in e, e)
    v, e = p7_commit(repo, commit("cita uno que no existe [L2-PLT-99]", "mas\n"), rel, doc)
    caso("commit que cita un requisito que NO existe -> P7 ROJO", v == "ROJO" and "NO existen" in e, e)
    v, e = p7_commit(repo, commit("cita en el cuerpo", "segun L1-01, el motor\n"), rel, doc)
    caso("CONTROL: el ID citado en el CONTENIDO agregado tambien traza -> VERDE", v == "VERDE", e)
    (pr / "ESTADO_ACTUAL.md").write_text("# x2\n", encoding="utf-8")
    G("add", "-A"); G("commit", "-q", "-m", "solo estado")
    v, e = p7_commit(repo, git(repo, "rev-parse", "HEAD").strip(), rel, doc)
    caso("CONTROL: un commit que toca solo el registro -> P7 NO APLICA", v == "NO APLICA", e)
    # T13 (L2-AUD-01): sin documento declarado decide la FASE del PDP. PDP sintetico: el caso no depende de la fase de
    # un proyecto vivo. El NO APLICA de antes es justo lo que el mutante reproduce.
    pt = tmp / "t13" / "proyectos" / "ingenieria" / "demo-c"
    pt.mkdir(parents=True)
    fila = "| 3 | %s | x | **abierta** |\n\n**Fase en curso:** 3\n"
    (pt / "PDP.md").write_text(fila % "Fase C: diseño final", encoding="utf-8")
    r7 = p7_de(g, "demo-c", {}, pt, repo, rel, "2026-01-15 00:00:00", RAIZ)
    caso("T13: Fase C SIN requisitos -> P7 ROJO (antes NO APLICA)",
         [x["veredicto"] for x in r7] == ["ROJO"] and "Fase C" in str(r7), r7, ver=True)
    viejo = g.FASES_DESARROLLO
    g.FASES_DESARROLLO = ()
    r7m = p7_de(g, "demo-c", {}, pt, repo, rel, "2026-01-15 00:00:00", RAIZ)
    g.FASES_DESARROLLO = viejo
    caso("MUTANTE T13 (ninguna fase exige) vuelve al NO APLICA: el caso lo ve",
         [x["veredicto"] for x in r7m] == ["NO APLICA"], r7m)
    (pt / "PDP.md").write_text(fila % "Pre-Fase A: estudio de conceptos", encoding="utf-8")
    r7 = p7_de(g, "demo-c", {}, pt, repo, rel, "2026-01-15 00:00:00", RAIZ)
    caso("CONTROL T13: Pre-Fase A sin requisitos -> P7 NO APLICA", [x["veredicto"] for x in r7] == ["NO APLICA"], r7)
    # T19a (L1-04 acotado por N-09): un proyecto de materia en Fase C sin requisitos no da ROJO; con la naturaleza
    # documentos agregada a las del ciclo NASA (mutante), vuelve el ROJO: el caso lo ve.
    pd = tmp / "t13" / "proyectos" / "documentos" / "demo-apunte"
    pd.mkdir(parents=True)
    (pd / "PDP.md").write_text(fila % "Fase C: diseño final", encoding="utf-8")
    r7 = p7_de(g, "demo-apunte", {}, pd, repo, rel, "2026-01-15 00:00:00", RAIZ)
    caso("CONTROL T19a: apunte (documentos) en Fase C sin requisitos -> P7 NO APLICA",
         [x["veredicto"] for x in r7] == ["NO APLICA"], r7)
    viejo_n = g.NATURALEZAS_NASA
    g.NATURALEZAS_NASA = viejo_n + ("documentos",)
    r7m = p7_de(g, "demo-apunte", {}, pd, repo, rel, "2026-01-15 00:00:00", RAIZ)
    g.NATURALEZAS_NASA = viejo_n
    caso("MUTANTE T19a (documentos con ciclo NASA) vuelve el ROJO: el caso lo ve",
         [x["veredicto"] for x in r7m] == ["ROJO"], r7m)
    desde = "2026-01-15 00:00:00"
    v, e = p8_checkpoint(repo, rel, rel + "/HANDOFF.md", desde)
    caso("commits sin pushear y sin HANDOFF -> P8 ROJO", v == "ROJO" and "sin pushear" in e and "HANDOFF" in e, e)
    (pr / "HANDOFF.md").write_text("# h2\n", encoding="utf-8")
    G("add", "-A"); G("commit", "-q", "-m", "checkpoint"); G("push", "-q")
    v, e = p8_checkpoint(repo, rel, rel + "/HANDOFF.md", desde)
    caso("CONTROL: ESTADO + HANDOFF + commit + push -> P8 VERDE", v == "VERDE", e)
    v, e = repo_al_dia(repo)
    caso("CONTROL: repo limpio y pusheado -> P11 VERDE", v == "VERDE", e)
    (repo / ".claude" / "auditorias").mkdir(parents=True)
    (repo / ".claude" / "auditorias" / "informe.md").write_text("# informe\n", encoding="utf-8")
    v, e = repo_al_dia(repo)
    caso("CONTROL: solo el informe de la auditoria sin commitear -> P11 VERDE", v == "VERDE", e)
    (pr / "docs" / "x.md").write_text("sin commitear\n", encoding="utf-8")
    v, e = p8_checkpoint(repo, rel, rel + "/HANDOFF.md", desde)
    caso("un cambio sin commitear -> P8 ROJO", v == "ROJO" and "sin commitear" in e, e)
    v, e = repo_al_dia(repo)
    caso("un cambio sin commitear -> P11 ROJO", v == "ROJO" and "sin commitear" in e, e)
    # P8 en un repo PROPIO: el proyecto vive en su .git, ignorado por el repo de arriba (como teoria-circuitos en
    # claude-acceso). Antes P8 miraba el de arriba y daba NO APLICA con el commit hecho adentro (sesion dd781a07).
    nube = cargar_nube()

    def Gr(r, *a):
        env = dict(os.environ, GIT_AUTHOR_DATE=fecha["v"], GIT_COMMITTER_DATE=fecha["v"])
        return subprocess.run(["git", "-C", str(r), "-c", "user.name=prueba", "-c", "user.email=prueba-sin-arroba",
                               "-c", "core.autocrlf=false"] + list(a), capture_output=True, env=env)

    def registro(d, texto):
        for nombre in ("ESTADO_ACTUAL.md", "HANDOFF.md"):
            (d / nombre).write_text(texto, encoding="utf-8")
    arriba, rem2 = tmp / "arriba", tmp / "aparte.git"
    pa, sr = arriba / "proyectos" / "documentos" / "aparte", arriba / "proyectos" / "documentos" / "sin-remote"
    pa.mkdir(parents=True); sr.mkdir(parents=True)
    subprocess.run(["git", "init", "-q", "--bare", str(rem2)], capture_output=True)
    for r in (arriba, pa, sr):
        subprocess.run(["git", "init", "-q", "-b", "main", str(r)], capture_output=True)
    (arriba / ".gitignore").write_text("proyectos/documentos/aparte/\nproyectos/documentos/sin-remote/\n", encoding="utf-8")
    fecha["v"] = "2026-01-01T10:00:00"
    Gr(arriba, "add", "-A"); Gr(arriba, "commit", "-q", "-m", "base de arriba")
    registro(pa, "# base\n")
    Gr(pa, "add", "-A"); Gr(pa, "commit", "-q", "-m", "base"); Gr(pa, "remote", "add", "origin", str(rem2))
    Gr(pa, "push", "-q", "-u", "origin", "main")
    fecha["v"] = "2026-02-01T10:00:00"
    registro(pa, "# cierre\n")
    Gr(pa, "add", "-A"); Gr(pa, "commit", "-q", "-m", "checkpoint, sin push")
    v, e = p8_de(g, nube, arriba, pa, desde)
    caso("repo PROPIO: ESTADO + HANDOFF commiteados SIN push -> P8 ROJO", v == "ROJO" and "sin pushear" in e
         and "aparte" in e, e, ver=True)
    Gr(pa, "push", "-q")
    h = git(pa, "rev-parse", "HEAD").strip()
    v, e = p8_de(g, nube, arriba, pa, desde)
    caso("CONTROL: repo PROPIO con commit + push -> P8 VERDE con SU commit", v == "VERDE" and h[:8] in e, e, ver=True)
    fecha["v"] = "2026-02-05T10:00:00"
    (pa / "nota.md").write_text("x\n", encoding="utf-8")
    Gr(pa, "add", "-A"); Gr(pa, "commit", "-q", "-m", "sin registro"); Gr(pa, "push", "-q")
    v, e = p8_de(g, nube, arriba, pa, desde)
    caso("CONTROL: con ESTADO+HANDOFF en ALGUN commit de la sesion -> P8 VERDE", v == "VERDE", e)
    v, e = p8_de(g, nube, arriba, pa, "2026-02-03 00:00:00")   # la sesion solo ve el ultimo commit
    caso("repo PROPIO: commit pusheado sin ESTADO ni HANDOFF -> P8 ROJO", v == "ROJO" and "ESTADO_ACTUAL" in e
         and "HANDOFF" in e, e, ver=True)
    registro(sr, "# x\n")
    Gr(sr, "add", "-A"); Gr(sr, "commit", "-q", "-m", "commit sin remote")
    v, e = p8_de(g, nube, arriba, sr, desde)
    caso("repo PROPIO sin remote -> P8 ROJO que lo dice", v == "ROJO" and "no tiene remote" in e, e, ver=True)
    v, e = p8_de(g, nube, arriba, sr, "2026-03-01 00:00:00")
    caso("repo PROPIO sin remote y sin commits de la sesion -> AMARILLO, no NO APLICA", v == "AMARILLO"
         and "no tiene remote" in e, e, ver=True)
    v, e = repo_al_dia(sr, nube)
    caso("repo sin remote -> P11 ROJO (antes: '' se leia como 0 sin pushear)", v == "ROJO" and "no tiene remote" in e,
         e, ver=True)
    (pa / "borrador.md").write_text("a medio hacer\n", encoding="utf-8")
    v, e = p8_de(g, nube, arriba, pa, "2026-03-01 00:00:00")
    caso("repo PROPIO con un archivo sin commitear -> P8 ROJO", v == "ROJO" and "borrador.md" in e, e, ver=True)
    # P10: solo cuentan las lecciones NUEVAS desde el ultimo commit anterior a la sesion
    pg = tmp / "arbol-lec"
    lr = pg / "perfil-global" / "aprendizaje"
    lr.mkdir(parents=True)
    Gp = lambda *a: subprocess.run(["git", "-C", str(pg / "perfil-global"), "-c", "user.name=prueba", "-c",
                                    "user.email=prueba-sin-arroba"] + list(a), capture_output=True,
                                   env=dict(os.environ, GIT_AUTHOR_DATE="2026-01-01T10:00:00",
                                            GIT_COMMITTER_DATE="2026-01-01T10:00:00"))
    subprocess.run(["git", "init", "-q", str(pg / "perfil-global")], capture_output=True)
    (lr / "lecciones.jsonl").write_text(json.dumps({"titulo": "de otra sesion", "fecha": "2026-02-01"}) + "\n", encoding="utf-8")
    Gp("add", "-A"); Gp("commit", "-q", "-m", "base")
    nuevas, base = lecciones_nuevas(pg, "2026-01-15 00:00:00")
    caso("CONTROL: la leccion de OTRA sesion (ya commiteada antes) no cuenta como nueva", nuevas == [] and bool(base), nuevas)
    with open(lr / "lecciones.jsonl", "a", encoding="utf-8") as fh:
        fh.write(json.dumps({"titulo": "la de esta sesion", "fecha": "2026-02-01", "nivel": "herramienta"}) + "\n")
    nuevas, _ = lecciones_nuevas(pg, "2026-01-15 00:00:00")
    caso("la leccion agregada en la sesion (aun sin commitear) -> cuenta", [x["titulo"] for _, x in nuevas] == ["la de esta sesion"], nuevas)
    # P4 con el tema declarado (T19, pieza C): sin el tema la puerta deja la nota; con el tema, no (antes la auditoria
    # no pasaba los temas y daba AMARILLO a la sesion que si lo habia declarado)
    dec_a = {"t": "declara", "proy": "arquitectura-se", "nec": ["metodo"], "ts": 1}
    f = sesion("P4sin", [dec_a])
    p4 = [r for r in preguntas_de_estado(g, cat, f, eventos(f))[0] if r["id"] == "P4"]
    caso("CONTROL P4: arquitectura-se SIN tema -> la nota TEMA SIN DECLARAR llega", "TEMA SIN DECLARAR" in str(p4), p4)
    f = sesion("P4con", [dec_a, {"t": "tema", "proy": "arquitectura-se", "temas": ["t19"], "ts": 1.1}])
    p4 = [r for r in preguntas_de_estado(g, cat, f, eventos(f))[0] if r["id"] == "P4"]
    caso("P4 con el tema declarado -> sin la nota TEMA SIN DECLARAR", p4 and "TEMA SIN DECLARAR" not in str(p4), p4)
    # T19, pieza E (L2-AUD-04..08): P12, la quinta pregunta. Caja negra sintetica: un autotest corrido 3 veces, un
    # script 1 vez, un echo que NOMBRA un script (no lo corre) y dos negadas (no corrieron).
    def corre(cmd, v="pasa"):
        return {"t": "decide", "tool": "PowerShell", "obj": cmd, "cwd": "", "v": v, "motivo": "", "ts": 5}
    pz = "python .claude/hooks/cascada_puerta.py --autotest"
    evs12 = [corre(pz)] * 3 + [corre("python medir.py"), corre('echo "corre x.py"'), corre('echo "corre x.py"'),
                                corre('echo "corre x.py"'), corre(pz, "niega"), corre(pz, "niega")]
    pc = procedimientos_corridos(g, evs12)
    caso("E: cuenta lo que CORRIO (no el echo que lo nombra, no lo negado)",
         pc == {"cascada_puerta.py --autotest": 3, "medir.py": 1}, pc, ver=True)
    pc = procedimientos_corridos(g, [corre('& "C:\\una carpeta\\banco.ps1" -Rapido; python -I ./x/arma.py armar')])
    caso("E: CONTROL: un script por ruta entre comillas y otro tras un ';' cuentan con su subcomando",
         pc == {"banco.ps1 -rapido": 1, "arma.py armar": 1}, pc, ver=True)
    r = p12(g, evs12, [])
    caso("E: sin declaracion de contraste -> P12 ROJO con la forma de --procedimiento",
         r["veredicto"] == "ROJO" and "--procedimiento" in str(r["evidencia"]), r, ver=True)
    bien = "cascada_puerta.py --autotest | que la puerta niegue y deje pasar lo que dice su L2 | produce"
    r = p12(g, evs12, [bien])
    caso("E: CONTROL: el repetido declarado con necesidad y resultado -> P12 VERDE", r["veredicto"] == "VERDE", r)
    r = p12(g, evs12, ["medir.py | contar los scripts | corregido: cuenta por tramo"])
    caso("E: un procedimiento repetido sin contraste -> P12 AMARILLO con su cuenta",
         r["veredicto"] == "AMARILLO" and "cascada_puerta.py --autotest x3" in str(r["evidencia"]), r, ver=True)
    r = p12(g, evs12, ["cascada_puerta.py | probar la puerta"])
    caso("E: declaracion sin resultado -> P12 ROJO", r["veredicto"] == "ROJO" and "incompleta" in str(r), r)
    r = p12(g, evs12, ["cascada_puerta.py | probar la puerta | ok"])
    caso("E: un resultado que no es produce, corregido ni preguntado -> P12 ROJO", r["veredicto"] == "ROJO", r)
    r = p12(g, evs12, ["ninguno"])
    caso("E: 'ninguno' con un procedimiento repetido -> P12 AMARILLO", r["veredicto"] == "AMARILLO", r)
    r = p12(g, [corre("python medir.py")], ["ninguno"])
    caso("E: CONTROL: 'ninguno' sin repetidos -> P12 VERDE", r["veredicto"] == "VERDE", r)
    # T19, pieza D (L2-AUD-09..12): P13 y la muestra del lazo de uso
    lect = {"proyecto:ingenieria": [{"ruta": "perfil-global/pilares/nucleo-ise.md", "por": "base: el libro"},
                                    {"ruta": "perfil-global/pilares/nasa-seh/readme.md", "por": "necesidad diseno"},
                                    {"ruta": "perfil-global/pilares/rechtin-maier/readme.md", "por": "necesidad diseno"},
                                    {"ruta": "proyectos/ingenieria/demo/docs/10-requisitos.md", "por": "base"}]}
    r, u = p13(lect, [])
    caso("D: sin declaracion de uso -> P13 ROJO con la forma de --uso y sin muestra",
         r["veredicto"] == "ROJO" and "--uso" in str(r["evidencia"]) and u is None, r, ver=True)
    r, u = p13(lect, ["nucleo-ise.md"])
    caso("D: declaracion sin la decision -> P13 ROJO y sin muestra", r["veredicto"] == "ROJO" and u is None, r)
    r, u = p13(lect, ["nucleo-isse.md | escribir el L2"])
    caso("D: un archivo que no es exigido -> P13 AMARILLO, y no marca nada", r["veredicto"] == "AMARILLO"
         and "nucleo-isse.md" in str(r["evidencia"]) and u == {"proyecto:ingenieria": set()}, (r, u), ver=True)
    r, u = p13(lect, ["nucleo-ise.md, README.md | escribir el L2 de E"])
    caso("D: CONTROL: lo usado se marca; un nombre ambiguo marca los dos README", r["veredicto"] == "VERDE"
         and u["proyecto:ingenieria"] == {"perfil-global/pilares/nucleo-ise.md", "perfil-global/pilares/nasa-seh/readme.md",
                                         "perfil-global/pilares/rechtin-maier/readme.md"}, (r, u))
    r, u = p13(lect, ["ninguna"])
    caso("D: CONTROL: 'ninguna' -> P13 VERDE con 0 usadas (es una muestra)", r["veredicto"] == "VERDE"
         and u == {"proyecto:ingenieria": set()}, (r, u))
    r, u = p13({}, [])
    caso("D: CONTROL: sin lecturas exigidas -> P13 NO APLICA", r["veredicto"] == "NO APLICA" and u is None, r)
    rz = tmp / "raiz-uso"
    (rz / REG_USO).parent.mkdir(parents=True)
    (rz / REG_USO).write_text('{"sesion": "otra", "fecha": "2026-10-18 09:00:00", "clase": "ingenieria", '
                              '"exigidas": [], "usadas": []}\n{roto\n', encoding="utf-8")
    a = {"sesion": "s1", "desde": "2026-10-19 10:00:00",
         "uso": {"lecturas": lect, "usadas": {"proyecto:ingenieria": {"perfil-global/pilares/nucleo-ise.md"}}}}
    escribir_muestras(a, rz)
    escribir_muestras(a, rz)
    lin = (rz / REG_USO).read_text(encoding="utf-8").splitlines()
    caso("D: la muestra se escribe una vez aunque se audite dos veces; lo ajeno y lo ilegible quedan",
         len(lin) == 3 and sum('"s1"' in l for l in lin) == 1 and "{roto" in lin and '"otra"' in lin[0], lin, ver=True)
    m1 = json.loads([l for l in lin if '"s1"' in l][0])
    caso("D: la muestra trae clase, exigidas con su motivo y usadas", m1["clase"] == "proyecto:ingenieria"
         and len(m1["exigidas"]) == 4 and m1["usadas"] == ["perfil-global/pilares/nucleo-ise.md"], m1)
    caso("D: CONTROL: sin declaracion valida no hay muestra", escribir_muestras({"uso": None}, tmp / "vacia") is None
         and not (tmp / "vacia" / REG_USO).exists())
    st = {"declaradas": {"arquitectura-se": {"metodo"}}, "excepciones": {}, "temas": {"arquitectura-se": {"t19"}},
          "clases": {"ingenieria"}}
    lc = lecturas_por_clase(g, cat, st, RAIZ)
    rutas = {x["ruta"] for x in lc.get("proyecto:ingenieria", [])}
    caso("D: sobre el catalogo real, la clase del proyecto trae el libro y el documento del tema; la de ingenieria, el "
         "tronco", "perfil-global/pilares/nucleo-ise.md" in rutas and any("t19-arbol" in x for x in rutas)
         and any("reglas.md" in x["ruta"] for x in lc.get("ingenieria", [])), sorted(lc), ver=True)
    caso("D: la ruta de perfil-global es la misma en la nube (al lado del arbol) que en la PC (adentro)",
         clave_ruta("/home/user/perfil-global/pilares/x.md", Path("/home/user/claude-acceso")) == "perfil-global/pilares/x.md"
         and clave_ruta(RAIZ / "perfil-global" / "pilares" / "x.md", RAIZ) == "perfil-global/pilares/x.md")
    shutil.rmtree(tmp, ignore_errors=True)
    print("autotest: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Audita una sesion contra la arquitectura, desde los registros.")
    ap.add_argument("--sesion")
    ap.add_argument("--de-fran", action="append", default=[])
    ap.add_argument("--nota", action="append", default=[], help="lo que los registros no muestran (declarado)")
    ap.add_argument("--procedimiento", action="append", default=[],
                    help="P12: 'que | que tiene que producir | produce / corregido: que / preguntado: que', o ninguno")
    ap.add_argument("--uso", action="append", default=[],
                    help="P13: 'archivo[, archivo] | para que decision', o ninguna")
    ap.add_argument("--escribir", action="store_true")
    ap.add_argument("--autotest", action="store_true")
    a = ap.parse_args()
    if a.autotest:
        sys.exit(autotest())
    au = auditar(a.sesion, a.de_fran, procedimientos=a.procedimiento, usos=a.uso)
    au["notas"] = a.nota
    for n in a.nota:
        print("  NOTA (declarado): %s" % n)
    rc = imprimir(au)
    if a.escribir:
        print("  informe: %s" % escribir(au))
    sys.exit(rc)
