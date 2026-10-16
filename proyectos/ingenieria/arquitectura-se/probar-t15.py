#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probar-t15.py -- el saboteador de T15, «el aprendizaje se cierra» (docs/t15-el-aprendizaje-se-cierra.md).

Cada pieza sana en verde, y cada mutante visto en rojo EN SU CASO (un mutante solo se juzga si su caso paso sano en
la misma corrida; si no, NO JUZGABLE y cuenta como MAL). Nada toca lo real: copias en temporal, y la caja negra con
USERPROFILE y TEMP apuntados a carpetas de prueba.

  1. aprender.py   (L2-APR-01..11)  su autotest, sano y con 6 mutantes
  2. guardia-fanout (L2-GFO-01..05) el costo en el texto, la decision 'ask', y un mutante que no cuenta
  3. la puerta      (L2-PTA-18/19)  la caja negra fuera del temporal y la copia del legado; 2 mutantes
  4. la auditoria   (L2-AUD-03)     lee la caja del legado por la regla de la puerta; 1 mutante
  5. la cascada     (DA-058)        'metodo' avisa el concepto freno al declarar; 1 mutante

Uso: python proyectos/ingenieria/arquitectura-se/probar-t15.py      (sale 0 si todo discrimina)
"""
from __future__ import annotations

import importlib.util
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
APR = RAIZ / "perfil-global" / "herramientas" / "aprender.py"
GFO = RAIZ / "perfil-global" / "hooks" / "guardia-fanout.ps1"
PUERTA = RAIZ / ".claude" / "hooks" / "cascada_puerta.py"
AUD = RAIZ / "auditar-sesion.py"
TMP = Path(tempfile.mkdtemp(prefix="probar-t15-"))
mal = 0


def caso(nombre, ok, detalle=""):
    global mal
    mal += not ok
    print("%s  %-78s %s" % ("ok " if ok else "MAL", nombre, "" if ok else "-> " + str(detalle).replace("\n", " | ")[:200]))
    return ok


def mutante(src: Path, viejo: str, nuevo: str, destino: Path) -> bool:
    txt = src.read_text(encoding="utf-8")
    if viejo not in txt:
        return False
    destino.parent.mkdir(parents=True, exist_ok=True)
    destino.write_text(txt.replace(viejo, nuevo, 1), encoding="utf-8")
    return True


# ------------------------------------------------------------------ 1. aprender.py
def apr(script: Path):
    r = subprocess.run([sys.executable, str(script), "--repo", str(RAIZ), "autotest"], capture_output=True, text=True,
                       encoding="utf-8", errors="replace")
    return r.returncode, r.stdout + r.stderr


print("== 1. aprender.py (L2-APR-01..11)")
rc, s = apr(APR)
sano_apr = {l[5:].split("  ")[0].strip() for l in s.splitlines() if l.startswith("ok ")}
caso("SANO: el autotest de aprender.py da BIEN", rc == 0 and "autotest: BIEN" in s, s[-300:])
for marca, viejo, nuevo in (
        ("L2-APR-01", 'ok, motivo = validar_renglon(a.triage, getattr(a, "renglon", None), raiz)', 'ok, motivo = True, ""'),
        ("L2-APR-03", 'if vins is not None and not renglon_llega(l["renglon"], vins):', "if False:"),
        ("L2-APR-04", "if nh > TOPE_HEREDADAS:", "if False:"),
        ("L2-APR-06/07", 'l["nivel_exigido"] = nivel_siguiente(l.get("nivel"))', "pass"),
        ("L2-APR-08", "if nivel_pendiente(l):", "if False:"),
        ("L2-APR-09", "if ex and ORDEN_NIVELES.index(a.nivel) < ORDEN_NIVELES.index(ex):", "if False:")):
    m = TMP / "apr" / marca.replace("/", "-") / "aprender.py"
    if not any(x.startswith(marca) for x in sano_apr):
        caso("MUTANTE %s: NO JUZGABLE (su caso no paso sano)" % marca, False)
        continue
    if not mutante(APR, viejo, nuevo, m):
        caso("MUTANTE %s: NO APLICA (el texto cambio)" % marca, False)
        continue
    rc, s = apr(m)
    vistos = [l for l in s.splitlines() if l.startswith("MAL") and marca in l]
    caso("MUTANTE %s -> lo ve su caso" % marca, rc == 1 and bool(vistos), s[-300:])

# ------------------------------------------------------------------ 2. guardia de fan-out
print("== 2. guardia-fanout (L2-GFO-01..05)")
wf = TMP / "wf.js"
wf.write_text("export const meta = {name: 'x'}\nawait agent('a')\nawait agent('b')\n", encoding="utf-8")


def gfo(script: Path, ev: dict):
    r = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", str(script)],
                       input=json.dumps(ev), capture_output=True, text=True, encoding="utf-8", errors="replace")
    return r.stdout


casos_gfo = [
    ("Workflow con 3 agent() en el script -> 'al menos 3', 12-18 %",
     {"tool_name": "Workflow", "tool_input": {"script": "agent('a'); agent( 'b' ); x.map(() => agent('c'))"}},
     ["al menos 3 agente", "12-18 %", "wf_3f865b1e"]),
    ("Workflow por scriptPath con 2 agent() -> 'al menos 2'",
     {"tool_name": "Workflow", "tool_input": {"scriptPath": str(wf)}}, ["al menos 2 agente", "8-12 %"]),
    ("Agent -> 1 agente", {"tool_name": "Agent", "tool_input": {"description": "x"}}, ["al menos 1 agente", "4-6 %"]),
    ("Workflow guardado por nombre -> costo DESCONOCIDO",
     {"tool_name": "Workflow", "tool_input": {"name": "review-changes"}}, ["DESCONOCIDO"]),
]
sano_gfo = {}
for nombre, ev, esp in casos_gfo:
    s = gfo(GFO, ev)
    try:
        dec = json.loads(s)["hookSpecificOutput"]
    except Exception:
        dec = {}
    sano_gfo[nombre] = caso("SANO: " + nombre + " (y la decision es 'ask', L2-GFO-05)",
                            dec.get("permissionDecision") == "ask" and all(e in dec.get("permissionDecisionReason", "")
                                                                           for e in esp), s[:300])
m = TMP / "gfo" / "guardia-fanout.ps1"
if not sano_gfo.get(casos_gfo[0][0]):
    caso("MUTANTE guardia que no cuenta: NO JUZGABLE", False)
elif not mutante(GFO, "$agentes = ([regex]::Matches($script, '\\bagent\\s*\\(')).Count", "$agentes = 1", m):
    caso("MUTANTE guardia que no cuenta: NO APLICA", False)
else:
    s = gfo(m, casos_gfo[0][1])
    caso("MUTANTE guardia que no cuenta -> el caso de 3 agentes lo ve", "al menos 3 agente" not in s, s[:200])

# ------------------------------------------------------------------ 3. la caja negra (puerta)
print("== 3. la caja negra fuera de %TEMP% (L2-PTA-18/19)")


def entorno(base: Path) -> dict:
    (base / "home").mkdir(parents=True, exist_ok=True)
    (base / "temp" / "claude-cascada").mkdir(parents=True, exist_ok=True)
    e = {k: v for k, v in os.environ.items() if not k.startswith("CASCADA_")}
    e.update(USERPROFILE=str(base / "home"), HOME=str(base / "home"), TEMP=str(base / "temp"), TMP=str(base / "temp"),
             CASCADA_RAIZ=str(RAIZ), CASCADA_CATALOGO=str(RAIZ / ".claude" / "cascada.json"))
    return e


def caja(script: Path, base: Path, sid: str):
    """Un legado con una declaracion; despues un Read de PostToolUse. Devuelve (nueva, legado) como texto."""
    e = entorno(base)
    leg = base / "temp" / "claude-cascada" / ("%s.jsonl" % sid)
    leg.write_text(json.dumps({"t": "declara", "proy": "telescopio", "nec": ["diseno"], "ts": 1.0}) + "\n", encoding="utf-8")
    ev = {"hook_event_name": "PostToolUse", "session_id": sid, "tool_name": "Read",
          "tool_input": {"file_path": str(RAIZ / "CLAUDE.md")}, "tool_response": {}}
    subprocess.run([sys.executable, str(script)], input=json.dumps(ev).encode("utf-8"), capture_output=True, env=e)
    nueva = base / "home" / ".claude" / "caja-negra" / ("%s.jsonl" % sid)
    return (nueva.read_text(encoding="utf-8") if nueva.exists() else ""), leg.read_text(encoding="utf-8")


nueva, leg = caja(PUERTA, TMP / "p-sana", "t15-sana")
sano_caja = caso("SANO: la caja nueva vive en ~/.claude/caja-negra, trae lo del legado y lo nuevo; el legado no crece",
                 '"declara"' in nueva and '"lee"' in nueva and '"lee"' not in leg, "nueva=%r legado=%r" % (nueva[:160], leg[:160]))
for nombre, viejo, nuevo, ve in (
        ("caja en el temporal (L2-PTA-18)",
         'ESTADO_DIR = Path(os.environ.get("CASCADA_ESTADO_DIR") or Path.home() / ".claude" / "caja-negra")',
         'ESTADO_DIR = Path(os.environ.get("CASCADA_ESTADO_DIR") or Path(tempfile.gettempdir()) / "claude-cascada")',
         lambda n, l: '"lee"' not in n),
        ("sin la copia del legado (L2-PTA-19)", "        if viejo.exists():", "        if False:",
         lambda n, l: '"declara"' not in n)):
    m = TMP / ("p-%d" % len(nombre)) / ".claude" / "hooks" / "cascada_puerta.py"
    if not sano_caja:
        caso("MUTANTE %s: NO JUZGABLE" % nombre, False)
    elif not mutante(PUERTA, viejo, nuevo, m):
        caso("MUTANTE %s: NO APLICA" % nombre, False)
    else:
        n, l = caja(m, TMP / ("pm-%d" % len(nombre)), "t15-mut")
        caso("MUTANTE %s -> lo ve" % nombre, ve(n, l), "nueva=%r" % n[:160])

# ------------------------------------------------------------------ 4. la auditoria
print("== 4. la auditoria lee la caja por la regla de la puerta (L2-AUD-03)")


def auditar_con(script: Path, base: Path, sid: str):
    e = entorno(base)
    (base / "temp" / "claude-cascada" / ("%s.jsonl" % sid)).write_text(
        json.dumps({"t": "declara", "proy": "telescopio", "nec": ["diseno"], "ts": 1.0}) + "\n", encoding="utf-8")
    codigo = ("import importlib.util, json, sys; from pathlib import Path\n"
              "s = importlib.util.spec_from_file_location('aud', r'%s'); m = importlib.util.module_from_spec(s)\n"
              "s.loader.exec_module(m)\n"
              "r = m.auditar('%s', [], Path(r'%s'))\n"
              "print(json.dumps({'estado': r['estado'], 'proyectos': r['proyectos']}))\n") % (script, sid, RAIZ)
    p = subprocess.run([sys.executable, "-c", codigo], capture_output=True, text=True, env=e, encoding="utf-8",
                       errors="replace")
    try:
        return json.loads(p.stdout.strip().splitlines()[-1])
    except Exception:
        return {"error": (p.stdout + p.stderr)[-300:]}


r = auditar_con(AUD, TMP / "a-sana", "t15-aud")
sano_aud = caso("SANO: con la caja solo en el legado, la auditoria la lee (y la copia a la caja nueva)",
                "telescopio" in r.get("proyectos", []) and "caja-negra" in r.get("estado", ""), r)
m = TMP / "aud" / "auditar-sesion.py"
txt = AUD.read_text(encoding="utf-8")
viejos = ("        g.migrar_legado()", "        f = g.archivo_estado(sesion)")
if not sano_aud:
    caso("MUTANTE auditoria que arma la ruta por su cuenta: NO JUZGABLE", False)
elif not all(v in txt for v in viejos):
    caso("MUTANTE auditoria que arma la ruta por su cuenta: NO APLICA", False)
else:
    m.parent.mkdir(parents=True, exist_ok=True)
    m.write_text(txt.replace(viejos[0], "        pass", 1).replace(
        viejos[1], '        f = d / ("%s.jsonl" % re.sub(r"[^A-Za-z0-9_.-]", "_", sesion))', 1), encoding="utf-8")
    r = auditar_con(m, TMP / "a-mut", "t15-aud")
    caso("MUTANTE auditoria que arma la ruta por su cuenta -> no ve la sesion", "telescopio" not in r.get("proyectos", []), r)

# ------------------------------------------------------------------ 5. la cascada avisa el concepto freno
print("== 5. 'metodo' avisa el concepto freno al declarar (DA-058, leccion 351)")


def exige(cat: Path):
    e = dict(os.environ, CASCADA_CATALOGO=str(cat))
    return subprocess.run([sys.executable, str(PUERTA), "--exige", "arquitectura-se", "--necesidad", "metodo"],
                          capture_output=True, text=True, env=e, encoding="utf-8", errors="replace").stdout


s = exige(RAIZ / ".claude" / "cascada.json")
sano_ex = caso("SANO: --exige metodo imprime 'AL TOCAR ... concepto freno' con saltzer-schroeder",
               "concepto freno" in s and "AL TOCAR" in s and "saltzer-schroeder" in s, s[-300:])
cat = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
cat["necesidades"]["metodo"].pop("al_tocar", None)
cm = TMP / "cat-sin-al-tocar.json"
cm.write_text(json.dumps(cat, ensure_ascii=False), encoding="utf-8")
if sano_ex:
    caso("MUTANTE catalogo sin al_tocar -> el aviso desaparece", "AL TOCAR" not in exige(cm))
else:
    caso("MUTANTE catalogo sin al_tocar: NO JUZGABLE", False)

shutil.rmtree(TMP, ignore_errors=True)
print("probar-t15: %s" % ("BIEN, todo discrimina" if not mal else "%d MAL" % mal))
sys.exit(1 if mal else 0)
