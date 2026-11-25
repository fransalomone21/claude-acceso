"""Arma datos/catalogo.json: todo lo que la tienda puede ofrecer, con la version exacta de cada archivo.

Fuentes:
  1. la base: los jars de una instancia de Prism (Better MC 5, sin Serene Seasons) se identifican por SHA-1
     contra Modrinth, asi la version queda fijada exactamente a la que ya se probo;
  2. los extras de datos/curado.json ("extras": mods, shaders, resource packs): la ultima version estable
     para 1.21.1 + NeoForge (o Iris / resourcepack), con sus dependencias obligatorias.

  python catalogar.py --base "<carpeta mods de la instancia>"   (lee, no escribe en la instancia)
  python catalogar.py                                           (solo re-resuelve los extras)
"""
import argparse, glob, hashlib, json, os, sys

import modrinth as M

AQUI = os.path.dirname(os.path.abspath(__file__))
DATOS = os.path.join(AQUI, "datos")
CAT = os.path.join(DATOS, "catalogo.json")
CURADO = os.path.join(DATOS, "curado.json")

LOADERS_TIPO = {"mod": (M.CARGADOR,), "shader": ("iris",), "resourcepack": None}


def archivo_principal(v):
    fs = v["files"]
    return next((f for f in fs if f.get("primary")), fs[0])


def lado(proj):
    c, s = proj.get("client_side"), proj.get("server_side")
    if s == "unsupported":
        return "client"
    if c == "unsupported":
        return "server"
    return "both"


def registrar(cat, proj, v, tipo, origen):
    slug = proj["slug"]
    f = archivo_principal(v)
    cat["proyectos"][slug] = {
        "id": proj["id"], "titulo": proj["title"], "desc_en": proj["description"], "icono": proj.get("icon_url"),
        "cliente": proj.get("client_side"), "servidor": proj.get("server_side"), "lado": lado(proj),
        "categorias": proj.get("categories", []) + proj.get("additional_categories", []), "tipo": tipo,
        "descargas": proj.get("downloads", 0), "origen": origen}
    cat["versiones"][slug] = {
        "version_id": v["id"], "version": v["version_number"], "archivo": f["filename"], "url": f["url"],
        "sha1": f["hashes"]["sha1"], "sha512": f["hashes"]["sha512"], "bytes": f["size"],
        "deps": [d["project_id"] for d in v.get("dependencies", []) if d["dependency_type"] == "required" and d.get("project_id")]}


def main():
    a = argparse.ArgumentParser()
    a.add_argument("--base")
    o = a.parse_args()
    os.makedirs(DATOS, exist_ok=True)
    cat = json.load(open(CAT, encoding="utf-8-sig")) if os.path.exists(CAT) else {"proyectos": {}, "versiones": {}, "base": []}
    por_id = {p["id"]: s for s, p in cat["proyectos"].items()}
    curado = json.load(open(CURADO, encoding="utf-8-sig"))
    excluir_base = [x.lower() for x in curado.get("base_excluir", [])]

    if o.base:
        jars = sorted(glob.glob(os.path.join(o.base, "*.jar")))
        hs = {hashlib.sha1(open(j, "rb").read()).hexdigest(): j for j in jars}
        vs = versiones_ok = M.versiones_por_hash(list(hs))
        sin = [os.path.basename(j) for h, j in hs.items() if h not in vs]
        projs = {p["id"]: p for p in M.proyectos(sorted({v["project_id"] for v in vs.values()}))}
        cat["base"] = []
        for h, v in vs.items():
            p = projs.get(v["project_id"])
            if not p or any(x in os.path.basename(hs[h]).lower() for x in excluir_base):
                continue
            tipo = "mod"
            registrar(cat, p, v, tipo, "bmc5")
            cat["base"].append(p["slug"])
            por_id[p["id"]] = p["slug"]
        print(f"base: {len(jars)} jars, {len(cat['base'])} en el catalogo, sin identificar en Modrinth: {sin or 'ninguno'}")

    pendientes = []
    for item in curado.get("extras", []):
        slug, tipo = item["slug"], item.get("tipo", "mod")
        pendientes.append((slug, tipo))
    visto = set()
    faltan = []
    while pendientes:
        slug, tipo = pendientes.pop(0)
        if slug in visto:
            continue
        visto.add(slug)
        if slug in cat["proyectos"] and cat["proyectos"][slug].get("origen") == "bmc5":
            continue
        p = (M.proyectos([slug]) or [None])[0]
        if not p:
            faltan.append(slug + " (no existe)")
            continue
        v = M.mejor_version(p["id"], LOADERS_TIPO[tipo])
        if not v:
            faltan.append(slug + " (sin version 1.21.1 para el cargador)")
            continue
        registrar(cat, p, v, tipo, "extra" if slug in {i["slug"] for i in curado["extras"]} else "dependencia")
        por_id[p["id"]] = p["slug"]
        for d in cat["versiones"][p["slug"]]["deps"]:
            if d not in por_id:
                pendientes.append((d, "mod"))
    # las dependencias de la base que no son de la base
    for slug in list(cat["versiones"]):
        for d in cat["versiones"][slug]["deps"]:
            if d not in por_id:
                dp = (M.proyectos([d]) or [None])[0]
                if dp and dp["slug"] not in cat["proyectos"]:
                    v = M.mejor_version(dp["id"], LOADERS_TIPO["mod"])
                    if v:
                        registrar(cat, dp, v, "mod", "dependencia")
                        por_id[dp["id"]] = dp["slug"]
                    else:
                        faltan.append(dp["slug"] + " (dependencia de " + slug + ", sin version)")
    # slugs en deps: pasar ids a slugs
    for s, v in cat["versiones"].items():
        v["deps"] = [por_id.get(d, d) for d in v["deps"]]
    json.dump(cat, open(CAT, "w", encoding="utf-8"), indent=1, ensure_ascii=False)
    print(f"catalogo: {len(cat['proyectos'])} proyectos ({len(cat['base'])} de la base); no resueltos: {faltan or 'ninguno'}")
    return 1 if faltan else 0


if __name__ == "__main__":
    sys.exit(main())
