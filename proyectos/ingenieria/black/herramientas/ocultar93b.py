"""(93b) sobre el fork ya armado por `ocultar_pasada.py sonda` (J2 corriendo, filtro en memoria, ganchos repuestos):
(1) ocultar a cada jugador en SU pasada (A = J, B = J2): si los brazos/arma de primera persona son el dibujo
del personaje, desaparecen de la mitad propia; control A = B = 0 antes y despues.
(2) J2 en la vista de J: se gira la mira de J (sondas_coop.MIRA) de a 45 grados con A = J2 y se cuenta
cuantas veces el filtro lo saltea en la pasada 1; captura con A = J2 y con A = 0 en el mejor yaw."""
import json, subprocess, sys, time
from pathlib import Path
H = str(Path(__file__).resolve().parent)
sys.path.insert(0, H)
from pine import Pine
import sondas_coop as sc
import ocultar_pasada as oc
from PIL import Image, ImageChops, ImageStat

C = Path(H).parent / "volcados" / "capturas-93"
T0 = time.time()


def log(*a):
    print("[%5.0f s]" % (time.time() - T0), *a, flush=True)


def run(*a):
    r = subprocess.run([sys.executable, *a], cwd=H, capture_output=True, text=True, encoding="utf-8", errors="replace")
    log(">>", " ".join(a), "|", r.stdout.strip()[-120:])


def cap(n):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                    H + r"\capturar-pantalla.ps1", "-Salida", str(C / n)], capture_output=True)


def mitades(n):
    im = Image.open(C / (n + ".png")).convert("L"); w, h = im.size
    return im.crop((0, 0, w // 2, h)), im.crop((w // 2, 0, w, h))


def dif(a, b):
    ma, mb = mitades(a), mitades(b)
    return [round(ImageStat.Stat(ImageChops.difference(ma[k], mb[k])).mean[0], 2) for k in (0, 1)]


def caso(nombre, va, vb, seg=1.5):
    with Pine() as p:
        p.escribir32(oc.A, va); p.escribir32(oc.B, vb)
        n1, n2 = p.leer32(oc.CNT1), p.leer32(oc.CNT2)
    time.sleep(seg)
    if nombre:
        cap(nombre + ".png")
    with Pine() as p:
        return p.leer32(oc.CNT1) - n1, p.leer32(oc.CNT2) - n2


with Pine() as p:
    J = p.leer32(0x0040F4D0) + 0x30
    assert p.leer32(oc.OCULTAR + 4) == oc.codigo()[1]
run("depurador.py", "pausar")
with Pine() as p:
    for a, w in oc.ganchos():
        p.escribir32(a, w)
run("depurador.py", "continuar")
res = {}
res["b_c0"] = caso("b_c0", 0, 0)
res["b_propios"] = caso("b_propios", J, oc.J2)
res["b_c1"] = caso("b_c1", 0, 0)
log(res)
for n in ("b_propios", "b_c1"):
    log(n, "dif contra b_c0 (izq, der):", dif("b_c0", n))
with Pine() as p:
    y0 = p.leer_f32(sc.MIRA)
barrido = []
for k in range(8):
    with Pine() as p:
        p.escribir_f32(sc.MIRA, y0 + 45 * k)
    time.sleep(0.3)
    barrido.append((45 * k, caso(None, oc.J2, 0, 1.0)[0]))
log("barrido yaw (+grados, ocultos p1 en 1 s):", barrido)
mejor = max(barrido, key=lambda x: x[1])[0]
with Pine() as p:
    p.escribir_f32(sc.MIRA, y0 + mejor)
time.sleep(0.5)
res["v_c0"] = caso("v_c0", 0, 0)
res["v_j2"] = caso("v_j2", oc.J2, 1)
res["v_c1"] = caso("v_c1", 0, 0)
log(res, "yaw", y0 + mejor)
for n in ("v_j2", "v_c1"):
    log(n, "dif contra v_c0 (izq, der):", dif("v_c0", n))
res["barrido"] = barrido
(C / "ocultar93b.json").write_text(json.dumps(res, indent=1))
imgs = [Image.open(C / (n + ".png")).convert("RGB").resize((960, 540)) for n in
        ("b_c0", "b_propios", "v_c0", "v_j2")]
t = Image.new("RGB", (960, 540 * 4))
for i, im in enumerate(imgs):
    t.paste(im, (0, 540 * i))
t.save(C / "tira-b.png")
log("fin (ganchos quedan puestos)")
