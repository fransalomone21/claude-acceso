"""El vigia: lo NUEVO alrededor de BLACK, al entrar al proyecto (DA-091, sesion 132).

Dos ports a PC salieron el 2026-10-14/15 y el proyecto se entero el 30, por casualidad. Nada miraba afuera durante
el proyecto: el contexto se busco una vez, al abrir el concepto, y despues envejecio en silencio. Esto vuelve a
mirar las consultas guardadas en kb/vigia.json (GitHub por nombre y por tema, los issues y releases de los dos
ports, archive.org, Hidden Palace) e imprime SOLO lo que no se habia visto. Lo nuevo queda tambien en
docs/vigia-novedades.md, con fecha, para que no se pierda si la sesion no lo lee.

    python herramientas/vigia.py aviso         # lo corre abrir-sesion.ps1: mira si pasaron cada_dias dias
    python herramientas/vigia.py mirar         # mira ya, sin esperar
    python herramientas/vigia.py base          # la primera vez: marca todo lo de hoy como visto, sin imprimirlo
    python herramientas/vigia.py --autotest    # saboteador: un repo nuevo simulado TIENE que salir

Una consulta que no se pudo hacer (sin red, limite de la API) sale como 'SIN MIRAR', nunca como 'nada nuevo'.
Salida: 0 en aviso/mirar (no frena la apertura); el autotest sale 0 verde, 1 rojo, 3 revento.
"""
from __future__ import annotations

import datetime as dt
import hashlib
import json
import re
import sys
import urllib.parse
import urllib.request
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
KB = RAIZ / "kb" / "vigia.json"
NOVEDADES = RAIZ / "docs" / "vigia-novedades.md"
UA = {"User-Agent": "claude-acceso-black-vigia", "Accept": "application/vnd.github+json"}


def http_json(url: str):
    with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=12) as r:
        return json.loads(r.read().decode("utf-8"))


def http_texto(url: str) -> str:
    with urllib.request.urlopen(urllib.request.Request(url, headers={"User-Agent": UA["User-Agent"]}),
                                timeout=12) as r:
        return r.read().decode("utf-8", "replace")


def items_de(c: dict, traer_json=http_json, traer_texto=http_texto) -> dict[str, str]:
    """{id estable: linea legible} de una consulta."""
    t = c["tipo"]
    if t == "github-repos":
        u = "https://api.github.com/search/repositories?per_page=50&q=" + urllib.parse.quote(c["q"])
        return {i["full_name"]: f"{i['full_name']} -- {(i.get('description') or '')[:90]} ({i['html_url']})"
                for i in traer_json(u).get("items", [])}
    if t == "github-issues":
        u = f"https://api.github.com/repos/{c['repo']}/issues?state=all&per_page=50"
        return {i["html_url"]: f"{c['repo']} #{i['number']}: {i['title'][:100]} ({i['html_url']})"
                for i in traer_json(u)}
    if t == "github-releases":
        u = f"https://api.github.com/repos/{c['repo']}/releases?per_page=20"
        return {i["html_url"]: f"{c['repo']} release {i.get('tag_name')}: {(i.get('name') or '')[:80]} ({i['html_url']})"
                for i in traer_json(u)}
    if t == "archive":
        u = ("https://archive.org/advancedsearch.php?fl[]=identifier&fl[]=title&rows=100&output=json&q="
             + urllib.parse.quote(c["q"]))
        docs = traer_json(u).get("response", {}).get("docs", [])
        return {d["identifier"]: f"archive.org {d['identifier']}: {str(d.get('title'))[:90]}" for d in docs}
    if t == "pagina":
        html = traer_texto(c["url"])
        enlaces = sorted(set(m for m in re.findall(r'href="([^"]+)"', html) if re.search(c["patron"], m)))
        h = hashlib.sha1("\n".join(enlaces).encode()).hexdigest()[:12]
        return {f"huella:{h}": f"{c['url']} cambio sus enlaces ({len(enlaces)} con '{c['patron']}', huella {h})"}
    raise ValueError(f"tipo desconocido {t}")


def mirar(datos: dict, imprimir=True, traer_json=http_json, traer_texto=http_texto):
    nuevos, sin_mirar = [], []
    vistos = datos.setdefault("vistos", {})
    for c in datos["consultas"]:
        try:
            items = items_de(c, traer_json, traer_texto)
        except Exception as e:  # noqa: BLE001 -- una consulta caida se DICE, no se calla
            sin_mirar.append(f"{c['id']}: {type(e).__name__} {str(e)[:80]}")
            continue
        ya = set(vistos.get(c["id"], []))
        for k, linea in items.items():
            if k not in ya:
                nuevos.append((c["id"], linea))
        vistos[c["id"]] = sorted(ya | set(items))
    datos["ultima_mirada"] = dt.date.today().isoformat()
    if imprimir:
        n = len(datos["consultas"])
        print(f"vigia: {n - len(sin_mirar)} de {n} consultas miradas, {len(nuevos)} novedad(es)")
        for cid, linea in nuevos[:25]:
            print(f"  NUEVO [{cid}] {linea}")
        if len(nuevos) > 25:
            print(f"  ... y {len(nuevos) - 25} mas en docs/vigia-novedades.md")
        for s in sin_mirar:
            print(f"  SIN MIRAR {s}")
    return nuevos, sin_mirar


def anotar(nuevos):
    if not nuevos:
        return
    hoy = dt.date.today().isoformat()
    previo = NOVEDADES.read_text(encoding="utf-8") if NOVEDADES.exists() else (
        "# Lo que el vigia encontro nuevo (generado por herramientas/vigia.py; se lee, no se edita)\n")
    bloque = f"\n## {hoy}\n\n" + "".join(f"- [{cid}] {linea}\n" for cid, linea in nuevos)
    NOVEDADES.write_text(previo + bloque, encoding="utf-8")


def cargar():
    return json.loads(KB.read_text(encoding="utf-8"))


def guardar(datos):
    KB.write_text(json.dumps(datos, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def autotest() -> int:
    """El sabotaje: un repo nuevo simulado TIENE que salir; lo ya visto no; una consulta caida sale SIN MIRAR."""
    base = {"consultas": [{"id": "r", "tipo": "github-repos", "q": "x"},
                          {"id": "caida", "tipo": "github-issues", "repo": "a/b"}],
            "vistos": {"r": ["viejo/uno"]}}

    def falso(url):
        if "issues" in url:
            raise OSError("sin red (simulado)")
        return {"items": [{"full_name": "viejo/uno", "html_url": "u1", "description": ""},
                          {"full_name": "simulado/BLACK-coop-nuevo", "html_url": "u2", "description": "coop"}]}

    nuevos, sin = mirar(base, imprimir=False, traer_json=falso)
    ok1 = [n for _, n in nuevos] and all("simulado/BLACK-coop-nuevo" in n for _, n in nuevos) and len(nuevos) == 1
    ok2 = len(sin) == 1 and "caida" in sin[0]
    nuevos2, _ = mirar(base, imprimir=False, traer_json=falso)
    ok3 = not nuevos2
    print(f"sabotaje: el repo nuevo simulado sale y el visto no: {'OK' if ok1 else 'MAL'}")
    print(f"control: la consulta caida sale SIN MIRAR (no como 'nada nuevo'): {'OK' if ok2 else 'MAL'}")
    print(f"control: la segunda mirada no repite lo ya visto: {'OK' if ok3 else 'MAL'}")
    return 0 if ok1 and ok2 and ok3 else 1


def main(argv) -> int:
    cmd = argv[0] if argv else "aviso"
    if cmd == "--autotest":
        try:
            return autotest()
        except Exception as e:  # noqa: BLE001
            print(f"REVENTO: {type(e).__name__}: {e}")
            return 3
    if cmd == "ficha":
        for r in argv[1:]:
            try:
                d = http_json("https://api.github.com/repos/" + r)
                print(f"{r} | creado {d['created_at'][:10]} | push {d['pushed_at'][:10]} | "
                      f"{d['stargazers_count']} estrellas | fork={d['fork']} | {d.get('language')} | "
                      f"{(d.get('description') or '')[:150]}")
            except Exception as e:  # noqa: BLE001
                print(f"{r} | SIN MIRAR {type(e).__name__} {str(e)[:60]}")
        return 0
    datos = cargar()
    if cmd == "base":
        nuevos, sin = mirar(datos, imprimir=False)
        guardar(datos)
        # (132) la base NO se traga lo que trae: la primera mirada es el mapa del contexto, y se anota entero
        # para revisar (la primera version marco 282 items como vistos sin mostrarlos, entre ellos un coop de BLACK)
        anotar([(cid, "(linea base, sin revisar) " + linea) for cid, linea in nuevos])
        print(f"vigia: base puesta, {sum(len(v) for v in datos['vistos'].values())} items vistos, "
              f"anotados en docs/vigia-novedades.md para revisar; {len(sin)} consulta(s) SIN MIRAR")
        for s in sin:
            print(f"  SIN MIRAR {s}")
        return 0
    if cmd == "aviso":
        ult = datos.get("ultima_mirada")
        if ult and (dt.date.today() - dt.date.fromisoformat(ult)).days < datos.get("cada_dias", 3):
            print(f"vigia: ultima mirada {ult} (cada {datos.get('cada_dias', 3)} dias): no toca")
            return 0
    if cmd in ("aviso", "mirar"):
        nuevos, _ = mirar(datos)
        anotar(nuevos)
        guardar(datos)
        return 0
    print(__doc__)
    return 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
