"""Saboteador de T19, piezas D y E: cada requisito con mutante (L2-AUD-04..12, L2-USO-01..07), visto en SU caso.

Los casos viven en los autotests de auditar-sesion.py (P12, P13, la muestra) y de uso-lecturas.py (el lazo). Este
script muta una linea por vez, en una copia AL LADO del original (la auditoria importa la puerta por la raiz), y exige
que el caso de ese requisito pase con el original y caiga con el mutante. Tres resultados por caso: ok, MAL y FALTA
(el autotest revento o el caso no corrio). Un mutante cuyo caso ya fallaba sano es NO JUZGABLE y cuenta como MAL.
Diseno: docs/t19-arbol-de-conocimiento.md sec. 8-9; requisitos: docs/10-requisitos.md sec. 13.

    python proyectos/ingenieria/arquitectura-se/probar-t19de.py      sale 0 si cada mutante cae en su caso
"""
import os
import subprocess
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
AUD = RAIZ / "auditar-sesion.py"
USO = RAIZ / "uso-lecturas.py"
PUERTA = RAIZ / ".claude" / "hooks" / "cascada_puerta.py"
# (script, requisito, caso del autotest, texto original, texto mutado)
MUTANTES = (
    (AUD, "L2-AUD-04", "E: sin declaracion de contraste",
     'return R("P12", q, "ROJO", "declarado", ["sin declaracion de contraste',
     'return R("P12", q, "VERDE", "declarado", ["sin declaracion de contraste'),
    (AUD, "L2-AUD-05", "E: un resultado que no es produce",
     'RESULTADOS = ("produce", "corregido", "preguntado")', 'RESULTADOS = ("",)'),
    (AUD, "L2-AUD-06", "E: un procedimiento repetido sin contraste", "REPETIDO = 3 ", "REPETIDO = 10 ** 6 "),
    (AUD, "L2-AUD-06 (lo negado no corrio)", "E: cuenta lo que CORRIO",
     'or e.get("v") != "pasa":\n            continue\n        cmd = e.get("obj", "")',
     ':\n            continue\n        cmd = e.get("obj", "")'),
    (AUD, "L2-AUD-09", "D: sin declaracion de uso",
     'return R("P13", q, "ROJO", "declarado", "sin declaracion de uso',
     'return R("P13", q, "VERDE", "declarado", "sin declaracion de uso'),
    (AUD, "L2-AUD-10", "D: declaracion sin la decision",
     'malas = [u for u in llenas if "|" not in u', 'malas = [u for u in [] if "|" not in u'),
    (AUD, "L2-AUD-11", "D: un archivo que no es exigido",
     "            if not hits:\n                fuera.append", "            if False:\n                fuera.append"),
    (AUD, "L2-AUD-12", "D: la muestra se escribe una vez",
     'if json.loads(l).get("sesion") == a["sesion"]:', "if False:"),
    # DA-078 (L2-AUD-13): la auditoria usa la funcion de la puerta. El mutante va en la PUERTA (sin los temas de la
    # sesion) y lo tienen que ver los casos de la auditoria, en P4 y en P13: si la auditoria calculara por su cuenta, no.
    (PUERTA, "L2-AUD-13 (P4)", "P4 con el tema declarado",
     '    temas = st["temas"].get(proyecto)\n', "    temas = None\n"),
    (PUERTA, "L2-AUD-13 (P13)", "D: sobre el catalogo real",
     '    temas = st["temas"].get(proyecto)\n', "    temas = None\n"),
    (USO, "L2-USO-01", "USO-01: b.md exigida", "            if sin >= ventana:", "            if sin > 10 ** 6:"),
    (USO, "L2-USO-05", "USO-05: un 'no' de Fran calla", '                if m["fecha"] <= desde:', "                if False:"),
    (USO, "L2-USO-04", "USO-04: sin las palabras de Fran", "    if not fran.strip():", "    if False:"),
    (USO, "L2-USO-06", "USO-06: una muestra posterior",
     '        if d["veredicto"] != "si":\n            continue', "        if True:\n            continue"),
    (USO, "L2-USO-07", "USO-07: un renglon ilegible",
     '            err.append("%s:%d ilegible (%s)" % (f.name, n, e))', "            pass"),
)


def casos(script: Path, puerta: Path | None = None) -> dict:
    """{linea del caso: 'ok' | 'MAL'} del autotest; vacio si revento antes de imprimir. Con puerta, la auditoria la
    carga en lugar de la instalada (CASCADA_PUERTA; CASCADA_RAIZ porque el mutante no vive en .claude/hooks)."""
    env = dict(os.environ, CASCADA_PUERTA=str(puerta), CASCADA_RAIZ=str(RAIZ)) if puerta else None
    r = subprocess.run([sys.executable, str(script), "--autotest"], capture_output=True, cwd=str(RAIZ), env=env)
    out = {}
    for l in r.stdout.decode("utf-8", "replace").splitlines():
        if l[:3] in ("ok ", "MAL"):
            out[l[5:].strip()] = l[:3].strip()
    return out


def de(res: dict, caso: str) -> str:
    v = [x for k, x in res.items() if k.startswith(caso)]
    return v[0] if len(v) == 1 else "FALTA"


def main() -> int:
    mal = 0
    sanos = {AUD: casos(AUD), USO: casos(USO)}
    for s, r in sanos.items():
        print("%s  original %s: %d casos, %d MAL" % ("ok " if r and "MAL" not in r.values() else "MAL", s.name, len(r),
                                                     sum(v == "MAL" for v in r.values())))
        mal += not r or "MAL" in r.values()
    # DA-078: la clase, no el caso -- la auditoria no arma ninguna llamada propia a exigido() (inspeccion, L2-AUD-13)
    propias = AUD.read_text(encoding="utf-8").count("g.exigido(")
    print("%s  %-34s %s" % ("ok " if propias == 0 else "MAL", "L2-AUD-13 (inspeccion)",
                            "la auditoria usa solo exigido_de_sesion()" if propias == 0
                            else "%d llamada(s) propia(s) a g.exigido()" % propias))
    mal += propias != 0
    for n, (script, req, caso, viejo, nuevo) in enumerate(MUTANTES):
        sano = de(sanos[AUD if script == PUERTA else script], caso)
        fuente = script.read_text(encoding="utf-8")
        if sano != "ok":
            print("MAL  %-34s NO JUZGABLE: su caso sano da %s" % (req, sano))
            mal += 1
            continue
        if fuente.count(viejo) != 1:
            print("MAL  %-34s NO APLICA: el texto a mutar aparece %d veces" % (req, fuente.count(viejo)))
            mal += 1
            continue
        m = RAIZ / ("_mutante_t19de_%d.py" % n)
        m.write_text(fuente.replace(viejo, nuevo, 1), encoding="utf-8")
        try:
            v = de(casos(AUD, m) if script == PUERTA else casos(m), caso)
        finally:
            m.unlink()
        print("%s  %-34s %s  (caso '%s')" % ("ok " if v == "MAL" else "MAL", req,
                                             "lo ve" if v == "MAL" else "NO lo ve: %s" % v, caso))
        mal += v != "MAL"
    print("probar-t19de: %s (%d mutantes)" % ("BIEN" if not mal else "%d MAL" % mal, len(MUTANTES)))
    return 1 if mal else 0


if __name__ == "__main__":
    sys.exit(main())
