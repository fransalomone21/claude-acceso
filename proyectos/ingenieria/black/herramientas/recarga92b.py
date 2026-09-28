"""(92) la recarga de J2 en el stub, en el fork en el puerto 28012 (la partida de Fran tiene el 28011).
Control: jal del llenado y 'sw zero,0xd8' en nop (en pausa) -> el arma trabada tiene que seguir trabada.
Prueba: repuestos -> tiene que pasar a estado 0 con el cargador lleno y la reserva descontada."""
import json, os, re, shutil, subprocess, sys, time
from pathlib import Path
os.environ["BLACK_PINE_SLOT"] = "28012"
H = r"C:\Users\frans\Desktop\claude-acceso\proyectos\ingenieria\black\herramientas"
sys.path.insert(0, H)
from pine import Pine
from mips import ensamblar

EXE = r"C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe"
ISO = r"C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso"
INI = Path(os.environ["USERPROFILE"]) / r"Documents\PCSX2\inis\PCSX2.ini"
SCR = Path(__file__).parent
J2 = 0x0046CDF0
T0 = time.time()


def log(*a):
    print("[%5.0f s]" % (time.time() - T0), *a, flush=True)


def run(*a, t=120):
    r = subprocess.run([sys.executable, *a], cwd=H, capture_output=True, text=True, encoding="utf-8",
                       errors="replace", timeout=t)
    log(">>", " ".join(a), "|", r.stdout.strip()[-250:].replace("\n", " / "), r.stderr.strip()[-200:])
    return r


def ini_slot(n):
    t = INI.read_text(encoding="utf-8")
    t2 = re.sub(r"(?m)^PINESlot = \d+", "PINESlot = %d" % n, t)
    tarjetas = "true" if n == 28011 else "false"
    t2 = re.sub(r"(?m)^(Slot[12]_Enable) = \w+", r"\1 = " + tarjetas, t2)
    INI.write_text(t2, encoding="utf-8")


def arma(p):
    a = p.leer32(J2 + 0x2A4); f4 = p.leer32(a + 0xF4); ec = p.leer32(a + 0xEC)
    return a, f4, ec


def leer(p, tag):
    a, f4, ec = arma(p)
    t = p.leer32(ec + 0x64)
    d = dict(D8=p.leer32(a + 0xD8), cargador=p.leer16(f4 + 0x18), reserva=p.leer16(J2 + 0x280 + 2 * t),
             cuenta=p.leer32(0x0046D7D0))
    log(tag, d)
    return d


if "--solo-probar" not in sys.argv:
    shutil.copy(INI, SCR / "PCSX2.ini.respaldo")
    ini_slot(28012)
    run("coop_mod.py", "desactivar")
    subprocess.Popen([EXE, "-fastboot", "-batch", "--", ISO])
    time.sleep(30)
    ini_slot(28011)
    run("coop_mod.py", "activar")
    log("ini devuelto a 28011 con tarjetas; bloque reactivado")
    time.sleep(5)
    run("pine.py", "cargarestado", "--slot", "3"); time.sleep(8)
    run("depurador.py", "continuar"); time.sleep(12)
    run("selector_depuracion.py", "vivo")
    run("coop_mod.py", "poner")
    run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    run("selector_depuracion.py", "elegir", "0", "0")
    run("selector_depuracion.py", "aceptar")
    run("coop_mod.py", "mirar", "30", t=90)

res = {}
with Pine() as p:
    base = p.leer32(0x0046D800)
    sitios = [x for x in range(0x0046D800, 0x0046D9F0, 4) if p.leer32(x) == ensamblar("jal 0x156d60", x)]
    log("jal del llenado en:", [hex(x) for x in sitios])
    assert len(sitios) == 1
    s = sitios[0]
    sw_d8 = s - 4
    assert p.leer32(sw_d8) == ensamblar("sw zero, 0xd8(t0)", sw_d8), hex(p.leer32(sw_d8))
    orig = (p.leer32(sw_d8), p.leer32(s))
    res["antes"] = leer(p, "antes")

def trabar_y_mirar(tag, seg=6):
    with Pine() as p:
        a, f4, ec = arma(p)
        p.escribir16(f4 + 0x18, 0); p.escribir32(a + 0xD8, 4)
        out = [leer(p, tag + " t0")]
        for i in range(seg * 2):
            time.sleep(0.5)
            out.append(leer(p, "%s +%.1f" % (tag, (i + 1) / 2)))
    return out

# control: sin llenado ni cambio de estado
run("depurador.py", "pausar")
with Pine() as p:
    p.escribir32(sw_d8, 0); p.escribir32(s, 0)
run("depurador.py", "continuar"); time.sleep(1)
res["control"] = trabar_y_mirar("control")
run("depurador.py", "pausar")
with Pine() as p:
    p.escribir32(sw_d8, orig[0]); p.escribir32(s, orig[1])
run("depurador.py", "continuar"); time.sleep(1)
res["prueba"] = trabar_y_mirar("prueba")
res["prueba2"] = trabar_y_mirar("prueba2")
(SCR / "recarga92b.json").write_text(json.dumps(res, indent=1))
log("fin")
