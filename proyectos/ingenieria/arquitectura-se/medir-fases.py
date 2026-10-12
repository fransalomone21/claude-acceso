#!/usr/bin/env python3
"""medir-fases.py -- ¿la arquitectura NASA se ejecuta por la FASE, o depende de un campo opcional?

Para cada proyecto del catalogo (.claude/cascada.json): el TIPO de su fase abierta, leido del PDP con las mismas
funciones que usa la compuerta (.claude/hooks/fase_activa.py), contra si el proyecto declara su documento de
requisitos y si ese documento existe. Nacio del insumo docs/insumo-2026-10-12-nasa-por-etiqueta.md (Fran: «no puede
ser que llevemos tantas sesiones usando NASA y no haya requerimientos definidos»).

Sale 1 si hay proyectos en Fase A-D sin requisitos declarados (es el rojo que T13 va a llevar al verificador), 0 si
no hay ninguno, y 2 si el instrumento revento en algun proyecto (tres resultados, no dos).

Control positivo: telescopio declara docs/10-requisitos.md y tiene que salir 'declara / existe'. La primera version
de este script daba '0 expuestos' porque le pasaba una tupla a tipo_de() y cada proyecto revento: un cero que acusa
al instrumento. Por eso cuenta los reventados aparte.

Uso:  python medir-fases.py          (desde cualquier carpeta)
"""
import json
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(RAIZ / ".claude" / "hooks"))
import fase_activa  # noqa: E402

FASES_CON_REQUISITOS = ("Fase A", "Fase B", "Fase C", "Fase D")


def medir():
    cat = json.loads((RAIZ / ".claude" / "cascada.json").read_text(encoding="utf-8"))
    filas = []
    for nombre, ent in sorted(cat["proyectos"].items()):
        hallados = [p for p in (RAIZ / "proyectos").glob("*/" + nombre) if p.is_dir()]
        tipo, req, existe = "(sin carpeta)", ent.get("requisitos"), None
        if hallados:
            proy = hallados[0]
            pdp = proy / "PDP.md"
            if not pdp.exists():
                tipo = "(sin PDP)"
            else:
                try:
                    f = fase_activa.fase_abierta(pdp)  # (id, titulo, texto para tipar) | None
                    if not f:
                        tipo = "(PDP sin 'Fase en curso')"
                    elif f[0] == "ninguna":
                        tipo = "(ninguna abierta)"
                    else:
                        t = fase_activa.tipo_de(f[2])
                        tipo = "%s: %s" % (f[0], t[0] if t else "(sin tipo)")
                except Exception as e:
                    tipo = "(REVENTO %s)" % e
            existe = (proy / req).exists() if req else None
        filas.append({"proyecto": nombre, "fase": tipo, "requisitos": req, "existe": existe})
    return filas


def main():
    filas = medir()
    for f in filas:
        decl = "declara" if f["requisitos"] else "NO declara"
        ex = "-" if f["requisitos"] is None else ("existe" if f["existe"] else "FALTA")
        print("  %-22s %-50s %-11s %s" % (f["proyecto"], f["fase"][:50], decl, ex))
    expuestos = [f["proyecto"] for f in filas
                 if any((": " + x) in f["fase"] for x in FASES_CON_REQUISITOS) and not f["requisitos"]]
    faltan = [f["proyecto"] for f in filas if f["requisitos"] and not f["existe"]]
    sin_tipo = [f["proyecto"] for f in filas if "(sin tipo)" in f["fase"]]
    reventados = [f["proyecto"] for f in filas if "REVENTO" in f["fase"]]
    print()
    print("  en Fase A-D SIN requisitos declarados: %d -> %s" % (len(expuestos), ", ".join(expuestos) or "ninguno"))
    print("  requisitos declarados que NO existen  : %d -> %s" % (len(faltan), ", ".join(faltan) or "ninguno"))
    print("  fase abierta SIN tipo NASA            : %d -> %s" % (len(sin_tipo), ", ".join(sin_tipo) or "ninguno"))
    print("  reventados (el instrumento, no el mundo): %d" % len(reventados))
    control = next((f for f in filas if f["proyecto"] == "telescopio"), None)
    control_ok = bool(control and control["requisitos"] and control["existe"] and "Fase" in control["fase"])
    print("  control positivo (telescopio declara, existe y tiene fase tipada): %s" % ("OK" if control_ok else "FALLA"))
    if reventados or not control_ok:
        return 2
    return 1 if (expuestos or faltan) else 0


if __name__ == "__main__":
    sys.exit(main())
