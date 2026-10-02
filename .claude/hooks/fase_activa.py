#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fase_activa.py -- EL DISPARADOR DE LA ARQUITECTURA (2026-09-28, pedido de Fran tras BLACK (96)).

La arquitectura existia (el PDP de cada proyecto dice que fase esta abierta, y en BLACK que COOP-B es DISENO
PRELIMINAR y la cierra una PDR), pero nada la ponia delante en el momento de decidir: el cuadro de fase nombraba
la fase y no decia que NO se hace en ella, y la sesion (96) arreglo sintomas a prueba y error en una fase de
diseno. Esto es el flujo de informacion que faltaba (Meadows), no una regla mas fuerte.

Dos usos:
  python .claude/hooks/fase_activa.py <carpeta del proyecto>   -> imprime la compuerta de la fase abierta
  (hook PostToolUse)  lee el JSON del evento por stdin; la PRIMERA vez que una sesion toca un archivo de
                      proyectos/<naturaleza>/<proyecto>/, le inyecta la compuerta de ESE proyecto (una vez por
                      sesion y proyecto). Falla ABIERTO: si algo sale mal, no dice nada y no frena nada.
  python .claude/hooks/fase_activa.py --autotest               -> casos conocidos, con su rojo

La fase se LEE del PDP (fila de la tabla de fases que dice "abierta"); el tipo sale de su nombre con el ciclo de
vida NASA (SP-2016-6105, cap. 3). No hay una segunda lista: si el PDP no declara el tipo, la compuerta lo dice.
Sin acentos en la salida a proposito: la consola de Windows la lee como cp1252.
"""
from __future__ import annotations

import json
import os
import re
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[2]

# (tipo, patron sobre la fila, que produce, que NO se hace, que la cierra, nombre NASA, que es en criollo)
# El nombre NASA es el que imprime el handbook (SP-2016-6105 Rev2, p. 20; ficha nasa-seh/ciclo-vida.md): Fran
# pidio la fase con su nombre oficial y la contrapartida en criollo (2026-10-02). Esta tabla es la UNICA fuente de
# los dos: el cuadro los copia de la compuerta, no de memoria.
TIPOS = [
    ("Pre-Fase A (estudio de conceptos)", r"pre-?fase a|estudio de concepto",
     "alternativas, factibilidad y la meta partida en fases",
     "disenar en detalle o construir el producto", "MCR: concepto elegido con sus criterios",
     'Pre-Phase A, "Concept Studies"', "ver que se podria hacer y elegir el concepto"),
    ("Fase A (concepto y desarrollo de tecnologia)", r"\bfase a\b|desarrollo de tecnolog",
     "requisitos y los habilitadores criticos madurados con prototipos que retiran riesgo",
     "fabricar el producto final", "SRR/SDR: requisitos y habilitadores en su madurez objetivo",
     'Phase A, "Concept and Technology Development"', "decidir que se quiere y probar que la tecnologia da"),
    ("Fase B (diseno preliminar)", r"dise.o preliminar|\bfase b\b",
     "el DISENO: arquitectura, interfaces, cada direccion/archivo que se toca, riesgos altos retirados por efecto",
     "construir o cambiar el producto a prueba y error; arreglar sintomas de a uno sin el modelo de como esta "
     "armado lo que se copia. Lo vivo solo confirma una PREDICCION del diseno, con control. Varios sintomas del "
     "mismo sistema = UNA pregunta de arquitectura, en frio",
     "PDR: el diseno escrito, verificado contra el codigo y revisado por Fran ANTES de fabricar",
     'Phase B, "Preliminary Design and Technology Completion"', "el diseno en grueso, con los riesgos grandes resueltos"),
    ("Fase C (diseno final)", r"dise.o (final|detallado)|\bfase c\b",
     "el diseno detallado completo y verificado",
     "integrar o instalar sin el diseno detallado aprobado", "CDR",
     'Phase C, "Final Design and Fabrication"', "el diseno fino y fabricar las piezas"),
    ("Fase D (fabricacion, integracion y prueba)", r"fabricaci|integraci|construcci|\bfase d\b",
     "el producto construido segun el diseno aprobado, verificado contra sus requisitos",
     "redisenar sobre la marcha: un cambio de diseno vuelve a la revision", "verificacion + validacion",
     'Phase D, "System Assembly, Integration and Test, Launch"', "armar lo disenado, probar que anda y ponerlo en marcha"),
    ("Fase E (operacion)", r"operaci|\bfase e\b",
     "uso y mantenimiento", "cambios sin control de configuracion", "cierre",
     'Phase E, "Operations and Sustainment"', "usarlo y mantenerlo andando"),
    ("Fase F (cierre)", r"\bfase f\b|cierre del proyecto",
     "el cierre: lo aprendido escrito y el material archivado", "abrir trabajo nuevo", "archivo y lecciones",
     'Phase F, "Closeout"', "cerrarlo y guardar lo aprendido"),
]


def fase_abierta(pdp: Path):
    """La fase de la linea '**Fase en curso:** X' del PDP (la convencion de la plantilla) y su fila en la tabla
    de fases: (id, nombre, texto para tipar). ('ninguna', motivo, '') si la linea dice que no hay; None si falta.
    (Buscar 'abierta' en cualquier celda tomaba la fila 5b de BLACK: el autotest lo puso en rojo.)"""
    lineas = pdp.read_text(encoding="utf-8", errors="replace").splitlines()
    ident, resto = None, ""
    for linea in lineas:
        m = re.search(r"\*\*Fase en curso:?\*?\*?:?\s*\**\s*([^\s*,.—–]+)(.*)", linea)
        if m:
            ident, resto = m.group(1).strip(), m.group(2)
            break
    if ident is None:
        return None
    if ident.lower().startswith("ninguna"):
        return "ninguna", resto.strip(" —-*"), ""
    for linea in lineas:
        if linea.lstrip().startswith("|"):
            celdas = [c.strip().strip("*").strip() for c in linea.strip().strip("|").split("|")]
            if len(celdas) >= 2 and celdas[0] == ident:
                return ident, celdas[1], linea + " " + resto
    return ident, resto.strip(" —-*"), resto


def tipo_de(fila: str):
    baja = fila.lower()
    for t in TIPOS:
        if re.search(t[1], baja):
            return t
    return None


def compuerta(proyecto: Path) -> str:
    pdp = proyecto / "PDP.md"
    nombre = proyecto.name
    if not pdp.exists():
        return "FASE ACTIVA de %s: no hay PDP.md. Sin PDP no hay fase ni criterio de salida (regla 3 de la estructura)." % nombre
    f = fase_abierta(pdp)
    if not f:
        return ("FASE ACTIVA de %s: el PDP no tiene la linea '**Fase en curso:** X'. Antes de trabajar: declarar "
                "la fase con su criterio de salida escrito (o que el proyecto esta cerrado)." % nombre)
    ident, titulo, fila = f
    if ident == "ninguna":
        return ("FASE ACTIVA de %s: NINGUNA (%s). Antes de trabajar en el proyecto hay que abrir una fase con su "
                "criterio de salida escrito en el PDP." % (nombre, titulo[:120]))
    t = tipo_de(fila)
    cab = "FASE ACTIVA de %s (leida del PDP): %s -- %s." % (nombre, ident, titulo)
    if not t:
        return (cab + " El PDP NO declara su tipo en el ciclo de vida (Pre-A, A, B diseno preliminar, C, D, E): "
                "sin tipo no se sabe que NO se hace en esta fase. Declararlo en la fila del PDP.")
    return (cab + "\n  TIPO      : %s\n  NASA      : %s\n  EN CRIOLLO: %s\n  PRODUCE   : %s\n  NO SE HACE: %s\n"
            "  LA CIERRA : %s\n"
            "  Antes de cada accion: ubicarla en ESTE tipo. Si es de una fase posterior, no se hace: se anota y "
            "se vuelve al entregable de la fase.\n"
            "  PARA EL CUADRO (copiar): Fase : %s -- NASA %s\n                          = %s. La cierra: <el "
            "resultado del PDP>" % (t[0], t[5], t[6], t[2], t[3], t[4], ident, t[5], t[6]))


PATRON = re.compile(r"proyectos[/\\]+(ingenieria|documentos|seguimiento)[/\\]+([A-Za-z0-9_.-]+)")


def proyecto_del_evento(ev: dict):
    textos = [json.dumps(ev.get("tool_input", {}), ensure_ascii=False), str(ev.get("cwd", ""))]
    for t in textos:
        m = PATRON.search(t.replace("\\\\", "\\"))
        if m:
            p = RAIZ / "proyectos" / m.group(1) / m.group(2)
            if p.is_dir():
                return p
    return None


def hook() -> int:
    try:
        ev = json.loads(sys.stdin.read() or "{}")
        p = proyecto_del_evento(ev)
        if not p:
            return 0
        marca = Path(tempfile.gettempdir()) / "claude-fase-activa" / ("%s-%s" % (ev.get("session_id", "x"), p.name))
        if marca.exists():
            return 0
        texto = compuerta(p)
        marca.parent.mkdir(parents=True, exist_ok=True)
        marca.write_text(texto, encoding="utf-8")
        print(json.dumps({"hookSpecificOutput": {"hookEventName": ev.get("hook_event_name", "PostToolUse"),
                                                 "additionalContext": texto}}))
    except Exception:  # noqa: BLE001 -- falla abierto: solo informa
        return 0
    return 0


def autotest() -> int:
    mal = 0
    casos = [
        ("| **COOP-B** | **Proyecto coop, Fase B: diseño preliminar** | x | PDR | **abierta 2026-09-27** |", "Fase B"),
        ("| 0 | Pre-Fase A: estudio de conceptos | x | MCR | abierta |", "Pre-Fase A"),
        ("| 3 | Fase D: integración y prueba | x | y | abierta |", "Fase D"),
        ("| 3 | fase tres del apunte | x | y | abierta |", None),
    ]
    for fila, esperado in casos:
        t = tipo_de(fila)
        got = t[0].split(" (")[0] if t else None
        ok = got == esperado
        mal += not ok
        print("%s  %-60s -> %s" % ("ok " if ok else "MAL", fila[:60], got))
    # cada tipo trae su nombre NASA y su criollo (el cuadro los copia de aca, no de memoria)
    ok = all(len(t) == 7 and t[5].startswith(("Pre-Phase", "Phase")) and t[6] for t in TIPOS)
    mal += not ok
    print("%s  los %d tipos traen nombre NASA y criollo" % ("ok " if ok else "MAL", len(TIPOS)))
    # un PDP sintetico con la fase CONOCIDA: el caso exacto. (Hasta el 2026-10-02 este caso leia el PDP real de BLACK
    # y esperaba "Fase B" escrito aca; BLACK paso a la C y el autotest quedo en rojo sin que nadie lo corriera.)
    sint = Path(tempfile.mkdtemp(prefix="fase-activa-autotest-"))
    (sint / "PDP.md").write_text("| # | Fase | Cierra | Estado |\n|---|---|---|---|\n"
                                 "| **COOP-B** | **Proyecto coop, Fase B: diseño preliminar** | PDR | **abierta** |\n\n"
                                 "**Fase en curso:** COOP-B\n", encoding="utf-8")
    txt = compuerta(sint)
    __import__("shutil").rmtree(sint, ignore_errors=True)
    ok = "Fase B (diseno preliminar)" in txt and "NO SE HACE" in txt and 'NASA Phase B, "Preliminary Design' in txt
    mal += not ok
    print("%s  PDP sintetico en Fase B -> %s" % ("ok " if ok else "MAL", txt.splitlines()[0][:100]))
    # el de BLACK real: la ESTRUCTURA, no la fase (la fase cambia; que se tipe y traiga el nombre NASA, no)
    txt = compuerta(RAIZ / "proyectos" / "ingenieria" / "black")
    ok = "TIPO      :" in txt and "NO SE HACE" in txt and "NASA Phase" in txt
    mal += not ok
    print("%s  BLACK real se tipa y trae NASA -> %s" % ("ok " if ok else "MAL", txt.splitlines()[0][:100]))
    # el hook: evento con una ruta de BLACK emite; sin proyecto, calla
    ev = {"session_id": "autotest-%d" % os.getpid(), "hook_event_name": "PostToolUse",
          "tool_input": {"file_path": str(RAIZ / "proyectos" / "ingenieria" / "black" / "PDP.md")}}
    ok = proyecto_del_evento(ev) is not None and proyecto_del_evento({"tool_input": {"file_path": "C:/x/y.txt"}}) is None
    mal += not ok
    print("%s  hook: detecta la ruta del proyecto y calla fuera de proyectos/" % ("ok " if ok else "MAL"))
    # de punta a punta, como lo corre Claude Code: la 1.a vez inyecta, la 2.a (misma sesion) calla
    import subprocess
    salidas = [subprocess.run([sys.executable, __file__], input=json.dumps(ev), capture_output=True, text=True).stdout
               for _ in range(2)]
    ok = "additionalContext" in salidas[0] and "FASE ACTIVA de black" in salidas[0] and salidas[1].strip() == ""
    mal += not ok
    print("%s  hook de punta a punta: inyecta una vez y despues calla" % ("ok " if ok else "MAL"))
    print("autotest: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--autotest":
        sys.exit(autotest())
    if len(sys.argv) > 1:
        print(compuerta(Path(sys.argv[1]).resolve()))
        sys.exit(0)
    sys.exit(hook())
