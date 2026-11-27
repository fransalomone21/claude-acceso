"""El corazon de la tienda: de una seleccion (cartas o combo) a un pack publicado y probado.

  seleccion -> resolver (nucleo + cartas + dependencias)            L0-02
            -> bloquear castigos (frio, calor, sed)                 L1-10
            -> bajar los jars al cache con su SHA-1
            -> server de prueba: arranca la seleccion hasta "Done"  L1-05, L1-06
            -> publicar: lista.json (lo que leen las instancias) y el server de la tienda al dia

Uso por consola (la pagina usa las mismas funciones):
  python armar.py --combo aventura
  python armar.py --cartas yung,lootr --nombre "mi prueba"
  python armar.py --combo liviana --solo-resolver
"""
import argparse, hashlib, json, os, shutil, subprocess, sys, threading, time, urllib.request

from perfil import P, VERSION   # 1.21.1 NeoForge o 1.21.4 Fabric, por TIENDA_VERSION (L1-01, L1-20)

AQUI = os.path.dirname(os.path.abspath(__file__))
DATOS = os.path.join(AQUI, P["datos"])
RAIZ = os.environ.get("TIENDA_RAIZ", P["raiz"])
CACHE = os.path.join(RAIZ, "cache")
PUBLICADO = os.path.join(RAIZ, "publicado")
PRUEBA = os.path.join(RAIZ, "prueba")
SERVER = os.path.join(RAIZ, "server")
BMC5_SERVER = r"C:\Users\frans\MinecraftServer\bmc5"
NEOFORGE_LIBS = os.path.join(RAIZ, "neoforge", "libraries")
# Fabric: el lanzador (fabric-server-launch.jar, del instalador de Fabric: trae fijos el cargador y la version de
# Minecraft) baja el server de Mojang y sus librerias la primera vez. Eso se guarda una sola vez en RAIZ\fabric y
# el server de prueba y el de la tienda lo usan por union, como las librerias de NeoForge. .fabric/processedMods
# NO se comparte: lo arma cada server con SUS mods, y dos servers a la vez lo pisarian.
FABRIC = os.path.join(RAIZ, "fabric")
FABRIC_COMPARTIDO = ("libraries", "versions", ".fabric/server", ".fabric/remappedJars")
BMC5_MODS = os.path.join(os.environ.get("APPDATA", ""), "PrismLauncher", "instances", "Better MC 5 (1.21.1)", ".minecraft", "mods")
JAVA = os.path.join(os.environ.get("APPDATA", ""), "PrismLauncher", "java", "java-runtime-delta", "bin", "java.exe")
CARGADOR = P["cargador"]
NEOFORGE = P["cargador_version"] if CARGADOR == "neoforge" else None   # 21.1.267: los extras piden >= 21.1.195
FABRIC_LOADER = P["cargador_version"] if CARGADOR == "fabric" else None
MC = P["mc"]
ARGS_NEOFORGE = f"@libraries/net/neoforged/neoforge/{NEOFORGE}/win_args.txt"
TOPE_PRUEBA_S = 280          # L1-02 pide publicar en 300 s
PUERTO_PRUEBA = P["puerto_prueba"]
PUERTO_SERVER = P["puerto_server"]


def comando_server():
    """Lo que arranca el server en su carpeta: NeoForge por su archivo de argumentos, Fabric por su lanzador."""
    if CARGADOR == "neoforge":
        return [JAVA, "@user_jvm_args.txt", ARGS_NEOFORGE, "nogui"]
    return [JAVA, "-Xms2G", "-Xmx8G", "-jar", "fabric-server-launch.jar", "nogui"]


def _union(enlace, destino):
    if os.path.exists(enlace) and os.path.realpath(enlace) != os.path.realpath(destino):
        os.rmdir(enlace)   # una union vieja (rmdir de una union no toca el destino; una carpeta llena da error)
    if not os.path.exists(enlace):
        os.makedirs(destino, exist_ok=True)
        os.makedirs(os.path.dirname(enlace), exist_ok=True)
        subprocess.run(["cmd", "/c", "mklink", "/J", enlace, destino], check=True, capture_output=True)


class Bloqueado(Exception):
    pass


def cargar():
    cat = json.load(open(os.path.join(DATOS, "catalogo.json"), encoding="utf-8-sig"))
    cur = json.load(open(os.path.join(DATOS, "curado.json"), encoding="utf-8-sig"))
    return cat, cur


def locales():
    """Los jars de Better MC 5 que no estan en Modrinth (CurseForge): se sirven desde la notebook."""
    p = os.path.join(DATOS, "locales.json")
    return json.load(open(p, encoding="utf-8-sig")) if os.path.exists(p) else {}


def es_castigo(texto, cur):
    t = texto.lower().replace("_", "-")
    return next((c for c in cur["castigos"] if c in t), None)


def resolver(cat, cur, cartas=(), combo=None, slugs_extra=()):
    """Devuelve (nombre, lista de slugs con dependencias, incluye_locales)."""
    todo_bmc5 = False
    nombre = "seleccion"
    cartas = list(cartas)
    if combo:
        c = next(x for x in cur["combos"] if x["id"] == combo)
        nombre, todo_bmc5 = c["nombre"], bool(c.get("todo_bmc5"))
        cartas += c["cartas"]
    por_carta = {x["id"]: x for x in cur["cartas"]}
    pedidos = list(cat["base"]) if todo_bmc5 else list(cur["nucleo"])
    for cid in cartas:
        pedidos += por_carta[cid]["mods"]
    pedidos += list(slugs_extra)
    # castigos: se miran ANTES de resolver, sobre lo pedido (L1-10)
    for s in pedidos:
        c = es_castigo(s, cur)
        if c:
            raise Bloqueado(f"'{s}' es de la lista de castigos ({c}): la seleccion no se publica")
    out, cola = [], list(pedidos)
    while cola:
        s = cola.pop(0)
        if s in out:
            continue
        if s not in cat["versiones"]:
            raise Bloqueado(f"'{s}' no esta en el catalogo")
        out.append(s)
        # deps_faltan: las que el mod pide al arrancar y Modrinth no declara (medido 2026-11-26: irons_lib, patchouli, fzzy_config)
        cola += [d for d in cat["versiones"][s]["deps"] + cur.get("deps_faltan", {}).get(s, []) if d not in out]
    for s in out:   # y sobre lo resuelto (una dependencia tambien cuenta)
        c = es_castigo(s, cur) or es_castigo(cat["versiones"][s]["archivo"], cur)
        if c:
            raise Bloqueado(f"'{s}' es de la lista de castigos ({c}): la seleccion no se publica")
    return nombre, out, todo_bmc5


def entradas(cat, slugs, con_locales):
    es = []
    for s in slugs:
        v, p = cat["versiones"][s], cat["proyectos"][s]
        es.append({"slug": s, "nombre": p["titulo"], "archivo": v["archivo"], "sha1": v["sha1"], "url": v["url"],
                   "lado": p["lado"], "bytes": v["bytes"]})
    if con_locales:
        for archivo, l in sorted(locales().items()):
            es.append({"slug": "local:" + archivo, "nombre": archivo, "archivo": archivo, "sha1": l["sha1"],
                       "url": "archivos/" + archivo, "lado": l["lado"], "bytes": l["bytes"]})
    return es


def sha1(ruta):
    h = hashlib.sha1()
    with open(ruta, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def al_cache(e, log):
    os.makedirs(CACHE, exist_ok=True)
    dst = os.path.join(CACHE, e["archivo"])
    if os.path.exists(dst) and sha1(dst) == e["sha1"]:
        return dst
    if e["url"].startswith("archivos/"):
        src = os.path.join(BMC5_MODS, e["archivo"])
        shutil.copy2(src, dst)
    else:
        req = urllib.request.Request(e["url"], headers={"User-Agent": "claude-acceso/minecraft-amigos (tienda de mods)"})
        with urllib.request.urlopen(req, timeout=120) as r, open(dst + ".part", "wb") as f:
            shutil.copyfileobj(r, f)
        os.replace(dst + ".part", dst)
    if sha1(dst) != e["sha1"]:
        os.remove(dst)
        raise Bloqueado(f"SHA-1 distinto al bajar {e['archivo']}")
    log(f"bajado {e['archivo']}")
    return dst


def preparar_server(dir_, es, puerto, nivel, log):
    """Deja un server (NeoForge o Fabric, segun la version) en dir_ con exactamente los mods de lado server/both."""
    os.makedirs(dir_, exist_ok=True)
    if CARGADOR == "neoforge":   # las librerias del NeoForge de la tienda, por union (no se copian)
        _union(os.path.join(dir_, "libraries"), NEOFORGE_LIBS)
    else:
        lanzador = os.path.join(FABRIC, "fabric-server-launch.jar")
        if not os.path.exists(lanzador):
            raise Bloqueado(f"falta {lanzador}: correr 'python armar.py --preparar-fabric' una vez")
        shutil.copy2(lanzador, os.path.join(dir_, "fabric-server-launch.jar"))
        for d in FABRIC_COMPARTIDO:
            _union(os.path.join(dir_, *d.split("/")), os.path.join(FABRIC, *d.split("/")))
    mods = os.path.join(dir_, "mods")
    os.makedirs(mods, exist_ok=True)
    quiero = {e["archivo"]: e for e in es if e["lado"] != "client"}
    for f in os.listdir(mods):
        if f not in quiero:
            os.remove(os.path.join(mods, f))
    for a, e in quiero.items():
        dst = os.path.join(mods, a)
        if not (os.path.exists(dst) and sha1(dst) == e["sha1"]):
            shutil.copy2(os.path.join(CACHE, a), dst)
    open(os.path.join(dir_, "eula.txt"), "w").write("eula=true\n")
    open(os.path.join(dir_, "user_jvm_args.txt"), "w").write("-Xms2G\n-Xmx8G\n")
    props = os.path.join(dir_, "server.properties")
    lineas = open(props, encoding="utf-8").read().splitlines() if os.path.exists(props) else []
    pon = {"server-port": str(puerto), "level-name": nivel, "online-mode": "false", "motd": f"Tienda - {nivel}",
           "enable-rcon": "false", "max-players": "8", "spawn-protection": "0"}
    hechas = set()
    for i, l in enumerate(lineas):
        k = l.split("=", 1)[0]
        if k in pon:
            lineas[i] = f"{k}={pon[k]}"; hechas.add(k)
    lineas += [f"{k}={v}" for k, v in pon.items() if k not in hechas]
    open(props, "w", encoding="utf-8").write("\n".join(lineas) + "\n")
    log(f"server en {dir_}: {len(quiero)} mods de lado server")


def probar(es, log, tope=TOPE_PRUEBA_S):
    """L1-05/L1-06: arranca la seleccion en un server efimero; True solo si llega a 'Done ('."""
    mundo = os.path.join(PRUEBA, "prueba-mundo")
    shutil.rmtree(mundo, ignore_errors=True)
    preparar_server(PRUEBA, es, PUERTO_PRUEBA, "prueba-mundo", log)
    t0 = time.time()
    p = subprocess.Popen(comando_server(), cwd=PRUEBA, stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, encoding="utf-8", errors="replace")
    ultimas, todas, done = [], [], None
    def leer():
        nonlocal done
        for l in p.stdout:
            todas.append(l.rstrip())
            ultimas.append(l.rstrip()); del ultimas[:-40]
            if "Done (" in l and "For help" in l and done is None:
                done = time.time() - t0
                # se sigue leyendo: si nadie lee, el cano se llena con el 'stop' y el server se traba al guardar
    hilo = threading.Thread(target=leer, daemon=True); hilo.start()
    while done is None and hilo.is_alive() and p.poll() is None and time.time() - t0 < tope:
        time.sleep(1)
    ok = done is not None
    if p.poll() is None:
        try:
            p.stdin.write("stop\n"); p.stdin.flush(); p.wait(60)
        except Exception:
            pass
        if p.poll() is None:
            p.kill()
    shutil.rmtree(mundo, ignore_errors=True)
    if ok:
        log(f"server de prueba: arranco en {done:.0f} s")
        return True, ""
    open(os.path.join(PRUEBA, "ultimo-fallo.log"), "w", encoding="utf-8").write("\n".join(todas))
    # el detalle de NeoForge viene DESPUES de "Loading errors encountered:", en renglones "\t- ..."
    detalle = []
    for i, l in enumerate(todas):
        if "Loading errors encountered" in l:
            detalle = [x.strip() for x in todas[i + 1:i + 40] if x.strip().startswith("- ")]
            break
        if "Immediate reason:" in l:   # Fabric: el resolvedor dice en ingles que mod pide que (2026-11-27)
            detalle = [l.split("Immediate reason:", 1)[1].strip()]
            break
    motivo = " | ".join(detalle[:6]) if detalle else next((l for l in reversed(ultimas) if any(k in l for k in ("Missing or unsupported", "requires", "Exception", "ERROR", "Error"))), ultimas[-1] if ultimas else "sin salida")
    log(f"server de prueba: NO arranco en {time.time() - t0:.0f} s -- {motivo}")
    return False, motivo


def publicar(nombre, combo, es, log):
    """Escribe lista.json de forma atomica. El server de la tienda se pone al dia al prenderlo (sincronizar_server),
    asi publicar con el server andando no le saca los mods de abajo."""
    os.makedirs(os.path.join(PUBLICADO, "archivos"), exist_ok=True)
    for e in es:
        if e["url"].startswith("archivos/"):
            shutil.copy2(os.path.join(CACHE, e["archivo"]), os.path.join(PUBLICADO, "archivos", e["archivo"]))
    doc = {"nombre": nombre, "combo": combo, "publicado": time.strftime("%Y-%m-%d %H:%M:%S"), "minecraft": MC,
           "cargador": CARGADOR, "cargador_version": P["cargador_version"], "mods": es}
    if NEOFORGE:
        doc["neoforge"] = NEOFORGE   # lo que leia la version de antes
    tmp = os.path.join(PUBLICADO, "lista.json.tmp")
    json.dump(doc, open(tmp, "w", encoding="utf-8"), indent=1, ensure_ascii=False)
    os.replace(tmp, os.path.join(PUBLICADO, "lista.json"))
    log(f"publicado: {nombre}, {len(es)} mods (el server toma el cambio la proxima vez que se prenda)")


def sincronizar_server(log=print):
    """Lo corre iniciar-server-tienda.bat antes de prender el server: lo deja igual a lo publicado, un mundo por combo."""
    d = json.load(open(os.path.join(PUBLICADO, "lista.json"), encoding="utf-8"))
    for e in d["mods"]:
        al_cache(e, log)
    nivel = "mundo-" + (d.get("combo") or "seleccion-" + "".join(ch for ch in d["nombre"].lower() if ch.isalnum()))
    preparar_server(SERVER, d["mods"], PUERTO_SERVER, nivel, log)
    log(f"server de la tienda: '{d['nombre']}' ({d['publicado']}), mundo {nivel}")


def preparar_fabric(origen=None, log=print):
    """Deja RAIZ\\fabric listo: el lanzador oficial de Fabric para MC + el cargador de la tienda (meta.fabricmc.net,
    con su version verificada adentro), y si se da un server Fabric que ya anda, lo que ese server bajo de Mojang
    (el jar del server y sus librerias), asi la primera prueba no baja 70 MB. Del origen solo se lee."""
    if CARGADOR != "fabric":
        raise SystemExit("--preparar-fabric es de la version 1.21.4 (TIENDA_VERSION=1.21.4)")
    import io, zipfile
    url = f"https://meta.fabricmc.net/v2/versions/loader/{MC}/{FABRIC_LOADER}/{P['instalador_fabric']}/server/jar"
    req = urllib.request.Request(url, headers={"User-Agent": "claude-acceso/minecraft-amigos (tienda de mods)"})
    jar = urllib.request.urlopen(req, timeout=120).read()
    props = zipfile.ZipFile(io.BytesIO(jar)).read("install.properties").decode()
    if f"game-version={MC}" not in props or f"fabric-loader-version={FABRIC_LOADER}" not in props:
        raise SystemExit(f"el lanzador bajado no es {MC} + Fabric {FABRIC_LOADER}: {props!r}")
    os.makedirs(FABRIC, exist_ok=True)
    open(os.path.join(FABRIC, "fabric-server-launch.jar"), "wb").write(jar)
    if origen:
        for d in ("libraries", "versions", ".fabric/server"):
            src, dst = os.path.join(origen, *d.split("/")), os.path.join(FABRIC, *d.split("/"))
            if os.path.isdir(src):
                shutil.copytree(src, dst, dirs_exist_ok=True)
    log(f"fabric listo en {FABRIC}: {props.strip()}")


def armar(cartas=(), combo=None, nombre=None, slugs_extra=(), saltear_dep=None, log=print, solo_resolver=False):
    """Todo el camino. Devuelve dict con ok, motivo, segundos. saltear_dep: SOLO para el sabotaje."""
    t0 = time.time()
    cat, cur = cargar()
    try:
        n, slugs, todo = resolver(cat, cur, cartas, combo, slugs_extra)
    except Bloqueado as e:
        log(f"BLOQUEADO: {e}")
        return {"ok": False, "motivo": str(e), "segundos": time.time() - t0}
    if saltear_dep:
        slugs = [s for s in slugs if s != saltear_dep]
    es = entradas(cat, slugs, todo)
    log(f"seleccion: {len(es)} mods ({sum(e['bytes'] for e in es) / 1e6:.0f} MB)")
    if solo_resolver:
        return {"ok": True, "motivo": "", "segundos": time.time() - t0, "mods": len(es)}
    try:
        for e in es:
            al_cache(e, log)
    except Exception as ex:
        log(f"BLOQUEADO: {ex}")
        return {"ok": False, "motivo": str(ex), "segundos": time.time() - t0}
    ok, motivo = probar(es, log)
    if not ok:
        log("NO SE PUBLICA: el server de prueba no arranco")
        return {"ok": False, "motivo": motivo, "segundos": time.time() - t0}
    publicar(nombre or n, combo, es, log)
    s = time.time() - t0
    log(f"listo en {s:.0f} s")
    return {"ok": True, "motivo": "", "segundos": s}


if __name__ == "__main__":
    a = argparse.ArgumentParser()
    a.add_argument("--combo")
    a.add_argument("--cartas", default="")
    a.add_argument("--nombre")
    a.add_argument("--solo-resolver", action="store_true")
    a.add_argument("--server", action="store_true", help="solo poner al dia el server de la tienda con lo publicado")
    a.add_argument("--arrancar", action="store_true", help="con --server: despues lo arranca en esta consola")
    a.add_argument("--preparar-fabric", metavar="SERVER_FABRIC", nargs="?", const="",
                   help="1.21.4: baja el lanzador de Fabric; si se da un server Fabric que anda, copia lo que ya bajo de Mojang")
    o = a.parse_args()
    if o.preparar_fabric is not None:
        preparar_fabric(o.preparar_fabric or None); sys.exit(0)
    if o.server:
        sincronizar_server()
        if o.arrancar:   # la consola queda en el server: se cierra escribiendo stop
            sys.exit(subprocess.call(comando_server(), cwd=SERVER))
        sys.exit(0)
    r = armar([c for c in o.cartas.split(",") if c], o.combo, o.nombre, solo_resolver=o.solo_resolver)
    sys.exit(0 if r["ok"] else 1)
