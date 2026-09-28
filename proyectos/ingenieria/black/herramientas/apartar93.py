"""(93c) Hipotesis: el cuelgue de los niveles con cartel (FUN_0033DD98, mundo de colision) es J2 construido en
EL MISMO PUNTO que J (FUN_0012BD98 le da la aparicion de J). Prueba por PINE: en cuanto FASE (0x0046D790) = 2
(J2 construido, antes de que el por cuadro le ate el controlador a los ~30 cuadros) se pausa y se corre J2
`dx` metros en x (+0xA0, +0x100, +0x190); despues se espera el juego (TITERES sube). Control: dx = 0.
    python herramientas/apartar93.py <nivel> <dx>
Salida: volcados/campana/apartar93-n<nivel>-dx<dx>.json"""
import json, subprocess, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
from pine import Pine  # noqa: E402

nivel, dx = int(sys.argv[1]), float(sys.argv[2])
res = {"nivel": nivel, "dx": dx}
if not cc.lanzar():
    raise SystemExit("fork no vivo")
cc.run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
cc.run("selector_depuracion.py", "elegir", str(nivel), "0")
cc.run("selector_depuracion.py", "aceptar")
t0 = time.time()
with Pine() as p:
    while time.time() - t0 < 90 and p.leer32(cm.FASE) != 2:
        time.sleep(0.005)
    res["fase2_s"] = round(time.time() - t0, 2)
    res["estado_al_ver"] = p.leer32(cm.ESTADO)
subprocess.run([sys.executable, str(H / "depurador.py"), "pausar"], capture_output=True)
with Pine() as p:
    res["J"] = list(cj.pos(p, cj.J)); res["J2_antes"] = list(cj.pos(p, cj.J2))
    res["estado_en_pausa"] = p.leer32(cm.ESTADO)
    if dx:
        for off in (0xA0, 0x100, 0x190):
            p.escribir_f32(cj.J2 + off, p.leer_f32(cj.J2 + off) + dx)
    res["J2_despues"] = list(cj.pos(p, cj.J2))
subprocess.run([sys.executable, str(H / "depurador.py"), "continuar"], capture_output=True)
juego = None
while time.time() - t0 < 120:
    with Pine() as p:
        a = p.leer32(cm.TITERES)
    time.sleep(1.5)
    with Pine() as p:
        if p.leer32(cm.TITERES) - a > 30:
            juego = round(time.time() - t0, 1)
            res["J2_en_juego"] = list(cj.pos(p, cj.J2)); res["J_en_juego"] = list(cj.pos(p, cj.J))
            break
res["juego_s"] = juego
cc.cap("apartar-n%d-dx%g.png" % (nivel, dx))
if juego:
    r = cc.run("coop_mod.py", "manos", "2")
    res["manos"] = r.stdout.strip()[-300:] if r else None
(cc.SAL / ("apartar93-n%d-dx%g.json" % (nivel, dx))).write_text(json.dumps(res, indent=1))
print(json.dumps(res))
