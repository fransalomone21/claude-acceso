#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probar-divergencias.py -- el saboteador de divergencias.py (T20, 2026-10-12).

Requisitos que prueba: L2-DIV-01..05 de proyectos/ingenieria/arquitectura-se/docs/10-requisitos.md; casos (a)-(e) de
docs/t20-cero-divergencias.md §4. Arma un arbol SINTETICO parecido al real (un PDP con su tabla de fases, la lluvia
con su §6, un ESTADO y un retome llenos de mediciones fechadas y punteros) y corre el medidor por su linea de comando
(la frontera real). Cada caso exige el codigo Y su marca en una linea [FAIL] o [aviso] -- no un rojo cualquiera -- y
reporta la linea que lo satisfizo. Despues, los mutantes: una COPIA del medidor al lado del original con un
mecanismo apagado, y cada mutante tiene que verse en SU caso. La copia se borra siempre; el original no se toca.

Sale 0 si todo se ve; 1 si un caso o un mutante no (la prueba o el medidor estan ciegos); 2 si un mutante no aplica
(el texto a mutar cambio: el saboteador quedo viejo).

Uso:  python probar-divergencias.py
"""
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
MEDIDOR = RAIZ / "divergencias.py"

PDP = """# PDP -- demo

## 4. Las fases, y QUE CIERRA CADA UNA

| # | Fase | Que la cierra | Como se certifica | Estado |
|---|---|---|---|---|
| **5** | **Disenar** | los tres archivos | medir-matriz.py | `cerrada` |
| 6 | **Migrar** | chequeo en verde | chequeo-completo | **CERRADA 2026-09-17** (el ESTADO lo dice) |
| 7 | **Validar** (no verificar). Tipo: **Fase D** (fabricacion, integracion y prueba) | una sesion real | P10 | `abierta` |

**Fase en curso:** 7 -- Validar (no verificar). Tipo: Fase D.
"""

LLUVIA = """# Lluvia de ideas

## 6. El orden propuesto

| # | Diseno | Defectos | Decision |
|---|---|---|---|
| 1 | **T14** la puerta infiere | DA-045 | CONSTRUIDO `e6d58bb` (2026-10-12) |
| 1b | **T20, ley de cero divergencias** | DA-017 | DISENADO |
| 2 | **T17** conectores | DA-046 | frenar |
| 6 | costo del fan-out | DA-051 | -- |

## 7. Las decisiones

| 9 | **T99** no es del orden | -- | -- |
"""

ESTADO = """# ESTADO ACTUAL -- demo

La fase en curso y que la cierra: `PDP.md` §4 (dueno). El orden de lo que sigue:
[`docs/lluvia-2026-10-12.md`](docs/lluvia-2026-10-12.md) §6 (dueno). Aca no se copian (T20).

**2026-10-12 (sesion `814911bc`) -- T14 CONSTRUIDO.** Al cerrar: Fase 7 ABIERTA, y el camino
T14 -> T20 -> T17, con 48 abiertos de 54.

**Siguiente, al 2026-09-29 (reemplazado): T2** (camino critico T1 → T2 → T3 →
T7 → T9).

## 2026-09-28 -- el diagnostico medido

el camino critico T1 → T2 → T3 → T4 → T7 →
T9 y la Fase 6 ABIERTA de entonces.

## Lo que quedo instalado

| Pieza | Estado |
|---|---|
| P2 | cumple |
"""

RETOME = """# Retome

```
Retomo el METODO: el orden de lo que sigue lo tiene docs/lluvia-2026-10-12.md §6 (dueno; no se copia).

8. MEDIR AL ENTRAR: defectos.py resumen (al cerrar 814911bc: 48 abiertos, 6 arreglados, de 54).
```
"""

HANDOFF = """# HANDOFF

> **2026-10-12 (sesion `814911bc`, CERRADA) -- SIGUE: T20.** El orden era T14 -> T20 -> T19 y la
> Fase 7 ABIERTA; 48 abiertos.
"""

DEFECTOS = "# Defectos\n\n**48 abiertos · 6 arreglados sin validar · 0 validados** (de 54).\n"

REGISTRO = {
    "datos": [
        {"id": "demo/fase-en-curso",
         "dueno": {"archivo": "proy/PDP.md", "extractor": "fase_activa"},
         "copias": [
             {"archivo": "proy/PDP.md", "clase": "vista", "que": "la fila abierta",
              "extractor": {"regex": "(?m)^\\|\\s*\\**([0-9]+[a-z]?)\\**\\s*\\|.*\\|\\s*`?\\**abierta\\**`?\\s*\\|\\s*$"}},
             {"archivo": "proy/ESTADO_ACTUAL.md", "clase": "puntero", "nombra": "PDP.md"}],
         "forma": "(?i)\\bfase\\s+\\d+\\**\\s*(?:[-—–:]+\\s*)?\\**abierta", "ambito": "proy"},
        {"id": "demo/orden",
         "dueno": {"archivo": "proy/docs/lluvia-2026-10-12.md",
                   "extractor": {"seccion": "## 6.", "regex": "(?m)^\\|\\s*\\w+\\s*\\|\\s*\\*\\*(T\\d+)\\b"}},
         "copias": [
             {"archivo": "proy/ESTADO_ACTUAL.md", "clase": "puntero", "nombra": "lluvia-2026-10-12.md"},
             {"archivo": "proy/RETOME.md", "clase": "puntero", "nombra": "lluvia-2026-10-12.md"}],
         "forma": "\\bT\\d+[a-z]?\\s*(?:→|->)\\s*T\\d+", "ambito": "proy"},
        {"id": "demo/abiertos",
         "dueno": {"archivo": "perfil/DEFECTOS.md", "extractor": {"regex": "\\*\\*(\\d+) abiertos"}},
         "copias": [], "forma": "\\b\\d+ abiertos\\b", "ambito": "proy"},
    ]
}


def armar() -> Path:
    t = Path(tempfile.mkdtemp(prefix="probar-divergencias-"))
    for rel, txt in (("proy/PDP.md", PDP), ("proy/docs/lluvia-2026-10-12.md", LLUVIA),
                     ("proy/ESTADO_ACTUAL.md", ESTADO), ("proy/RETOME.md", RETOME), ("proy/HANDOFF.md", HANDOFF),
                     ("perfil/DEFECTOS.md", DEFECTOS)):
        p = t / rel
        p.parent.mkdir(parents=True, exist_ok=True)
        p.write_text(txt, encoding="utf-8")
    (t / ".claude").mkdir()
    (t / ".claude" / "datos.json").write_text(json.dumps(REGISTRO, ensure_ascii=False, indent=1), encoding="utf-8")
    return t


def editar(t: Path, rel: str, viejo: str, nuevo: str):
    p = t / rel
    txt = p.read_text(encoding="utf-8")
    assert txt.count(viejo) == 1, "el fixture no tiene una sola vez: %r" % viejo
    p.write_text(txt.replace(viejo, nuevo), encoding="utf-8")


def agregar(t: Path, rel: str, texto: str):
    p = t / rel
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text((p.read_text(encoding="utf-8") if p.exists() else "") + texto, encoding="utf-8")


def registro(t: Path, cambio):
    reg = json.loads(json.dumps(REGISTRO))
    cambio(reg)
    (t / ".claude" / "datos.json").write_text(json.dumps(reg, ensure_ascii=False), encoding="utf-8")


# (nombre, romper(t), codigo esperado, prefijo de la linea, marcas que la linea tiene que tener TODAS, marca prohibida)
CASOS = [
    ("(d) CONTROL parecido al real: fechadas y punteros dan verde", lambda t: None, 0, "[OK  ]",
     ["demo/orden", "= T14, T20, T17;"], "[FAIL]"),
    ("(d) CONTROL: el dueno de la fase se extrae (llego)", lambda t: None, 0, "[OK  ]",
     ["demo/fase-en-curso", "= 7;"], "[aviso]"),
    ("(a) copia vista divergente -> ROJO con dato, dueno y copia (L2-DIV-01)",
     lambda t: (editar(t, "proy/PDP.md", "| `abierta` |", "| `cerrada` |"),
                editar(t, "proy/PDP.md", "medir-matriz.py | `cerrada` |", "medir-matriz.py | `abierta` |")),
     1, "[FAIL]", ["DIVERGE demo/fase-en-curso", "dueno proy/PDP.md = 7", "copia vista proy/PDP.md", "= 5"], None),
    ("(b) puntero que copia el valor -> ROJO (L2-DIV-02)",
     lambda t: agregar(t, "proy/ESTADO_ACTUAL.md", "\nSigue: T14 -> T20 -> T17.\n"),
     1, "[FAIL]", ["PUNTERO COPIA EL VALOR demo/orden", "proy/ESTADO_ACTUAL.md:"], None),
    ("(b) titulo sin fecha con la fase -> ROJO (L2-DIV-02)",
     lambda t: agregar(t, "proy/ESTADO_ACTUAL.md", "\n## Fase 7 -- ABIERTA\n"),
     1, "[FAIL]", ["PUNTERO COPIA EL VALOR demo/fase-en-curso", "## Fase 7 -- ABIERTA"], None),
    ("(b) puntero que ya no nombra al dueno -> ROJO",
     lambda t: editar(t, "proy/RETOME.md", "docs/lluvia-2026-10-12.md §6", "la lluvia"),
     1, "[FAIL]", ["YA NO NOMBRA demo/orden", "proy/RETOME.md"], None),
    ("(c) extractor del dueno vacio -> ROJO (L2-DIV-03)",
     lambda t: editar(t, "proy/PDP.md", "**Fase en curso:** 7", "Fase: 7"),
     1, "[FAIL]", ["DUENO VACIO demo/fase-en-curso"], None),
    ("(c) registro que no parsea -> ROJO (L2-DIV-03)",
     lambda t: (t / ".claude" / "datos.json").write_text("{", encoding="utf-8"),
     1, "[FAIL]", ["REGISTRO no parsea"], None),
    ("(c) registro vacio -> ROJO, no verde por vacio",
     lambda t: (t / ".claude" / "datos.json").write_text('{"datos": []}', encoding="utf-8"),
     1, "[FAIL]", ["REGISTRO", "vacio"], None),
    ("(c) archivo del dueno ausente -> ROJO",
     lambda t: (t / "perfil" / "DEFECTOS.md").unlink(),
     1, "[FAIL]", ["DUENO AUSENTE demo/abiertos"], None),
    ("(c) copia declarada que no existe -> ROJO",
     lambda t: (t / "proy" / "RETOME.md").unlink(),
     1, "[FAIL]", ["COPIA AUSENTE demo/orden", "proy/RETOME.md"], None),
    ("L2-DIV-05: un dato con dos duenos -> ROJO",
     lambda t: registro(t, lambda r: r["datos"][2].__setitem__("dueno", [r["datos"][2]["dueno"],
                                                                          {"archivo": "proy/RETOME.md",
                                                                           "extractor": {"regex": "x"}}])),
     1, "[FAIL]", ["DOS DUENOS demo/abiertos"], None),
    ("L2-DIV-05: el mismo dato dos veces en el registro -> ROJO",
     lambda t: registro(t, lambda r: r["datos"].append(json.loads(json.dumps(r["datos"][2])))),
     1, "[FAIL]", ["DOS DUENOS demo/abiertos", "dos veces"], None),
    ("L2-DIV-04: copia no declarada sin fecha -> [aviso], sin cambiar el codigo",
     lambda t: agregar(t, "proy/docs/notas.md", "Hoy: Fase 7 ABIERTA.\n\n**2026-10-01** la Fase 6 ABIERTA de entonces.\n"),
     0, "[aviso]", ["copia ausente del registro", "demo/fase-en-curso", "proy/docs/notas.md:1", "Fase 7"], "notas.md:3"),
]

# (texto original del medidor, texto mutado, el caso que tiene que dejar de verse)
MUTANTES = [
    ("if v != valor:", "if False:", "(a) copia vista divergente"),
    ("for n, l in lineas_vigentes(texto):\n                    if forma.search(l):",
     "for n, l in []:\n                    if forma.search(l):", "(b) puntero que copia el valor"),
    ("            if not nivel_fechado:  # un titulo", "            if False:  # un titulo",
     "(b) titulo sin fecha con la fase"),
    ("        if not valor:\n", "        if False:\n", "(c) extractor del dueno vacio"),
    ("if not nivel_fechado and not fechado and not FECHA.search(linea):", "if True:",
     "(d) CONTROL parecido al real"),
]


def correr(medidor: Path, t: Path):
    r = subprocess.run([sys.executable, str(medidor), "--raiz", str(t), "--registro", str(t / ".claude" / "datos.json")],
                       capture_output=True, timeout=120)
    return r.returncode, (r.stdout + r.stderr).decode("utf-8", "replace")


def caso(medidor: Path, c):
    """(visto, detalle). Visto = el codigo esperado Y una linea con el prefijo y TODAS las marcas, y nada prohibido."""
    nombre, romper, codigo, prefijo, marcas, prohibida = c
    t = armar()
    try:
        romper(t)
        rc, sal = correr(medidor, t)
    finally:
        shutil.rmtree(t, ignore_errors=True)
    if rc == 2:
        return False, "REVENTO: " + sal.strip()[-160:]
    linea = next((l for l in sal.splitlines() if l.startswith(prefijo) and all(m in l for m in marcas)), "")
    malo = next((l for l in sal.splitlines() if prohibida and prohibida in l), "")
    if rc == codigo and linea and not malo:
        return True, linea.strip()[:130]
    return False, "exit %d (esperado %d); %s" % (rc, codigo, ("prohibida: " + malo.strip()[:100]) if malo
                                                  else "ninguna linea %s con %s" % (prefijo, marcas))


def main() -> int:
    try:
        sys.stdout.reconfigure(errors="replace")
    except Exception:  # noqa: BLE001
        pass
    mal, sanos = 0, set()
    print("== casos (el medidor real, por su linea de comando) ==")
    for c in CASOS:
        visto, det = caso(MEDIDOR, c)
        mal += not visto
        if visto:
            sanos.add(c[0])
        print("%s  %-62s -> %s" % ("ok " if visto else "MAL", c[0][:62], det))
    print("== mutantes (cada uno tiene que verse en SU caso) ==")
    fuente, viejos = MEDIDOR.read_text(encoding="utf-8"), 0
    for viejo, nuevo, nombre in MUTANTES:
        if fuente.count(viejo) != 1:
            viejos += 1
            print("NO APLICA  el texto a mutar no esta una sola vez: %r" % viejo[:50])
            continue
        c = next(x for x in CASOS if x[0].startswith(nombre))
        if c[0] not in sanos:  # un mutante 'visto' sobre un caso que ya fallaba sin mutar no prueba nada
            mal += 1
            print("MAL  %-40s -> NO JUZGABLE: su caso no paso con el medidor sano" % nuevo.strip()[:40])
            continue
        copia = MEDIDOR.with_name("divergencias_mutante.py")
        try:
            copia.write_text(fuente.replace(viejo, nuevo, 1), encoding="utf-8")
            sigue_visto, det = caso(copia, c)
        finally:
            copia.unlink(missing_ok=True)
        mal += sigue_visto
        print("%s  %-40s -> %s" % ("ok " if not sigue_visto else "MAL", nuevo.strip()[:40],
                                   ("lo ve: " + det[:80]) if not sigue_visto else "NO LO VE: el caso sigue igual"))
    if viejos:
        print("probar-divergencias: %d mutante(s) NO APLICAN: el saboteador quedo viejo" % viejos)
        return 2
    print("probar-divergencias: %s" % ("los %d casos y los %d mutantes, vistos" % (len(CASOS), len(MUTANTES))
                                       if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    sys.exit(main())
