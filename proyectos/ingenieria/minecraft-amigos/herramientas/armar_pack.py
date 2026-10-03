"""Arma la instancia de la juntada: copia la base, suma mods de Modrinth con sus
dependencias, y escribe el manifiesto (que es cada jar, de donde vino, de que lado corre).

Uso:
  python armar_pack.py --origen <instancia base> --destino <instancia nueva> \
      --mc 1.21.4 --agregar agregar.txt --manifiesto pack-manifiesto.json

  agregar.txt: un slug de Modrinth por linea; '#' comenta.
  Si --destino ya existe NO se vuelve a copiar la base: solo se suman mods (idempotente).
"""
import argparse
import hashlib
import json
import shutil
import sys
import urllib.parse
import urllib.request
from pathlib import Path

API = "https://api.modrinth.com/v2"
UA = {"User-Agent": "fransalomone21/minecraft-amigos (setup juntada)",
      "Content-Type": "application/json"}
NO_COPIAR = {"saves", "logs", "crash-reports", "screenshots", ".cache", "debug",
             "command_history.txt", "servers.dat_old"}


def req(url, body=None):
    data = json.dumps(body).encode() if body is not None else None
    r = urllib.request.Request(url, data=data, headers=UA)
    with urllib.request.urlopen(r, timeout=60) as resp:
        return json.load(resp)


def sha1(p):
    h = hashlib.sha1()
    with open(p, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def ultima_version(pid, mc):
    q = urllib.parse.urlencode({"loaders": json.dumps(["fabric"]),
                                "game_versions": json.dumps([mc])})
    vs = req(f"{API}/project/{pid}/version?{q}")
    # preferir release; si no hay, lo mas nuevo
    rel = [v for v in vs if v["version_type"] == "release"]
    return (rel or vs or [None])[0]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--origen", required=True)
    ap.add_argument("--destino", required=True)
    ap.add_argument("--mc", required=True)
    ap.add_argument("--agregar", required=True)
    ap.add_argument("--manifiesto", required=True)
    a = ap.parse_args()

    origen, destino = Path(a.origen), Path(a.destino)
    if not destino.exists():
        shutil.copytree(origen, destino,
                        ignore=lambda d, names: [n for n in names if n in NO_COPIAR])
        print(f"[copia] {origen.name} -> {destino.name}")
    mods = destino / ".minecraft" / "mods"

    # 1. lo que ya hay: hash -> proyecto de Modrinth
    jars = {sha1(p): p for p in mods.glob("*.jar")}
    conocidos = req(f"{API}/version_files", {"hashes": list(jars), "algorithm": "sha1"})
    tengo = {}          # project_id -> nombre de archivo
    huerfanos = []      # jars que Modrinth no conoce
    for h, p in jars.items():
        if h in conocidos:
            tengo[conocidos[h]["project_id"]] = p.name
        else:
            huerfanos.append(p.name)
    origen_de = {pid: "base" for pid in tengo}

    # 2. lo pedido, con dependencias, en anchura
    pedidos = [l.split("#")[0].strip() for l in Path(a.agregar).read_text("utf-8").splitlines()]
    cola = [(s, "nuevo") for s in pedidos if s]
    faltan = []
    while cola:
        ident, motivo = cola.pop(0)
        v = ultima_version(ident, a.mc)
        if v is None:
            faltan.append(ident)
            continue
        pid = v["project_id"]
        if pid in tengo:
            continue
        f = next((x for x in v["files"] if x.get("primary")), v["files"][0])
        dst = mods / f["filename"]
        if not dst.exists():
            with urllib.request.urlopen(urllib.request.Request(f["url"], headers=UA), timeout=120) as r:
                dst.write_bytes(r.read())
        if sha1(dst) != f["hashes"]["sha1"]:
            dst.unlink()
            sys.exit(f"[ROJO] sha1 no coincide: {f['filename']}")
        tengo[pid] = f["filename"]
        origen_de[pid] = motivo
        print(f"[+] {f['filename']}  ({motivo})")
        for d in v["dependencies"]:
            if d["dependency_type"] == "required" and d.get("project_id") and d["project_id"] not in tengo:
                cola.append((d["project_id"], f"dependencia de {ident}"))

    # 3. de que lado corre cada uno
    proys = req(f"{API}/projects?" + urllib.parse.urlencode({"ids": json.dumps(list(tengo))}))
    filas = []
    for p in proys:
        filas.append({"slug": p["slug"], "titulo": p["title"], "archivo": tengo[p["id"]],
                      "cliente": p["client_side"], "servidor": p["server_side"],
                      "origen": origen_de[p["id"]]})
    for n in huerfanos:
        filas.append({"slug": None, "titulo": None, "archivo": n, "cliente": "?",
                      "servidor": "?", "origen": "base (no esta en Modrinth)"})
    filas.sort(key=lambda r: r["archivo"].lower())
    Path(a.manifiesto).write_text(json.dumps({"mc": a.mc, "mods": filas, "sin_version": faltan},
                                             indent=1, ensure_ascii=False), "utf-8")
    print(f"[ok] {len(filas)} jars; sin version {a.mc}: {faltan or 'ninguno'}; "
          f"no-Modrinth: {huerfanos or 'ninguno'}")


if __name__ == "__main__":
    main()
