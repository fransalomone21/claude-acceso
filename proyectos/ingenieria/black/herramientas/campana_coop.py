"""campana_coop.py -- el coop nivel por nivel de la campana, por el pnach solo (bitacora (93), tramo e).

Lanza el fork de pruebas (PCSX2-MCP de Downloads) con el bloque COOP como esta en los ajustes (instalado y
ACTIVO: nada de `poner`), entra a un nivel desde el slot 3 y, con el selector de depuracion, carga uno por uno
los niveles pedidos (unidad 1). Por nivel mide:
  - arma: FASE (0x0046D790) = 2 y ESTADO (0x0046D784) = 3, y en cuantos segundos desde aceptar;
  - titere: el aliado 1 existe con bando 0 y TITERES sube;
  - pantalla: el stub de la pantalla corre (DATOS+0x88 sube) y la pasada 2 oculta al titere (0x0046FBFC sube);
  - camina: `coop_mod.py manos 2` (metros de J2);
  - la carga siguiente no cuelga: el nivel siguiente se carga desde este (la segunda carga de cada uno).
Si una carga cuelga (PINE no contesta o no se arma en 90 s) lo anota y relanza el fork.

    python herramientas/campana_coop.py 1 2 3 4 5 6 7 0     # indices de la tabla del selector
Salida: volcados/campana/campana.json y una captura por nivel.
Niveles (tabla *(sesion+0x2106C), (78)): 0 City Streets, 1 Wilderness, 2 Town, 3 Steelworks, 4 Asylum,
5 Docks, 6 City Bridge, 7 Gulag. 8..11 son de prueba (97, 98, 99, 96): no se piden.
"""
import json, subprocess, sys, time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
from salida import tolerar_salida_pobre  # noqa: E402
import coop_mod as cm  # noqa: E402
import pantalla_dividida as pd  # noqa: E402
import ocultar_pasada as oc  # noqa: E402
import sondas_coop as sc  # noqa: E402

tolerar_salida_pobre()   # (93y) tambien cuando otra herramienta importa esto: log() imprime la salida de otras

EXE = r"C:\Users\frans\Downloads\PCSX2-MCP-v1.0.0-win64\PCSX2-MCP-v1.0.0-win64\pcsx2-qt.exe"
ISO = r"C:\Users\frans\Desktop\Juegos\Juegos de emulador\PS2\BLACK\ISOs\Black.iso"
NOMBRES = ["City Streets", "Wilderness", "Town", "Steelworks", "Asylum", "Docks", "City Bridge", "Gulag"]
SAL = H.parent / "volcados" / "campana"
T0 = time.time()


def log(*a):
    print("[%5.0f s]" % (time.time() - T0), *a, flush=True)


def run(*a, t=120):
    try:
        r = subprocess.run([sys.executable, *a], cwd=str(H), capture_output=True, text=True, encoding="utf-8",
                           errors="replace", timeout=t)
    except subprocess.TimeoutExpired:
        log(">>", " ".join(a), "| TIMEOUT")
        return None
    log(">>", " ".join(a), "|", r.stdout.strip()[-160:].replace("\n", " / "), r.stderr.strip()[-160:])
    return r


def cap(nombre):
    subprocess.run(["powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
                    str(H / "capturar-pantalla.ps1"), "-Salida", str(SAL / nombre)], capture_output=True)


def matar_fork():
    subprocess.run(["powershell", "-NoProfile", "-Command",
                    "Get-Process pcsx2* | ? { $_.Path -like '*Downloads\\PCSX2-MCP*' } | Stop-Process"],
                   capture_output=True)
    time.sleep(2)


def lanzar():
    matar_fork()
    subprocess.Popen([EXE, "-fastboot", "-batch", "--", ISO])
    time.sleep(35)
    run("pine.py", "cargarestado", "--slot", "3"); time.sleep(8)
    run("depurador.py", "continuar"); time.sleep(12)
    r = run("selector_depuracion.py", "vivo")
    return r is not None and '"vivo": true' in r.stdout


def leer(p, f):
    try:
        return f(p)
    except Exception as ex:  # noqa: BLE001
        return "error: %s" % ex


def probar_nivel(n):
    res = {"indice": n, "nombre": NOMBRES[n]}
    run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    run("selector_depuracion.py", "elegir", str(n), "0")
    run("selector_depuracion.py", "aceptar")
    t_acept = time.time()
    armado, ultimo = None, None
    while time.time() - t_acept < 90:
        try:
            with Pine() as p:
                e = cm.leer_estado(p)
        except Exception as ex:  # noqa: BLE001
            e = {"error": str(ex)}
        ultimo = e
        if e.get("fase") == 2 and e.get("estado") == 3:
            armado = round(time.time() - t_acept, 1)
            break
        time.sleep(1)
    res["armado_s"] = armado
    res["estado"] = ultimo
    if armado is None:
        res["cuelga_o_no_arma"] = True
        return res
    # se espera el juego: el por cuadro de J2 corre (CONTADOR sube). (93e) Sin apretar nada: los "carteles
    # eternos" eran el EE caido (93c), y Start en pleno juego abre la pausa y frena el por cuadro.
    t_juego, starts = time.time(), 0
    while time.time() - t_juego < 120:
        with Pine() as p:
            t_a = p.leer32(cm.CONTADOR)
        time.sleep(1.5)
        with Pine() as p:
            if p.leer32(cm.CONTADOR) - t_a > 5:
                break
    else:
        res["juego_no_arranca"] = True
    res["juego_s"] = round(time.time() - t_acept, 1)
    res["starts"] = starts
    cap("n%d-inicio.png" % n)
    time.sleep(8)   # que termine el fundido y el titere copie
    with Pine() as p:
        al = cm.aliado(p)
        res["titere_act"] = hex(p.leer32(cm.TITERE_ACT))   # (93h) 0 = el stub no encontro aliado vivo
        res["aliado"] = hex(al) if al else None
        if al:
            res["aliado_tipo"] = hex(p.leer32(al + 0x328))
            res["aliado_bando"] = p.leer32(al + 0x3A4)
        t1, c1, o1a, o2a = p.leer32(cm.TITERES), p.leer32(pd.DATOS + 0x88), p.leer32(oc.CNT1), p.leer32(oc.CNT2)
    time.sleep(2)
    with Pine() as p:
        res["titeres_2s"] = p.leer32(cm.TITERES) - t1
        res["pantalla_llamadas_2s"] = p.leer32(pd.DATOS + 0x88) - c1
        res["ocultos_p1_2s"] = p.leer32(oc.CNT1) - o1a
        res["ocultos_p2_2s"] = p.leer32(oc.CNT2) - o2a
        # (93y) la ranura 3 (solo si se instalo con --con-r3; si no, todo en 0 y J2+0x330 = la ranura de J)
        pers = p.leer32(0x0040F50C)
        res["r3"] = {"armada": p.leer32(cm.R3_ARMADA), "cargas": p.leer32(cm.R3_CARGAS),
                     "reapuntes": p.leer32(cm.R3_REAPUNTES), "desvios": p.leer32(cm.R3_DESVIOS),
                     "bajas": p.leer32(cm.R3_BAJAS), "J2_330": hex(p.leer32(cm.cj.J2 + 0x330)),
                     "J_330": hex(p.leer32(cm.cj.J + 0x330)), "duenio_R3": hex(p.leer32(cm.R3)),
                     "duenio_r0": hex(p.leer32(pers + 0x470)) if pers else None,
                     "J": hex(cm.cj.J), "J2": hex(cm.cj.J2)}
    cap("n%d-quieto.png" % n)
    r = run("coop_mod.py", "manos", "2")
    try:
        m = json.loads(r.stdout.strip().splitlines()[-1])
        res["manos"] = {k: m.get(k) for k in ("metros", "aliado_J2_final_m", "aliado_J2_max_m", "titeres")}
    except Exception as ex:  # noqa: BLE001
        res["manos"] = "error: %s" % ex
    cap("n%d-camino.png" % n)
    r = run("selector_depuracion.py", "vivo")
    res["vivo_despues"] = r is not None and '"vivo": true' in r.stdout
    return res


def entregar_a_fran():
    """(114) Despues de lanzar() + probar_nivel(), el control 1 de J queda en el mando FALSO (el selector lo usa):
    Fran no puede mover a J con nada. Antes de pedirle que juegue, se devuelve al mando real y se MIDE."""
    with Pine() as p:
        sc.falso_quitar(p)
        ok = p.leer32(sc.CTRL1 + 0xC) == sc.MANDO1_REAL
    log("control 1 de J en el mando real:", ok)
    return ok


def probar_sin_mod(n):
    """El CONTROL: la misma carga con el bloque apagado. Juego = el eje del falso gira la vista (vivo)."""
    res = {"indice": n, "nombre": NOMBRES[n], "sin_mod": True}
    run("selector_depuracion.py", "pedir-frontend", "--bandera", "0", "--segundos", "7")
    run("selector_depuracion.py", "elegir", str(n), "0")
    run("selector_depuracion.py", "aceptar")
    t0, starts, juego = time.time(), 0, None
    while time.time() - t0 < 240:
        time.sleep(8)
        r = run("selector_depuracion.py", "vivo", t=30)
        if r is not None and '"vivo": true' in r.stdout and time.time() - t0 > 15:
            juego = round(time.time() - t0, 1)
            break
        if time.time() - t0 > 30:
            with Pine() as p:
                sc.poner_boton(p, 8, True); time.sleep(0.15); sc.poner_boton(p, 8, False)
            starts += 1
    res["juego_s"], res["starts"] = juego, starts
    cap("s%d-inicio.png" % n)
    return res


def pcsx2_de_fran_abierto() -> bool:
    """(93y) El 2.8.0 de Fran comparte PINE 28011 y la tarjeta de memoria con el fork: con el abierto, los
    pedidos de esta regresion le llegan a SU partida (paso: cargarestado --slot 3 fue a la de el)."""
    r = subprocess.run(["powershell", "-NoProfile", "-Command",
                        "@(Get-Process pcsx2* -ErrorAction SilentlyContinue | "
                        "? { $_.Path -notlike '*Downloads\\PCSX2-MCP*' }).Count"],
                       capture_output=True, text=True)
    return r.stdout.strip() not in ("", "0")


def main():
    if "-h" in sys.argv or "--help" in sys.argv:   # (93y) sin esto, '--help' corria la regresion entera
        print(__doc__); return 0
    tolerar_salida_pobre()
    if pcsx2_de_fran_abierto():
        log("el PCSX2 de Fran esta abierto: cerralo antes (comparte PINE y la tarjeta con el fork)"); return 1
    sin_mod = "--sin-mod" in sys.argv
    niveles = [int(x) for x in sys.argv[1:] if not x.startswith("--")] or [1, 2, 3, 4, 5, 6, 7, 0]
    if sin_mod:
        run("coop_mod.py", "desactivar")
        SAL.mkdir(parents=True, exist_ok=True)
        out = {}
        for n in niveles:
            if not lanzar():
                log("el fork no quedo vivo"); break
            out[str(n)] = probar_sin_mod(n)
            log(json.dumps(out[str(n)], ensure_ascii=False))
            (SAL / "control-sin-mod.json").write_text(json.dumps(out, indent=1, ensure_ascii=False))
        matar_fork()
        run("coop_mod.py", "activar")
        return 0
    assert all(0 <= n <= 7 for n in niveles), "solo la campana (0..7)"
    SAL.mkdir(parents=True, exist_ok=True)
    arch = SAL / "campana.json"
    todo = json.loads(arch.read_text()) if arch.exists() else {}
    if not lanzar():
        log("el fork no quedo vivo"); return 1
    for n in niveles:
        log("== nivel", n, NOMBRES[n])
        res = probar_nivel(n)
        res["fecha"] = time.strftime("%Y-%m-%d %H:%M")
        log(json.dumps(res, ensure_ascii=False))
        todo[str(n)] = res
        arch.write_text(json.dumps(todo, indent=1, ensure_ascii=False))
        if res.get("cuelga_o_no_arma") or not res.get("vivo_despues"):
            log("relanzando el fork")
            if not lanzar():
                log("el fork no quedo vivo"); return 1
    matar_fork()
    log("fin")
    return 0


if __name__ == "__main__":
    sys.exit(main())
