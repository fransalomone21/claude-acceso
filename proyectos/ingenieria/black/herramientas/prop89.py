"""(89) proporcion: capturas entera / dividida con +0x38 = 1 / dividida con +0x38 = 0, y la comparacion."""
import subprocess, sys, time
sys.path.insert(0, r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\herramientas")
from PIL import Image, ImageChops, ImageStat
from pine import Pine
import pantalla_dividida as pd

H = r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\herramientas"
C = r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\volcados\capturas-89" + "\\"


def cap(nombre):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", H + r"\capturar-pantalla.ps1",
                    "-Salida", C + nombre], capture_output=True)
    return Image.open(C + nombre).convert("L")


def poner(div, prop):
    with Pine() as p:
        p.escribir32(pd.DATOS + 0x80, div)
        p.escribir32(pd.DATOS + 0x38, prop)
        r = p.leer32(pd.G_RENDER) + 0xD400
        v = (p.leer_f32(r + 0x70), p.leer_f32(r + 0x74))
    time.sleep(0.8)
    return v


import os
os.makedirs(C, exist_ok=True)
res = {}
res["entera_prop"] = poner(0, 1); ent = cap("entera.png")
res["div1_prop"] = poner(1, 1); d1 = cap("dividida-prop1.png")
res["div0_prop"] = poner(1, 0); d0 = cap("dividida-prop0.png")
res["entera2_prop"] = poner(0, 1); ent2 = cap("entera-2.png")
poner(1, 1)
W, Hh = ent.size
recorte = ent.crop((W // 4, 150, 3 * W // 4, Hh))
aplastada = ent.resize((W // 2, Hh)).crop((0, 150, W // 2, Hh))
dif = lambda a, b: round(ImageStat.Stat(ImageChops.difference(a, b)).mean[0], 1)
for nombre, d in (("prop1", d1), ("prop0", d0)):
    izq = d.crop((0, 150, W // 2, Hh))
    res[nombre] = {"vs_recorte_central": dif(izq, recorte), "vs_aplastada": dif(izq, aplastada)}
res["ruido_entera_vs_entera2"] = dif(ent.crop((0, 150, W, Hh)), ent2.crop((0, 150, W, Hh)))
print(res)
