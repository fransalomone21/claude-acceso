"""Instala un modpack .mrpack de Modrinth como instancia de Prism y/o como server NeoForge, verificando
el SHA-1 de cada archivo contra el indice del pack. Base de la tienda de la fase 2 (docs/fase-2-tienda.md).

  python instalar_mrpack.py <pack.mrpack> --instancia "<carpeta de la instancia>" --nombre "<nombre en Prism>"
  python instalar_mrpack.py <pack.mrpack> --server "<carpeta del server>" --puerto 25567 --probar
  --excluir SereneSeasons          (subcadena del nombre de archivo; se puede repetir)

El server queda con online-mode=false (cada jugador entra con su cuenta sin conexion) y un
iniciar-server.bat que usa la Java de Prism. --probar lo arranca, espera el "Done" y lo apaga con "stop".
"""
import argparse, concurrent.futures as cf, hashlib, json, os, subprocess, sys, time, urllib.request, zipfile

UA = {"User-Agent": "claude-acceso/minecraft-amigos (instalar_mrpack)"}
JAVA = os.path.expandvars(r"%APPDATA%\PrismLauncher\java\java-runtime-delta\bin\java.exe")


def bajar(url, destino, sha1, intentos=3):
    os.makedirs(os.path.dirname(destino), exist_ok=True)
    if os.path.exists(destino) and hashlib.sha1(open(destino, "rb").read()).hexdigest() == sha1:
        return "ya"
    for _ in range(intentos):
        try:
            with urllib.request.urlopen(urllib.request.Request(url, headers=UA), timeout=60) as r:
                datos = r.read()
            if hashlib.sha1(datos).hexdigest() != sha1:
                continue
            open(destino, "wb").write(datos)
            return "ok"
        except Exception:
            time.sleep(2)
    return "FALLA"


def instalar(pack, base, lado, excluir):
    z = zipfile.ZipFile(pack)
    idx = json.loads(z.read("modrinth.index.json"))
    tareas = []
    for f in idx["files"]:
        env = f.get("env") or {}
        if env.get(lado) == "unsupported" or any(x.lower() in f["path"].lower() for x in excluir):
            continue
        tareas.append((f["downloads"][0], os.path.join(base, f["path"]), f["hashes"]["sha1"]))
    with cf.ThreadPoolExecutor(8) as ex:
        res = list(ex.map(lambda t: bajar(*t), tareas))
    fallas = [t[1] for t, r in zip(tareas, res) if r == "FALLA"]
    otro = "server-overrides" if lado == "client" else "client-overrides"
    n = 0
    for nombre in z.namelist():
        if nombre.endswith("/") or nombre.startswith(otro + "/") or not nombre.startswith(("overrides/", "client-overrides/", "server-overrides/")):
            continue
        rel = nombre.split("/", 1)[1]
        if any(x.lower() in rel.lower() for x in excluir):
            continue
        destino = os.path.join(base, rel)
        os.makedirs(os.path.dirname(destino), exist_ok=True)
        open(destino, "wb").write(z.read(nombre))
        n += 1
    print(f"[{lado}] {len(tareas)} archivos del indice ({len(tareas) - len(fallas)} con SHA-1 verificado), {n} de overrides")
    if fallas:
        print(f"[{lado}] FALLARON {len(fallas)}: " + ", ".join(os.path.basename(x) for x in fallas[:10]))
    return idx, not fallas


def main():
    a = argparse.ArgumentParser()
    a.add_argument("pack")
    a.add_argument("--instancia"); a.add_argument("--nombre", default="Modpack")
    a.add_argument("--server"); a.add_argument("--puerto", type=int, default=25567)
    a.add_argument("--memoria", type=int, default=8192)
    a.add_argument("--excluir", action="append", default=[])
    a.add_argument("--probar", action="store_true")
    o = a.parse_args()
    idx = json.loads(zipfile.ZipFile(o.pack).read("modrinth.index.json"))
    mc, nf = idx["dependencies"]["minecraft"], idx["dependencies"].get("neoforge")
    print(f"pack: {idx.get('name')} {idx.get('versionId')} -> Minecraft {mc}, NeoForge {nf}")

    if o.instancia:
        _, ok = instalar(o.pack, os.path.join(o.instancia, ".minecraft"), "client", o.excluir)
        open(os.path.join(o.instancia, "instance.cfg"), "w", encoding="utf-8").write(
            "[General]\nConfigVersion=1.2\nInstanceType=OneSix\niconKey=default\n"
            f"name={o.nombre}\nOverrideMemory=true\nMinMemAlloc=4096\nMaxMemAlloc={o.memoria}\n")
        json.dump({"components": [{"important": True, "uid": "net.minecraft", "version": mc},
                                  {"uid": "net.neoforged", "version": nf}], "formatVersion": 1},
                  open(os.path.join(o.instancia, "mmc-pack.json"), "w", encoding="utf-8"), indent=1)
        print(f"instancia lista: {o.instancia} ({'completa' if ok else 'CON FALLAS'})")

    if o.server:
        os.makedirs(o.server, exist_ok=True)
        inst = os.path.join(o.server, f"neoforge-{nf}-installer.jar")
        url = f"https://maven.neoforged.net/releases/net/neoforged/neoforge/{nf}/neoforge-{nf}-installer.jar"
        if not os.path.exists(inst):
            urllib.request.urlretrieve(url, inst)
        r = subprocess.run([JAVA, "-jar", inst, "--installServer", o.server], cwd=o.server, capture_output=True, text=True)
        print("instalador NeoForge:", "ok" if r.returncode == 0 else "FALLA " + r.stdout[-400:])
        _, ok = instalar(o.pack, o.server, "server", o.excluir)
        open(os.path.join(o.server, "eula.txt"), "w").write("eula=true\n")
        props = os.path.join(o.server, "server.properties")
        base = {"online-mode": "false", "server-port": str(o.puerto), "max-players": "8",
                "motd": o.nombre, "level-name": "mundo", "allow-flight": "true", "spawn-protection": "0"}
        if os.path.exists(props):
            for linea in open(props, encoding="utf-8"):
                if "=" in linea and not linea.startswith("#"):
                    k, v = linea.rstrip("\n").split("=", 1)
                    base.setdefault(k, v)
        open(props, "w", encoding="utf-8").write("".join(f"{k}={v}\n" for k, v in base.items()))
        open(os.path.join(o.server, "user_jvm_args.txt"), "w").write(f"-Xms4G\n-Xmx{o.memoria // 1024}G\n")
        args = f"@libraries/net/neoforged/neoforge/{nf}/win_args.txt"
        open(os.path.join(o.server, "iniciar-server.bat"), "w").write(
            "@echo off\nrem Server " + o.nombre + ". Doble clic. Para cerrarlo: escribir stop en esta ventana.\n"
            'cd /d "%~dp0"\ntitle Server ' + o.nombre + "\n"
            'set "JAVA=%APPDATA%\\PrismLauncher\\java\\java-runtime-delta\\bin\\java.exe"\n'
            f'"%JAVA%" @user_jvm_args.txt {args} nogui\npause\n')
        print(f"server listo: {o.server} (puerto {o.puerto}, {'completo' if ok else 'CON FALLAS'})")
        if o.probar:
            t0 = time.time()
            p = subprocess.Popen([JAVA, "@user_jvm_args.txt", args, "nogui"], cwd=o.server,
                                 stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
                                 encoding="utf-8", errors="replace")
            hecho, ultimas = False, []
            for linea in p.stdout:
                ultimas = (ultimas + [linea.rstrip()])[-6:]
                if "Done (" in linea:
                    hecho = True
                    print(f"ARRANCO en {time.time() - t0:.0f} s: {linea.strip()[:120]}")
                    p.stdin.write("stop\n"); p.stdin.flush()
                    break
                if time.time() - t0 > 420:
                    break
            if not hecho:
                print("NO ARRANCO. Ultimas lineas:\n  " + "\n  ".join(ultimas))
                p.kill()
            try:
                p.wait(timeout=90)
            except Exception:
                p.kill()
            sys.exit(0 if hecho else 1)


if __name__ == "__main__":
    main()
