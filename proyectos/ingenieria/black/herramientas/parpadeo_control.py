#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
parpadeo_control.py -- (93y) el arreglo del parpadeo de (93v), MEDIDO con su control.

(93t): la mitad de J2 parpadea (vista B = comprimida a 0,5 en horizontal) cuando J2 dispara, porque el parche
comunitario 'Widescreen 16:9' reescribe en cada cuadro la proporcion que el stub pone a la mitad. (93v): el
acceso COOP lo apaga y el bloque trae su propia pantalla ancha. (93y): apagarlo en los ajustes no alcanzaba (lo
prendia EnableWideScreenPatches global); ahora el acceso lo apaga tambien por juego.

    python herramientas/parpadeo_control.py coop      # los ajustes como los deja el acceso COOP
    python herramientas/parpadeo_control.py control   # + 'Widescreen 16:9' prendido a mano (vuelve la carrera)
Lanza el fork, carga City Streets (selector), J2 quieto: una captura de referencia; despues J2 dispara sin
parar (el cargador se rellena por PINE) y se toman N capturas. Las clasifica parpadeo_escala.py.
Prediccion: coop 0 de N en B; control >= 1 de N en B (si da 0, el control no mide).
Al terminar deja los ajustes como el acceso COOP. Salida: volcados/campana/parpadeo-<modo>.json + capturas.
"""
import json
import struct
import subprocess
import sys
import time
from pathlib import Path

H = Path(__file__).resolve().parent
sys.path.insert(0, str(H))
from pine import Pine  # noqa: E402
import campana_coop as cc  # noqa: E402
import clon_jugador as cj  # noqa: E402
import mando_j2 as m2  # noqa: E402

AJ = Path.home() / "Documents" / "PCSX2" / "gamesettings" / "SLUS-21376_5C891FF1.ini"
WS = "Enable = Widescreen 16:9"
WSP = "EnableWideScreenPatches = false"
PROPORCION = 0x004CA5F0   # R+0xD470/74 (93t)
N = 16


def ajustes(modo):
    ls = [l for l in AJ.read_text(encoding="utf-8").splitlines() if l.strip() not in (WS, WSP)]
    i_p = ls.index("[Patches]") + 1
    i_e = ls.index("[EmuCore]") + 1 if "[EmuCore]" in ls else None
    if modo == "control":
        ls.insert(i_p, WS)                       # y la global (true) queda mandando
    else:
        if i_e is None:
            ls.append("[EmuCore]"); i_e = len(ls)
        ls.insert(i_e, WSP)
    AJ.write_text("\n".join(ls) + "\n", encoding="utf-8")


def emulog_ws():
    log = Path.home() / "Documents" / "PCSX2" / "logs" / "emulog.txt"
    try:
        t = log.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return None
    return [l.strip() for l in t.splitlines() if "Enabled patch" in l]


def rellenar(p):
    arma = p.leer32(cj.J2 + 0x2A4)
    sub = p.leer32(arma + 0xF4)
    p.escribir16(sub + 0x18, 15)


def main():
    modo = sys.argv[1] if len(sys.argv) > 1 else "coop"
    if cc.pcsx2_de_fran_abierto():
        print("el PCSX2 de Fran esta abierto: no"); return 1
    ajustes(modo)
    res = {"modo": modo, "fecha": time.strftime("%Y-%m-%d %H:%M")}
    try:
        if not cc.lanzar():
            print("el fork no quedo vivo"); return 1
        res["parches"] = emulog_ws()
        niv = cc.probar_nivel(0)
        res["nivel"] = {k: niv.get(k) for k in ("nombre", "armado_s", "vivo_despues")}
        with Pine() as p:
            m2.poner(p)
            time.sleep(1.0)
            res["proporcion_quieto"] = list(struct.unpack("<2f", p.leer_bloque(PROPORCION, 8)))
        ref = "parp-%s-ref.png" % modo
        cc.cap(ref)
        caps = []
        with Pine() as p:
            m2.boton(p, m2.NOMBRES["disparar"], True)
            for k in range(N):
                rellenar(p)
                nombre = "parp-%s-%02d.png" % (modo, k)
                cc.cap(nombre)
                caps.append(str(cc.SAL / nombre))
            m2.boton(p, m2.NOMBRES["disparar"], False)
        r = subprocess.run([sys.executable, str(H / "parpadeo_escala.py"), str(cc.SAL / ref), *caps],
                           capture_output=True, text=True, encoding="utf-8", errors="replace")
        filas = [json.loads(l) for l in r.stdout.splitlines() if l.startswith('{"captura"')]
        res["clasificacion"] = [(Path(f["captura"]).name, f.get("vista"), f.get("escala_x")) for f in filas]
        res["B"] = sum(1 for f in filas if f.get("vista") == "B")
        res["salida_clasificador"] = r.stdout.strip().splitlines()[-1:] + r.stderr.strip().splitlines()[-2:]
    finally:
        ajustes("coop")
        cc.matar_fork()
    (cc.SAL / ("parpadeo-%s.json" % modo)).write_text(json.dumps(res, indent=1, ensure_ascii=False))
    print(json.dumps({k: res.get(k) for k in ("modo", "B", "proporcion_quieto", "nivel", "parches")}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
