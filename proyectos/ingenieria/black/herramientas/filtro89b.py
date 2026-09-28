"""(89b) reponer la pantalla con el filtro (sin riesgo) y comparar: filtro / original / nop."""
import json, subprocess, sys, time
H = r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\herramientas"
sys.path.insert(0, H)
from PIL import Image, ImageChops, ImageStat
from pine import Pine
from mips import ensamblar
import pantalla_dividida as pd

C = r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\volcados\capturas-89" + "\\"
ORIG = ensamblar("jal 0x1b0ac8", pd.SITIO_FILTRO)
FILT = ensamblar("jal 0x%x" % pd.FILTRO, pd.SITIO_FILTRO)


def run(*a):
    r = subprocess.run([sys.executable, *a], cwd=H, capture_output=True, text=True, encoding="utf-8", errors="replace")
    print(">>", " ".join(a), r.stdout.strip()[-300:], r.stderr.strip()[-300:], flush=True)


def cap(n):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", H + r"\capturar-pantalla.ps1",
                    "-Salida", C + n], capture_output=True)
    return Image.open(C + n).convert("L")


if "reponer" in sys.argv:
    run("pantalla_dividida.py", "quitar")
    time.sleep(0.5)
    run("depurador.py", "pausar")
    run("pantalla_dividida.py", "poner")
    with Pine() as p:
        for o in (0x80, 0x94, 0x38):
            p.escribir32(pd.DATOS + o, 1)
    run("depurador.py", "continuar")
    run("selector_depuracion.py", "vivo")

imgs = {}
for nombre, palabra in (("filtro", FILT), ("original", ORIG), ("nop", 0), ("filtro-2", FILT)):
    with Pine() as p:
        p.escribir32(pd.SITIO_FILTRO, palabra)
    time.sleep(0.8)
    imgs[nombre] = cap("g-%s.png" % nombre)
with Pine() as p:
    p.escribir32(pd.SITIO_FILTRO, FILT)
W, Hh = imgs["nop"].size
caja = (0, 150, W, Hh)
dif = lambda a, b: round(ImageStat.Stat(ImageChops.difference(imgs[a].crop(caja), imgs[b].crop(caja))).mean[0], 1)
print(json.dumps({"filtro_vs_nop": dif("filtro", "nop"), "original_vs_nop": dif("original", "nop"),
                  "filtro_vs_filtro2 (ruido)": dif("filtro", "filtro-2"), "filtro_vs_original": dif("filtro", "original")}))
t = Image.new("RGB", (960, 540 * 2))
for i, k in enumerate(("filtro", "original", "nop", "filtro-2")):
    t.paste(Image.open(C + "g-%s.png" % k).convert("RGB").resize((480, 270)), ((i % 2) * 480, (i // 2) * 270))
t.crop((0, 0, 960, 540)).save(C + "g-tira.png")
