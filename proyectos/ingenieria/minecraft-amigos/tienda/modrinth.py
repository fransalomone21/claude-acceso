"""Cliente minimo de la API de Modrinth para la tienda: siempre con filtros de version y cargador
(nunca se baja la lista entera de versiones de un proyecto: se traba)."""
import json, re, time, urllib.parse, urllib.request

API = "https://api.modrinth.com/v2"
UA = {"User-Agent": "claude-acceso/minecraft-amigos (tienda de mods)", "Content-Type": "application/json"}
MC = "1.21.1"
CARGADOR = "neoforge"


def _pedir(url, datos=None, intentos=4):
    for i in range(intentos):
        try:
            req = urllib.request.Request(url, headers=UA, data=None if datos is None else json.dumps(datos).encode())
            with urllib.request.urlopen(req, timeout=60) as r:
                return json.load(r)
        except urllib.error.HTTPError as e:
            if e.code == 404:
                return None
            if e.code == 429:
                time.sleep(5 * (i + 1))
                continue
            if i == intentos - 1:
                raise
            time.sleep(2)
        except Exception:
            if i == intentos - 1:
                raise
            time.sleep(2)


def versiones_por_hash(hashes):
    """sha1 -> objeto version (project_id, files, dependencies...)."""
    out = {}
    for i in range(0, len(hashes), 200):
        out.update(_pedir(f"{API}/version_files", {"hashes": hashes[i:i + 200], "algorithm": "sha1"}) or {})
    return out


def proyectos(ids_o_slugs):
    out = []
    for i in range(0, len(ids_o_slugs), 80):
        lote = json.dumps(ids_o_slugs[i:i + 80])
        out += _pedir(f"{API}/projects?ids=" + urllib.parse.quote(lote)) or []
    return out


def mejor_version(proyecto, loaders=(CARGADOR,), mc=MC):
    """Ultima version estable (o la mas nueva si no hay) compatible con 1.21.1 + el cargador."""
    filtros = {"game_versions": json.dumps([mc])}
    if loaders:
        filtros["loaders"] = json.dumps(list(loaders))
    q = urllib.parse.urlencode(filtros)
    vs = _pedir(f"{API}/project/{proyecto}/version?{q}") or []
    # Modrinth a veces etiqueta 1.21.1 un archivo de otra version (medido 2026-11-25: Structory Towers
    # 'Structory_Towers_26.2_v1.0.17.jar' listado para 1.21.1 -> "not a valid mod file"). Si el nombre del
    # archivo nombra versiones de Minecraft y ninguna es la nuestra, se descarta.
    def nombra_otra(v):
        f = next((x for x in v["files"] if x.get("primary")), v["files"][0])["filename"]
        vers = re.findall(r"(?<![\d.])(1\.2\d(?:\.\d+)?|2[5-9]\.\d+(?:\.\d+)?)(?![\d])", f)
        return bool(vers) and not any(x in (mc, mc.rsplit(".", 1)[0]) for x in vers)
    vs = [v for v in vs if not nombra_otra(v)]
    vs.sort(key=lambda v: v["date_published"], reverse=True)
    for tipo in ("release", "beta", "alpha"):
        for v in vs:
            if v["version_type"] == tipo:
                return v
    return None


def version(id_version):
    return _pedir(f"{API}/version/{id_version}")


def buscar(texto, tipo="mod", loader=CARGADOR, n=6):
    fac = [[f"versions:{MC}"], [f"project_type:{tipo}"]]
    if loader:
        fac.append([f"categories:{loader}"])
    q = urllib.parse.urlencode({"query": texto, "facets": json.dumps(fac), "limit": n, "index": "relevance"})
    return (_pedir(f"{API}/search?{q}") or {}).get("hits", [])
