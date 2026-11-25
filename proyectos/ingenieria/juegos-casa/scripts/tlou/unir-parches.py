"""Une los patch.yml de comradesean/tlou-factions-server en uno solo, BCUS98174_patch.yml.

RPCS3 0.0.43 carga solo patches/patch.yml, patches/imported_patch.yml y patches/<TITLE_ID>_patch.yml
(Utilities/bin_patch.cpp: append_global_patches / append_title_patches); el README del servidor dice que
cualquier .yml sirve, y medido el 2026-11-25 no aplico ninguno. Cada archivo de origen tiene 'Version:' y uno o
mas bloques por hash de EBOOT (PPU-...); aca se juntan las entradas de cada hash bajo una sola clave.
Uso: python unir-parches.py <salida.yml> <entrada1.yml> [<entrada2.yml> ...]
"""
import re, sys

salida, entradas = sys.argv[1], sys.argv[2:]
bloques, orden, version = {}, [], None
for ruta in entradas:
    actual = None
    for linea in open(ruta, encoding="utf-8").read().splitlines():
        m = re.match(r"^Version:\s*(\S+)", linea)
        if m:
            version = version or m.group(1)
            continue
        m = re.match(r"^(PPU-[0-9a-f]{40}):\s*$", linea)
        if m:
            actual = m.group(1)
            if actual not in bloques:
                bloques[actual] = []
                orden.append(actual)
            continue
        if actual and (linea.startswith(" ") or not linea.strip()):
            bloques[actual].append(linea)
        elif linea.startswith("#"):
            continue
        elif linea.strip():
            actual = None
texto = [f"Version: {version}", ""]
for h in orden:
    texto.append(f"{h}:")
    texto += bloques[h]
    texto.append("")
open(salida, "w", encoding="utf-8", newline="\n").write("\n".join(texto) + "\n")
try:
    import yaml
    d = yaml.safe_load(open(salida, encoding="utf-8"))
    for h in orden:
        print(f"{h}: {len(d[h])} entradas: " + "; ".join(d[h]))
except ImportError:
    print("sin PyYAML: no se valido")
