"""Sabotajes y controles de la tienda (L1-10, L1-06, L1-03). Cada caso dice QUE LLEGO y POR QUE dio su resultado.

  python probar_tienda.py            (con la tienda corriendo en :8765; tarda ~2 minutos: arranca servers de prueba)

Casos:
  S1  una seleccion con Tough As Nails queda BLOQUEADA por la lista de castigos y lista.json no cambia     (L1-10)
  S2  una seleccion a la que le falta una dependencia (Cataclysm sin lionfish-api) NO arranca y no se publica (L1-06)
  C1  control positivo: la combinacion liviana arranca y se publica                                          (L1-05)
  S3  una instancia con un jar de mas, uno de menos y uno cambiado da ROJO nombrando los tres                 (L1-03)
  C2  despues de sincronizar, la misma instancia da VERDE y el de mas quedo en mods_fuera_de_pack             (L1-03)
  S4  el verificador con el pack inalcanzable no da verde (sale 2)
"""
import hashlib, os, shutil, subprocess, sys, tempfile

import armar as A

TIENDA = os.path.dirname(os.path.abspath(__file__))
PACK = "http://localhost:8765/pack/lista.json"
resultados = []


def caso(nombre, ok, llego):
    resultados.append((nombre, ok))
    print(f"[{'OK' if ok else 'MAL'}] {nombre} -- {llego}")


def huella():
    p = os.path.join(A.PUBLICADO, "lista.json")
    return hashlib.sha1(open(p, "rb").read()).hexdigest() if os.path.exists(p) else None


def ps(script, *args):
    r = subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", os.path.join(TIENDA, script), *args],
                       capture_output=True, text=True, encoding="utf-8", errors="replace")
    return r.returncode, (r.stdout + r.stderr).strip()


def pack_prendido():
    import socket
    try:
        socket.create_connection(("127.0.0.1", 8765), timeout=2).close()
        return True
    except OSError:
        return False


def main():
    """La prueba construye su precondicion (el pack en :8765) y deja todo como estaba: lo publicado se guarda
    antes y se devuelve al final (2026-11-25: dejaba publicada la Liviana encima de la combinacion de Fran)."""
    import time
    copia = tempfile.mkdtemp(prefix="tienda-publicado-")
    shutil.copytree(A.PUBLICADO, os.path.join(copia, "p"))
    servidor = None
    if not pack_prendido():
        servidor = subprocess.Popen([sys.executable, os.path.join(TIENDA, "tienda.py")], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        for _ in range(30):
            if pack_prendido():
                break
            time.sleep(0.5)
    try:
        return casos()
    finally:
        shutil.rmtree(A.PUBLICADO, ignore_errors=True)
        shutil.copytree(os.path.join(copia, "p"), A.PUBLICADO)
        shutil.rmtree(copia, ignore_errors=True)
        print(f"lo publicado volvio a como estaba: {huella()}")
        if servidor:
            servidor.kill()


def casos():
    log = []
    # C1 primero: deja publicado un pack conocido (la liviana) sobre el que miden los demas
    r = A.armar(combo="liviana", log=log.append)
    caso("C1 liviana se publica", r["ok"], f"server de prueba: {next((l for l in log if 'server de prueba' in l), 'sin linea')}")
    base = huella()

    log.clear()
    r = A.armar(combo="liviana", slugs_extra=["tough-as-nails"], log=log.append)
    caso("S1 Tough As Nails bloqueado", (not r["ok"]) and "castigos" in r["motivo"] and huella() == base,
         f"motivo: {r['motivo']!r}; lista.json {'igual' if huella() == base else 'CAMBIO'}; corrio server de prueba: {any('server de prueba' in l for l in log)}")

    log.clear()
    r = A.armar(cartas=["cataclysm"], nombre="sabotaje", saltear_dep="lionfish-api", log=log.append)
    llego = any("server de prueba: NO arranco" in l for l in log)
    caso("S2 dependencia faltante no se publica", (not r["ok"]) and llego and "lionfish" in r["motivo"].lower() and huella() == base,
         f"server de prueba: {next((l for l in log if 'server de prueba' in l), 'NO CORRIO')}; lista.json {'igual' if huella() == base else 'CAMBIO'}")

    # S3/C2 sobre una copia de mods sincronizada desde cero
    tmp = tempfile.mkdtemp(prefix="tienda-prueba-")
    mods = os.path.join(tmp, "mods")
    rc, out = ps("sincronizar.ps1", "-Pack", PACK, "-Mods", mods)
    rc0, out0 = ps("verificar-instancia.ps1", "-Pack", PACK, "-Mods", mods)
    caso("C2a instancia recien sincronizada da verde", rc0 == 0, out0.splitlines()[0] if out0 else "sin salida")
    jars = sorted(f for f in os.listdir(mods) if f.endswith(".jar"))
    open(os.path.join(mods, "mod-de-mas-sabotaje.jar"), "wb").write(b"no soy un mod")
    os.remove(os.path.join(mods, jars[0]))
    with open(os.path.join(mods, jars[1]), "ab") as f:
        f.write(b"x")
    rc1, out1 = ps("verificar-instancia.ps1", "-Pack", PACK, "-Mods", mods)
    vio = all(k in out1 for k in ("DE MAS: mod-de-mas-sabotaje.jar", f"FALTA: {jars[0]}", f"DISTINTO: {jars[1]}"))
    caso("S3 de mas, de menos y distinto dan rojo", rc1 == 1 and vio, " | ".join(l.strip() for l in out1.splitlines()[:4]))
    rc2, out2 = ps("sincronizar.ps1", "-Pack", PACK, "-Mods", mods)
    rc3, out3 = ps("verificar-instancia.ps1", "-Pack", PACK, "-Mods", mods)
    apartado = os.path.exists(os.path.join(tmp, "mods_fuera_de_pack", "mod-de-mas-sabotaje.jar"))
    caso("C2b sincronizar lo deja igual al pack", rc3 == 0 and apartado, f"{out2.splitlines()[-1] if out2 else ''} || {out3.splitlines()[0] if out3 else ''}")

    rc4, out4 = ps("verificar-instancia.ps1", "-Pack", "http://127.0.0.1:9/pack/lista.json", "-Mods", mods)
    caso("S4 pack inalcanzable no da verde", rc4 == 2, out4.splitlines()[0] if out4 else "sin salida")
    shutil.rmtree(tmp, ignore_errors=True)

    mal = [n for n, ok in resultados if not ok]
    print(f"\n{len(resultados) - len(mal)} de {len(resultados)} casos bien" + (f"; MAL: {mal}" if mal else ""))
    return 1 if mal else 0


if __name__ == "__main__":
    sys.exit(main())
