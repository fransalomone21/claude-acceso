"""Por cada banco de voz BTLCV_<id>_<idioma>, que mods lo pisan. Resume cobertura JP vs US."""
import re, pathlib, collections, sys
carpeta = pathlib.Path(sys.argv[1])
cub = collections.defaultdict(lambda: {"JP": [], "US": []})
for f in sorted(carpeta.glob("*.utoc")):
    b = f.read_bytes()
    for m in set(re.findall(rb"BTLCV_(\d{4}_\d{2})_(JP|US)", b)):
        cub[m[0].decode()][m[1].decode()].append(f.stem.replace("_P", ""))
solo_jp = [k for k, v in cub.items() if v["JP"] and not v["US"]]
solo_us = [k for k, v in cub.items() if v["US"] and not v["JP"]]
ambos = [k for k, v in cub.items() if v["US"] and v["JP"]]
print(f"bancos pisados: {len(cub)}  solo JP: {len(solo_jp)}  solo US: {len(solo_us)}  ambos: {len(ambos)}")
for k in sorted(cub):
    v = cub[k]
    print(k, "JP:", ",".join(v["JP"]) or "-", "| US:", ",".join(v["US"]) or "-")
