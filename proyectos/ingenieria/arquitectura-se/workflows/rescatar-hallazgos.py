#!/usr/bin/env python3
"""rescatar-hallazgos.py -- arma el resultado de encontrar-defectos.js desde el JOURNAL del workflow, sin gastar un
token de modelo: los escepticos ya juzgaron; esto solo recalcula quien sobrevive con la misma regla del script.

Existe porque la corrida wf_c0502758-925 (2026-10-12) completo la ronda 1 entera (8 buscadores, dedup y 24
escepticos) y despues el limite del plan corto las rondas 2 y 3 y el registrador: el resultado estaba en el journal y
en ningun otro lado.

Uso:
  python rescatar-hallazgos.py <journal.jsonl> --ronda 1                 resumen compacto (una linea por sobreviviente)
  python rescatar-hallazgos.py <journal.jsonl> --ronda 1 --doc <md>      escribe el documento de hallazgos
  python rescatar-hallazgos.py <journal.jsonl> --ronda 1 --registrar     corre defectos.py agregar por sobreviviente
"""
import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[4]
LOTE = 5                       # el mismo de encontrar-defectos.js
LENTES = ("evidencia", "alcance", "consecuencia")


def clave(t: str) -> str:      # la misma normalizacion que el script del workflow
    return re.sub(r"[^a-z0-9]+", " ", (t or "").lower()).strip()


def cargar(journal: Path, ronda: int):
    label, res = {}, {}
    for linea in journal.read_text(encoding="utf-8").splitlines():
        o = json.loads(linea)
        if o.get("type") == "started":
            label[o["key"]] = o.get("label", "")
        elif o.get("type") == "result":
            res[o["key"]] = o.get("result")
    por = {label.get(k, ""): v for k, v in res.items()}
    dedup = por.get("r%d:dedup" % ronda)
    if not dedup:
        raise SystemExit("la ronda %d no tiene resultado de dedup en el journal" % ronda)
    frescos = dedup["frescos"]
    lotes = [frescos[i:i + LOTE] for i in range(0, len(frescos), LOTE)]
    sobre, refu, faltan = [], [], []
    for li, lote in enumerate(lotes, 1):
        juicios = {}
        for lente in LENTES:
            j = por.get("r%d:refutar:%s:%d" % (ronda, lente, li))
            if j is None:
                faltan.append("r%d:refutar:%s:%d" % (ronda, lente, li))
            juicios[lente] = (j or {}).get("veredictos", [])
        for c in lote:
            votos = []
            for lente in LENTES:
                v = next((x for x in juicios[lente] if clave(x.get("titulo")) == clave(c["titulo"])), None)
                if v:
                    votos.append({"lente": lente, "refutado": v["refutado"], "razon": v["razon"],
                                  "verificada": v.get("evidencia_verificada", False)})
            en_pie = sum(not v["refutado"] for v in votos)
            verif = any(v["lente"] == "evidencia" and v["verificada"] and not v["refutado"] for v in votos)
            reg = dict(c, votos=votos)
            if len(votos) < 3:
                reg["aviso"] = "solo %d de 3 escepticos devolvieron veredicto" % len(votos)
            if en_pie >= 2:
                reg["grado"] = "confirmado" if en_pie == 3 and verif else ("probable" if verif else "hipotesis")
                sobre.append(reg)
            else:
                refu.append(reg)
    return dedup, sobre, refu, faltan


def documento(dedup, sobre, refu, faltan, ronda: int) -> str:
    L = ["# Hallazgos de la búsqueda de defectos del método (2026-10-12)", "",
         "Generado por `workflows/rescatar-hallazgos.py` desde el journal de `wf_c0502758-925` "
         "(`workflows/encontrar-defectos.js`). **Ronda %d completa**: 8 buscadores (NASA, INCOSE, Meadows, Saltzer, "
         "Leveson, Rechtin y Hunt-Thomas, costo y desempeño, y afuera), un deduplicador contra los DA registrados y "
         "3 escépticos por candidato (evidencia, duplicado y alcance, consecuencia); sobrevive el que queda en pie con "
         "2 de 3. **La búsqueda NO se agotó**: el límite del plan cortó las rondas 2 y 3 y el script las contó como "
         "«secas» (un agente que falla devolvía vacío: defecto del script, corregido el mismo día)." % ronda, "",
         "Grado: **confirmado** = los tres escépticos lo dejaron en pie y el de evidencia la vio con sus ojos; "
         "**probable** = 2 de 3 con la evidencia vista; **hipótesis** = 2 de 3 sin evidencia verificada.", "",
         "Duplicados de lo ya registrado que marcó el deduplicador: %d. Sobrevivientes: **%d**. Refutados: %d."
         % (len(dedup.get("duplicados", [])), len(sobre), len(refu)), ""]
    if faltan:
        L += ["**Juicios que faltan en el journal:** " + ", ".join(faltan), ""]
    L += ["## Sobrevivientes", ""]
    for n, c in enumerate(sobre, 1):
        L += ["### H-%02d — %s" % (n, c["titulo"]), "",
              "- **Grado:** %s%s" % (c["grado"], (" (" + c["aviso"] + ")") if c.get("aviso") else ""),
              "- **Clase:** %s" % c["clase"], "- **Síntoma:** %s" % c["sintoma"],
              "- **Mecanismo:** %s" % c["mecanismo"], "- **Evidencia:** %s" % c["evidencia"],
              "- **Dónde:** %s" % c["donde"], "- **Fuente:** %s" % c["fuente"], "- **Impacto:** %s" % c["impacto"],
              "- **Relación:** %s" % c["relacion"], "- **Propuesta:** %s" % c["propuesta"],
              "- **Fusionados:** %s" % ("; ".join(c.get("fusionados", [])) or "-"), "- **Votos:**"]
        L += ["  - %s: %s — %s" % (v["lente"], "refutado" if v["refutado"] else "en pie", v["razon"])
              for v in c["votos"]]
        L.append("")
    L += ["## Refutados", "", "| Candidato | Lo tumbó | Por qué |", "|---|---|---|"]
    for c in refu:
        tumbo = [v for v in c["votos"] if v["refutado"]]
        L.append("| %s | %s | %s |" % (c["titulo"].replace("|", "/"), ", ".join(v["lente"] for v in tumbo),
                                        " / ".join(v["razon"].replace("|", "/").replace("\n", " ")[:300] for v in tumbo)))
    L += ["", "## Duplicados de lo ya registrado", "", "| Candidato | De |", "|---|---|"]
    L += ["| %s | %s |" % (d["titulo"].replace("|", "/"), d["de"]) for d in dedup.get("duplicados", [])]
    return "\n".join(L) + "\n"


def registrar(sobre) -> list:
    out = []
    for n, c in enumerate(sobre, 1):
        cmd = [sys.executable, str(RAIZ / "perfil-global" / "herramientas" / "defectos.py"), "agregar",
               "--titulo", c["titulo"], "--clase", c["clase"], "--sintoma", c["sintoma"],
               "--evidencia", "%s | mecanismo: %s | impacto: %s" % (c["evidencia"], c["mecanismo"], c["impacto"]),
               "--donde", c["donde"],
               "--fuente", "%s | %s | hallazgos-2026-10-12.md H-%02d" % (c["fuente"], c["relacion"], n),
               "--grado", c["grado"]]
        r = subprocess.run(cmd, capture_output=True, cwd=str(RAIZ))
        sal = (r.stdout + r.stderr).decode("utf-8", "replace").strip()
        out.append("H-%02d -> %s" % (n, sal.splitlines()[-1] if sal else "exit %d" % r.returncode))
    return out


def main():
    a = argparse.ArgumentParser()
    a.add_argument("journal")
    a.add_argument("--ronda", type=int, default=1)
    a.add_argument("--doc")
    a.add_argument("--registrar", action="store_true")
    o = a.parse_args()
    dedup, sobre, refu, faltan = cargar(Path(o.journal), o.ronda)
    if o.doc:
        Path(o.doc).write_text(documento(dedup, sobre, refu, faltan, o.ronda), encoding="utf-8")
        print("escrito: %s" % o.doc)
    for n, c in enumerate(sobre, 1):
        print("H-%02d %-10s %-28s %s" % (n, c["grado"], c["relacion"][:28], c["titulo"][:150]))
    print("sobrevivientes %d, refutados %d, duplicados %d, juicios faltantes %d"
          % (len(sobre), len(refu), len(dedup.get("duplicados", [])), len(faltan)))
    if o.registrar:
        for l in registrar(sobre):
            print(l)


if __name__ == "__main__":
    main()
