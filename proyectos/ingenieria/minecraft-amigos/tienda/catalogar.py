"""Arma datos/catalogo.json: todo lo que la tienda puede ofrecer, con la version exacta de cada archivo.

Fuentes:
  1. la base: los jars de una instancia de Prism (Better MC 5, sin Serene Seasons) se identifican por SHA-1
     contra Modrinth, asi la version queda fijada exactamente a la que ya se probo;
  2. los extras de datos/curado.json ("extras": mods, shaders, resource packs): la ultima version estable
     para 1.21.1 + NeoForge (o Iris / resourcepack), con sus dependencias obligatorias.

  python catalogar.py --base "<carpeta mods de la instancia>"   (lee, no escribe en la instancia)
  python catalogar.py                                           (solo re-resuelve los extras)
"""
import argparse, glob, hashlib, json, os, re, sys

import modrinth as M

AQUI = os.path.dirname(os.path.abspath(__file__))
DATOS = os.path.join(AQUI, M.P["datos"])
CAT = os.path.join(DATOS, "catalogo.json")
CURADO = os.path.join(DATOS, "curado.json")

LOADERS_TIPO = {"mod": (M.CARGADOR,), "shader": ("iris",), "resourcepack": None}
# de donde sale la base: 1.21.1 de la instancia Better MC 5; 1.21.4 de la instancia "Nuevo 1.21.4" (el mundo con Agus)
ORIGEN_BASE = "bmc5" if M.CARGADOR == "neoforge" else "base"


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


# Nunca son fotos del mod: insignias, redes, donaciones, separadores. Los banners y logos SI pueden mostrarlo
# (medido 2026-11-25: los «banners» de Maple's Rabbits son fotos de los conejos): entran solo si no alcanza con lo demas.
NUNCA = re.compile(r"shields\.io|badge|discord|ko-?fi|patreon|bisecthosting|paypal|kinetic|button|"
                   r"curseforge\.com/images|/divider|separator", re.I)
SI_FALTA = re.compile(r"banner|logo|icon|header|title", re.I)


def galeria(proj, n=3):
    """Las fotos que el autor eligio para su pagina de Modrinth: la destacada primero, despues por su orden. Si la
    galeria tiene menos de 2, se completan con las imagenes de la descripcion de la pagina: primero las que no
    parecen banner ni logo, despues esas; las insignias y los links de donaciones nunca."""
    gs = sorted(proj.get("gallery") or [], key=lambda g: (not g.get("featured"), g.get("ordering", 0)))
    fotos = [g["url"] for g in gs if g.get("url")][:n]
    if len(fotos) < 2:
        cuerpo = proj.get("body") or ""
        urls = re.findall(r"!\[[^\]]*\]\((https?://[^)\s]+)", cuerpo) + re.findall(r"<img[^>]+src=[\"'](https?://[^\"']+)", cuerpo)
        urls = [u for u in urls if re.search(r"\.(png|jpe?g|webp|gif)(\?|$)", u, re.I) and not NUNCA.search(u)]
        # orden: lo que no parece banner antes, y las fotos antes que los gif (pesan)
        urls.sort(key=lambda u: (bool(SI_FALTA.search(u)), u.lower().split("?")[0].endswith(".gif")))
        fotos += [u for u in urls if u not in fotos][:n - len(fotos)]
    return fotos


def completar_galerias(cat):
    """Las fotos de cada proyecto del catalogo que todavia no tiene 2 (los de la base, los viejos y los que el filtro
    dejo cortos): se vuelven a pedir a Modrinth."""
    faltan = [p["id"] for p in cat["proyectos"].values() if len(p.get("galeria") or []) < 2]
    por_id = {p["id"]: s for s, p in cat["proyectos"].items()}
    for p in M.proyectos(faltan):
        s = por_id.get(p["id"])
        if s:
            cat["proyectos"][s]["galeria"] = galeria(p)
    return len(faltan)


def registrar(cat, proj, v, tipo, origen):
    slug = proj["slug"]
    f = archivo_principal(v)
    cat["proyectos"][slug] = {
        "id": proj["id"], "titulo": proj["title"], "desc_en": proj["description"], "icono": proj.get("icon_url"),
        "galeria": galeria(proj),
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
    a.add_argument("--ultimas", action="store_true")
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
            registrar(cat, p, v, tipo, ORIGEN_BASE)
            cat["base"].append(p["slug"])
            por_id[p["id"]] = p["slug"]
        print(f"base: {len(jars)} jars, {len(cat['base'])} en el catalogo, sin identificar en Modrinth: {sin or 'ninguno'}")

    pendientes = []
    for item in curado.get("extras", []):
        slug, tipo = item["slug"], item.get("tipo", "mod")
        pendientes.append((slug, tipo))
    for ds in curado.get("deps_faltan", {}).values():   # las que Modrinth no declara tambien van al catalogo
        pendientes += [(d, "mod") for d in ds]
    visto = set()
    faltan = []
    while pendientes:
        slug, tipo = pendientes.pop(0)
        if slug in visto:
            continue
        visto.add(slug)
        if slug in cat["proyectos"] and cat["proyectos"][slug].get("origen") == ORIGEN_BASE:
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
        print(f"  {p['slug']} {v['version_number']}", flush=True)
        for d in cat["versiones"][p["slug"]]["deps"]:
            if d not in por_id:
                pendientes.append((d, "mod"))
    # las dependencias de la base que no son de la base
    for slug in list(cat["versiones"]):
        for d in list(cat["versiones"][slug]["deps"]):
            if d not in por_id:
                dp = (M.proyectos([d]) or [None])[0]
                if dp and dp["slug"] not in cat["proyectos"]:
                    v = M.mejor_version(dp["id"], LOADERS_TIPO["mod"])
                    if v:
                        registrar(cat, dp, v, "mod", "dependencia")
                        por_id[dp["id"]] = dp["slug"]
                    elif cat["proyectos"][slug].get("origen") == ORIGEN_BASE:
                        # la base ya arranco y se jugo sin ese jar: viene adentro del mod (medido 2026-11-27: Mod Menu
                        # declara placeholder-api y lo trae adentro; el server de Agus lo muestra en .fabric/processedMods)
                        cat["versiones"][slug]["deps"].remove(d)
                        cat["versiones"][slug].setdefault("deps_adentro", []).append(dp["slug"])
                        print(f"  aviso: {dp['slug']} (de {slug}) sin version suelta: viene adentro del mod de la base")
                    else:
                        faltan.append(dp["slug"] + " (dependencia de " + slug + ", sin version)")
    # --ultimas: cada proyecto a su ultima version 1.21.1 + NeoForge (la de Better MC 5 queda en 'fijadas').
    # Medido el 2026-11-25: con las versiones de Better MC 5, Aquamirae y Mowzie's pedian una geckolib mas nueva
    # y el server de prueba no arrancaba.
    if o.ultimas:
        cat.setdefault("fijadas", {})
        mr = {p["slug"]: p for p in M.proyectos([v["id"] for v in cat["proyectos"].values()])}
        cola = list(cat["proyectos"])
        hechos = set()
        while cola:
            slug = cola.pop(0)
            if slug in hechos:
                continue
            hechos.add(slug)
            p = mr.get(slug) or (M.proyectos([slug]) or [None])[0]
            if not p:
                faltan.append(slug + " (no existe)")
                continue
            tipo = cat["proyectos"].get(p["slug"], {}).get("tipo", "mod")
            v = M.mejor_version(p["id"], LOADERS_TIPO[tipo])
            if not v:
                if p["slug"] not in cat["proyectos"]:
                    faltan.append(slug + " (dependencia sin version)")
                continue
            if p["slug"] in cat["versiones"] and p["slug"] not in cat["fijadas"]:
                cat["fijadas"][p["slug"]] = cat["versiones"][p["slug"]]
            origen = cat["proyectos"].get(p["slug"], {}).get("origen", "dependencia")
            registrar(cat, p, v, tipo, origen)
            por_id[p["id"]] = p["slug"]
            for d in cat["versiones"][p["slug"]]["deps"]:
                if d not in por_id and d not in hechos:
                    cola.append(d)
        print(f"ultimas: {len(hechos)} proyectos revisados")
    print(f"fotos: {completar_galerias(cat)} proyectos completados")
    # slugs en deps: pasar ids a slugs
    for s, v in cat["versiones"].items():
        v["deps"] = [por_id.get(d, d) for d in v["deps"]]
    json.dump(cat, open(CAT, "w", encoding="utf-8"), indent=1, ensure_ascii=False)
    print(f"catalogo: {len(cat['proyectos'])} proyectos ({len(cat['base'])} de la base); no resueltos: {faltan or 'ninguno'}")
    return 1 if faltan else 0


if __name__ == "__main__":
    sys.exit(main())
