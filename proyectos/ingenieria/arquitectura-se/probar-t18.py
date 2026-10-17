#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""probar-t18.py -- el saboteador de T18, «el método también retira» (docs/t18-el-metodo-retira.md).

El autotest de retiro.py sano en verde (L2-RET-01..10, L2-NUC-01..03, sobre un perfil sintético con el chequeo real,
git de verdad y transcripts armados como los del harness), y cada mutante visto en rojo EN SU CASO: un mutante sólo
se juzga si su caso pasó sano en la misma corrida; si no, NO JUZGABLE y cuenta como MAL. Los mutantes son copias en
temporal de retiro.py y nucleo-chequeo.py juntos (retiro.py importa el generador de su propia carpeta).

Mutante equivalente, declarado: sacar el piso de sesiones auditadas de la pasada no cambia nada, porque una viñeta
vence con 20 auditadas sin uso y con menos de 20 leídas ninguna puede llegar. El piso queda por el mensaje.

Uso: python proyectos/ingenieria/arquitectura-se/probar-t18.py      (sale 0 si todo discrimina)
"""
from __future__ import annotations

import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
HERR = RAIZ / "perfil-global" / "herramientas"
TMP = Path(tempfile.mkdtemp(prefix="probar-t18-"))
mal = 0


def caso(nombre, ok, detalle=""):
    global mal
    mal += not ok
    print("%s  %-78s %s" % ("ok " if ok else "MAL", nombre, "" if ok else "-> " + str(detalle).replace("\n", " | ")[:200]))
    return ok


def autotest(carpeta: Path):
    r = subprocess.run([sys.executable, str(carpeta / "retiro.py"), "autotest"], capture_output=True, text=True,
                       encoding="utf-8", errors="replace")
    return r.returncode, r.stdout + r.stderr


rc, s = autotest(HERR)
sanos = [l[5:] for l in s.splitlines() if l.startswith("ok ")]
caso("SANO: el autotest de retiro.py da BIEN (%d casos)" % len(sanos), rc == 0 and "autotest: BIEN" in s, s[-300:])

MUTANTES = (
    # (marca del caso que lo tiene que ver, archivo, texto sano, texto mutado)
    ("L2-RET-02", "retiro.py", "elegidas = [] if motivo else venc[:TOPE]", "elegidas = [] if motivo else venc"),
    ("L2-RET-03", "retiro.py", "key=lambda f: (-f['sin_uso'], f['ultimo_uso'] or 0,",
     "key=lambda f: (f['sin_uso'], f['ultimo_uso'] or 0,"),
    ("L2-RET-05", "retiro.py", "vueltas = [f for f in m['filas'] if f['vuelta']]", "vueltas = []"),
    ("L2-RET-07", "retiro.py", "if venc and m['ultima_pasada'] < ult_aud:", "if False:"),
    ("L2-RET-08 una retirada", "retiro.py", "        if f['vuelta']:\n            print('ROJO: vuelta pendiente",
     "        if False:\n            print('ROJO: vuelta pendiente"),
    ("L2-RET-08 recurrencia", "retiro.py", "for c, ts in recurrencias(perfil, vins).items():",
     "for c, ts in {}.items():"),
    ("L2-RET-09", "retiro.py", "def ciego(m):\n", "def ciego(m):\n    return ''\n"),
    ("L2-RET-11", "retiro.py", "    for k, e in arch.items():\n",
     "    for k, e in [x for x in arch.items() if Path(x[0]).exists()]:\n"),
    ("Read del nucleo", "retiro.py", "if 'chequeo-nucleo' in entradas.get(b.get('tool_use_id'), ''):", "if False:"),
    ("L2-RET-04", "nucleo-chequeo.py", "LARGO_CLAVE = 40", "LARGO_CLAVE = 58"),
    ("L2-NUC-01", "nucleo-chequeo.py", "vs = [v for v in vinetas if clave(v) not in fuera]", "vs = list(vinetas)"),
    ("L2-NUC-03", "nucleo-chequeo.py", "raise ValueError('%s linea %d ilegible: %s' % (ruta, n, e))", "continue"),
)

for marca, archivo, viejo, nuevo in MUTANTES:
    if not any(marca in x for x in sanos):
        caso("MUTANTE %s: NO JUZGABLE (su caso no paso sano)" % marca, False)
        continue
    dest = TMP / marca.replace(" ", "_").replace("/", "-")
    dest.mkdir(parents=True)
    for f in ("retiro.py", "nucleo-chequeo.py"):
        shutil.copy(str(HERR / f), str(dest / f))
    txt = (dest / archivo).read_text(encoding="utf-8")
    if viejo not in txt:
        caso("MUTANTE %s: NO APLICA (el texto de %s cambio)" % (marca, archivo), False)
        continue
    (dest / archivo).write_text(txt.replace(viejo, nuevo, 1), encoding="utf-8")
    rc, s = autotest(dest)
    vistos = [l for l in s.splitlines() if l.startswith("MAL") and marca in l]
    caso("MUTANTE %s (%s) -> lo ve su caso" % (marca, archivo), rc == 1 and bool(vistos), s[-300:])

shutil.rmtree(str(TMP), ignore_errors=True)
print("probar-t18: %s" % ("BIEN" if not mal else "%d MAL" % mal))
sys.exit(1 if mal else 0)
