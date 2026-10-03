"""Consulta Modrinth: que slugs tienen version Fabric para una version de MC.

Uso:
  python modrinth_check.py 1.21.4 slug1 slug2 ...            -> resumen por pantalla
  python modrinth_check.py 1.21.4 --json salida.json slug... -> ademas, JSON con url/sha1/deps
"""
import json
import sys
import urllib.parse
import urllib.request

API = "https://api.modrinth.com/v2"
UA = {"User-Agent": "fransalomone21/minecraft-amigos (setup juntada)"}


def get(url):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def latest(slug, mc):
    q = urllib.parse.urlencode({"loaders": json.dumps(["fabric"]),
                                "game_versions": json.dumps([mc])})
    try:
        vs = get(f"{API}/project/{slug}/version?{q}")
    except Exception as e:  # 404 = el slug no existe
        return {"slug": slug, "error": str(e)}
    if not vs:
        return {"slug": slug, "ok": False}
    v = vs[0]
    f = next((x for x in v["files"] if x.get("primary")), v["files"][0])
    deps = [d["project_id"] for d in v["dependencies"]
            if d["dependency_type"] == "required" and d.get("project_id")]
    return {"slug": slug, "ok": True, "version": v["version_number"],
            "type": v["version_type"], "file": f["filename"], "url": f["url"],
            "sha1": f["hashes"]["sha1"], "deps": deps, "project_id": v["project_id"]}


def main():
    args = sys.argv[1:]
    mc = args.pop(0)
    out = None
    if args and args[0] == "--json":
        out = args[1]
        args = args[2:]
    res = [latest(s, mc) for s in args]
    for x in res:
        if x.get("ok"):
            print(f"OK   {x['slug']:34} {x['version']:28} {x['type']:8} deps={len(x['deps'])}")
        elif "error" in x:
            print(f"ERR  {x['slug']:34} {x['error'][:50]}")
        else:
            print(f"NO   {x['slug']:34} sin version fabric {mc}")
    if out:
        with open(out, "w", encoding="utf-8") as fh:
            json.dump(res, fh, indent=1)


if __name__ == "__main__":
    main()
