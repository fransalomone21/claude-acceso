"""Arranca un server NeoForge y, si un mod de solo-cliente lo tira ("Failed to create mod instance. ModID: X"),
mueve ese jar a mods_solo_cliente/ y vuelve a probar, hasta que llega al "Done" o se agotan los intentos.
Los jars se identifican por el modId de su META-INF/neoforge.mods.toml, no por el nombre del archivo.

  python server_sin_mods_de_cliente.py "<carpeta del server>" [--intentos 6]
"""
import os, re, shutil, subprocess, sys, time, zipfile

JAVA = os.path.expandvars(r"%APPDATA%\PrismLauncher\java\java-runtime-delta\bin\java.exe")


def indice_modids(mods):
    idx = {}
    for f in os.listdir(mods):
        if not f.endswith(".jar"):
            continue
        try:
            with zipfile.ZipFile(os.path.join(mods, f)) as z:
                for nombre in ("META-INF/neoforge.mods.toml", "META-INF/mods.toml"):
                    if nombre in z.namelist():
                        for m in re.findall(r'modId\s*=\s*"([^"]+)"', z.read(nombre).decode("utf-8", "replace")):
                            idx.setdefault(m, f)
        except Exception:
            pass
    return idx


def probar(server):
    args = [a for a in os.listdir(os.path.join(server, "libraries", "net", "neoforged", "neoforge"))]
    win = f"@libraries/net/neoforged/neoforge/{args[0]}/win_args.txt"
    t0 = time.time()
    p = subprocess.Popen([JAVA, "@user_jvm_args.txt", win, "nogui"], cwd=server, stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, encoding="utf-8", errors="replace")
    malos = set()
    for linea in p.stdout:
        m = re.search(r"Failed to create mod instance\. ModID: (\S+?),", linea)
        if m:
            malos.add(m.group(1))
        if "Done (" in linea:
            p.stdin.write("stop\n"); p.stdin.flush()
            # se sigue leyendo hasta que el server cierre: si nadie lee, el cano se llena mientras guarda el mundo
            # y el server se traba (2026-11-24: TimeoutExpired despues del Done en bmc5-arreglo.log)
            for _ in p.stdout:
                pass
            p.wait(timeout=300)
            return True, time.time() - t0, malos
        if time.time() - t0 > 400:
            break
    try:
        p.kill()
    except Exception:
        pass
    return False, time.time() - t0, malos


def main():
    server = sys.argv[1]
    intentos = int(sys.argv[sys.argv.index("--intentos") + 1]) if "--intentos" in sys.argv else 6
    mods = os.path.join(server, "mods")
    fuera = os.path.join(server, "mods_solo_cliente")
    os.makedirs(fuera, exist_ok=True)
    idx = indice_modids(mods)
    for i in range(1, intentos + 1):
        ok, seg, malos = probar(server)
        if ok:
            print(f"intento {i}: ARRANCO en {seg:.0f} s con {len(os.listdir(mods))} mods; afuera: {sorted(os.listdir(fuera))}")
            return 0
        sacados = []
        for m in malos:
            jar = idx.get(m)
            if jar and os.path.exists(os.path.join(mods, jar)):
                shutil.move(os.path.join(mods, jar), os.path.join(fuera, jar))
                sacados.append(jar)
        print(f"intento {i}: no arranco ({seg:.0f} s); mods de cliente sacados: {sacados or 'ninguno identificado'}")
        if not sacados:
            print("no hay mod identificado que sacar: ver logs/latest.log y crash-reports/")
            return 1
    return 1


if __name__ == "__main__":
    sys.exit(main())
