"""Bancos de voz del juego base (de voces.json de la sesion anterior: pakchunk0 y 1) contra los que pisan los
mods latinos de la PC (tally.txt). Dice cuales quedan latinos con voz japonesa, cuales con inglesa, y cuales no tienen mod."""
import re, json, pathlib, sys
d = json.load(open(sys.argv[1], encoding="utf-8"))
ids = sorted({m for k in d if not k.endswith("_P") for f in d[k] for m in re.findall(r"BTLCV_(\d{4}_\d{2})_JP", f)})
cub = {}
for line in pathlib.Path(sys.argv[2]).read_text(encoding="utf-8").splitlines()[1:]:
    k, resto = line.split(" ", 1)
    jp = resto.split("| US:")[0].replace("JP:", "").strip()
    us = resto.split("| US:")[1].strip()
    cub[k] = (jp != "-", us != "-")
sin = [i for i in ids if i not in cub]
ambos = [i for i in ids if cub.get(i) == (True, True)]
solo_jp = [i for i in ids if cub.get(i) == (True, False)]
print(f"bancos base: {len(ids)}")
print(f"latino en los dos idiomas: {len(ambos)}")
print(f"latino SOLO con voz japonesa: {len(solo_jp)}")
print(f"sin mod latino: {len(sin)}")
print("SIN:", " ".join(sin))
print("agregados (no estan en la base):", " ".join(k for k in cub if k not in ids))
