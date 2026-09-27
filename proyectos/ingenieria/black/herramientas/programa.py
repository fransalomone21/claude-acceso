"""El programa BLACK: mapa de nivel 1, catalogo de conceptos y sus trazas.

    python herramientas/programa.py verificar   # sale 1 si una traza se corta
    python herramientas/programa.py catalogo    # regenera docs/12-catalogo.md
    python herramientas/programa.py resumen     # el mapa, para abrir sesion
    python herramientas/programa.py trade       # sale 2 si faltan los pesos de Fran

Fuentes: kb/subsistemas.json (PBS de nivel 1 con madurez K0-K7) y
kb/conceptos.json (NGOs, MOEs, funciones, criterios, conceptos).
docs/12-catalogo.md es DERIVADO: verificar lo regenera en memoria y sale en
rojo si el archivo no coincide. Un dato en dos lados diverge; uno derivado y
medido, no.

Por que 'trade' se niega sin pesos: los criterios de un trade study los fija
el interesado (NASA p. 46: elicit / validate / obtain commitments). Un ranking
con pesos inventados por la sesion es una opinion con formato de numero.
--raiz permite correrlo sobre una copia: lo usa pruebas/probar-programa.py.
"""
import argparse
import json
import sys
from pathlib import Path

COSTOS = {"S": "1-2 sesiones", "M": "3-6", "L": "7-15", "XL": "mas de 15"}
VEHICULOS = {"datos-iso", "pnach-datos", "pnach-codigo", "pine", "emulador", "externo"}
ESTADOS = {"candidato", "hecho", "descartado"}
CABECERA = ("<!-- GENERADO por herramientas/programa.py catalogo desde kb/conceptos.json "
            "y kb/subsistemas.json. NO SE EDITA A MANO: programa.py verificar lo compara. -->\n")


def cargar(raiz):
    s = json.load(open(raiz / "kb" / "subsistemas.json", encoding="utf-8"))
    c = json.load(open(raiz / "kb" / "conceptos.json", encoding="utf-8"))
    return s, c


def k_minima(concepto, subs):
    ks = [(subs[h]["k"], h) for h in concepto["habilitadores"] if h in subs]
    return min(ks) if ks else (None, None)


def catalogo_md(s, c):
    subs = {x["id"]: x for x in s["subsistemas"]}
    ngos = {n["id"]: n for n in c["ngos"]}
    lineas = [CABECERA, "# Catalogo de conceptos — Pre-Fase A del programa BLACK\n",
              "La columna **K min** es la madurez del habilitador MAS FLOJO (escala en "
              "`kb/subsistemas.json`): es el riesgo tecnico del concepto, calculado, no opinado.\n",
              "Costo: " + ", ".join(f"**{k}** {v}" for k, v in COSTOS.items()) + ".\n"]
    cats = []
    for x in c["conceptos"]:
        if x["cat"] not in cats:
            cats.append(x["cat"])
    for cat in cats:
        lineas.append(f"\n## {cat}\n")
        lineas.append("| id | concepto | que | NGO | costo | vehiculo | K min (cuello) | riesgo | estado |")
        lineas.append("|---|---|---|---|---|---|---|---|---|")
        for x in c["conceptos"]:
            if x["cat"] != cat:
                continue
            k, h = k_minima(x, subs)
            kk = f"K{k} ({h})" if k is not None else "—"
            ng = ", ".join(x["ngos"])
            lineas.append(f"| {x['id']} | {x['nombre']} | {x['que']} | {ng} | {x['costo']} | "
                          f"{x['vehiculo']} | {kk} | {x['riesgo']} | {x.get('estado', 'candidato')} |")
    lineas.append("\n## NGOs (borrador hasta la MCR)\n")
    for n in c["ngos"]:
        v = "validada" if n.get("validada") else "SIN VALIDAR"
        lineas.append(f"- **{n['id']}** {n['que']} — {n['fuente']} — *{v}*")
    return "\n".join(lineas) + "\n"


def verificar(raiz):
    s, c = cargar(raiz)
    rojos = []
    subs = {x["id"]: x for x in s["subsistemas"]}
    funcs = {f["id"] for f in c["funciones"]}
    ngos = {n["id"] for n in c["ngos"]}
    for x in s["subsistemas"]:
        k = x.get("k")
        if not isinstance(k, int) or not 0 <= k <= 7:
            rojos.append(f"subsistema {x['id']}: k fuera de 0-7")
            continue
        if k <= 1 and not x.get("sonda"):
            rojos.append(f"subsistema {x['id']}: K{k} sin la sonda que lo subiria")
        if k >= 2 and not x.get("evidencia"):
            rojos.append(f"subsistema {x['id']}: K{k} sin evidencia")
        for f in x.get("funciones", []):
            if f not in funcs:
                rojos.append(f"subsistema {x['id']}: funcion {f} inexistente")
    asignadas = {f for x in s["subsistemas"] for f in x.get("funciones", [])}
    for f in sorted(funcs - asignadas):
        rojos.append(f"funcion {f} sin ningun subsistema asignado (NASA p. 64: asignar cada funcion)")
    for x in c["conceptos"]:
        est = x.get("estado", "candidato")
        if est not in ESTADOS:
            rojos.append(f"concepto {x['id']}: estado {est} invalido")
        if x["costo"] not in COSTOS:
            rojos.append(f"concepto {x['id']}: costo {x['costo']} invalido")
        if x["vehiculo"] not in VEHICULOS:
            rojos.append(f"concepto {x['id']}: vehiculo {x['vehiculo']} invalido")
        if est == "descartado":
            if not x.get("riesgo"):
                rojos.append(f"concepto {x['id']}: descartado sin el motivo")
            continue
        if not x["ngos"]:
            rojos.append(f"concepto {x['id']}: no traza a ninguna NGO")
        for n in x["ngos"]:
            if n not in ngos:
                rojos.append(f"concepto {x['id']}: NGO {n} inexistente")
        for f in x["funciones"]:
            if f not in funcs:
                rojos.append(f"concepto {x['id']}: funcion {f} inexistente")
        for h in x["habilitadores"]:
            if h not in subs:
                rojos.append(f"concepto {x['id']}: habilitador {h} no esta en el mapa de nivel 1")
    p = c.get("pesos")
    if p is not None:
        if not (p.get("fuente") and p.get("fecha")):
            rojos.append("pesos sin fuente o sin fecha: los pone el interesado, con fecha")
        tot = sum(v for k, v in p.items() if k.startswith("C"))
        if tot != 100:
            rojos.append(f"pesos suman {tot}, no 100")
    doc = raiz / "docs" / "12-catalogo.md"
    esperado = catalogo_md(s, c)
    if not doc.exists() or doc.read_text(encoding="utf-8") != esperado:
        rojos.append("docs/12-catalogo.md no coincide con kb/: correr 'programa.py catalogo'")
    for r in rojos:
        print("[ROJO]", r)
    n = sum(1 for x in c["conceptos"] if x.get("estado", "candidato") != "descartado")
    print(f"{len(s['subsistemas'])} subsistemas, {n} conceptos vivos, {len(rojos)} rojos")
    return 1 if rojos else 0


def resumen(raiz):
    s, c = cargar(raiz)
    por_k = {}
    for x in s["subsistemas"]:
        por_k.setdefault(x["k"], []).append(x["id"])
    print("MAPA DE NIVEL 1 (kb/subsistemas.json) -- madurez del conocimiento, K0 a K7")
    for k in range(8):
        ids = por_k.get(k, [])
        if ids:
            print(f"  K{k}: {len(ids):>2}  {', '.join(ids)}")
    subs = {x["id"]: x for x in s["subsistemas"]}
    vivos = [x for x in c["conceptos"] if x.get("estado", "candidato") == "candidato"]
    frenados = [x["id"] for x in vivos if k_minima(x, subs)[0] is not None and k_minima(x, subs)[0] <= 1]
    print(f"  conceptos candidatos: {len(vivos)}; frenados por un habilitador en K0-K1: "
          f"{len(frenados)} ({', '.join(frenados)})")
    print("  pesos del trade study:", "PENDIENTES (los pone Fran)" if c.get("pesos") is None
          else f"de {c['pesos'].get('fuente')}")
    return 0


def trade(raiz):
    s, c = cargar(raiz)
    if c.get("pesos") is None:
        print("BLOQUEADO: no hay pesos del interesado en kb/conceptos.json.")
        print("Los criterios C1-C6 los pondera Fran (preguntas de docs/12-estudio-de-conceptos.md).")
        print("Un ranking con pesos inventados por la sesion es una opinion con formato de numero.")
        return 2
    print("pesos presentes; el puntaje por criterio se define en la MCR (todavia no implementado)")
    return 0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("accion", choices=["verificar", "catalogo", "resumen", "trade"])
    ap.add_argument("--raiz", default=str(Path(__file__).resolve().parent.parent))
    a = ap.parse_args()
    raiz = Path(a.raiz)
    if a.accion == "catalogo":
        s, c = cargar(raiz)
        (raiz / "docs" / "12-catalogo.md").write_text(catalogo_md(s, c), encoding="utf-8")
        print("escrito docs/12-catalogo.md")
        return 0
    return {"verificar": verificar, "resumen": resumen, "trade": trade}[a.accion](raiz)


if __name__ == "__main__":
    sys.exit(main())
