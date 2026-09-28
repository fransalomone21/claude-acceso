"""(93o) La TERCERA RANURA para J2, prototipo por PINE (diseno: docs/15-tercera-ranura.md).

Arma una ranura de primera persona propia para J2 con las funciones del juego, como el constructor arma r0/r1:
  una vez:  submonton 6 -> FUN_00343fc8(R3+0x10) -> FUN_001a4ff0(R3, 1) -> soltar el submonton
  cargar:   FUN_001a51c8(R3, J2, pers+0x398+i*0x6C), i = (signed char) J2+0x2C3
El codigo corre UNA vez desde el gancho por cuadro (0x00129574, desviado a UNA en pausa) y sigue al stub.

Control en la misma corrida: J2 dispara y recarga con la ranura COMPARTIDA (8 capturas), despues se arma la
ranura 3 y se repite. Prediccion: con la ranura 3 la mitad de J queda quieta y J2 tiene brazos propios.
Salida: volcados/campana/ranura3.json y ranura3-{control,prueba}-k.png
  python herramientas/ranura3.py
"""
import json, subprocess, sys, time
from pathlib import Path
H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
import campana_coop as cc  # noqa: E402
import coop_mod as cm  # noqa: E402
import clon_jugador as cj  # noqa: E402
import gancho as g  # noqa: E402
import jugador2 as j2  # noqa: E402
from ocultar_pasada import codigo  # noqa: E402
from aislar93 import boton2, DISPARAR, municion  # noqa: E402
from mips import ensamblar  # noqa: E402
from pine import Pine  # noqa: E402

PEDIDO, ARMADA, DBG_AC, DBG_330 = 0x0046E0B0, 0x0046E0B4, 0x0046E0B8, 0x0046E0BC
R3, TAM = 0x0046E100, 0x240
UNA = 0x0046E340
PERS_PTR, J2 = 0x0040F50C, 0x0046CDF0

FUENTE = [
    "lui t0, 0x47", "lw t1, -0x1f50(t0)", "addiu t2, zero, 1", "bne t1, t2, FIN", "nop",
    "addiu sp, sp, -0x40", "sd ra, 0(sp)", "sd a0, 8(sp)", "sd a1, 0x10(sp)", "sd a2, 0x18(sp)",
    "sd a3, 0x20(sp)", "sd s0, 0x28(sp)", "sd s1, 0x30(sp)",
    "lui s0, 0x47", "addiu s0, s0, -0x1f00",
    "lw t1, -0x1f4c(t0)", "bne t1, zero, CARGAR", "nop",
    # armar una vez: submonton 6 (el persistente), como FUN_001ab780
    "lui a0, 0x41", "addiu a0, a0, -0xf10", "addiu a1, zero, 6", "jal 0x107ab8", "addiu a2, zero, 0",
    "jal 0x343fc8", "addiu a0, s0, 0x10",
    "move a0, s0", "jal 0x1a4ff0", "addiu a1, zero, 1",
    "lui a0, 0x41", "addiu a0, a0, -0xf10", "addiu a1, zero, 6", "jal 0x107b08", "addiu a2, zero, 0",
    "lui t0, 0x47", "addiu t1, zero, 1", "sw t1, -0x1f4c(t0)",
    "CARGAR:",
    "lw t1, 0xac(s0)", "addiu t2, zero, -1", "beq t1, t2, MAL", "nop",
    "lui t0, 0x41", "lw s1, -0xaf4(t0)",
    "lui a1, 0x47", "addiu a1, a1, -0x3210", "lb t2, 0x2c3(a1)", "addiu t3, zero, 0x6c",
    "mult t2, t2, t3", "addu a2, s1, t2", "addiu a2, a2, 0x398",
    "jal 0x1a51c8", "move a0, s0",
    "lui t0, 0x47", "lw t1, 0xac(s0)", "sw t1, -0x1f48(t0)",
    "lui a1, 0x47", "addiu a1, a1, -0x3210", "lw t1, 0x330(a1)", "sw t1, -0x1f44(t0)",
    "addiu t1, zero, 2", "b SALIR", "sw t1, -0x1f50(t0)",
    "MAL:", "lui t0, 0x47", "addiu t1, zero, 3", "sw t1, -0x1f50(t0)",
    "SALIR:",
    "ld ra, 0(sp)", "ld a0, 8(sp)", "ld a1, 0x10(sp)", "ld a2, 0x18(sp)", "ld a3, 0x20(sp)",
    "ld s0, 0x28(sp)", "ld s1, 0x30(sp)", "addiu sp, sp, 0x40",
    "FIN:", "j 0x%x" % j2.STUB, "nop",
]


def dep(accion):
    subprocess.run([sys.executable, str(H / "depurador.py"), accion], capture_output=True)


def pool(p):
    pers = p.leer32(PERS_PTR)
    curs, n = p.leer32(pers + 0x8FC + 4), p.leer32(pers + 0x8FC + 0x10)
    libres = [i for i in range(n) if p.leer32(curs + 4 * i) == 0]
    sub6 = 0x40F0F4 + 6 * 0x24
    return {"pers": hex(pers), "F4": p.leer32(pers + 0xF4), "bloques_libres": libres,
            "sub6_libre": p.leer32(sub6 + 0xC) - p.leer32(sub6 + 0x10), "submonton": p.leer32(0x40F4A4)}


def tanda(nombre, J):
    """J2 sostiene disparar 4 s (vacia y recarga); 8 capturas cada 0,5 s. J quieto."""
    serie = []
    with Pine() as p:
        boton2(p, DISPARAR, True)
    for k in range(8):
        time.sleep(0.5)
        cc.cap("ranura3-%s-%d.png" % (nombre, k))
        with Pine() as p:
            serie.append({"k": k, "J2": municion(p, J2), "J": municion(p, J)})
    with Pine() as p:
        boton2(p, DISPARAR, False)
    time.sleep(3)
    return serie


def mitades(nombre):
    """Diferencia media de cada mitad contra la captura 0 de la tanda (0 = quieta)."""
    from PIL import Image, ImageChops, ImageStat
    ims = [Image.open(cc.SAL / ("ranura3-%s-%d.png" % (nombre, k))).convert("L") for k in range(8)]
    w, h = ims[0].size
    out = []
    for im in ims[1:]:
        d = []
        for caja in ((0, 0, w // 2, h), (w // 2, 0, w, h)):
            d.append(round(ImageStat.Stat(ImageChops.difference(ims[0].crop(caja), im.crop(caja))).mean[0], 2))
        out.append(d)
    return out


def main():
    res = {}
    prog = codigo(UNA, FUENTE)
    if not cc.lanzar():
        raise SystemExit("fork no vivo")
    cc.run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    cc.run("selector_depuracion.py", "elegir", "0", "0")
    cc.run("selector_depuracion.py", "aceptar")
    t0 = time.time()
    while time.time() - t0 < 120:
        try:
            with Pine() as p:
                a = p.leer32(cm.CONTADOR)
            time.sleep(1.5)
            with Pine() as p:
                if p.leer32(cm.CONTADOR) - a > 5 and p.leer32(cm.FASE) == 2:
                    break
        except Exception:  # noqa: BLE001
            time.sleep(1)
    time.sleep(8)
    cc.run("coop_mod.py", "manos", "0.5")
    with Pine() as p:
        J = p.leer32(cj.JUEGO_PTR) + 0x30
        gancho_esperado = ensamblar("jal 0x%x" % j2.STUB, g.SITIO)
        res["gancho_ok"] = p.leer32(g.SITIO) == gancho_esperado
        res["antes"] = {"pool": pool(p), "J_330": hex(p.leer32(J + 0x330)), "J2_330": hex(p.leer32(J2 + 0x330)),
                        "J2_2C3": p.leer8(J2 + 0x2C3), "J_2C3": p.leer8(J + 0x2C3)}
    if not res["gancho_ok"]:
        (cc.SAL / "ranura3.json").write_text(json.dumps(res, indent=1))
        cc.matar_fork()
        raise SystemExit("el gancho por cuadro no es el esperado")
    res["control"] = tanda("control", J)
    # armar la ranura 3: en pausa se escribe R3 en cero, el codigo y el desvio del gancho
    dep("pausar")
    with Pine() as p:
        for o in range(0, TAM, 4):
            p.escribir32(R3 + o, 0)
        for dato in (PEDIDO, ARMADA, DBG_AC, DBG_330):
            p.escribir32(dato, 0)
        for i, w in enumerate(prog):
            p.escribir32(UNA + 4 * i, w)
        escrito = all(p.leer32(UNA + 4 * i) == w for i, w in enumerate(prog))
        p.escribir32(g.SITIO, ensamblar("jal 0x%x" % UNA, g.SITIO))
    dep("continuar")
    res["codigo_palabras"], res["codigo_escrito"] = len(prog), escrito
    with Pine() as p:
        p.escribir32(PEDIDO, 1)
        t0 = time.time()
        while p.leer32(PEDIDO) == 1 and time.time() - t0 < 5:
            time.sleep(0.05)
        res["pedido"] = p.leer32(PEDIDO)
    dep("pausar")
    with Pine() as p:
        p.escribir32(g.SITIO, gancho_esperado)
    dep("continuar")
    time.sleep(1)
    with Pine() as p:
        res["despues"] = {"pool": pool(p), "R3_AC": hex(p.leer32(DBG_AC)), "J2_330": hex(p.leer32(J2 + 0x330)),
                          "R3_dueno": hex(p.leer32(R3)), "R3_50": hex(p.leer32(R3 + 0x50)),
                          "R3_54": hex(p.leer32(R3 + 0x54)), "R3_B8": p.leer8(R3 + 0xB8),
                          "R3_nombre": bytes(p.leer8(R3 + 0x5C + i) for i in range(13)).split(b"\0")[0].decode("latin-1"),
                          "r0_dueno": hex(p.leer32(p.leer32(PERS_PTR) + 0x470)), "J_330": hex(p.leer32(J + 0x330))}
    if res["pedido"] == 2:
        res["prueba"] = tanda("prueba", J)
    r = cc.run("selector_depuracion.py", "vivo")
    res["vivo"] = r is not None and '"vivo": true' in r.stdout
    try:
        res["mitades_control"] = mitades("control")
        if "prueba" in res:
            res["mitades_prueba"] = mitades("prueba")
    except Exception as ex:  # noqa: BLE001
        res["mitades_error"] = str(ex)
    (cc.SAL / "ranura3.json").write_text(json.dumps(res, indent=1))
    print(json.dumps({k: v for k, v in res.items() if k not in ("control", "prueba")}, indent=1))
    cc.matar_fork()


if __name__ == "__main__":
    main()
