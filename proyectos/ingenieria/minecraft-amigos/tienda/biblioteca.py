"""L1-11: copia a la PC cada jar del catalogo que ya esta en el cache, ordenado por familia de contenido.

  python biblioteca.py            -> C:\\Games\\Minecraft-mods\\<familia>\\ en la PC (por SSH), con el SHA-1 verificado

Los mods que no son de ninguna carta van a 'Base y rendimiento' (el nucleo) o a 'Bibliotecas y de Better MC 5'.
"""
import hashlib, os, subprocess, sys, tempfile

import armar as A

LLAVE = os.path.expanduser(r"~\.ssh\pc-cable")
PC = "Fran@10.147.20.3"
DESTINO = "C:/Games/Minecraft-mods"


def main():
    cat, cur = A.cargar()
    fam = {}
    for c in cur["cartas"]:
        for m in c["mods"]:
            fam[m] = cur["familias"][c["familia"]]
    for m in cur["nucleo"]:
        fam.setdefault(m, "Base y rendimiento")
    plan = {}
    for s, v in cat["versiones"].items():
        f = os.path.join(A.CACHE, v["archivo"])
        if os.path.exists(f):
            plan.setdefault(fam.get(s, "Bibliotecas y de Better MC 5"), []).append((f, v["sha1"]))
    for archivo, l in A.locales().items():
        f = os.path.join(A.CACHE, archivo)
        if os.path.exists(f):
            plan.setdefault("Bibliotecas y de Better MC 5", []).append((f, l["sha1"]))
    total = 0
    for familia, fs in sorted(plan.items()):
        d = f"{DESTINO}/{familia}"
        subprocess.run(["ssh", "-i", LLAVE, PC, f'if not exist "{d}" mkdir "{d}"'], capture_output=True)
        r = subprocess.run(["scp", "-i", LLAVE, "-q"] + [f for f, _ in fs] + [f"{PC}:{d}/"], capture_output=True, text=True)
        print(f"{familia}: {len(fs)} jars {'OK' if r.returncode == 0 else 'FALLO ' + r.stderr.strip()}")
        total += len(fs)
    # verificacion: SHA-1 de lo que quedo en la PC contra el catalogo
    cmd = (f"Get-ChildItem '{DESTINO}' -Recurse -File -Filter *.jar | ForEach-Object {{ (Get-FileHash $_.FullName -Algorithm SHA1).Hash }}")
    enc = __import__("base64").b64encode(cmd.encode("utf-16-le")).decode()
    out = subprocess.run(["ssh", "-i", LLAVE, PC, f"powershell -NoProfile -EncodedCommand {enc}"], capture_output=True, text=True).stdout
    hay = {l.strip().lower() for l in out.splitlines() if len(l.strip()) == 40}
    esperados = {s.lower() for fs in plan.values() for _, s in fs}
    faltan = esperados - hay
    print(f"biblioteca en la PC: {total} jars copiados; SHA-1 presentes {len(esperados & hay)}/{len(esperados)}" + (f"; FALTAN {len(faltan)}" if faltan else ""))
    return 1 if faltan else 0


if __name__ == "__main__":
    sys.exit(main())
