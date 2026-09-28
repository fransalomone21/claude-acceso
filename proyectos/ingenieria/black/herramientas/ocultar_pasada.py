"""(93) VISIBILIDAD POR PASADA: un filtro en el callback de dibujo de la escena.

FUN_001297E0 recorre lo visible con FUN_00273A18(juego+0x4920, R+0xCFD0, 0x1297A0, 0); el callback
FUN_001297A0(nodo, modo) llama al metodo vtable+0x30 de *(nodo+0x34) (personajes: FUN_00133BA0, que dibuja
el modelo, el arma en la mano y los agregados). El filtro (OCULTAR) va en lugar de 0x1297A0 (el lui/addiu de
0x001298F8/0x00129900): con la pantalla partida (DATOS+0x3C != 0) saltea el objeto A en la pasada 1 (sub-raster
x = 0) y en la pasada 2 (x = 320) el objeto B, o el titere si B = 1 (aliado 1, con las guardas de TITERE_MOD).
Cuenta lo que oculto en 0x0046FBF8 (pasada 1) y 0x0046FBFC (pasada 2).

  python herramientas/ocultar_pasada.py sonda        # lanza el fork, arma el coop y mide con capturas y control
"""
import json, os, subprocess, sys, time
from pathlib import Path

H = str(Path(__file__).resolve().parent)
sys.path.insert(0, H)
from mips import ensamblar

OCULTAR = 0x0046FB20
A, B, CNT1, CNT2 = 0x0046FBF0, 0x0046FBF4, 0x0046FBF8, 0x0046FBFC
GANCHO_LUI, GANCHO_ADDIU = 0x001298F8, 0x00129900
ORIG_LUI, ORIG_ADDIU = "lui a2, 0x13", "addiu a2, a2, -0x6860"
J2 = 0x0046CDF0

FUENTE = [
    "lui t0, 0x47", "lw t1, -0x3c4(t0)", "beq t1, zero, SIGUE", "lw t2, 0x34(a0)",
    "lui t3, 0x41", "lw t3, -0xb40(t3)", "ori t4, zero, 0xd400", "addu t3, t3, t4",
    "lw t3, 0x58(t3)", "lw t3, 0x60(t3)", "lh t3, 0x1c(t3)", "bne t3, zero, P2", "nop",
    "lw t1, -0x410(t0)", "bne t1, t2, SIGUE", "nop",
    "lw t1, -0x408(t0)", "addiu t1, t1, 1", "b NO", "sw t1, -0x408(t0)",
    "P2:", "lw t1, -0x40c(t0)", "addiu t3, zero, 1", "bne t1, t3, CMP2", "nop",
    "lui t1, 0x41", "lw t1, -0xaec(t1)", "beq t1, zero, SIGUE", "nop",
    "addiu t1, t1, 0x450", "lw t3, 0x328(t1)", "beq t3, zero, SIGUE", "nop",
    "lw t3, 0x3a4(t1)", "bne t3, zero, SIGUE", "nop",
    "CMP2:", "bne t1, t2, SIGUE", "nop",
    "lw t1, -0x404(t0)", "addiu t1, t1, 1", "b NO", "sw t1, -0x404(t0)",
    "SIGUE:", "j 0x1297a0", "nop",
    "NO:", "jr ra", "addiu v0, zero, 1",
]


def codigo(base=OCULTAR, fuente=FUENTE):
    etiquetas, pc = {}, base
    for t in fuente:
        if t.endswith(":"):
            etiquetas[t[:-1]] = pc
        else:
            pc += 4
    out, pc = [], base
    for t in fuente:
        if t.endswith(":"):
            continue
        partes = t.replace(",", " ").split()
        if partes[-1] in etiquetas:
            t = t[: t.rfind(partes[-1])] + "0x%x" % etiquetas[partes[-1]]
        out.append(ensamblar(t, pc))
        pc += 4
    return out


def ganchos():
    return [(GANCHO_LUI, ensamblar("lui a2, 0x%x" % (OCULTAR + 0x8000 >> 16), GANCHO_LUI)),
            (GANCHO_ADDIU, ensamblar("addiu a2, a2, %d" % ((OCULTAR & 0xFFFF) - (0x10000 if OCULTAR & 0x8000 else 0)),
                                     GANCHO_ADDIU))]


def sonda():
    from pine import Pine
    from PIL import Image, ImageChops, ImageStat
    EXE = r"C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe"
    ISO = r"C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso"
    C = Path(H).parent / "volcados" / "capturas-93"
    C.mkdir(parents=True, exist_ok=True)
    T0 = time.time()

    def log(*a):
        print("[%5.0f s]" % (time.time() - T0), *a, flush=True)

    def run(*a, t=120):
        r = subprocess.run([sys.executable, *a], cwd=H, capture_output=True, text=True, encoding="utf-8",
                           errors="replace", timeout=t)
        log(">>", " ".join(a), "|", r.stdout.strip()[-200:].replace("\n", " / "), r.stderr.strip()[-200:])
        return r

    def cap(n):
        subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                        H + r"\capturar-pantalla.ps1", "-Salida", str(C / n)], capture_output=True)
        return C / n

    run("coop_mod.py", "desactivar")
    subprocess.Popen([EXE, "-fastboot", "-batch", "--", ISO])
    time.sleep(35)
    run("pine.py", "cargarestado", "--slot", "3"); time.sleep(8)
    run("depurador.py", "continuar"); time.sleep(12)
    run("selector_depuracion.py", "vivo")
    run("coop_mod.py", "poner")
    run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    run("selector_depuracion.py", "elegir", "0", "0")
    run("selector_depuracion.py", "aceptar")
    run("coop_mod.py", "mirar", "30", t=90)

    with Pine() as p:
        jota = p.leer32(0x0040F4D0) + 0x30
        g = ganchos()
        orig = [p.leer32(a) for a, _ in g]
        log("ganchos originales", [hex(x) for x in orig], "esperados",
            [hex(ensamblar(ORIG_LUI, GANCHO_LUI)), hex(ensamblar(ORIG_ADDIU, GANCHO_ADDIU))])
        assert orig == [ensamblar(ORIG_LUI, GANCHO_LUI), ensamblar(ORIG_ADDIU, GANCHO_ADDIU)]
    run("depurador.py", "pausar")
    with Pine() as p:
        for i, w in enumerate(codigo()):
            p.escribir32(OCULTAR + 4 * i, w)
        for x in (A, B, CNT1, CNT2):
            p.escribir32(x, 0)
        for a, w in g:
            p.escribir32(a, w)
    run("depurador.py", "continuar")
    res = {"J": hex(jota), "casos": []}
    casos = [("c0", 0, 0), ("t_j2_titere", J2, 1), ("c1", 0, 0), ("t_j2_titere_b", J2, 1),
             ("t_titere_J", J2, jota), ("c2", 0, 0)]
    for nombre, va, vb in casos:
        with Pine() as p:
            p.escribir32(A, va); p.escribir32(B, vb)
            n1, n2 = p.leer32(CNT1), p.leer32(CNT2)
        time.sleep(2.0)
        f = cap(nombre + ".png")
        with Pine() as p:
            d1, d2 = p.leer32(CNT1) - n1, p.leer32(CNT2) - n2
            pos = {k: [round(p.leer_f32(b + 0xA0 + 4 * i), 2) for i in range(3)]
                   for k, b in (("J", jota), ("J2", J2))}
        caso = {"caso": nombre, "A": hex(va), "B": hex(vb), "ocultos_p1_2s": d1, "ocultos_p2_2s": d2,
                "captura": f.name, "pos": pos}
        log(caso)
        res["casos"].append(caso)
    # diferencias por mitad contra c0
    def mitades(n):
        im = Image.open(C / (n + ".png")).convert("L")
        w, h = im.size
        return im.crop((0, 0, w // 2, h)), im.crop((w // 2, 0, w, h))
    base = mitades("c0")
    for caso in res["casos"]:
        m = mitades(caso["caso"])
        caso["dif_izq"] = round(ImageStat.Stat(ImageChops.difference(base[0], m[0])).mean[0], 2)
        caso["dif_der"] = round(ImageStat.Stat(ImageChops.difference(base[1], m[1])).mean[0], 2)
        log(caso["caso"], "dif contra c0: izq", caso["dif_izq"], "der", caso["dif_der"])
    run("depurador.py", "pausar")
    with Pine() as p:
        for (a, _), w in zip(g, orig):
            p.escribir32(a, w)
    run("depurador.py", "continuar")
    (C / "ocultar93.json").write_text(json.dumps(res, indent=1))
    run("coop_mod.py", "activar")
    log("fin")


if __name__ == "__main__":
    if sys.argv[1:] == ["sonda"]:
        sonda()
    else:
        for i, w in enumerate(codigo()):
            print(hex(OCULTAR + 4 * i), "%08x" % w)
        print([(hex(a), "%08x" % w) for a, w in ganchos()])
