"""Los iconos de los juegos del indice: C:\\Games\\_indice\\iconos\\<id>.ico en las dos maquinas.

  python iconos.py            arma los que faltan y copia la carpeta a la PC
  python iconos.py --todos    los rehace todos

De donde sale cada uno:
  Mega Drive y PlayStation 2  la caratula de las miniaturas de RetroArch (repositorio libretro-thumbnails de GitHub,
                              Named_Boxarts; es lo que baja el propio RetroArch). El nombre se busca por parecido
                              con el campo 'caratula' del catalogo (o el nombre del juego).
  PlayStation 3               el ICON0.PNG del juego instalado (de la note o de la PC, segun donde este).
  PC                          ninguno: el acceso usa el icono del .exe o el de Steam, que ya son los del juego.
El icono se arma cuadrado (256, 64, 48, 32 y 16 px) con la imagen centrada sobre transparente.
"""
import difflib, html, io, json, os, re, subprocess, sys, tempfile, urllib.parse, urllib.request

from PIL import Image

AQUI = os.path.dirname(os.path.abspath(__file__))
DESTINO = r"C:\Games\_indice\iconos"
LLAVE = os.path.expanduser(r"~\.ssh\pc-cable")
PC = "Fran@10.147.20.3"
# El repositorio publico de las miniaturas de RetroArch (libretro-thumbnails, en GitHub): thumbnails.libretro.com
# ya no lista ni sirve los archivos (2026-11-25: 404 en la raiz y en un archivo conocido).
SISTEMAS = {"Mega Drive": "Sega_-_Mega_Drive_-_Genesis", "PlayStation 2": "Sony_-_PlayStation_2"}
UA = {"User-Agent": "juegos-casa-indice (iconos)"}


def listado(sistema):
    """Los nombres de Named_Boxarts. Por partes (raiz y despues la carpeta): el arbol recursivo de PS2 es tan
    grande que la API da 500."""
    api = f"https://api.github.com/repos/libretro-thumbnails/{sistema}/git/trees/"
    raiz = json.load(urllib.request.urlopen(urllib.request.Request(api + "master", headers=UA), timeout=120))
    sha = next(x["sha"] for x in raiz["tree"] if x["path"] == "Named_Boxarts")
    t = json.load(urllib.request.urlopen(urllib.request.Request(api + sha, headers=UA), timeout=180))
    return [x["path"][:-4] for x in t["tree"] if x["path"].endswith(".png")]


def bajar(sistema, nombre, saltos=3):
    """La caratula; si el archivo del repositorio es un enlace (git guarda el nombre del destino como texto), se
    sigue el enlace."""
    d = urllib.request.urlopen(urllib.request.Request(url_caratula(sistema, nombre), headers=UA), timeout=60).read()
    if d[:8] != b"\x89PNG\r\n\x1a\n" and saltos and len(d) < 512:
        destino = d.decode("utf-8", "replace").strip().split("/")[-1]
        return bajar(sistema, destino[:-4] if destino.lower().endswith(".png") else destino, saltos - 1)
    return d


def url_caratula(sistema, nombre):
    return (f"https://raw.githubusercontent.com/libretro-thumbnails/{sistema}/master/Named_Boxarts/"
            + urllib.parse.quote(nombre + ".png"))


def norm(s):
    s = re.sub(r"\([^)]*\)|\[[^]]*\]", " ", s.lower()).replace("_", " ").replace("&", " and ")
    return re.sub(r"[^a-z0-9]+", " ", s).strip()


def elegir(busca, nombres):
    n = norm(busca)
    pref = lambda x: (0 if "(USA" in x else 1 if "(World" in x else 2 if "(Europe" in x else 3)
    cands = sorted(nombres, key=lambda x: (-difflib.SequenceMatcher(None, n, norm(x)).ratio(), pref(x), len(x)))
    mejor = cands[0]
    r = difflib.SequenceMatcher(None, n, norm(mejor)).ratio()
    # entre los igual de parecidos, el de USA
    empatados = [c for c in cands[:12] if abs(difflib.SequenceMatcher(None, n, norm(c)).ratio() - r) < 1e-9]
    return sorted(empatados, key=lambda x: (pref(x), len(x)))[0], r


def a_ico(datos_png, dst):
    im = Image.open(io.BytesIO(datos_png)).convert("RGBA")
    im.thumbnail((256, 256), Image.LANCZOS)
    lienzo = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    lienzo.paste(im, ((256 - im.width) // 2, (256 - im.height) // 2), im)
    lienzo.save(dst, format="ICO", sizes=[(256, 256), (64, 64), (48, 48), (32, 32), (16, 16)])


def png_de_ps3(ruta, maquina):
    for c in (os.path.join(ruta, "ICON0.PNG"), os.path.join(ruta, "PS3_GAME", "ICON0.PNG")):
        if maquina == "note":
            if os.path.exists(c):
                return open(c, "rb").read()
        else:
            tmp = os.path.join(tempfile.gettempdir(), "icon0-pc.png")
            r = subprocess.run(["scp", "-q", "-i", LLAVE, f"{PC}:{c.replace(chr(92), '/')}", tmp], capture_output=True)
            if r.returncode == 0 and os.path.exists(tmp):
                d = open(tmp, "rb").read()
                os.remove(tmp)
                return d
    return None


def main(argv):
    todos = "--todos" in argv
    cat = json.load(open(os.path.join(AQUI, "catalogo.json"), encoding="utf-8"))
    os.makedirs(DESTINO, exist_ok=True)
    invs = {}
    for m in ("note", "pc"):
        p = os.path.join(os.path.dirname(AQUI), "inventario", f"{m}.json")
        if os.path.exists(p):
            invs[m] = json.load(open(p, encoding="utf-8"))
    listas, hechos, sin = {}, [], []
    for j in cat["juegos"]:
        dst = os.path.join(DESTINO, j["id"] + ".ico")
        if os.path.exists(dst) and not todos:
            continue
        s = j.get("sistema")
        try:
            if s in SISTEMAS:
                if s not in listas:
                    listas[s] = listado(SISTEMAS[s])
                nombre, r = elegir(j.get("caratula") or j["nombre"], listas[s])
                if r < 0.55:
                    sin.append(f"{j['nombre']}: la mas parecida es '{nombre}' ({r:.2f}), no alcanza")
                    continue
                a_ico(bajar(SISTEMAS[s], nombre), dst)
                hechos.append(f"{j['nombre']} <- {nombre} ({r:.2f})")
            elif s == "PlayStation 3":
                datos = None
                for m, inv in invs.items():
                    for it in inv["items"]:
                        if it["clase"] == "ps3" and any((d.get("id") and re.search(d["id"], it.get("id") or "", re.I)) or
                                                        (d.get("titulo") and re.search(d["titulo"], it.get("nombre") or "", re.I))
                                                        for d in j.get("detectar", []) if d["clase"] == "ps3"):
                            datos = png_de_ps3(it["ruta"], m)
                            if datos:
                                break
                    if datos:
                        break
                if datos:
                    a_ico(datos, dst)
                    hechos.append(f"{j['nombre']} <- ICON0.PNG")
                else:
                    sin.append(f"{j['nombre']}: sin ICON0.PNG en ninguna maquina")
        except Exception as e:
            sin.append(f"{j['nombre']}: {e}")
    for h in hechos:
        print("  icono:", h)
    for s in sin:
        print("  SIN ICONO:", s)
    r = subprocess.run(["scp", "-q", "-r", "-i", LLAVE, DESTINO, f"{PC}:C:/Games/_indice/"], capture_output=True, text=True)
    total = len([f for f in os.listdir(DESTINO) if f.endswith(".ico")])
    print(f"iconos: {total} en la note; copia a la PC: {'OK' if r.returncode == 0 else 'FALLO ' + r.stderr.strip()}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
