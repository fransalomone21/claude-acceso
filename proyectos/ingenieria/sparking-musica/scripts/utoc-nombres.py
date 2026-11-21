"""Lista los nombres de archivo de cada .utoc (cadenas ASCII de largo >=2) y filtra por patron.
uso: python utoc_nombres.py <carpeta> <regex>"""
import re, sys, pathlib
carpeta, pat = sys.argv[1], re.compile(sys.argv[2], re.I)
for f in sorted(pathlib.Path(carpeta).glob("*.utoc")):
    b = f.read_bytes()
    nombres = [m.group().decode() for m in re.finditer(rb"[\x20-\x7e]{2,}", b)]
    hits = sorted({n for n in nombres if pat.search(n)})
    if hits:
        print(f"{f.name}: {' | '.join(hits)}")
