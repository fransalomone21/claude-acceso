"""Saca de la base oficial de parches de RPCS3 (rpcs3.net/compatibility?patch&api=v1&v=1.2, la que baja el Patch
Manager) los bloques de The Last of Us PS3 (los hashes de la 01.00 y la 01.11) y lista sus nombres.
Uso: python parches-oficiales.py <resp.json> [--escribir <patch.yml>]
Con --escribir deja un patch.yml con la base entera (verificada por su sha256), que es el archivo que RPCS3 lee
como patches/patch.yml.
"""
import hashlib, json, re, sys

datos = json.load(open(sys.argv[1], encoding="utf-8"))
texto = datos["patch"]
ok = hashlib.sha256(texto.encode("utf-8")).hexdigest() == datos["sha256"]
print(f"sha256 {'OK' if ok else 'DISTINTO'}; version {datos['version']}")
for h in ("PPU-9df60dc1aa5005a0c80e9066e4951dc0471553e6", "PPU-120fb71f7352d62521c639b0e99f960018c10a56"):
    m = re.search(rf"^{h}:\n((?:[ \t].*\n|\n)+)", texto, re.M)
    if not m:
        print(f"{h}: sin parches")
        continue
    nombres = re.findall(r'^  "([^"]+)":', m.group(1), re.M)
    print(f"{h}: {len(nombres)} parches")
    for n in nombres:
        print(f"   - {n}")
if "--escribir" in sys.argv:
    if not ok:
        sys.exit("no se escribe: el sha256 no coincide")
    destino = sys.argv[sys.argv.index("--escribir") + 1]
    open(destino, "w", encoding="utf-8", newline="\n").write(texto)
    print(f"escrito {destino}")
