"""Compara la tabla de voz japonesa y la inglesa de un personaje (los .uasset del juego, con el .acb adentro):
mismas cues, mismas ondas en el mismo orden? Si si, el audio latino (que esta armado para la tabla japonesa) sirve
tal cual con nombre _US. Usa acb-cues.py de lp-trabajo para leer la tabla.
uso: python comparar-tablas-voz.py <JP.uasset> <US.uasset>"""
import subprocess, sys, tempfile, os, re

ACB = r"C:\Users\frans\herramientas\lp-trabajo\scripts\acb-cues.py"


def cues(p):
    b = open(p, "rb").read()
    i = b.find(b"@UTF")
    f = tempfile.NamedTemporaryFile(suffix=".acb", delete=False)
    f.write(b[i:]); f.close()
    r = subprocess.run([sys.executable, ACB, f.name], capture_output=True, text=True)
    os.unlink(f.name)
    return [re.sub(r"\s+", " ", l.strip()) for l in r.stdout.splitlines() if l.strip()]


a, b = cues(sys.argv[1]), cues(sys.argv[2])
ja, jb = open(sys.argv[1], "rb").read(), open(sys.argv[2], "rb").read()
dif = sum(1 for x, y in zip(ja, jb) if x != y)
print(f"cues JP {len(a)}  US {len(b)}  lineas iguales {sum(1 for x, y in zip(a, b) if x == y)}")
print(f"bytes distintos entre los .uasset: {dif} de {len(ja)}")
for x, y in list(zip(a, b))[:3]:
    print("JP:", x[:110]); print("US:", y[:110])
malas = [(x, y) for x, y in zip(a, b) if x != y]
print("distintas (primeras 3):", malas[:3])
