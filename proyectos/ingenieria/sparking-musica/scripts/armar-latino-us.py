"""Arma zzLatinoUS_P.pak: el audio latino de los bancos de voz que los mods pisan SOLO en japones, copiado con nombre
_US, para que suenen en latino tambien con el juego en voces en ingles. Es lo mismo que hacen los mods latinos que ya
traen las dos versiones (VegetaFinLAT: BTLCV_*_JP.awb y BTLCV_*_US.awb, el mismo audio): la tabla japonesa y la
inglesa de cada personaje tienen las mismas cues en el mismo orden (medido con Whis: 278 de 278).
No toca ningun mod: solo lee sus .pak. Si un banco lo pisan dos mods, gana el que dice LAT/LATINO en el nombre.
uso: python armar-latino-us.py <carpeta ~mods> <cobertura tally.txt> <salida>"""
import hashlib, os, re, shutil, subprocess, sys

UP = r"C:\Users\frans\herramientas\sz-audio\Tools\UnrealPak\UnrealPak.exe"
MODS, TALLY, OUT = sys.argv[1], sys.argv[2], sys.argv[3]
EXT = os.path.join(OUT, "_extraidos")
ST = os.path.join(OUT, "zzLatinoUS_P")
CW = os.path.join(ST, "SparkingZERO", "Content", "CriWareData")
os.makedirs(CW, exist_ok=True)

solo_jp = {}
for line in open(TALLY, encoding="utf-8").read().splitlines()[1:]:
    k, resto = line.split(" ", 1)
    jp = [m.strip() for m in resto.split("| US:")[0].replace("JP:", "").split(",") if m.strip() != "-"]
    us = resto.split("| US:")[1].strip()
    if jp and us == "-":
        lat = [m for m in jp if re.search(r"LAT", m, re.I)]
        solo_jp[k] = (lat or jp)[0]

hechos, faltan = [], []
for banco, mod in sorted(solo_jp.items()):
    d = os.path.join(EXT, mod)
    if not os.path.isdir(d) or not os.listdir(d):
        # el nombre del tally es el del pak sin "_P" (KidBuuLAT_P_9.pak -> KidBuuLAT_9)
        pak = [f for f in os.listdir(MODS) if f.endswith(".pak") and f[:-4].replace("_P", "") == mod]
        subprocess.run([UP, os.path.join(MODS, pak[0]), "-Extract", d], capture_output=True)
    src = [os.path.join(r, f) for r, _, fs in os.walk(d) for f in fs if f == f"BTLCV_{banco}_JP.awb"]
    if len(src) != 1:
        faltan.append((banco, mod, len(src)))
        continue
    dst = os.path.join(CW, f"BTLCV_{banco}_US.awb")
    shutil.copyfile(src[0], dst)
    hechos.append((banco, mod, os.path.getsize(dst), hashlib.md5(open(dst, "rb").read()).hexdigest()))

fl = os.path.join(OUT, "filelist.txt")
open(fl, "w").write(f'"{ST}\\*.*" "..\\..\\..\\*.*"\n')
pak = os.path.join(OUT, "zzLatinoUS_P.pak")
r = subprocess.run([UP, pak, f"-create={fl}"], capture_output=True, text=True)
with open(os.path.join(OUT, "latino-us.txt"), "w", encoding="utf-8") as f:
    f.write("banco  mod de origen  bytes  md5\n")
    for h in hechos:
        f.write("  ".join(map(str, h)) + "\n")
print(f"copiados {len(hechos)} de {len(solo_jp)}; faltan {faltan}")
print("UnrealPak", r.returncode, pak, os.path.getsize(pak) if os.path.exists(pak) else "NO SE CREO")
