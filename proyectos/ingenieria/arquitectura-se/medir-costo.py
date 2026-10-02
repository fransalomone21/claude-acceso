#!/usr/bin/env python3
"""medir-costo.py -- cuanto contexto le cobra el METODO a una sesion, leido del transcript (el efecto, no los archivos).

T12 (simplificar) se cierra con el costo por TURNO, por SESION y por ENTRADA A PROYECTO medido antes y despues. Este es
el instrumento de las dos mediciones, y la semilla de P10 (affordable, SEH p. 165-166). Lee lo que el harness metio de
verdad en la ventana -- salidas de hooks, CLAUDE.md cargados, lo que la puerta hizo leer -- y lo separa de lo que pone
el harness (prompt de sistema, herramientas, skills de plugins), que el metodo no controla.

Los tres presupuestos NO se suman (un costo que se paga una vez y uno que se paga por turno no van en el mismo total).
Caracteres, no tokens: ~3,5 caracteres por token en este repo es a ojo y se dice.

    python medir-costo.py                      # las ultimas 8 sesiones de este repo
    python medir-costo.py --ultimas 20
    python medir-costo.py --transcript <x.jsonl>
"""
from __future__ import annotations

import argparse
import json
import re
import statistics
import sys
from pathlib import Path

PROYECTOS = Path.home() / ".claude" / "projects" / "C--Users-frans-Desktop-claude-acceso"
TOTAL_PUERTA = re.compile(r"total:\s*(\d+)\s*caracteres")


def medir(p: Path) -> dict:
    m = {"sesion_metodo": {}, "sesion_harness": {}, "turnos": 0, "turno_recordatorio": [], "turno_cuadros": [],
         "entrada_puerta": [], "al_paso": 0, "fase_activa": 0, "nested": 0}
    for linea in p.read_text(encoding="utf-8", errors="replace").splitlines():
        try:
            d = json.loads(linea)
        except Exception:
            continue
        a = d.get("attachment") or {}
        t = a.get("type")
        if t == "hook_success":
            ev, c = a.get("hookEvent"), len(a.get("content") or "")
            if ev == "SessionStart":
                nombre = (a.get("command") or "").split("\\")[-1][:60] or "?"
                m["sesion_metodo"]["hook " + nombre] = m["sesion_metodo"].get("hook " + nombre, 0) + c
            elif ev == "UserPromptSubmit":
                m["turno_recordatorio"].append(c)
        elif t == "hook_additional_context":
            c = sum(len(x) for x in a.get("content") or [] if isinstance(x, str))
            if "PreToolUse" in (a.get("hookName") or ""):
                m["al_paso"] += c
            else:
                m["fase_activa"] += c
        elif t == "instructions":
            for f in a.get("files") or []:
                m["sesion_metodo"]["md " + Path(f.get("path", "?")).name + " (" + Path(f.get("path", "?")).parent.name
                                    + ")"] = len(f.get("content") or "")
        elif t == "nested_memory":
            c = a.get("content") or ""  # viene como objeto, no como texto (medido: daba 4 caracteres)
            m["nested"] += len(c if isinstance(c, str) else json.dumps(c, ensure_ascii=False))
        elif t in ("skill_listing", "agent_listing_delta", "mcp_instructions_delta", "deferred_tools_delta"):
            m["sesion_harness"][t] = m["sesion_harness"].get(t, 0) + len(json.dumps(a, ensure_ascii=False))
        elif t == "prompt_snapshot":
            n = len(a.get("systemPrompt") or "") + len(json.dumps(a.get("tools") or [], ensure_ascii=False))
            m["sesion_harness"]["prompt+tools"] = max(m["sesion_harness"].get("prompt+tools", 0), n)
        if d.get("type") == "user" and isinstance((d.get("message") or {}).get("content"), str):
            m["turnos"] += 1
        if d.get("type") == "user":
            for b in (d.get("message") or {}).get("content") or []:
                if isinstance(b, dict) and b.get("type") == "tool_result":
                    txt = b.get("content")
                    txt = txt if isinstance(txt, str) else json.dumps(txt, ensure_ascii=False)
                    for x in TOTAL_PUERTA.findall(txt):
                        m["entrada_puerta"].append(int(x))
        if d.get("type") == "assistant":
            for b in (d.get("message") or {}).get("content") or []:
                if isinstance(b, dict) and b.get("type") == "text":
                    bloques = re.findall(r"```.*?```", b.get("text") or "", re.S)
                    c = sum(len(x) for x in bloques if "PARA VOS" in x or "Fase     :" in x)
                    if c:
                        m["turno_cuadros"].append(c)
    return m


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--transcript", action="append")
    ap.add_argument("--ultimas", type=int, default=8)
    ap.add_argument("--min-turnos", type=int, default=2, help="descarta sesiones de prueba de menos turnos")
    o = ap.parse_args()
    if o.transcript:
        archivos = [Path(x) for x in o.transcript]
    else:
        archivos = sorted(PROYECTOS.glob("*.jsonl"), key=lambda x: x.stat().st_mtime, reverse=True)[: o.ultimas * 3]
    filas = []
    for f in archivos:
        m = medir(f)
        if m["turnos"] < o.min_turnos and not o.transcript:
            continue
        filas.append((f, m))
        if len(filas) >= o.ultimas and not o.transcript:
            break
    if not filas:
        print("sin sesiones que medir")
        return 1
    print("%-10s %6s %9s %9s %8s %8s %9s %8s %7s" % ("sesion", "turnos", "ses.met", "ses.harn", "recor/t", "cuadr/t",
                                                     "entrada", "al-paso", "nested"))
    agg = {k: [] for k in ("sm", "sh", "rt", "ct", "en", "ap", "ne")}
    for f, m in filas:
        sm, sh = sum(m["sesion_metodo"].values()), sum(m["sesion_harness"].values())
        rt = statistics.mean(m["turno_recordatorio"]) if m["turno_recordatorio"] else 0
        ct = statistics.mean(m["turno_cuadros"]) if m["turno_cuadros"] else 0
        en = sum(m["entrada_puerta"])
        for k, v in zip(agg, (sm, sh, rt, ct, en, m["al_paso"], m["nested"])):
            agg[k].append(v)
        print("%-10s %6d %9d %9d %8d %8d %9d %8d %7d" % (f.stem[:8], m["turnos"], sm, sh, rt, ct, en, m["al_paso"],
                                                         m["nested"]))
    md = {k: statistics.median(v) for k, v in agg.items()}
    print("MEDIANA    %6s %9d %9d %8d %8d %9d %8d %7d" % ("", md["sm"], md["sh"], md["rt"], md["ct"], md["en"], md["ap"],
                                                        md["ne"]))
    print("\nDesglose de la sesion mas reciente (lo que paga el METODO al abrir):")
    for k, v in sorted(filas[0][1]["sesion_metodo"].items(), key=lambda x: -x[1]):
        print("  %8d  %s" % (v, k))
    print("\nses.met = hooks SessionStart + CLAUDE.md/MEMORY cargados; ses.harn = prompt, herramientas y listados del"
          "\nharness (no es del metodo); recor/t y cuadr/t = por turno; entrada = lo que la puerta exigio leer (suma de"
          "\nlas declaraciones); al-paso = viñetas inyectadas antes de una herramienta; nested = CLAUDE.md de una"
          "\nsubcarpeta cargado al leer adentro. Caracteres.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
