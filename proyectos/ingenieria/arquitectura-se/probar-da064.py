#!/usr/bin/env python3
"""probar-da064.py -- el saboteador de DA-064: el libro llega al momento de escribir un alcance (2026-10-19).

El concepto 'alcance' de la puerta (.claude/cascada.json) exige la ficha, el SEH y la catedra cuando la sesion escribe
una seccion del alcance. Requisitos: L1-19, L2-PTA-20..23, L2-VER-04 y L2-CAS-03/04 de docs/10-requisitos.md §11. El
autotest de la puerta (caso 20) lo prueba sobre archivos sinteticos cruzando el hook; aca se prueba sobre el CATALOGO
REAL y los ARTEFACTOS REALES, que es donde un falso positivo o un hueco se notarian:

  (a) el informe real del TP de IISE: reescribir la frase de la necesidad (sin tocar su titulo) dispara 'alcance';
  (b) el PDP real de arquitectura-se: editar su seccion 1 (el problema) dispara 'alcance';
  (c) el documento de requisitos real: editar una necesidad N-xx dispara 'alcance' (ademas de 'requisitos');
  (d) CONTROL: editar el ESTADO_ACTUAL real no dispara 'alcance';
  (e) CONTROL: editar una fila L2 del documento de requisitos dispara 'requisitos' y NO 'alcance';
  (f) CONTROL: editar la seccion 4 del PDP real no dispara 'alcance';
  (v) --verificar sobre el catalogo real: verde; sobre uno con el patron de titulo roto: ROJO que nombra la seccion;
  (m) MUTANTE: el catalogo real sin 'secciones' tiene que hacer fallar (a), (b) y (c).

Un artefacto que no esta en esta maquina (el TP vive en un repo aparte) sale SALTEADO con su nombre, no verde.
Sale 0 si todo pasa y el mutante se ve; 1 si algo falla o el mutante pasa (la prueba esta ciega).
Uso:  python proyectos/ingenieria/arquitectura-se/probar-da064.py
"""
import copy
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(RAIZ / ".claude" / "hooks"))
import cascada_puerta as cp  # noqa: E402

ARQ = RAIZ / "proyectos" / "ingenieria" / "arquitectura-se"
TP = RAIZ / "proyectos" / "documentos" / "trabajo-final-iise" / "informe" / "seccion-1.md"


def linea_bajo(path: Path, titulo: str):
    """La primera linea de texto (no titulo, no vacia) debajo del titulo que matchea: se DERIVA del archivo."""
    lineas = path.read_text(encoding="utf-8").splitlines()
    for i, l in enumerate(lineas):
        if re.match(titulo, l):
            for x in lineas[i + 1:]:
                if x.strip() and not x.startswith("#"):
                    return x
    return None


def edit(path: Path, viejo):
    return {"file_path": str(path), "old_string": viejo, "new_string": viejo + " (editado)"}


def casos(cat):
    """[(nombre, inp o None si el artefacto no esta, espera 'alcance', concepto extra esperado)]"""
    req = ARQ / "docs" / "10-requisitos.md"
    n_fila = next((l for l in req.read_text(encoding="utf-8").splitlines() if l.startswith("| N-")), None)
    l2_fila = next((l for l in req.read_text(encoding="utf-8").splitlines() if l.startswith("| L2-")), None)
    tp = linea_bajo(TP, r"^#+\s+(\d+(\.\d+)*\.?\s+)?Necesidad") if TP.exists() else None
    return [
        ("(a) TP de IISE: la frase de la necesidad", edit(TP, tp) if tp else None, True, None),
        ("(b) PDP de arquitectura-se: seccion 1, el problema",
         edit(ARQ / "PDP.md", linea_bajo(ARQ / "PDP.md", r"^## 1\. ")), True, None),
        ("(c) requisitos: una necesidad N-xx", edit(req, n_fila), True, "requisitos"),
        ("(d) CONTROL: el ESTADO_ACTUAL", edit(ARQ / "ESTADO_ACTUAL.md",
                                               linea_bajo(ARQ / "ESTADO_ACTUAL.md", r"^# ")), False, None),
        ("(e) CONTROL: una fila L2 de requisitos", edit(req, l2_fila), False, "requisitos"),
        ("(f) CONTROL: la seccion 4 del PDP", edit(ARQ / "PDP.md", linea_bajo(ARQ / "PDP.md", r"^## 4\. ")), False,
         None)]


def correr_casos(cat, imprimir=True):
    mal, res = 0, {}
    for nombre, inp, espera, extra in casos(cat):
        if inp is None or not inp["old_string"]:
            print("SALTEADO  %s: el artefacto no esta en esta maquina" % nombre)
            res[nombre] = None
            continue
        cs = cp.conceptos_de(cat, "Edit", inp)
        ok = (("alcance" in cs) == espera) and (extra is None or extra in cs)
        res[nombre] = ok
        mal += not ok
        if imprimir:
            print("%s  %s -> %s" % ("ok " if ok else "MAL", nombre, ", ".join(cs) or "ningun concepto"))
    return mal, res


def verificar(cat) -> str:
    with tempfile.TemporaryDirectory(prefix="probar-da064-") as d:
        f = Path(d) / "cat.json"
        f.write_text(json.dumps(cat, ensure_ascii=False), encoding="utf-8")
        r = subprocess.run([sys.executable, str(RAIZ / ".claude" / "hooks" / "cascada_puerta.py"), "--verificar"],
                           capture_output=True, env=dict(os.environ, CASCADA_CATALOGO=str(f)))
        return r.stdout.decode("utf-8", "replace")


def main() -> int:
    cat = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    mal, res = correr_casos(cat)
    # (v) el verificador: el catalogo real sin rojos de patrones; uno con el titulo roto, ROJO que lo nombra
    sano = [l for l in verificar(cat).splitlines() if l.startswith("[FAIL]") and "regex" in l]
    roto = copy.deepcopy(cat)
    roto["conceptos"]["alcance"]["secciones"][0]["titulo"] = "(?i)^(necesidad"
    rojo = [l for l in verificar(roto).splitlines() if l.startswith("[FAIL]") and "secciones[0].titulo" in l]
    for nombre, ok in (("(v) CONTROL: --verificar sin regex rotas en el catalogo real", not sano),
                       ("(v) SABOTAJE: patron de titulo roto -> ROJO que nombra secciones[0].titulo", bool(rojo))):
        mal += not ok
        print("%s  %s" % ("ok " if ok else "MAL", nombre))
    # (m) el mutante: sin 'secciones' el concepto queda mudo; cada sabotaje que paso sano tiene que fallar
    mut = copy.deepcopy(cat)
    mut["conceptos"]["alcance"].pop("secciones", None)
    _, rm = correr_casos(mut, imprimir=False)
    juzgables = [n for n in rm if n[1] in "abc" and res.get(n)]
    visto = bool(juzgables) and all(rm[n] is False for n in juzgables)
    mal += not visto
    print("%s  (m) MUTANTE sin 'secciones': %s" % ("ok " if visto else "MAL", "falla en %s, lo ve" % ", ".join(
        n[:3] for n in juzgables) if visto else "PASA IGUAL o no hubo caso juzgable: ciega"))
    print("probar-da064: %s" % ("BIEN" if not mal else "%d MAL" % mal))
    return 1 if mal else 0


if __name__ == "__main__":
    sys.exit(main())
