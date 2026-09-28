"""(90) que llamada de la escena dibuja el fantasma: jal -> nop de a uno, captura, restaurar. Tira al final."""
import subprocess, sys, time
sys.path.insert(0, r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\herramientas")
from PIL import Image
from pine import Pine

H = r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\herramientas"
C = r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\volcados\capturas-89" + "\\"
SITIOS = {"base": None, "1b0260": 0x001299EC, "1b1dc0": 0x00129A40, "af768_6": 0x00129A50, "1be4c0": 0x00129A6C,
          "1b1e00": 0x00129A74, "1b0ac8": 0x00129AD0, "1ae5a0": 0x00129AD8, "110430": 0x00129AE0,
          "1ae5c8": 0x00129AE8}
if len(sys.argv) > 1:
    SITIOS = {k: v for k, v in SITIOS.items() if k in sys.argv[1:] or k == "base"}


def cap(nombre):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", H + r"\capturar-pantalla.ps1",
                    "-Salida", C + nombre], capture_output=True)


for nombre, sitio in SITIOS.items():
    orig = None
    if sitio:
        with Pine() as p:
            orig = p.leer32(sitio)
            assert orig >> 26 == 3, (nombre, hex(orig))      # es un jal
            p.escribir32(sitio, 0)
    time.sleep(0.8)
    cap("f-%s.png" % nombre)
    if sitio:
        with Pine() as p:
            p.escribir32(sitio, orig)
    time.sleep(0.4)
    print(nombre, "listo", flush=True)
n = list(SITIOS)
W, Hh = 480, 270
t = Image.new("RGB", (W * 2, Hh * ((len(n) + 1) // 2)))
for i, k in enumerate(n):
    t.paste(Image.open(C + "f-%s.png" % k).convert("RGB").resize((W, Hh)), ((i % 2) * W, (i // 2) * Hh))
t.save(C + "f-tira.png")
print(" / ".join(n))
